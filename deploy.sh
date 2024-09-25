#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

pod trunk push Backtrace-PLCrashReporter.podspec --allow-warnings