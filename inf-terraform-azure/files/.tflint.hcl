plugin "azurerm" {
  enabled = true
  version = "0.27.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Rule is disabled as files generated by framework do not follow that rule.
rule "terraform_deprecated_index" {
  enabled = false
}

# Rule is disabled in quickstarter template, but should be enabled after deployment.
rule "terraform_unused_declarations" {
  enabled = false
}

rule "terraform_comment_syntax" {
  enabled = true
}

# Rule is disabled as files generated by framework do not follow that rule.
rule "terraform_documented_outputs" {
  enabled = false
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}
