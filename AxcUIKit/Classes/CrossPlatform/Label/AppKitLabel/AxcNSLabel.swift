//
//  AxcNSLabel.swift
//  AxcBedrock
//
//  Created by 赵新 on 2023/6/30.
//

#if canImport(AppKit)

//import AppKit
//
///**
// * Style
// */
//public extension AxcNSLabel {
//    /**
//     * set style
//     */
//    func setStyle(style: NSLabel.Style) {
//        self.drawsBackground = style.backgroundColor != .clear
//        self.backgroundColor = style.backgroundColor
//        self.font = style.font
//        self.isBordered = style.isBordered
//        self.textColor = style.textColor
//        self.textAlignment = style.textAlignment
//        centerVertically()
//    }
//}
//
///**
// * Style
// */
//public extension AxcNSLabel {
//    /**
//     * Fixme: ⚠️️ add border color?
//     */
//    struct Style {
//        public let textColor: NSColor
//        public let font: NSFont
//        public let textAlignment: NSTextAlignment
//        public let centerVertically: Bool
//        public let backgroundColor: NSColor
//        public let isBordered: Bool
//    }
//}
//
//public extension NSLabel.Style {
//    static var `default`: NSLabel.Style {
//        .init(textColor: .black, font: .systemFont(ofSize: 20), textAlignment: .center, centerVertically: true, backgroundColor: .clear, isBordered: false)
//    }
//}
//
open class AxcNSLabel: NSTextField {
//    /**
//     * - Fixme: ⚠️️ write doc
//     */
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        self.isBezeled = false
//        self.drawsBackground = false
//        self.isEditable = false
//        self.isSelectable = false
//    }
//
//    /**
//     * Boilerplate
//     */
//    @available(*, unavailable)
//    public required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    open var textAlignment: NSTextAlignment {
//        get { self.alignment }
//        set { self.alignment = newValue }
//    }
//
//    /**
//     * Sets the text of the label
//     * - Note: This doesn't have to be optional, but Label.text in ios is optional so to make the call consistent we make it optional
//     */
//    open var text: String? {
//        get { self.stringValue }
//        set { self.stringValue = newValue ?? self.stringValue }
//    }
//
//    open override func hitTest(_ point: NSPoint) -> NSView? {
//        isEnabled ? super.hitTest(point) : nil
//    }
//
//    /**
//     * Fixme: ⚠️️ This is not optimal, there could be a better way to do this, maybe look into: baselineOffset attributed string etc
//     * Fixme: ⚠️️ add support for background color
//     */
//    public func centerVertically() {
//        let textHeight = self.attributedStringValue.size().height
//        let font = self.font
//        let isBordered = self.isBordered
//        let textAlignment = self.textAlignment
//        let textColor = self.textColor
//        let isEnabled = self.isEnabled
//        self.cell = VerticallyAlignedTextFieldCell(textHeight: textHeight, textCell: self.stringValue)
//        self.font = font // ⚠️️ We have to re-apply these after cell is set
//        self.isBordered = isBordered
//        self.textColor = textColor
//        self.isEnabled = isEnabled
//        self.textAlignment = textAlignment
//    }
}

#endif
