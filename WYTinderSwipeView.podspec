#
#  Be sure to run `pod spec lint WYTinderSwipeView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "WYTinderSwipeView"
  s.version      = "0.0.1"
  s.summary      = "An Univerasl Swipe View Imitate Tinder."

  s.homepage     = "https://github.com/wyanassert/WYTinderSwipeView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"

  s.author             = { "wyanassert" => "wyanassert@gmail.com" }
  s.social_media_url   = "https://github.com/wyanassert"

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/wyanassert/WYTinderSwipeView", :tag => "#{s.version}" }

  s.source_files  = "WYTinderSwipeView", "WYTinderSwipeView/**/*.{h,m}"
  s.public_header_files = "WYTinderSwipeView/**/*.h"
  # s.resources = "Resources/*.png"

  # s.requires_arc = true
  s.dependency "Masonry", "~> 1.1.0"

end
