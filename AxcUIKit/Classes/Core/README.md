# Core

核心模块包含统一生命周期、回调命名空间、基础 View、ViewController 和 Layer。其他组件只依赖这里的最小公共能力。

数据通道通过 AxcBedrock 的类型化关联对象和 `AxcOnce` 保证每个宿主实例只绑定一次。

SwiftPM 使用 `import AxcUIKitCore`；CocoaPods 使用 `pod 'AxcUIKit/Core'`。
