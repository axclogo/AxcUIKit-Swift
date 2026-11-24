# AxcImageView

直接继承 UIImageView/NSImageView，保留系统图片渲染和动画能力，默认使用等比例适配模式。

SwiftPM 使用 `import AxcUIKitImage`；CocoaPods 使用 `pod 'AxcUIKit/Image'`。

## 公共接口

- `currentImage`：读取当前平台的 UIImage/NSImage。
- `set(image:)`：跨平台更新图片。

组件不推断业务尺寸。请使用图片固有尺寸、宽高比约束或外部 Auto Layout 约束。

```swift
let imageView = AxcImageView()
imageView.set(image: image)
```
