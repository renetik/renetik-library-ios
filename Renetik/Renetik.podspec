#
# Be sure to run 'pod lib lint Renetik.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Renetik'
  s.version          = '0.10'
  s.summary          = 'Library for rapid development of iOS apps with readable code and pleasure.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
		Library for rapid development of iOS apps with readable code and pleasure,
		created out of passion to code my way and to improve readability of my codebase.
                       DESC

  s.homepage         = 'https://github.com/rene-dohan/renetik-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rene-dohan' => 'dohan.rene@gmail.com' }
  s.source           = { :git => 'https://github.com/rene-dohan/renetik-ios.git',
												 :tag => s.version.to_s }
  s.social_media_url = 'https://renetik-software.github.io'
  s.ios.resource_bundle = { 'RenetikBundle' => 'Renetik/Resources/**/*'}

  s.ios.deployment_target = '11.0'

	s.default_subspecs = 'All'

	s.subspec 'Core' do |ss|
		ss.dependency 'RenetikObjc/Core'
		ss.source_files = 'Renetik/Classes/Core/**/*'
		ss.dependency 'UITextView+Placeholder', '~> 1'
		ss.dependency 'MBProgressHUD', '~> 1'
		ss.dependency 'ChameleonFramework', '~> 2'
	end

	s.subspec 'Alamofire' do |ss|
		ss.dependency 'Alamofire', '~> 5'
		ss.dependency 'Renetik/Core'
		ss.dependency 'Renetik/JsonData'
		ss.dependency 'Renetik/Operation'
		ss.source_files = 'Renetik/Classes/Alamofire/**/*'
	end

    s.subspec 'AlamofireCached' do |ss|
		ss.dependency 'Renetik/Alamofire'
		ss.source_files = 'Renetik/Classes/AlamofireCached/**/*'
	end

    s.subspec 'Operation' do |ss|
		ss.dependency 'Renetik/Core'
		ss.source_files = 'Renetik/Classes/Operation/**/*'
	end

    s.subspec 'JsonData' do |ss|
		ss.dependency 'Renetik/Core'
		ss.source_files = 'Renetik/Classes/JsonData/**/*'
	end

	s.subspec 'CoreLocation' do |ss|
		ss.dependency 'Renetik/Core'
		ss.frameworks = 'CoreLocation'
		ss.source_files = 'Renetik/Classes/CoreLocation/**/*'
	end

	s.subspec 'CocoaLumberjack' do |ss|
		ss.dependency 'Renetik/Core'
		ss.dependency 'RenetikObjc/CocoaLumberjack'
		ss.source_files = 'Renetik/Classes/CocoaLumberjack/**/*'
	end

	s.subspec 'TableController' do |ss|
		ss.dependency 'Renetik/Core'
		ss.dependency 'Renetik/Operation'
		ss.dependency 'DZNEmptyDataSet','~> 1'
		ss.dependency 'ChameleonFramework', '~> 2'
		ss.source_files = 'Renetik/Classes/TableController/**/*'
	end

	s.subspec 'AFNetworking' do |ss|
		ss.dependency 'Renetik/Core'
		ss.source_files = 'Renetik/Classes/AFNetworking/**/*'
		ss.dependency 'AFNetworking', '~> 4'
	end

	s.subspec 'SDWebImage' do |ss|
		ss.dependency 'Renetik/Core'
		ss.dependency 'SDWebImage', '~> 5'
		ss.source_files = 'Renetik/Classes/SDWebImage/**/*'
	end

	s.subspec 'CSNotification' do |ss|
		ss.dependency 'Renetik/Core'
		ss.source_files = 'Renetik/Classes/CSNotification/**/*'
		ss.dependency 'RMessage', '~> 3'
	end

	s.subspec 'XLPagerTabStrip' do |ss|
		ss.dependency 'Renetik/Core'
        ss.dependency 'XLPagerTabStrip', '~> 9'
		ss.source_files = 'Renetik/Classes/XLPagerTabStrip/**/*'
	end

	s.subspec 'DTCoreText' do |ss|
		ss.dependency 'Renetik/Core'
		ss.dependency 'DTCoreText'
# 		ss.dependency 'IDMPhotoBrowser'
#    ss.dependency 'NYTPhotoViewer'
    ss.dependency 'SKPhotoBrowser'
		ss.dependency 'ARChromeActivity'
		ss.dependency 'TUSafariActivity'
		ss.source_files = 'Renetik/Classes/DTCoreText/**/*'
	end

	s.subspec 'CSMaterial' do |ss|
        ss.dependency 'Renetik/Core'
        ss.dependency 'MaterialComponents', '~> 119'
        ss.dependency 'BlocksKit', '~> 2'
        ss.source_files = 'Renetik/Classes/CSMaterial/**/*'
    end

    s.subspec 'All' do |ss|
		ss.dependency 'Renetik/Core'
		ss.dependency 'Renetik/Alamofire'
		ss.dependency 'Renetik/AlamofireCached'
		ss.dependency 'Renetik/JsonData'
		ss.dependency 'Renetik/Operation'
		ss.dependency 'Renetik/CoreLocation'
		ss.dependency 'Renetik/CocoaLumberjack'
		ss.dependency 'Renetik/TableController'
		ss.dependency 'Renetik/AFNetworking'
		ss.dependency 'Renetik/SDWebImage'
		ss.dependency 'Renetik/CSNotification'
		ss.dependency 'Renetik/XLPagerTabStrip'
		ss.dependency 'Renetik/DTCoreText'
		ss.dependency 'Renetik/CSMaterial'
	end
end
