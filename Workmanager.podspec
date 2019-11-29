# Podfile Specs: https://guides.cocoapods.org/syntax/podfile.html

Pod::Spec.new do |s|
  s.name                = 'Workmanager'
  s.version             = '0.1.0'
  s.summary             = 'Background manager for iOS'
  s.homepage            = 'https://github.com/vrtdev/ios-workmanager'
  s.author              = { 'Olivier Scalais' => 'olivier@codify.be' }
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.source              = { :path => '.' }
  s.source_files        = 'Workmanager/Classes/**/*'

  s.dependency 'Flutter'
  s.dependency 'SwiftyBeaver'

  s.ios.deployment_target = '13.0'

  s.description      = <<-DESC
Background manager for iOS 13+ which uses BackgroundTasks framework.
DESC
end
