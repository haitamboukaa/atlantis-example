# This policy provides warnings without blocking the apply
# Warnings show up in Atlantis but don't prevent the plan from being applied
package main

# warn rule provides warnings but doesn't block
warn contains msg if {
  resource := input.resource_changes[_]
  not resource.change.after.tags

  msg := sprintf(
    "Resource '%s' of type '%s' does not have tags defined. Consider adding tags for better resource management.",
    [resource.address, resource.type],
  )
}

# Another warning example
warn contains msg if {
  resource := input.resource_changes[_]
  resource.change.actions[_] == "delete"

  msg := sprintf(
    "Warning: Resource '%s' is being deleted. Make sure this is intentional.",
    [resource.address],
  )
}
