//
//  UnderBarTabCell.swift
//  UnderBarTab
//
//  Created by Yuta Kawabe on 2019/10/30.
//  Copyright © 2019 yuta kawabe. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Reusable

final class UnderBarTabCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var label: UILabel!
    
    private(set) var reuseDisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }
    
    static func width(for text: String, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.bounds.width
    }
    
    func setData(text: String) {
        self.label.text = text
    }
    
    func setAppearance(_ config: UnderBarTabCellConfig, isSelected: Bool, isEmphasis: Bool) {
        self.label.textColor = isSelected ? config.selectedTextColor : isEmphasis ? config.emphasisTextColor : config.normalTextColor
        self.label.font = isSelected ? config.selectedTextFont : config.normalTextFont
    }
}
