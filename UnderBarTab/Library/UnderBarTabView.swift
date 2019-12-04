//
//  UnderBarTabView.swift
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

final class UnderBarTabView: UIView, NibOwnerLoadable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView! {
        willSet {
            newValue.register(cellType: UnderBarTabCell.self)
        }
    }
    @IBOutlet private weak var barView: UIView!
    
    fileprivate var selectedIndex = 0
    
    private var config = UnderBarTabViewConfig()
    private var texts: [String] = []
}

// MARK: - Public
extension UnderBarTabView {
    
    func setup(config: UnderBarTabViewConfig? = nil) {
        if let config = config {
            self.config = config
        }
        self.barView.backgroundColor = self.config.underBarColor
    }
    
    func setData(_ texts: [String], initialIndex: Int? = nil) {
        self.texts = texts
        UIView.animate(
            withDuration: 0.0,
            animations: {
                self.collectionView.reloadData()
            },
            completion: { _ in
                self.barView.frame.origin.y = self.collectionView.bounds.height - self.barView.bounds.height
                let index = initialIndex ?? 0
                self.rx.selectedIndex.onNext(index)
            }
        )
    }
}

// MARK: - Private
fileprivate extension UnderBarTabView {
    
    func moveUnderBar() {
        guard let attributes = self.collectionView.layoutAttributesForItem(at: IndexPath(item: self.selectedIndex, section: 0)) else {
            return
        }
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.barView.frame.origin.x = attributes.frame.origin.x
                self.barView.frame.size.width = attributes.bounds.width
            }
        )
    }
}

// MARK: - UICollectionViewDataSource
extension UnderBarTabView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UnderBarTabCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setData(text: self.texts[indexPath.item])
        cell.setAppearance(self.config.cellConfig,
                           isSelected: indexPath.item == self.selectedIndex,
                           isEmphasis: indexPath.item == self.config.emphasisIndex)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension UnderBarTabView: UICollectionViewDelegate {}

// MARK: - UICollectionViewDelegateFlowLayout
extension UnderBarTabView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.config.type {
        case .fixed(width: let width):
            return CGSize(width: width, height: self.bounds.height)
        case .flexible(margin: let margin):
            let text = self.texts[indexPath.item]
            let textWidth = UnderBarTabCell.width(for: text, font: self.config.cellConfig.selectedTextFont)
            return CGSize(width: textWidth + margin * 2, height: self.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.config.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.config.itemSpacing
    }
}

// MARK: - Reactive
extension Reactive where Base: UnderBarTabView {
    
    var tapAt: ControlEvent<Int> {
        return .init(events: base.collectionView.rx.itemSelected.map { $0.item })
    }
    
    var selectedIndex: Binder<Int> {
        return Binder(base) { view, value in
            let oldValue = view.selectedIndex
            view.selectedIndex = value
            view.collectionView.reloadItems(at: [
                IndexPath(item: oldValue, section: 0),
                IndexPath(item: value, section: 0)
            ])
            view.collectionView.scrollToItem(at: IndexPath(item: value, section: 0), at: .centeredHorizontally, animated: true)
            view.moveUnderBar()
        }
    }
}
