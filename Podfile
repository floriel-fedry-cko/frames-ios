source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

workspace 'FramesIos.xcworkspace'

target 'FramesIos' do

    # Add test target
    target 'FramesIosTests' do
      inherit! :search_paths

      pod 'Mockingjay', '~> 2.0'
    end
end

target 'iOS Example Apple Pay' do
  project 'iOS Example Apple Pay/iOS Example Apple Pay.xcodeproj'
  pod 'Alamofire', '~> 4.7'
end

target 'iOS Example' do
  project 'iOS Example/iOS Example.xcodeproj'
  pod 'Alamofire', '~> 4.7'
end
