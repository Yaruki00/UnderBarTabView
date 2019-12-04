//
//  UnderBarInfiniteTabView.swift
//  UnderBarTab
//
//  Created by Yuta Kawabe on 2019/10/30.
//  Copyright © 2019 yuta kawabe. All rights reserved.
//

import Foundation
import Reusable
import RxCocoa
import RxSwift
import UIKit

final class UnderBarInfiniteTabView: UIView, NibOwnerLoadable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
    
    var underBarColor = UIColor.blue
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView! {
        willSet {
            newValue.register(cellType: UnderBarTabCell.self)
        }
    }
    @IBOutlet private weak var barView: UIView!
    @IBOutlet private weak var barViewWidthConstraint: NSLayoutConstraint!
    
    fileprivate var selectedIndex = 0
    fileprivate var texts: [String] = []
    
    private var config = UnderBarTabViewConfig()
}

// MARK: - Public
extension UnderBarInfiniteTabView {
    
    func setup(config: UnderBarTabViewConfig? = nil) {
        if let config = config {
            self.config = config
        }
        self.barView.backgroundColor = self.underBarColor
    }
    
    func setData(_ texts: [String], initialIndex: Int? = nil) {
        self.texts = texts
        UIView.animate(
            withDuration: 0.0,
            animations: {
                self.collectionView.reloadData()
            },
            completion: { _ in
                let index = initialIndex ?? 0
                self.selectedIndex = index + texts.count
                self.rx.selectedIndex.onNext(index)
            }
        )
    }
}

// MARK: - Private
fileprivate extension UnderBarInfiniteTabView {
    
    func moveUnderBar(animated: Bool) {
        guard let attributes = self.collectionView.layoutAttributesForItem(at: IndexPath(item: self.selectedIndex, section: 0)) else {
            return
        }
        if animated {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.barViewWidthConstraint.constant = attributes.bounds.width
                })
        }
        else {
            self.barViewWidthConstraint.constant = attributes.bounds.width
        }
    }
}

// MARK: - UICollectionViewDataSource
extension UnderBarInfiniteTabView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.texts.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item % self.texts.count
        let selectedIndex = self.selectedIndex % self.texts.count
        let cell: UnderBarTabCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setData(text: self.texts[index])
        cell.setAppearance(self.config.cellConfig,
                           isSelected: index == selectedIndex,
                           isEmphasis: index == self.config.emphasisIndex)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension UnderBarInfiniteTabView: UICollectionViewDelegate {}

// MARK: - UICollectionViewDelegateFlowLayout
extension UnderBarInfiniteTabView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.config.type {
        case .fixed(width: let width):
            return CGSize(width: width, height: self.bounds.height)
        case .flexible(margin: let margin):
            let index = indexPath.item % self.texts.count
            let text = self.texts[index]
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

// MARK: - UICollectionViewDelegate
extension UnderBarInfiniteTabView: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        moveUnderBar(animated: false)
    }
}

// MARK: - Reactive
extension Reactive where Base: UnderBarInfiniteTabView {
    
    var tapAt: ControlEvent<Int> {
        return .init(events: base.collectionView.rx.itemSelected.map { $0.item % self.base.texts.count })
    }
    
    var selectedIndex: Binder<Int> {
        return Binder(base) { view, value in
            let count = view.texts.count
            let newValue = value % count
            let oldValue = view.selectedIndex % count
            let cellIndex: Int
            if abs(newValue - oldValue) > count / 2 {
                cellIndex = newValue > oldValue ? newValue : newValue + count * 2
            } else {
                cellIndex = newValue + count
            }
            view.selectedIndex = newValue + count
            view.collectionView.reloadItems(at: [
                IndexPath(item: oldValue, section: 0),
                IndexPath(item: oldValue + count, section: 0),
                IndexPath(item: oldValue + count * 2, section: 0),
                IndexPath(item: newValue, section: 0),
                IndexPath(item: newValue + count, section: 0),
                IndexPath(item: newValue + count * 2, section: 0)
            ])
            view.collectionView.scrollToItem(at: IndexPath(item: cellIndex, section: 0), at: .centeredHorizontally, animated: true)
            view.moveUnderBar(animated: true)
        }
    }
}
