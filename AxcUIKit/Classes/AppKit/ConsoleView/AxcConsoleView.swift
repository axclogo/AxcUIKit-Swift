//
//  AxcConsoleView.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

import AxcBedrock

public extension AxcConsoleView {
    func _append(log: String) {
        let operation = BlockOperation { [weak self] in // 创建一个Operation任务
            guard let weakSelf = self else { return }
            let textView = weakSelf._textView
            // 是否滑动
            let isSmartScroll = textView.visibleRect.maxY == textView.bounds.maxY
            // 拼接
            let attributedString = NSAttributedString(string: "\(log)\n",
                                                      attributes: weakSelf._textAttributed)
            textView.textStorage?.append(attributedString)
            // 如果在最底部则继续滚动
            if isSmartScroll {
                textView.scrollToEndOfDocument(self)
            }
            // 更新日志进度
            weakSelf.updateLogProgressIndicator()
        }
        _logOperationQueue.addOperation(operation)
        _logOperationQueue.progress.totalUnitCount += 1
    }

    func updateLogProgressIndicator() {
        let totalUnitCount = Double(_logOperationQueue.progress.totalUnitCount)
        guard totalUnitCount > 0 else { return }
        let completedUnitCount = Double(_logOperationQueue.progress.completedUnitCount)
        _logProgressIndicator.maxValue = totalUnitCount
        _logProgressIndicator.doubleValue = completedUnitCount
    }
}

// MARK: - [AxcConsoleView]

open class AxcConsoleView: AxcView {
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

    
    private lazy var _logOperationQueue: OperationQueue = {
        let queue = OperationQueue.main
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

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
