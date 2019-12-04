//
//  UnderBarTabConfig.swift
//  UnderBarTab
//
//  Created by Yuta Kawabe on 2019/12/04.
//  Copyright © 2019 yuta kawabe. All rights reserved.
//

import Foundation
import UIKit

struct UnderBarTabViewConfig {
    let type: UnderBarTabWidthType
    let insets: UIEdgeInsets
    let itemSpacing: CGFloat
    let emphasisIndex: Int?
    let underBarColor: UIColor
    let cellConfig: UnderBarTabCellConfig
    
    init(type: UnderBarTabWidthType = .flexible(margin: 8.0),
         insets: UIEdgeInsets = .zero,
         itemSpacing: CGFloat = .zero,
         emphasisIndex: Int? = nil,
         underBarColor: UIColor = .blue,
         cellConfig: UnderBarTabCellConfig = UnderBarTabCellConfig()) {
        self.type = type
        self.insets = insets
        self.itemSpacing = itemSpacing
        self.emphasisIndex = emphasisIndex
        self.underBarColor = underBarColor
        self.cellConfig = cellConfig
    }
}

struct UnderBarTabCellConfig {
    let normalTextColor: UIColor
    let selectedTextColor: UIColor
    let emphasisTextColor: UIColor
    let normalTextFont: UIFont
    let selectedTextFont: UIFont
    
    init(normalTextColor: UIColor = .lightGray,
         selectedTextColor: UIColor = .red,
         emphasisTextColor: UIColor = .black,
         normalTextFont: UIFont = UIFont(name: "HiraginoSans-W3", size: 12.0)!,
         selectedTextFont: UIFont = UIFont(name: "HiraginoSans-W6", size: 13.0)!) {
        self.normalTextColor = normalTextColor
        self.selectedTextColor = selectedTextColor
        self.emphasisTextColor = emphasisTextColor
        self.normalTextFont = normalTextFont
        self.selectedTextFont = selectedTextFont
    }
}
