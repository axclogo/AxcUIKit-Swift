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
    s.version      = "1.1.0"
    
    s.swift_version = '5.0'
    
    s.summary      = "AxcUI控件库"
    
    s.homepage     = "https://github.com/axclogo/AxcUIKit-Swift"
    
    s.license      = { :type => "MIT", :file => "LICENSE" }
    
    s.author       = { "赵新" => "axclogo@163.com" }
    
    s.social_media_url   = "https://github.com/axclogo/"
    
    s.source       = { :git => "https://github.com/axclogo/AxcUIKit-Swift.git", :tag => s.version }
    
    
    
    s.ios.deployment_target = '10.0'
    
    
    fileType = "{swift,h,m,mm,cpp}"
    
    s.source_files  = "AxcUIKit/Classes/**/*.#{fileType}"
    
    s.static_framework = true
    s.requires_arc = true
    
    s.pod_target_xcconfig = {
        'CODE_SIGNING_ALLOWED' => 'NO'
    }
    
    
    # 设置子库
    # 核心
    s.subspec 'Core' do |c|
        c.source_files = "AxcUIKit/Classes/Core/**/*.#{fileType}"
        c.dependency 'AxcBedrock', '5.0.5'
        c.dependency 'AxcSere', '1.0.0'
        s.dependency 'SnapKit'
    end
    
    
    # Objs对象类
    s.subspec 'Objs' do |c|
        # Transition转场动画
        c.subspec 'Transition' do |c|
            c.source_files = "AxcUIKit/Classes/Objs/Transition/**/*.#{fileType}"
            c.dependency 'AxcUIKit/Core'
        end
        
        # Present模态器
        c.subspec 'Present' do |c|
            c.source_files = "AxcUIKit/Classes/Objs/Present/**/*.#{fileType}"
            c.dependency 'AxcUIKit/Objs/Transition'
        end
        
        # Collection布局器
        c.subspec 'CollectionLayout' do |c|
            c.source_files = "AxcUIKit/Classes/Objs/CollectionLayout/**/*.#{fileType}"
            c.dependency 'AxcUIKit/Core'
        end
        
        # 图片对象，支持网络本地加载
        c.subspec 'Image' do |c|
            c.source_files = "AxcUIKit/Classes/Objs/Image/**/*.#{fileType}"
            c.dependency 'AxcUIKit/Core'
            c.dependency 'Kingfisher'
        end
        
        # 文字对象，支持富文本、普通文字等相互转换
        c.subspec 'Text' do |c|
            c.source_files = "AxcUIKit/Classes/Objs/Text/**/*.#{fileType}"
            c.dependency 'AxcUIKit/Core'
        end
        
        # 大小对象，支持比率、数值大小
        c.subspec 'Size' do |c|
            c.source_files = "AxcUIKit/Classes/Objs/Size/**/*.#{fileType}"
            c.dependency 'AxcUIKit/Core'
        end
    end
    
    # 视图控件类
    s.subspec 'Views' do |c|
        # 基础视图
        c.subspec 'View' do |c|
            c.source_files = "AxcUIKit/Classes/Views/View/**/*.#{fileType}"
            c.dependency 'AxcUIKit/Core'
        end
        
        # 气泡视图
        c.subspec 'BubbleView' do |c|
            c.source_files = "AxcUIKit/Classes/Views/BubbleView/**/*.#{fileType}"
            c.dependency 'AxcUIKit/Views/View'
            c.dependency 'SnapKit'
        end
        
    end
end