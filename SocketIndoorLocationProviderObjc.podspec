Pod::Spec.new do |s|
  s.name         = "SocketIndoorLocationProviderObjc"
  s.version      = "1.0.1"
  s.license      = { :type => 'MIT' }
  s.summary      = "Allows to use a socket to provide indoorlocation"
  s.homepage     = "https://github.com/IndoorLocation/socket-indoor-location-provider-ios.git"
  s.author       = { "Indoor Location" => "indoorlocation@mapwize.io" }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/IndoorLocation/socket-indoor-location-provider-ios.git", :tag => "#{s.version}" }
  s.source_files  = "socket-indoorlocation-provider-ios-objc/Provider/*.{h,m}"
  s.dependency "IndoorLocation", "~> 1.0"
  s.dependency "Socket.IO-Client-Swift", "~> 13.1.0"
end
