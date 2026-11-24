/// 图片组件的跨平台公共接口。
public protocol AxcImageViewApi {
    /// 当前显示的系统图片。
    var currentImage: AxcSystemImage? { get }

    /// 更新当前显示的系统图片。
    func set(image: AxcSystemImage?)
}
