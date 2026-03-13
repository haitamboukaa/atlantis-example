# METADATA
# entrypoint: true
# description: This policy validates required tags on AWS resources
package policy.tags

import rego.v1
import data.policy.tags.lib.tag_utils

# Required tags with their validation rules
required_tags := {
	"Environment": "lowercase",
	"Project": "lowercase",
	"DeployedBy": "exact:terraform",
	"GitPath": "prefix:github:",
}

# Get resources that are being created
affected_resources contains resource if {
	some resource in input.resource_changes
	# ensure actions exist and contain create
	some action in resource.change.actions
	action == "create"
	resource.change.after.tags
}

# Get resources that are being updated
affected_resources contains resource if {
	some resource in input.resource_changes
	# ensure actions exist and contain update
	some action in resource.change.actions
	action == "update"
	resource.change.after.tags
}

# Generate warnings for missing tags
warn contains msg if {
	some resource in affected_resources
	some tag_name, _rule in required_tags

	not resource.change.after.tags[tag_name]

	msg := sprintf(
		"Resource '%s' is missing required tag '%s'",
		[resource.address, tag_name],
	)
}

# Generate warnings for invalid tag values
warn contains msg if {
	some resource in affected_resources
	some tag_name, rule in required_tags

	resource.change.after.tags[tag_name]

	validation := tag_utils.validate_tag(tag_name, rule, resource.change.after.tags)
	not validation.valid

	msg := sprintf(
		"Resource '%s' has invalid tag '%s': %s",
		[resource.address, tag_name, validation.message],
	)
}
