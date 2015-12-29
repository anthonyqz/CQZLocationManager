Pod::Spec.new do |s|
	s.name 				= 'CQZLocationManager'
  	s.version			= '0.5.0'
  	s.summary 			= 'Location'
  	s.homepage 			= 'https://github.com/anthonyqz/CQZLocationManager'
  	s.author 			= { "Christian Quicano" => "anthony.qz@ecorenetworks.com" }
  	s.source 			= {:git => 'https://github.com/anthonyqz/AMDataManager', :tag => s.version.to_s}

  	s.ios.deployment_target 	= '8.0'
  	s.requires_arc 			= true
	s.frameworks             	= "Foundation", "CoreLocation"
	s.source_files			= 'project/*.swift'

#	s.ios.vendored_frameworks	= 'project/AMDataManager.framework'
#  	s.dependency 'Alamofire', '~> 3.0'
#  s.resources 				= "RWPickFlavor/**/*.{png,jpeg,jpg,storyboard,xib}"


end