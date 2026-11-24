# AxcView

跨平台基础视图。保留 UIView/NSView 的标准背景色、事件和 NSCoder 初始化能力，并提供统一的生命周期及回调接口。

布局由 Auto Layout 驱动；内部绘制应使用 `bounds`。回调未配置时完全保持系统默认行为。
