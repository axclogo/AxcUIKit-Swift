//
//  AxcCollectionView.swift
//  AxcUIKit
//
//  Created by 赵新 on 2023/6/22.
//

#if canImport(UIKit)

import UIKit

/// 基于 UICollectionView 的标准集合视图。
///
/// 默认构造使用 UICollectionViewFlowLayout，也可以传入系统或自定义布局。
open class AxcCollectionView: UICollectionView {
    public convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

#endif
