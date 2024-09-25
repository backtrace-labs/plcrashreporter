#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

pod lib lint --verbose --allow-warnings --sources='https://cdn.cocoapods.org/'