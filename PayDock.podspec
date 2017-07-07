Pod::Spec.new do |s|
s.name = "PayDock"
s.platform = :ios
s.ios.deployment_target	= "9.0"
s.requires_arc = true
s.module_name = "PayDock"
s.version = "0.1.0"
s.summary = "PayDock is an open-source SDK for iOS and a solution for collecting and handling payment sources in secure way through PayDock."
s.description = "PayDock is a smart payments platform connecting to your e-commerce or online payments solution/gateway. We enable you to add multiple payment gateways instantly, access new payment methods and manage all payments data from one place."
s.homepage = "http://roundtableapps.com"
s.license = "MIT"
s.author = "Roundtableapps"
s.source = { :git => "",
:tag => "#{s.version}" }
s.source_files = "PayDock/**/*.swift"
end
