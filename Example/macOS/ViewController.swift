//
//  ViewController.swift
//  macOS
//
//  Created by 赵新 on 2023/6/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Cocoa

import AxcUIKit
import SnapKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let label = AxcLabel()
        label.set(text: "Hello World")
        label.set(textBackgroundColor: "FF0000")
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
//            make.size.equalTo(100)
        }
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

