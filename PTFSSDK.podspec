#
# Be sure to run `pod lib lint PTFSSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PTFSSDK'
  s.version          = '0.1.0'
  s.summary          = 'PTFSSDK for iOS'
  s.description      = <<-DESC
TODO: PTFSSDK for iOS
                       DESC

  s.homepage         = 'https://github.com/grapefruitmachine/PTFS_SDK_IOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '孙启明' => '344602144@qq.com' }
  s.source           = { :git => 'https://github.com/grapefruitmachine/PTFS_SDK_IOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PTFSSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PTFSSDK' => ['PTFSSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
