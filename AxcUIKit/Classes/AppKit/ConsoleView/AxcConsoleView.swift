//
//  AxcConsoleView.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

#if canImport(AppKit)

import AppKit
#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif
#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif
import SnapKit

public extension AxcConsoleView {
    /// 追加日志。多线程连续调用会在下一次主线程刷新时合并写入。
    func append(log: String) {
        _logLock.lock()
        _pendingLogs.append(log)
        _totalLogCount += 1
        let shouldSchedule = !_isFlushScheduled
        _isFlushScheduled = true
        _logLock.unlock()

        guard shouldSchedule else { return }
        DispatchQueue.main.async { [weak self] in
            self?._flushPendingLogs()
        }
    }

    /// 清空控制台。
    func clear() {
        _logLock.lock()
        _pendingLogs.removeAll(keepingCapacity: true)
        _totalLogCount = 0
        _logLock.unlock()
        DispatchQueue.main.async { [weak self] in
            self?._textView.textStorage?.setAttributedString(NSAttributedString())
            self?._logProgressIndicator.doubleValue = 0
        }
    }

    @available(*, deprecated, renamed: "append(log:)")
    func _append(log: String) {
        append(log: log)
    }
}

private extension AxcConsoleView {
    func _flushPendingLogs() {
        _logLock.lock()
        let logs = _pendingLogs
        _pendingLogs.removeAll(keepingCapacity: true)
        _isFlushScheduled = false
        let totalLogCount = _totalLogCount
        _logLock.unlock()

        guard !logs.isEmpty, let textStorage = _textView.textStorage else { return }
        let shouldScrollToEnd = _textView.visibleRect.maxY >= _textView.bounds.maxY
        let content = logs.joined(separator: "\n") + "\n"
        textStorage.append(NSAttributedString(string: content, attributes: _textAttributed))
        _trimTextStorageIfNeeded(textStorage)

        _logProgressIndicator.maxValue = Double(max(1, totalLogCount))
        _logProgressIndicator.doubleValue = Double(totalLogCount)
        if shouldScrollToEnd {
            _textView.scrollToEndOfDocument(self)
        }
    }

    func _trimTextStorageIfNeeded(_ textStorage: NSTextStorage) {
        guard maximumCharacterCount > 0,
              textStorage.length > maximumCharacterCount else { return }
        let overflow = textStorage.length - maximumCharacterCount
        let source = textStorage.string as NSString
        let searchRange = NSRange(location: overflow, length: source.length - overflow)
        let lineBreak = source.range(of: "\n", options: [], range: searchRange)
        let deleteLength = lineBreak.location == NSNotFound ? overflow : NSMaxRange(lineBreak)
        textStorage.deleteCharacters(in: NSRange(location: 0, length: deleteLength))
    }
}

// MARK: - [AxcConsoleView]

open class AxcConsoleView: AxcView {
    /// 控制台最多保留的字符数；设置为 0 表示不限制。
    open var maximumCharacterCount = 1_000_000

    open override func makeUI() {
        super.makeUI()
        set(backgroundColor: NSColor.black)

        addSubview(_logProgressIndicator)
        _logProgressIndicator.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        addSubview(_scrollView)
        _scrollView.snp.makeConstraints { make in
            make.top.equalTo(_logProgressIndicator.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private let _logLock = NSLock()
    private var _pendingLogs: [String] = []
    private var _isFlushScheduled = false
    private var _totalLogCount: Int64 = 0

    private lazy var _scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.backgroundColor = NSColor.black
        scrollView.hasVerticalScroller = true
        scrollView.documentView = _textView
        return scrollView
    }()

    private lazy var _textAttributed: [NSAttributedString.Key: Any] = {
        let fontSize: CGFloat = 6
        var attributedFont = fontSize.axc.nsFont
        if let font = NSFont(name: "Monaco", size: fontSize) {
            attributedFont = font
        }
        let textColorAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.white,
            .font: attributedFont,
        ]
        return textColorAttribute
    }()

    private lazy var _logProgressIndicator: NSProgressIndicator = {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.isIndeterminate = false
        progressIndicator.isBezeled = true
        progressIndicator.style = .bar
        progressIndicator.minValue = 0
        return progressIndicator
    }()

    private lazy var _textView: NSTextView = {
        let textView = NSTextView()
        textView.backgroundColor = NSColor.clear
        textView.isEditable = false
        textView.drawsBackground = false
        textView.toggleAutomaticQuoteSubstitution(nil)
        textView.toggleGrammarChecking(nil)
        textView.toggleAutomaticDashSubstitution(nil)
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.autoresizingMask = .width
        textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        return textView
    }()
}

#endif
