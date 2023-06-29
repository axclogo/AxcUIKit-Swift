//
//  iOS_WidgetBundle.swift
//  iOS_Widget
//
//  Created by 赵新 on 2023/6/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct iOS_WidgetBundle: WidgetBundle {
    var body: some Widget {
        iOS_Widget()
        iOS_WidgetLiveActivity()
    }
}
