#
# Be sure to run `pod lib lint PKCS12.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PKCS12'
  s.version          = '0.1.0'
  s.summary          = 'PKCS12 Serialization Tools for ObjC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Serialize *.p12 file to X509 certficate object.
                       DESC

  s.homepage         = 'https://github.com/Magic-Unique/PKCS12'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Magic-Unique' => '516563564@qq.com' }
  s.source           = { :git => 'https://github.com/Magic-Unique/PKCS12.git', :tag => "#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.10'

  s.subspec 'Core' do |ss|
    ss.source_files = 'PKCS12/Core/**/*'
    ss.public_header_files = 'PKCS12/Core/Public/*.h'
    ss.dependency 'OpenSSL-Universal', '~> 1.0.2.0'
  end

  s.subspec 'OCSP' do |ss|
    ss.source_files = 'PKCS12/OCSP/**/*'
    ss.public_header_files = 'PKCS12/OCSP/Public/*.h'
    ss.libraries = 'c++'
    ss.dependency 'OpenSSL-Universal', '~> 1.0.2.0'
    ss.dependency 'PKCS12/Core'
  end

  # s.source_files = 'PKCS12/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PKCS12' => ['PKCS12/Assets/*.png']
  # }

  # s.public_header_files = 'PKCS12/Classes/Public/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

end
