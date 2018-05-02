platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'FirebaseApp' do
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'

    target 'FirebaseAppTests' do
        inherit! :search_paths
        pod 'Firebase'
    end
end