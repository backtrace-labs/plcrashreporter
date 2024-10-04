#!/bin/bash

# Generate C files from proto files
cd Source/ && protoc --c_out="./" "PLCrashReport.proto" && cd ..
cd Tests/ && protoc --c_out="./" "PLCrashLogWriterEncodingTests.proto" && cd ..

# Update include statements in source files
find . \( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \) -exec sed -i '' -e 's/#include <protobuf-c\/protobuf-c.h>/#include <protobuf-c.h>/g' {} \;
find . \( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \) -exec sed -i '' -e 's/#import "CrashReporter\/CrashReporter.h"/#import "CrashReporter.h"/g' {} \;

# Get the SDKROOT for mig command
SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# Generate architecture-specific headers
mig -arch "arm64" -header "Source/mach_exc_arm64.h" -server /dev/null -user "Source/mach_exc_arm64User.inc" "${SDKROOT}/usr/include/mach/mach_exc.defs"
mig -arch "x86_64" -header "Source/mach_exc_x86_64.h" -server /dev/null -user "Source/mach_exc_x86_64User.inc" "${SDKROOT}/usr/include/mach/mach_exc.defs"

# Create mach_exc.h file
echo '#ifdef __LP64__'                       > Source/mach_exc.h
echo '#include "mach_exc_arm64.h"'          >> Source/mach_exc.h
echo '#elif defined(__x86_64__)'            >> Source/mach_exc.h
echo '#include "mach_exc_x86_64.h"'         >> Source/mach_exc.h
echo '#endif'                                >> Source/mach_exc.h

# Create mach_exc.c file
FILE_64=$(cat Source/mach_exc_x86_64User.inc)
echo '#import "PLCrashFeatureConfig.h"'      > Source/mach_exc.c
echo '#if PLCRASH_FEATURE_MACH_EXCEPTIONS'  >> Source/mach_exc.c
echo '#ifdef __LP64__'                      >> Source/mach_exc.c
echo "$FILE_64"                             >> Source/mach_exc.c
echo '#endif'                               >> Source/mach_exc.c
echo '#endif'                               >> Source/mach_exc.c

# Generate Xcode project files
xcodegen generate
