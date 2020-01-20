
Pod::Spec.new do |s|
  s.name             = 'RAMRouter'
  s.version          = '1.0.8'
  s.summary          = 'This is a good iOS Router'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RamboQiu/RAMRouter.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RamboQiu' => '625217640@qq.com' }
  s.source           = { :git => 'https://github.com/RamboQiu/RAMRouter.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.default_subspec = 'RAMCore'
  
  s.resource_bundles = {
   'RAMRouter' => ['RAMRouter/Assets/*.png']
  }

  s.dependency 'RAMUtil/RAMLog'
  s.dependency 'RAMUtil/RAMColor'
  s.dependency 'RAMUtil/RAMImage'
  s.dependency 'RAMUtil/RAMFrame'

  s.subspec 'RAMCore' do |cs|
    cs.source_files = "RAMRouter/RAMCore/*.{h,m}"
    cs.public_header_files = "RAMRouter/RAMCore/*.h"
  end

end

