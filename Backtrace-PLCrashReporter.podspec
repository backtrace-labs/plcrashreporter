Pod::Spec.new do |spec|
  spec.cocoapods_version = '>= 1.10'
  spec.name        = 'Backtrace-PLCrashReporter'
  spec.version     = '1.11.2-rc1'
  spec.summary     = 'Reliable, open-source crash reporting for iOS, macOS and tvOS.'
  spec.description = 'PLCrashReporter is a reliable open source library that provides an in-process live crash reporting framework for use on iOS, macOS and tvOS. The library detects crashes and generates reports to help your investigation and troubleshooting with the information of application, system, process, thread, etc. as well as stack traces.'

  spec.homepage    = 'https://backtrace.io/'
  spec.license     = { :type => 'MIT', :file => 'LICENSE.txt' }
  spec.authors     = { 'Microsoft' => 'appcentersdk@microsoft.com', "Backtrace I/O" => "info@backtrace.io" }

  spec.source      = { :git => "https://github.com/backtrace-labs/plcrashreporter.git", :tag => "#{ spec.version}" }

  spec.source_files  = ["Source/**/*.{h,hpp,c,cpp,m,mm,s}", "Dependencies/**/*.{h,c}"]

  spec.public_header_files = ["include/**/*.h*", "Dependencies/**/*.h*}"]

  spec.resource_bundle = { 'Backtrace-PLCrashReporter' => 'Resources/PrivacyInfo.xcprivacy' }

  spec.ios.deployment_target    = '12.0'
  spec.osx.deployment_target    = '10.13'
  spec.tvos.deployment_target   = '12.0'

  spec.requires_arc = false

  spec.prefix_header_contents = '#import "PLCrashNamespace.h"'

  spec.pod_target_xcconfig = {
    "GCC_PREPROCESSOR_DEFINITIONS" => "PLCR_PRIVATE PLCF_RELEASE_BUILD"
  }

  spec.prepare_command = <<-CMD
  set -e
  
   # Compile the bundled protobuf-c files
  if [ -f "Dependencies/protobuf-c/protobuf-c/protobuf-c.c" ]; then
    gcc -c Dependencies/protobuf-c/protobuf-c/protobuf-c.c -o build/protobuf-c.o
  else
    echo "Error: protobuf-c.c file not found."
    exit 1
  fi

  # Generate C files from proto files
  cd Source/ && protoc --c_out="./" "PLCrashReport.proto" && cd ..
  cd Tests/ && protoc --c_out="./" "PLCrashLogWriterEncodingTests.proto" && cd ..

  # Update include statements in source files
  find . \\( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \\) -exec sed -i '' -e 's/#include <protobuf-c\\/protobuf-c.h>/#include <protobuf-c.h>/g' {} \\;
  find . \\( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \\) -exec sed -i '' -e 's/#import "CrashReporter\\/CrashReporter.h"/#import "CrashReporter.h"/g' {} \\;

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
CMD

end
