Pod::Spec.new do |s|
	s.name 				= 'CQZLocationManager'
  	s.version			= '0.5.0'
  	s.summary 			= 'Location'
  	s.homepage 			= 'https://github.com/anthonyqz/CQZLocationManager'
  	s.author 			= { "Christian Quicano" => "anthony.qz@ecorenetworks.com" }
  	s.source 			= {:git => 'https://github.com/anthonyqz/CQZLocationManager', :tag => s.version}
  	s.ios.deployment_target 	= '11.0'
  	s.requires_arc 			= true
	s.frameworks             	= "Foundation", "CoreLocation"
	s.source_files			= 'project/CQZLocationManager/*.swift'
end