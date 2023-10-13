#
# Be sure to run `pod lib lint PowerBaseLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PowerBaseLibrary'
  s.version          = '1.1.1'
  s.summary          = 'PowerCC PowerBaseLibrary.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/PowerCC/PowerBaseLibrary.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zoucheng@live.cn' => 'zoucheng@live.cn' }
  s.source           = { :git => 'https://github.com/PowerCC/PowerBaseLibrary.git', :tag => s.version.to_s }
  
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  #s.osx.deployment_target = '10.15'

  s.source_files = 'PowerBaseLibrary/Classes/**/*'
  
  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'PowerBaseLibrary' => ['PowerBaseLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Alamofire'
  s.dependency 'CTMediator'
  s.dependency 'HandyJSON'
  s.dependency 'JSONModel'
  s.dependency 'MBProgressHUD'
  s.dependency 'MJRefresh'
  s.dependency 'Moya'
  s.dependency 'RxCocoa'
  s.dependency 'RxSwift'
  s.dependency 'SDWebImage'
  
end
