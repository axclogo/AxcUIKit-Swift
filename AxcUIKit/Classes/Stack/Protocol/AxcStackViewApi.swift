/// 堆叠布局组件的跨平台公共接口。
public protocol AxcStackViewApi {
    /// 当前堆叠轴向。
    var stackAxis: AxcStackAxis { get }
    /// 更新堆叠轴向。
    func set(axis: AxcStackAxis)
    /// 同时从 arrangedSubviews 和视图层级移除子视图。
    func removeArrangedSubviewCompletely(_ view: AxcStackArrangedView)
}
