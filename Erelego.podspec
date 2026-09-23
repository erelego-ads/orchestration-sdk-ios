Pod::Spec.new do |s|
  s.name = 'Erelego'
  s.version = '1.7.1'
  s.summary = 'Erelego ad mediation SDK for iOS applications.'
  s.homepage = 'https://github.com/erelego-ads/orchestration-sdk-ios'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = { 'Erelego' => '' }
  s.platform = :ios, '15.0'
  s.swift_version = '5.0'
  s.source = {
    :git => 'https://github.com/erelego-ads/orchestration-sdk-ios.git',
    :tag => "#{s.version}"
  }
  s.vendored_frameworks = 'Frameworks/ErelegoKit.xcframework'
  s.frameworks = 'AdSupport', 'AppTrackingTransparency', 'WebKit'
  # Match the version used to compile the vendored binary.
  s.dependency 'Google-Mobile-Ads-SDK', '= 13.2.0'
end
