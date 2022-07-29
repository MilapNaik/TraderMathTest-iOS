# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'TraderMathTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'DLRadioButton', '~> 1.4'
  pod 'Google-Mobile-Ads-SDK'
  pod 'Toaster'
  pod 'FirebaseAnalytics'
  pod 'FirebaseMessaging'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end