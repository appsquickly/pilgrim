Pod::Spec.new do |s|
  s.name             = 'Pilgrim-DI'
  s.version          = '0.0.1'
  s.summary          = 'Powerful dependency injection for Swift (iOS | OSX | Linux).'
  s.description      = 'Pilgrim provides simple and effective DI using an assembly and property wrappers.'
  s.homepage         = 'https://github.com/appsquickly/pilgrim'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jasperblues' => 'jasper@appsquick.ly' }
  s.source           = { :git => 'https://github.com/appsquickly/pilgrim.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/doctor_cerulean'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files     = 'Pilgrim/*.swift'
end
