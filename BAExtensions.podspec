#
#  Be sure to run `pod spec lint BAExtensions.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |s|
  s.name             = 'BAExtensions'
  s.version          = '1.0.0'
  s.summary          = 'BAExtensions is designed for the Entry Level iOS Developers.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  BAExtensions is designed for the Entry Level iOS Developers. This is developed for the seamless application development for the beginners.
                       DESC

  s.homepage         = 'https://github.com/bettoakkara/BAFirstLineDev'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bettoakkara' => 'bettoakkara1@gmail.com' }
  s.source           = { :git => 'https://github.com/bettoakkara/BAFirstLineDev.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '12.3'

  s.source_files = 'BAExtensions/Classes/**/*'

end
