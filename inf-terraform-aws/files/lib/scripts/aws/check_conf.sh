#!/bin/bash
#
# Author: Erhard Wais
#         erhard.wais@boehringer-ingelheim.com
#
# This script does some basic checks on the AWS QS and reports potential issues.
# will be triggered via "make check-config"

# TODO:
# - Return error in case of missconfig

set -e
set -o pipefail

#CONST
SHAREDBUCKET="bitfstate01"
EDPUSER="edpawsqs"
EDPPOLICY="BI-EDPAWSQS-Policy"
DEFAULTBUCKET="<your_bucket_name>"
DEFAULTACCOUNT="<your_aws_account_id>"
DOTS="........................................................................."
GITROOT=`git rev-parse --show-toplevel`

BUCKET=
ACCOUNT=
MESSAGE=
HASAWSCONFIGURED=0

# functions
function format_message() {
  MESSAGE=$1
  local offset=${#MESSAGE}
  MESSAGE="$MESSAGE${DOTS:offset:((${#DOTS} - offset))}"
}

function ok() {
  format_message "$1"
  echo -e "$MESSAGE\033[42mPassed\033[0m"
}
function nok() {
  format_message "$1"
  echo -e "$MESSAGE\033[41mFailed\033[0m"
}
function warn() {
  format_message "$1"
  echo -e "$MESSAGE\033[44m Warn \033[0m"
}
function note() {
  format_message "$1"
  echo -e "$MESSAGE"
}

function check_backend() {
  BUCKET=`grep "bucket =" backend.tf | awk -F '=' '{print $2}'|tr -d '"'|xargs`
  case $BUCKET in
    $DEFAULTBUCKET) nok "TF Backend is not configured. Check your backend.tf file";;
    $SHAREDBUCKET) ok "TF Backend configured to \"$BUCKET\"";;
    "") nok "There is no backend specified. Update your backend.tf file";;
    *) warn "You don't use the shared Backend. Backend is set to \"$BUCKET\"";;
  esac
}

function check_env() {
  local envaccount=`grep "account" environments/$1.yml | awk -F ':' '{print $2}'|tr -d '"'|xargs`
  if [ "$envaccount" = "$DEFAULTACCOUNT" ]; then
    warn "There is no account configured for the \"$1\" environment"
  else
    ok "Account \"$envaccount\" is configured for the \"$1\" environment"
  fi
}

function check_aws_credentials() {
  local exitStatus=0
  local foundKeys=0
  local arn
  local user
  local longuser

  if [ -v  AWS_ACCESS_KEY_ID ] && [ -v  AWS_SECRET_ACCESS_KEY ]; then
    ok "AWS account specified using environment variables"
    HASAWSCONFIGURED=1
  else
	  aws sts get-caller-identity &> /dev/null || exitStatus=$?
	  if [ $exitStatus = 0  ]; then
		  ok "AWS account configured using SSO"
        HASAWSCONFIGURED=1
  	else
	  	nok "No AWS account information specified for local development"
		fi
	fi

  # Check IAM user, Group and Policy
  if [[ $HASAWSCONFIGURED = 1 ]]; then
    arn=`aws sts get-caller-identity --query "Arn" --output text`
    arn=${arn:13}
    ACCOUNT=${arn%:*}
    longuser=${arn##*:}
    user=${arn##*/}

    ok "  Using \"$ACCOUNT:$user\""
    if [ "$user" = "$EDPUSER" ]; then
      # can there be more ?
      policy=`aws iam list-group-policies --group-name $user --query "PolicyNames" --output text`
      if [ "$policy" = "$EDPPOLICY" ]; then
        ok "  User \"$user\" has \"$policy\"assigned"
      fi
    fi
  fi
}

function check_backend_access() {
  local exitStatus=0

  if [[ $BUCKET != $DEFAULTBUCKET ]]; then
    if [[ $HASAWSCONFIGURED = 1 ]]; then
      echo touch | aws s3 cp - s3://$1/$2/testaccess &> /dev/null || exitStatus=$?
	    if [ $exitStatus = 0  ]; then
	      ok "  Check if current account can write to bucket"
	    else
    	  warn "  Account can not write to bucket"
      fi
    fi
  fi
}

# Rund different tests
check_env dev
check_env test
check_env prod
check_aws_credentials
check_backend
check_backend_access "$BUCKET" "$ACCOUNT"
