#!/bin/bash

PROJECT_DIR="$(dirname "$0")/../Runs"
BUILD_PATH="${PROJECT_DIR}/.build"
WORKFLOW_XC_PATH="${PROJECT_DIR}/frameworks"
WORKFLOW_XC_PATH_STATIC="${PROJECT_DIR}/frameworks/static"
WORKFLOW_XC_PATH_DYLIB="${PROJECT_DIR}/frameworks/dylib"
DERIVED_DATA_PATH="${PROJECT_DIR}/.derivedData"

rm -rf ${BUILD_PATH}
rm -rf ${WORKFLOW_XC_PATH}
rm -rf ${DERIVED_DATA_PATH}
mkdir ${BUILD_PATH}
mkdir ${WORKFLOW_XC_PATH}
mkdir ${WORKFLOW_XC_PATH_STATIC}
mkdir ${WORKFLOW_XC_PATH_DYLIB}
mkdir ${DERIVED_DATA_PATH}

xcodebuild archive \
    -project "CrashReporter.xcodeproj" \
    -scheme "CrashReporter iOS Framework" \
    -destination "generic/platform=iOS" \
    -archivePath ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive \
    -derivedDataPath ${DERIVED_DATA_PATH} \
    -configuration Release \
    DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

    xcodebuild archive \
    -project "CrashReporter.xcodeproj" \
    -scheme "CrashReporter iOS Framework" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath ${BUILD_PATH}/CrashReporter-iOS-Simulator-lib.xcarchive \
    -derivedDataPath ${DERIVED_DATA_PATH} \
    -configuration Release \
    DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

xcodebuild archive \
    -project "CrashReporter.xcodeproj" \
    -scheme "CrashReporter iOS Framework" \
    -destination "platform=macOS,variant=Mac Catalyst" \
    -archivePath ${BUILD_PATH}/CrashReporter-iOS-MacCatalyst-lib.xcarchive \
    -derivedDataPath ${DERIVED_DATA_PATH} \
    -configuration Release \
    DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
    SUPPORTS_MACCATALYST=YES BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO    

xcodebuild archive \
    -project "CrashReporter.xcodeproj" \
    -scheme "CrashReporter macOS Framework" \
    -destination "platform=macOS" \
    -archivePath ${BUILD_PATH}/CrashReporter-macOS-lib.xcarchive \
    -derivedDataPath ${DERIVED_DATA_PATH} \
    -configuration Release \
    DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

xcodebuild archive \
    -project "CrashReporter.xcodeproj" \
    -scheme "CrashReporter tvOS Framework" \
    -destination "generic/platform=tvOS" \
    -archivePath ${BUILD_PATH}/CrashReporter-tvOS-lib.xcarchive \
    -derivedDataPath ${DERIVED_DATA_PATH} \
    -configuration Release \
    DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

    xcodebuild archive \
    -project "CrashReporter.xcodeproj" \
    -scheme "CrashReporter tvOS Framework" \
    -destination "generic/platform=tvOS Simulator" \
    -archivePath ${BUILD_PATH}/CrashReporter-tvOS-Simulator-lib.xcarchive \
    -derivedDataPath ${DERIVED_DATA_PATH} \
    -configuration Release \
    DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

xcodebuild -create-xcframework \
    -archive ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive -framework CrashReporter.framework \
    -archive ${BUILD_PATH}/CrashReporter-iOS-Simulator-lib.xcarchive -framework CrashReporter.framework \
    -archive ${BUILD_PATH}/CrashReporter-iOS-MacCatalyst-lib.xcarchive -framework CrashReporter.framework \
    -archive ${BUILD_PATH}/CrashReporter-macOS-lib.xcarchive -framework CrashReporter.framework \
    -archive ${BUILD_PATH}/CrashReporter-tvOS-lib.xcarchive -framework CrashReporter.framework \
    -archive ${BUILD_PATH}/CrashReporter-tvOS-Simulator-lib.xcarchive -framework CrashReporter.framework \
    -output ${WORKFLOW_XC_PATH_DYLIB}/CrashReporter.xcframework

xcodebuild -create-xcframework \
    -library ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive/products/usr/local/lib/libCrashReporter.a -headers ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive/products/usr/local/lib/include \
    -library ${BUILD_PATH}/CrashReporter-iOS-Simulator-lib.xcarchive/products/usr/local/lib/libCrashReporter.a -headers ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive/products/usr/local/lib/include \
    -library ${BUILD_PATH}/CrashReporter-iOS-MacCatalyst-lib.xcarchive/products/usr/local/lib/libCrashReporter.a -headers ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive/products/usr/local/lib/include \
    -library ${BUILD_PATH}/CrashReporter-macOS-lib.xcarchive/products/usr/local/lib/libCrashReporter.a -headers ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive/products/usr/local/lib/include \
    -library ${BUILD_PATH}/CrashReporter-tvOS-lib.xcarchive/products/usr/local/lib/libCrashReporter.a -headers ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive/products/usr/local/lib/include \
    -library ${BUILD_PATH}/CrashReporter-tvOS-Simulator-lib.xcarchive/products/usr/local/lib/libCrashReporter.a -headers ${BUILD_PATH}/CrashReporter-iOS-lib.xcarchive/products/usr/local/lib/include \
    -output ${WORKFLOW_XC_PATH_STATIC}/CrashReporter.xcframework    

rm -rf ${BUILD_PATH}
rm -rf ${DERIVED_DATA_PATH}

if [ ! -d "${WORKFLOW_XC_PATH_DYLIB}/CrashReporter.xcframework" ]; then
  echo "Error: xcframework failed"
  rm -rf ${WORKFLOW_XC_PATH}
  exit 1
fi
