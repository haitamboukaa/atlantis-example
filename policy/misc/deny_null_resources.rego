# This policy denies the creation of null_resource resources
# This is a common example policy to demonstrate conftest with Atlantis
package policy.misc

import rego.v1

# deny rule blocks the plan from being applied
deny contains msg if {
	some resource in input.resource_changes
	resource.type == "null_resource"
	"create" in resource.change.actions

	msg := sprintf(
		"null_resource '%s' is not allowed. Use real resources instead of null_resource.",
		[resource.address],
	)
}
