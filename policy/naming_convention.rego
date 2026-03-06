# This policy enforces naming conventions for resources
package main

# Deny resources that don't follow naming conventions
deny contains msg if {
  resource := input.resource_changes[_]
  resource.change.actions[_] == "create"

  # Check if resource name doesn't end with approved suffixes
  not endswith(resource.name, "-prod")
  not endswith(resource.name, "-sdbx")
  not endswith(resource.name, "-stag")

  msg := sprintf(
    "Resource name '%s' must end with an approved environment suffix (-prod, -sdbx, -stag)",
    [resource.name],
  )
}

# Helper functions
endswith(str, suffix) if {
  # true if suffix exists at the end of the string
  i := count(str) - count(suffix)
  i >= 0
  substring(str, i, -1) == suffix
}
