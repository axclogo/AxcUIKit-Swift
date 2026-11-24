# AxcButton

直接继承 UIButton/NSButton，保留系统事件、状态、菜单和无障碍能力，仅补充统一的普通标题接口。

SwiftPM 使用 `import AxcUIKitButton`；CocoaPods 使用 `pod 'AxcUIKit/Button'`。

## 公共接口

- `buttonTitle`：读取普通状态标题。
- `set(title:)`：跨平台更新普通状态标题。

尺寸继续由系统固有尺寸或外部 Auto Layout 约束决定，组件不写死宽高。

```swift
let button = AxcButton()
button.set(title: "确认")
```
