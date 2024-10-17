terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.61.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }
}
