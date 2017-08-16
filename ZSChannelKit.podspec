
Pod::Spec.new do |s|

  s.name         = "ThirdQQSDK"
  s.version      = "0.0.1"
  s.summary      = "CocoaPods for third channels."

  s.description  = <<-DESC
                   integrate qq, wechat, sina sdk by pods
                   DESC

  s.homepage     = "https://github.com/caterpillarFly/ZSThirdKit.git"
  s.license      = "MIT"
  s.author       = { "caterpillarFly" => "zhaoshengxhu@163.com" }
  s.platform     = :ios, "8.0"
  
  s.source       = { :git => "https://github.com/caterpillarFly/ZSThirdKit.git", :tag => "#{s.version}" }

  s.source_files = ZSThirdKit/ZSThirdKit/ZSThirdKit/Channels/*.{h,m}, ZSThirdKit/ZSThirdKit/ZSThirdKit/DataInfo/*.{h,m},
  ZSThirdKit/ZSThirdKit/ZSThirdKit/Manager/*.{h,m},ZSThirdKit/ZSThirdKit/ZSThirdKit/Headers/*.{h,m}

  s.dependency   = 'WechatOpenSDK','~> 1.7.9'
  s.dependency   = 'WeiboSDK','~3.1.3'
  s.dependency   = 'ThirdQQSDK', :git => 'https://github.com/caterpillarFly/ThirdQQSDK.git', :tag => '0.0.1'

  #s.framework = "CoreTelephony", "CoreGraphics", "SystemConfiguration", "Security"
  #s.libraries = "iconv", "sqlite3", "stdc++", "z"

  #s.vendored_frameworks = 'sdk/**/*.{framework}'
  s.requires_arc = true

end
