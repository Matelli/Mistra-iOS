platform :ios, '7.0'
pod 'AFNetworking', '~> 2.2'
pod 'BlockRSSParser', '~> 2.1'
pod 'ZipArchive'
pod 'FlurrySDK'
pod 'AFOnoResponseSerializer'
pod 'BTUtils'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Ressources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end