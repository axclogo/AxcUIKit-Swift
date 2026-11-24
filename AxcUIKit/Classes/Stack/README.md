# AxcStackView

直接继承 UIStackView/NSStackView，统一轴向设置和彻底移除 arrangedSubview 的操作。间距、分布、对齐继续使用系统属性。

SwiftPM 使用 `import AxcUIKitStack`；CocoaPods 使用 `pod 'AxcUIKit/Stack'`。

## 公共接口

- `stackAxis`：读取当前平台的堆叠轴向。
- `set(axis:)`：跨平台更新轴向。
- `removeArrangedSubviewCompletely(_:)`：同时移除排列关系和视图层级。

排列子视图尺寸仍由固有尺寸、系统分布规则和 Auto Layout 约束共同决定。

```swift
let stackView = AxcStackView()
stackView.set(axis: .vertical)
stackView.addArrangedSubview(contentView)
```
