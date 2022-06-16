Pod::Spec.new do |s|
  s.name             = 'Pilgrim-DI'
  s.module_name      = 'PilgrimDI'
  s.version          = '1.1.2'
  s.summary          = 'Powerful dependency injection for Swift (iOS | OSX | Linux).'
  s.description      = 'Pilgrim provides simple and effective DI using an assembly and property wrappers.'
  s.homepage         = 'https://pilgrim.ph'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jasperblues' => 'jasper@appsquick.ly' }
  s.source           = { :git => 'https://github.com/appsquickly/pilgrim.git', :tag => s.version.to_s }
#   s.social_media_url = 'https://twitter.com/doctor_cerulean'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.source_files     = 'Sources/Pilgrim/*.swift'
  s.swift_version = '5.1'
end
