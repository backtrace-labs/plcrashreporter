#!/bin/sh
set -e

sh scripts/bootstrap.sh

cd Sources/Autogenerated && protoc --c_out="./" "PLCrashReport.proto" && cd ../..
cd Tests/Autogenerated &&  protoc --c_out="./" "PLCrashLogWriterEncodingTests.proto" && cd ../..
    find . \( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \) -exec sed -i '' -e 's/#include <protobuf-c\/protobuf-c.h>/#include <protobuf-c.h>/g' {} \;
    find . \( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \) -exec sed -i '' -e 's/#import "CrashReporter\/CrashReporter.h"/#import "CrashReporter.h"/g' {} \;
    SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    mig -arch "i386" -header "Sources/Autogenerated/mach_exc_i386.h" -server /dev/null -user "Sources/Autogenerated/mach_exc_i386User.inc" "${SDKROOT}/usr/include/mach/mach_exc.defs"
    mig -arch "x86_64" -header "Sources/Autogenerated/mach_exc_x86_64.h" -server /dev/null -user "Sources/Autogenerated/mach_exc_x86_64User.inc" "${SDKROOT}/usr/include/mach/mach_exc.defs"
    echo '#ifdef __LP64__'                       > Sources/Autogenerated/mach_exc.h
    echo '#include "mach_exc_x86_64.h"'         >> Sources/Autogenerated/mach_exc.h
    echo '#else'                                >> Sources/Autogenerated/mach_exc.h
    echo '#include "mach_exc_i386.h"'           >> Sources/Autogenerated/mach_exc.h
    echo '#endif'                               >> Sources/Autogenerated/mach_exc.h
    FILE_86=$(cat Sources/Autogenerated/mach_exc_i386User.inc)
    FILE_64=$(cat Sources/Autogenerated/mach_exc_x86_64User.inc)
    echo '#import "PLCrashFeatureConfig.h"'      > Sources/Autogenerated/mach_exc.c
    echo '#if PLCRASH_FEATURE_MACH_EXCEPTIONS'  >> Sources/Autogenerated/mach_exc.c
    echo '#ifdef __LP64__'                      >> Sources/Autogenerated/mach_exc.c
    echo "$FILE_64"                             >> Sources/Autogenerated/mach_exc.c
    echo '#else'                                >> Sources/Autogenerated/mach_exc.c
    echo "$FILE_86"                             >> Sources/Autogenerated/mach_exc.c
    echo '#endif'                               >> Sources/Autogenerated/mach_exc.c
    echo '#endif'                               >> Sources/Autogenerated/mach_exc.c

xcodegen generate