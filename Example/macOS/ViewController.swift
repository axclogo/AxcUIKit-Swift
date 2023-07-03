//
//  ViewController.swift
//  macOS
//
//  Created by 赵新 on 2023/6/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Cocoa
import SnapKit
import AxcUIKit
import AxcBedrock

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = AxcLabel()
        label.set(backgroundColor: AxcBedrockColor.white)
//        label._label.attributedStringValue = "Hello WorldHello WorldHello WorldHello WorldHello WorldHello World"
//            .axc.makeAttributed({ make in
//                make.set(font: 16)
//                    .set(foregroundColor: AxcBedrockColor.black)
//            })
        label.set(text: "Hello WorldHello WorldHello WorldHello WorldHello WorldHello World")
        label.set(textFont: 16.axc.nsFont(weight: .bold))
        label.set(contentEdgeInsets: 8.axc.edge)
//        label.set(textBackgroundColor: "FF0000")
//        label.set(numberOfLineType: .infinite)
//        label.set(textLineBreakMode: .byTruncatingTail)
        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.equalTo(120)
//            make.height.equalTo(120)
        }

        AxcGCD.Delay(delay: 2) {
            label.set(lineSpacing: 20)
            label.set(textBackgroundColor: AxcBedrockColor.green)
            print("延迟结束")
        }
        AxcGCD.Delay(delay: 3) {
            label.set(text: "Hello WorldHello WorldHello World")
            print("延迟结束")
        }
        AxcGCD.Delay(delay: 4) {
            label.set(lineSpacing: 8)
            label.set(textBackgroundColor: AxcBedrockColor.green)
            print("延迟结束")
        }

        let textField = _AxcNSLabel()
        textField.backgroundColor = .lightGray
        textField.attributedStringValue = "Hello WorldHello WorldHello WorldHello WorldHello WorldHello World"
            .axc.makeAttributed({ make in
                make.set(font: 16)
            })

        let contentView = AxcView()
        contentView.set(backgroundColor: NSColor.white)
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8.axc.edge)
        }

        let testView = AxcView()
        testView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8.axc.edge)
        }

        view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(120)
        }

        AxcGCD.Delay(delay: 2) {
            textField.attributedStringValue = textField.attributedStringValue.axc.makeAttributed { make in
                make.set(paragraphStyle: NSMutableParagraphStyle.Axc.CreateParagraphStyle({ make in
                    make.set(lineSpacing: 20)
                }))
            }
            print("延迟结束")
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
