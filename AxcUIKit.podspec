#
#  Be sure to run `s.dependency spec lint AxcBadrock.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    
    s.name         = "AxcUIKit"
    
    # UI控件库版本
    s.version      = "1.0.0"
    
    s.swift_version = '5.0'
    
    s.summary      = "AxcUI控件库"
    
    s.homepage     = "https://github.com/axclogo/AxcUIKit-Swift"
    
    s.license      = { :type => "MIT", :file => "LICENSE" }
    
    s.author       = { "赵新" => "axclogo@163.com" }
    
    s.social_media_url   = "https://github.com/axclogo/"
    
    s.source       = { :git => "https://github.com/axclogo/AxcUIKit-Swift.git", :tag => s.version }
    
    s.static_framework = true
    
    s.requires_arc = true
    
    s.pod_target_xcconfig = {
        'CODE_SIGNING_ALLOWED' => 'NO'
    }
    
    # 设置子库 ===>
    # 文件类型
    fileType = "{swift,h,m,mm,cpp}"
    # 基础路径
    baseFilePath = "AxcUIKit/Classes"
    
    # 核心文件（不可或缺）
    Core_files = [
    "#{baseFilePath}/Core/**/*.#{fileType}"
    ]
    # 跨平台文件
    CrossPlatform_files = "#{baseFilePath}/CrossPlatform/**/*.#{fileType}"
    QuartzCore_files = "#{baseFilePath}/QuartzCore/**/*.#{fileType}"
    
    
    #iOS平台
    s.ios.deployment_target = '11.0'
    
    # iOS平台文件
    ios_source_files =
    Core_files +
    [
    "#{baseFilePath}/UIKit/**/*.#{fileType}", # 主要文件
    CrossPlatform_files,
    QuartzCore_files
    ]
    s.ios.source_files = ios_source_files
    
    
    # macOS平台
    s.osx.deployment_target = '11.0'
    
    # macOS平台文件
    osx_source_files =
    Core_files +
    [
    "#{baseFilePath}/AppKit/**/*.#{fileType}", # 主要文件
    CrossPlatform_files,
    QuartzCore_files
    ]
    s.osx.source_files = osx_source_files
    
    
    # 核心
    s.subspec 'Core' do |c|
        c.source_files = Core_files
        c.dependency 'AxcBedrock', '1.0.0'
        c.dependency 'SnapKit'
    end


#    # iOS平台
#    s.subspec 'iOS' do |c|
#        # Objs对象类
#        s.subspec 'Objs' do |c|
#            # Transition转场动画
#            c.subspec 'Transition' do |c|
#                c.source_files = "AxcUIKit/Classes/Objs/Transition/**/*.#{fileType}"
#                c.dependency 'AxcUIKit/Core'
#            end
#
#            # Present模态器
#            c.subspec 'Present' do |c|
#                c.source_files = "AxcUIKit/Classes/Objs/Present/**/*.#{fileType}"
#                c.dependency 'AxcUIKit/Objs/Transition'
#            end
#
#            # Collection布局器
#            c.subspec 'CollectionLayout' do |c|
#                c.source_files = "AxcUIKit/Classes/Objs/CollectionLayout/**/*.#{fileType}"
#                c.dependency 'AxcUIKit/Core'
#            end
#
#        end
#
#        # 视图控件类
#        s.subspec 'Views' do |c|
#            # 基础视图
#            c.subspec 'View' do |c|
#                c.source_files = "AxcUIKit/Classes/Views/View/**/*.#{fileType}"
#                c.dependency 'AxcUIKit/Core'
#            end
#
#            # 气泡视图
#            c.subspec 'BubbleView' do |c|
#                c.source_files = "AxcUIKit/Classes/Views/BubbleView/**/*.#{fileType}"
#                c.dependency 'AxcUIKit/Views/View'
#                c.dependency 'SnapKit'
#            end
#
#        end
#    end
#
#    # MacOS平台
#    s.subspec 'MacOS' do |c|
#    end
#
#
#    # 通用平台
#    # 图片对象，支持网络本地加载
#    s.subspec 'Image' do |c|
#        c.source_files = "AxcUIKit/Classes/Objs/Image/**/*.#{fileType}"
#        c.dependency 'AxcUIKit/Core'
#        c.dependency 'Kingfisher'
#    end
#
#    # 文字对象，支持富文本、普通文字等相互转换
#    s.subspec 'Text' do |c|
#        c.source_files = "AxcUIKit/Classes/Objs/Text/**/*.#{fileType}"
#        c.dependency 'AxcUIKit/Core'
#    end
#
#    # 大小对象，支持比率、数值大小
#    s.subspec 'Size' do |c|
#        c.source_files = "AxcUIKit/Classes/Objs/Size/**/*.#{fileType}"
#        c.dependency 'AxcUIKit/Core'
#    end
end
