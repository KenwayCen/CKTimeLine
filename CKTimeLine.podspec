#
#  Be sure to run `pod spec lint CKTimeLine.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = 'CKTimeLine'
  spec.version      = '0.0.2'
  spec.summary      = 'CKTimeLine 将时间戳转换为某个指定的时间段表示的一个时间字符串，类似于时间轴'
  spec.description  = <<-DESC
			CKTimeLine 将时间戳转换为某个指定的时间段表示的一个时间字符串，类似于时间轴
                   DESC

  spec.homepage     = 'https://github.com/KenwayCen/CKTimeLine'
  spec.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }
  spec.author             = { 'CK' => '1250578320@qq.com' }
  spec.social_media_url   = 'https://www.weilni.cn'
  spec.platform     = :ios, '8.0'
  spec.source       = { :git => 'https://github.com/KenwayCen/CKTimeLine.git', :tag => 'v0.0.2' }
  spec.source_files  = 'CKTimeLineCovert/TimeLine/*.{h,m}'
  spec.requires_arc = true

end
