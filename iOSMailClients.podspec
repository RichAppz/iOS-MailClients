ENV['FORK_XCODE_WRITING'] = "true"

Pod::Spec.new do |s|
  s.name = 'iOSMailClients'
  s.version = '0.2.0'
  s.summary = 'Connecting your app to more than just Mail'
  s.source = { :git => 'https://github.com/RichAppz/iOS-MailClients.git', :tag => s.version }
  s.authors = 'RichMucha/RichAppz'
  s.license = 'RichAppz'
  s.homepage = 'https://richappz.com/'
  s.ios.deployment_target = '10.0'
  s.requires_arc = true
  
  s.source_files = 'Sources/**/*.{swift}'

end
