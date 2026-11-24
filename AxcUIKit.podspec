Pod::Spec.new do |s|
  s.name = 'AxcUIKit'
  s.version = '1.0.0'
  s.summary = '由基础组件逐层组合而成的 iOS 与 macOS 组件库'
  s.description = <<-DESC
    AxcUIKit 提供统一协议、跨平台基础视图和可按需导入的标准组件。
    组件优先复用 UIKit/AppKit 的系统能力，并通过小组件组合构建进阶组件。
  DESC

  s.homepage = 'https://github.com/axclogo/AxcUIKit-Swift'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { '赵新' => 'axclogo@163.com' }
  s.social_media_url = 'https://github.com/axclogo/'
  s.source = {
    :git => 'https://github.com/axclogo/AxcUIKit-Swift.git',
    :tag => s.version.to_s
  }

  s.swift_version = '5.7'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '11.0'
  s.static_framework = true
  s.requires_arc = true
  s.pod_target_xcconfig = { 'CODE_SIGNING_ALLOWED' => 'NO' }

  s.default_subspecs = 'Core', 'Gradient', 'Label', 'Bubble', 'Table', 'Collection', 'Button', 'Image', 'Scroll', 'Stack', 'AppKit'

  s.subspec 'Core' do |core|
    core.source_files = 'AxcUIKit/Classes/Core/**/*.swift'
    core.dependency 'AxcBedrock', '~> 2.0'
  end

  s.subspec 'Gradient' do |gradient|
    gradient.source_files = 'AxcUIKit/Classes/Gradient/**/*.swift'
    gradient.dependency 'AxcUIKit/Core'
  end

  s.subspec 'Label' do |label|
    label.source_files = 'AxcUIKit/Classes/Label/**/*.swift'
    label.dependency 'AxcUIKit/Gradient'
    label.dependency 'SnapKit', '~> 5.7.1'
  end

  s.subspec 'Bubble' do |bubble|
    bubble.source_files = 'AxcUIKit/Classes/Bubble/**/*.swift'
    bubble.dependency 'AxcUIKit/Gradient'
    bubble.dependency 'SnapKit', '~> 5.7.1'
  end

  s.subspec 'Table' do |table|
    table.source_files = 'AxcUIKit/Classes/Table/**/*.swift'
    table.dependency 'AxcUIKit/Core'
  end

  s.subspec 'Collection' do |collection|
    collection.ios.source_files = 'AxcUIKit/Classes/Collection/**/*.swift'
  end

  s.subspec 'Button' do |button|
    button.source_files = 'AxcUIKit/Classes/Button/**/*.swift'
  end

  s.subspec 'Image' do |image|
    image.source_files = 'AxcUIKit/Classes/Image/**/*.swift'
    image.dependency 'AxcBedrock', '~> 2.0'
  end

  s.subspec 'Scroll' do |scroll|
    scroll.source_files = 'AxcUIKit/Classes/Scroll/**/*.swift'
    scroll.dependency 'AxcUIKit/Core'
  end

  s.subspec 'Stack' do |stack|
    stack.source_files = 'AxcUIKit/Classes/Stack/**/*.swift'
  end

  s.subspec 'AppKit' do |appkit|
    appkit.osx.source_files = 'AxcUIKit/Classes/AppKit/**/*.swift'
    appkit.dependency 'AxcUIKit/Core'
    appkit.dependency 'SnapKit', '~> 5.7.1'
  end
end
