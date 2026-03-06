# This policy denies the creation of null_resource resources
# This is a common example policy to demonstrate conftest with Atlantis
package main

# deny rule blocks the plan from being applied
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "null_resource"
  resource.change.actions[_] == "create"

  msg := sprintf(
    "null_resource '%s' is not allowed. Use real resources instead of null_resource for production.",
    [resource.address],
  )
}
