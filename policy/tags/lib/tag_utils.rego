package policy.tags.lib.tag_utils

import rego.v1

# Check if a tag value is all lowercase
is_lowercase(value) if value == lower(value)

# Check if a tag value starts with a specific prefix
has_prefix(value, prefix) if startswith(value, prefix)

# Validate tag based on its rule type - lowercase only
validate_tag(tag_name, rule, tags) := result if {
	rule == "lowercase"
	tag_value := tags[tag_name]
	result := {
		"valid": is_lowercase(tag_value),
		"message": sprintf("must be all lowercase, but got '%s'", [tag_value]),
	}
}

# Validate tag based on its rule type - exact match
validate_tag(tag_name, rule, tags) := result if {
	startswith(rule, "exact:")
	expected := substring(rule, 6, -1)
	tag_value := tags[tag_name]
	result := {
		"valid": tag_value == expected,
		"message": sprintf("must be '%s', but got '%s'", [expected, tag_value]),
	}
}

# Validate tag based on its rule type - prefix with lowercase
validate_tag(tag_name, rule, tags) := result if {
	startswith(rule, "prefix:")
	prefix := substring(rule, 7, -1)
	tag_value := tags[tag_name]

	has_prefix(tag_value, prefix)
	is_lowercase(tag_value)

	result := {
		"valid": true,
		"message": "",
	}
}

# Validate tag based on its rule type - prefix with lowercase (failure case: no prefix)
validate_tag(tag_name, rule, tags) := result if {
	startswith(rule, "prefix:")
	prefix := substring(rule, 7, -1)
	tag_value := tags[tag_name]

	not has_prefix(tag_value, prefix)

	result := {
		"valid": false,
		"message": sprintf("must start with '%s' and be all lowercase, but got '%s'", [prefix, tag_value]),
	}
}

# Validate tag based on its rule type - prefix with lowercase (failure case: not lowercase)
validate_tag(tag_name, rule, tags) := result if {
	startswith(rule, "prefix:")
	prefix := substring(rule, 7, -1)
	tag_value := tags[tag_name]

	has_prefix(tag_value, prefix)
	not is_lowercase(tag_value)

	result := {
		"valid": false,
		"message": sprintf("must start with '%s' and be all lowercase, but got '%s'", [prefix, tag_value]),
	}
}
