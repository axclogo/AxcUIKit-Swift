//
//  ViewController.swift
//  macOS
//
//  Created by 赵新 on 2023/6/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Cocoa

import AxcUIKit
import AxcBedrock
import SnapKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let label = AxcLabel()
        label.set(text: "Hello WorldHello WorldHello World")
        label.set(textFont: 20.axc.nsFont(weight: .bold))
        label.set(textBackgroundColor: "FF0000")
        label.set(contentEdgeInsets: 8.axc.edge)
//        label.set(textLineBreakMode: .byTruncatingTail)
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(80)
//            make.height.equalTo(80)
        }
        
        AxcGCD.Delay(delay: 2) {
            label.set(lineSpacing: 25)
            print("延迟结束")
        }
        AxcGCD.Delay(delay: 3) {
            label.set(textBackgroundColor: NSColor.green)
            print("延迟结束")
        }
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

