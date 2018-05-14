source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

workspace 'CheckoutSdkIos.xcworkspace'

target 'CheckoutSdkIos' do

    # Add test target
    target 'CheckoutSdkIosTests' do
      inherit! :search_paths

      pod 'Mockingjay', '~> 2.0'
    end
end

target 'iOS Example' do
  project 'iOS Example/iOS Example.xcodeproj'
  pod 'Alamofire', '~> 4.7'
end