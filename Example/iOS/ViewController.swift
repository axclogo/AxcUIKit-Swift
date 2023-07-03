//
//  ViewController.swift
//  iOS
//
//  Created by 赵新 on 2023/6/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import AxcUIKit
import AxcBedrock

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemGray
        
        let label = AxcLabel()
        label.set(text: "Hello WorldHello WorldHello WorldHello WorldHello WorldHello World")
        label.set(textFont: 16.axc.uiFont(weight: .bold))
        label.set(textBackgroundColor: "FF0000")
        label.set(contentEdgeInsets: 8.axc.edge)
        label.set(numberOfLineType: .infinite)
//        label.set(textLineBreakMode: .byTruncatingTail)
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(120)
//            make.height.equalTo(120)
        }
        
        AxcGCD.Delay(delay: 2) {
            label.set(lineSpacing: 20)
            print("延迟结束")
        }
        AxcGCD.Delay(delay: 3) {
            label.set(textBackgroundColor: UIColor.green)
            print("延迟结束")
        }
        AxcGCD.Delay(delay: 4) {
            label.set(text: "Hello World")
            print("延迟结束")
        }
        
    }


}

