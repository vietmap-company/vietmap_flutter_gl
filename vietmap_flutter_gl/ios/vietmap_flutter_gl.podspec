#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'vietmap_flutter_gl'
  s.version          = '0.0.3'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'vietmap_flutter_gl/Sources/vietmap_flutter_gl/**/*'
  # s.source_files = 'Classes/**/*'
  s.public_header_files = 'vietmap_flutter_gl/Sources/vietmap_flutter_gl/**/*.h'
  
  s.dependency 'Flutter'
  # When updating the dependency version,
  # make sure to also update the version in Package.swift.
  s.dependency 'VietMap', '~> 2.0.0'
  s.swift_version = '4.2'
  s.ios.deployment_target = '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 'FRAMEWORK_SEARCH_PATHS' => '$(PROJECT_DIR)/Frameworks' }
  s.vendored_frameworks = 'Frameworks/*.xcframework'
end

