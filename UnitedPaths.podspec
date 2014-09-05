# -*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name         = "UnitedPaths"
  s.version      = "0.0.1"
  s.summary      = "A short description of UnitedPaths."

  s.description  = <<-DESC
                   A longer description of UnitedPaths in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://EXAMPLE/UnitedPaths"
  s.license      = "MIT"
  s.license      = { type: "MIT", file: "LICENSE" }
  s.author             = { "Florian Ebeling" => "florian.ebeling@gmail.com" }
  s.social_media_url   = "http://twitter.com/febeling"

  s.platform     = :osx, "10.7"
  # When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"

  s.source       = { git: "https://github.com/febeling/UnitedPaths.git", :tag => "0.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
end
