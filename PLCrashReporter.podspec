Pod::Spec.new do |spec|
  spec.cocoapods_version = '>= 1.10'
  spec.name        = 'PLCrashReporter'
  spec.version     = '1.11.2rc'
  spec.summary     = 'Reliable, open-source crash reporting for iOS, macOS and tvOS.'
  spec.description = 'PLCrashReporter is a reliable open source library that provides an in-process live crash reporting framework for use on iOS, macOS and tvOS. The library detects crashes and generates reports to help your investigation and troubleshooting with the information of application, system, process, thread, etc. as well as stack traces.'

  spec.homepage    = 'https://github.com/microsoft/plcrashreporter'
  spec.license     = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors     = { 'Microsoft' => 'appcentersdk@microsoft.com' }

  spec.source      = { :http => 'https://github.com/backtrace-labs/plcrashreporter/releases/download/1.11.2-rc1-6b77fceb/CrashReporter.xcframework.zip', :flatten => false }

  spec.vendored_frameworks = 'CrashReporter.xcframework'
  spec.preserve_paths = [
    'CrashReporter.xcframework/*',
    'CrashReporter.xcframework/*/Headers',
    'CrashReporter.xcframework/*/Headers/*.h',
    'CrashReporter.xcframework/*/module.modulemap'
  ]
  spec.ios.deployment_target    = '11.0'
  spec.osx.deployment_target    = '10.13'
  spec.tvos.deployment_target   = '11.0'
end
