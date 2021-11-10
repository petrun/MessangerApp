platform :ios, '13.0'

target 'MessangerApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # ignore all warnings from all dependencies
  inhibit_all_warnings!

  # Pods for MessangerApp

  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'

  pod 'MessageKit'
  pod 'Then'
  pod 'SnapKit', '~> 5.0.0'
  pod 'SwiftLint'
  pod 'SwiftyBeaver'
  pod 'Swinject'
  pod 'SwinjectAutoregistration'

  #pod 'Gallery'
  #pod 'RealmSwift'

  #pod 'ProgressHUD'
  #pod 'SKPhotoBrowser'

  #pod 'MessageKit'
  #pod 'InputBarAccessoryView'

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end
