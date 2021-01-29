# Uncomment the next line to define a global platform for your project

platform :ios, '14.0'

target 'Beaver' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Beaver

  target 'BeaverTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# add the Firebase pod for Google Analytics
pod 'Firebase/Analytics'
pod "Apollo"
pod 'SwiftKeychainWrapper'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end