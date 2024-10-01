Pod::Spec.new do |spec|
  spec.cocoapods_version = '>= 1.10'
  spec.name        = 'Backtrace-PLCrashReporter'
  spec.version     = '1.11.2'
  spec.summary     = 'Reliable, open-source crash reporting for iOS, macOS and tvOS.'
  spec.description = 'PLCrashReporter is a reliable open source library that provides an in-process live crash reporting framework for use on iOS, macOS and tvOS. The library detects crashes and generates reports to help your investigation and troubleshooting with the information of application, system, process, thread, etc. as well as stack traces.'

  spec.homepage    = 'https://backtrace.io/'
  spec.license     = { :type => 'MIT', :file => 'LICENSE.txt' }
  spec.authors     = { 'Microsoft' => 'appcentersdk@microsoft.com', "Backtrace I/O" => "info@backtrace.io" }

  spec.source      = { :git => "https://github.com/backtrace-labs/plcrashreporter.git", :tag => "#{ spec.version}" }

  spec.source_files  = ["Source/**/*.{h,hpp,c,cpp,m,mm,s}", "Dependencies/protobuf-c/protobuf-c/*.{h,c}"]

  spec.public_header_files = "include/**/*.h*"

  spec.resource_bundle = { 'Backtrace-PLCrashReporter' => 'Resources/PrivacyInfo.xcprivacy' }

  spec.ios.deployment_target    = '12.0'
  spec.osx.deployment_target    = '10.13'
  spec.tvos.deployment_target   = '12.0'

  spec.pod_target_xcconfig = {
    "GCC_PREPROCESSOR_DEFINITIONS" => "PLCR_PRIVATE PLCF_RELEASE_BUILD"
  }
end
