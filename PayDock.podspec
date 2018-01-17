Pod::Spec.new do |s|
	s.name = "PayDock"
	s.platform = :ios
	s.ios.deployment_target	= "9.0"
	s.requires_arc = true
	s.module_name = "PayDock"
	s.version = "1.0.1"

	s.summary = "PayDock is an open-source SDK for iOS and a solution for collecting and handling payment sources in secure way through PayDock."
	s.description = "PayDock is a smart payments platform connecting to your e-commerce or online payments solution/gateway. We enable you to add multiple payment gateways instantly, access new payment methods and manage all payments data from one place."
	s.homepage = "https://paydock.com"
	s.license = "MIT"
	s.author = "PayDock"
	s.source = { :git => "https://github.com/PayDockDev/paydock_ios_sdk.git",
	:tag => "#{s.version}" }
	s.source_files = 'PayDock/**/*.{h,m}', 'PayDock/**/*.swift'
	  s.resources = 'PayDock/Assets.xcassets', 'PayDock/**/*.storyboard', 'PayDock/Info1.plist'
	  s.resource_bundles = {
	      'PayDock' => [
	          'PayDock/**/*.{storyboard,xcassets,json,imageset,png,plist}'
	      ]
	  }
end
