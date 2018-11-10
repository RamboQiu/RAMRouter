
Pod::Spec.new do |s|
  s.name             = 'RAMRouter'
  s.version          = '1.0.0'
  s.summary          = ''

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RamboQiu/RAMRouter.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RamboQiu' => 'ramboq069@gmail.com' }
  s.source           = { :git => 'git@github.com:RamboQiu/RAMRouter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  s.source_files = 'RAMRouter/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
  #s.dependency 'CocoaLumberjack', '2.0.1'
  #s.dependency 'Fabric'
  #s.dependency 'Crashlytics'
end

