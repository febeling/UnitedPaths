# -*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name         = "UnitedPaths"
  s.version      = "0.0.1"
  s.summary      = "Boolean operations with bezier paths"

  s.description  = <<-DESC
                   A longer description of UnitedPaths in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   DESC

  s.homepage     = "http://github.com/febeling"
  s.license      = "MIT"
  s.license      = { type: "MIT", file: "LICENSE" }
  s.author             = { "Florian Ebeling" => "florian.ebeling@gmail.com" }
  s.social_media_url   = "http://twitter.com/febeling"

  s.platform     = :osx, "10.7"
  # When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"

  s.source       = { git: "https://github.com/febeling/UnitedPaths.git", :tag => "0.0.1" }
  s.source_files  = "UnitedPaths", "UnitedPaths/Source/**/*.{h,m}"
  s.requires_arc = true
  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
end
