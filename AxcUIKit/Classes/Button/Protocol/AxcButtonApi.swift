/// 按钮组件的跨平台公共接口。
public protocol AxcButtonApi {
    /// 普通状态下的标题。
    var buttonTitle: String? { get }

    /// 设置普通状态下的标题。
    func set(title: String?)
}
