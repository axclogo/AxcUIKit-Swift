# AxcUIKit

AxcUIKit 是一个以小组件组合为核心的 iOS 与 macOS 组件库。基础组件只负责一种能力，进阶组件通过继承或持有基础组件继续组合；UIKit/AppKit 已经提供的列表、集合和复用能力直接使用系统实现。

最低支持 iOS 12、macOS 11 和 Swift 5.7。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File → Add Package Dependencies**，填入：

```text
https://github.com/axclogo/AxcUIKit-Swift.git
```

全量导入：

```swift
import AxcUIKit
```

按需导入可选择 `AxcUIKitCore`、`AxcUIKitGradient`、`AxcUIKitLabel`、`AxcUIKitBubble`、`AxcUIKitTable`、`AxcUIKitCollection`、`AxcUIKitButton`、`AxcUIKitImage`、`AxcUIKitScroll`、`AxcUIKitStack` 或仅限 macOS 的 `AxcUIKitAppKit`。

### CocoaPods

```ruby
# 全量
pod 'AxcUIKit'

# 按需，例如只使用 Label；依赖的 Core 和 Gradient 会自动引入
pod 'AxcUIKit/Label'
```

可用 subspec：`Core`、`Gradient`、`Label`、`Bubble`、`Table`、`Collection`、`Button`、`Image`、`Scroll`、`Stack`、`AppKit`。
CocoaPods 的 subspec 只控制编译内容，业务代码仍统一使用 `import AxcUIKit`。

## 组件清单

| 组件 | 主要类型 | 平台 | 定位 |
| --- | --- | --- | --- |
| Core | `AxcView`、`AxcLayer`、`AxcViewController` | iOS / macOS | 生命周期、数据通道与基础视图 |
| Gradient | `AxcGradientLayer`、`AxcGradientView` | iOS / macOS | 渐变绘制能力 |
| Label | `AxcLabel` | iOS / macOS | 动态文本、边距、边框与标线 |
| Bubble | `AxcBubbleView` | iOS / macOS | 带箭头的动态气泡容器 |
| Table | `AxcTableView`、`AxcTableViewCell` | iOS / macOS | 系统表格与复用单元 |
| Collection | `AxcCollectionView` | iOS | 系统集合视图 |
| Button | `AxcButton` | iOS / macOS | 系统按钮的统一标题接口 |
| Image | `AxcImageView` | iOS / macOS | 系统图片视图的统一图片接口 |
| Scroll | `AxcScrollView` | iOS / macOS | 带动态内容容器的滚动视图 |
| Stack | `AxcStackView` | iOS / macOS | 系统堆叠布局的统一轴向接口 |
| AppKit | `AxcConsoleView`、`AxcTargetDragView` | macOS | 控制台输出与拖放目标 |

## 组件关系

```text
Core
├── Gradient
│   ├── Label
│   └── Bubble
├── Table
├── Scroll
└── AppKit

Collection（直接基于 UICollectionView）
Button（直接基于 UIButton/NSButton）
Image（直接基于 UIImageView/NSImageView）
Stack（直接基于 UIStackView/NSStackView）
```

组件协议统一放在各组件的 `Protocol` 目录，平台桥接实现统一放在 `Bridge` 目录。每个组件目录的 README 说明职责、依赖和布局规则。

## 开发约定

- 优先复用系统组件和系统版本兼容能力。
- 对外布局使用 Auto Layout；内部绘制以 `bounds` 为准，不依赖写死坐标。
- setter 只更新状态并触发布局，连续配置在下一次布局统一绘制。
- 新组件必须有中文公开注释、组件 README，以及覆盖核心行为的测试。
