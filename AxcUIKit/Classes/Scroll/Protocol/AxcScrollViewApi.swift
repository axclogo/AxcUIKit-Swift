#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif

/// 动态滚动容器的跨平台公共接口。
public protocol AxcScrollViewApi {
    /// 承载业务内容的动态布局容器。
    var documentContentView: AxcView { get }
    /// 当前滚动轴向。
    var scrollAxis: AxcScrollAxis { get }
    /// 切换滚动轴向并更新交叉轴约束。
    func set(axis: AxcScrollAxis)
}
