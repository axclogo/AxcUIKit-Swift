//
//  _AxcNSLabel.swift
//  Pods
//
//  Created by 赵新 on 2023/7/2.
//

#if canImport(AppKit)
import AppKit

open class _AxcNSLabel: NSTextField {
   public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        defaultConfig()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func hitTest(_ point: NSPoint) -> NSView? {
        isEnabled ? super.hitTest(point) : nil
    }
    
    func defaultConfig() {
        isBezeled = false
        isEditable = false // 不可编辑
        isBordered = false // 不显示边框
        isSelectable = false
        drawsBackground = true // 渲染背景色
    }
    
    // MARK: 桥接属性（这里没采用Api协议方式是因为需要统一Label默认的Api）

    /// 文字对齐
    var textAlignment: NSTextAlignment {
        set { alignment = newValue }
        get { return alignment } 
    }

    /// 富文本
    var attributedText: NSAttributedString? {
        set { attributedStringValue = newValue ?? NSAttributedString() }
        get { return attributedStringValue }
    }

    /// 行数
    var numberOfLines: Int {
        set {  maximumNumberOfLines = newValue }
        get { return maximumNumberOfLines }
    }
}

#endif
