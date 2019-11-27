Pod::Spec.new do |s|
  s.name             = 'Workmanager'
  s.version          = '0.1.0'
  s.summary          = 'Background manager for iOS'
  s.description      = <<-DESC
Background manager for iOS 13+ which uses BackgroundTasks framework.
DESC
  s.homepage         = 'https://github.com/vrtdev/ios-workmanager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Olivier Scalais' => 'olivier@codify.be' }
  s.ios.deployment_target = '13.0'
  s.source           = { :path => '.' }
  s.source_files     = 'Workmanager/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
