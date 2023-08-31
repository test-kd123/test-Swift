Pod::Spec.new do |s|

  s.name         = "MyApiLibraryDemo"
  s.version      = "0.1.0"
  s.summary      = "MyApiLibraryDemo."

  s.description  = <<-DESC
                    this is MyApiLibraryDemo
                   DESC

  s.homepage     = "https://github.com/test-kd123/test-Swift.git"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author       = "TangChao"

  # s.platform     = :ios, "10.0"

  #  When using multiple platforms
   s.ios.deployment_target = "11.0"
   s.osx.deployment_target = "10.13"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "git@github.com:test-kd123/test-Swift.git", :tag => s.version.to_s }

  s.source_files  = "MyApiLibraryDemo/src/**/*.swift"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resources  = "xx/xx/**/*.{storyboard,xib}", "TCCommonKit/Assets.xcassets"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
s.xcconfig = { "GENERATE_INFOPLIST_FILE" => "YES" }
  #  s.dependency "Masonry", '~> 1.1.0'
  # s.dependency "UMengUShare/Social/WeChat"
  # s.dependency "UMengUShare/Social/QQ""
end
