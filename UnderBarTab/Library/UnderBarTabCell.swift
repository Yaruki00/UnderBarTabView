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
    
    static var normalTextColor = UIColor.lightGray
    static var selectedTextColor = UIColor.black
    static var normalFont = UIFont(name: "HiraginoSans-W3", size: 12.0)
    static var selectedFont = UIFont(name: "HiraginoSans-W6", size: 13.0)
    
    static func width(for text: String) -> CGFloat {
        let label = UILabel()
        label.font = UnderBarTabCell.selectedFont
        label.text = text
        label.sizeToFit()
        return label.bounds.width
    }
    
    func setData(text: String) {
        self.label.text = text
    }
    
    func setSelected(_ isSelected: Bool) {
        self.label.textColor = isSelected ? UnderBarTabCell.selectedTextColor : UnderBarTabCell.normalTextColor
        self.label.font = isSelected ? UnderBarTabCell.selectedFont : UnderBarTabCell.normalFont
    }
}
