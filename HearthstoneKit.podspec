#
# Be sure to run `pod lib lint HearthstoneKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HearthstoneKit'
  s.version          = '1.0.0-beta'
  s.summary          = 'An elegant pure-swift SDK for consuming the official Hearthstone API.'
  s.description      = <<-DESC
HearthstoneKit is a pure-swift SDK for consuming the official Hearthstone API. With it you can interact with the official API using native swift types. HearthstoneKit's design goals are to be lightweight, simple to use, and leverage the power of swift.
                       DESC

  s.homepage         = 'https://github.com/StarLard/HearthstoneKit'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'StarLard' => 'contact@calebfriden.com' }
  s.source           = { :git => 'https://github.com/StarLard/HearthstoneKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/CalebFriden'

  s.ios.deployment_target = '13.0'
  s.swift_version = "5"

  s.source_files = 'Source/**/*.swift'
end
