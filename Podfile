source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

use_frameworks!

target "orderMe" do
   inhibit_all_warnings!
	pod 'Alamofire'
	pod 'ObjectMapper'
	pod 'AlamofireImage'
	pod 'FacebookCore'
	pod 'FacebookLogin'
	pod 'FacebookShare'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'SwiftLint'
	pod 'FBSDKCoreKit'  
	pod 'FBSDKLoginKit'
	pod 'FBSDKShareKit'
	pod 'FBSDKPlacesKit'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          # Force CocoaPods targets to always build for x86_64
          config.build_settings['ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
        end
      end
  end
end
