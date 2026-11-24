# 发行流程

1. 更新 `AxcUIKit.podspec` 中的版本和变更记录。
2. 本地执行 `swift build`、`swift test` 和 `pod lib lint AxcUIKit.podspec`。
3. 合并到 `master`，等待 CI 的 macOS、iOS 构建通过。
4. 创建与 Podspec 完全一致的语义化版本标签，例如 `1.1.0`，并推送标签。
5. Swift Package Manager 会直接使用该 Git 标签；CocoaPods 使用 `pod trunk push AxcUIKit.podspec` 发布。

SwiftPM 中的 AxcBedrock 当前固定到包含 Package.swift 的明确提交，因为其已发布的 `1.1.4` 标签中还没有 SwiftPM 清单。AxcBedrock 发布包含清单的新标签后，再切换为语义化版本依赖。
