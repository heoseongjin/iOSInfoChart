#
#  Be sure to run `pod spec lint InfoChart.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "InfoChart"
  spec.version      = "1.0.1"
  spec.summary      = "Awesome Charts for iOS. It's supported real time vital chart like ECG."
  spec.homepage     = "https://github.com/infodevelop/iOSInfoChart"
  spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  spec.author             = { "infodevelop" => "hsj02036@infomining.co.kr" }
  spec.ios.deployment_target = "10.0"
  spec.swift_version = '5.0'
  spec.source       = { :git => "https://github.com/infodevelop/iOSInfoChart.git", :tag => "v#{spec.version}" }
  
  spec.subspec "Core" do |ss|
    ss.source_files  = "Sources/InfoChart/**/*.swift"
  end
end
