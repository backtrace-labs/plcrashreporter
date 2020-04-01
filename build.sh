#!/bin/bash

cd Dependencies/protobuf-c &&  ./autogen.sh && ./configure && make && make install && cd ../..

cd "Resources" && "protoc" --c_out="../Source/Autogenerated" "crash_report.proto" && cd ..
    find . \( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \) -exec sed -i '' -e 's/#include <protobuf-c\/protobuf-c.h>/#include <protobuf-c.h>/g' {} \;
    find . \( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \) -exec sed -i '' -e 's/#import "CrashReporter\/CrashReporter.h"/#import "CrashReporter.h"/g' {} \;
    SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    mig -arch "i386" -header "Source/Autogenerated/mach_exc_i386.h" -server /dev/null -user "Source/Autogenerated/mach_exc_i386User.inc" "${SDKROOT}/usr/include/mach/mach_exc.defs"
    mig -arch "x86_64" -header "Source/Autogenerated/mach_exc_x86_64.h" -server /dev/null -user "Source/Autogenerated/mach_exc_x86_64User.inc" "${SDKROOT}/usr/include/mach/mach_exc.defs"
    echo '#ifdef __LP64__'                       > Source/Autogenerated/mach_exc.h
    echo '#include "mach_exc_x86_64.h"'         >> Source/Autogenerated/mach_exc.h
    echo '#else'                                >> Source/Autogenerated/mach_exc.h
    echo '#include "mach_exc_i386.h"'           >> Source/Autogenerated/mach_exc.h
    echo '#endif'                               >> Source/Autogenerated/mach_exc.h
    FILE_86=$(cat Source/Autogenerated/mach_exc_i386User.inc)
    FILE_64=$(cat Source/Autogenerated/mach_exc_x86_64User.inc)
    echo '#import "PLCrashFeatureConfig.h"'      > Source/Autogenerated/mach_exc.c
    echo '#if PLCRASH_FEATURE_MACH_EXCEPTIONS'  >> Source/Autogenerated/mach_exc.c
    echo '#ifdef __LP64__'                      >> Source/Autogenerated/mach_exc.c
    echo "$FILE_64"                             >> Source/Autogenerated/mach_exc.c
    echo '#else'                                >> Source/Autogenerated/mach_exc.c
    echo "$FILE_86"                             >> Source/Autogenerated/mach_exc.c
    echo '#endif'                               >> Source/Autogenerated/mach_exc.c
    echo '#endif'                               >> Source/Autogenerated/mach_exc.c