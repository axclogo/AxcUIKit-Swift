# AxcScrollView

基于 UIScrollView/NSScrollView，内置 `documentContentView` 作为 Auto Layout 内容容器。垂直模式自动固定内容宽度，水平模式自动固定内容高度，双向模式由内容约束决定尺寸。

SwiftPM 使用 `import AxcUIKitScroll`；CocoaPods 使用 `pod 'AxcUIKit/Scroll'`。

## 公共接口

- `documentContentView`：所有业务子视图的内容容器。
- `scrollAxis`：当前的 `.vertical`、`.horizontal` 或 `.both` 模式。
- `set(axis:)`：运行时切换滚动方向和交叉轴约束。

业务子视图应完整约束到 `documentContentView`，并让内容约束确定滚动轴长度。

```swift
let scrollView = AxcScrollView(axis: .vertical)
scrollView.documentContentView.addSubview(contentView)
// 将 contentView 四边约束到 documentContentView，内容高度决定滚动范围。
```
