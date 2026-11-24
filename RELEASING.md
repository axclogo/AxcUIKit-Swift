# 发行流程

1. 更新 `AxcUIKit.podspec` 中的版本和变更记录。
2. 本地执行 `swift build`、`swift test` 和 `pod lib lint AxcUIKit.podspec`。
3. 合并到 `master`，等待 CI 的 macOS、iOS 构建通过。
4. 创建与 Podspec 完全一致的语义化版本标签，例如 `1.1.0`，并推送标签。
5. Swift Package Manager 会直接使用该 Git 标签；CocoaPods 使用 `pod trunk push AxcUIKit.podspec` 发布。

SwiftPM 中的 AxcBedrock 当前固定到包含新基础能力的明确提交。AxcBedrock 发布正式的 `2.0.0` 标签后，应切换为语义化版本依赖。

CocoaPods 依赖已经要求 `AxcBedrock ~> 2.0`。发布 AxcUIKit 前必须先更新并发布 AxcBedrock 2.0 的 Podspec，否则 `pod lib lint` 无法解析该依赖。
