# -----------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# This stack supports the following secrets as environment variables.
# -----------------------------------------------------------------------------

# ARM_SUBSCRIPTION_ID
# ARM_TENANT_ID
# ARM_CLIENT_ID
# ARM_CLIENT_SECRET

# -----------------------------------------------------------------------------
# REQUIRED PARAMETERS
# The following stack parameters require a value.
# Documentation: https://www.terraform.io/docs/configuration/variables.html
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# The following stack parameters are optional with sensible defaults.
# Documentation: https://www.terraform.io/docs/configuration/variables.html
# -----------------------------------------------------------------------------

variable "name" {
  description = "The name of the stack."
  type        = string
  default     = "stack-azure-quickstarter-delete-me"
}

variable "is_test" {
  description = "Whether whether it is part of a test execution or not. Defaults to false."
  type        = bool
  default     = false
}

variable "meta_environment" {
  description = "The type of the environment. Can be any of DEVELOPMENT, EVALUATION, PRODUCTIVE, QUALITYASSURANCE, TRAINING, VALIDATION."
  type        = string
  default     = "DEVELOPMENT"
}

