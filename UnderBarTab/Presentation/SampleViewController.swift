//
//  SampleViewController.swift
//  UnderBarTab
//
//  Created by Yuta Kawabe on 2019/10/30.
//  Copyright © 2019 yuta kawabe. All rights reserved.
//

import UIKit
import RxSwift

enum SampleType {
    case normal
    case infinite
}

final class SampleViewController: UIViewController {

    @IBOutlet private weak var tabView: UnderBarTabView!
    @IBOutlet private weak var infiniteTabView: UnderBarInfiniteTabView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var type: SampleType = .normal
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabView()
        self.bind()
    }
}

extension SampleViewController {
    
    private func setupTabView() {
        switch self.type {
        case .normal:
            
            self.tabView.isHidden = false
            self.infiniteTabView.isHidden = true
        case .infinite:
            self.tabView.isHidden = true
            self.infiniteTabView.isHidden = false
        }
        self.setupNoLoopTabView()
        self.setupLoopTabView()
    }
    
    private func setupNoLoopTabView() {
        let cellConfig = UnderBarTabCellConfig(
            normalTextColor: .gray,
            selectedTextColor: .blue,
            emphasisTextColor: .cyan
        )
        let config = UnderBarTabViewConfig(
            type: .fixed(width: UIScreen.main.bounds.width / 5),
            emphasisIndex: 2,
            cellConfig: cellConfig
        )
        self.tabView.setup(config: config)
        self.tabView.setData(["1", "2", "3", "4", "5"])
    }
    
    private func setupLoopTabView() {
        self.infiniteTabView.setup()
        self.infiniteTabView.setData(["1", "222", "33333", "4444444", "555555555"])
    }
    
    private func bind() {
        let pageChanged = Observable.merge(
            tabView.rx.tapAt.asObservable(),
            infiniteTabView.rx.tapAt.asObservable(),
            scrollView.rx.didEndDecelerating.map { Int(self.scrollView.contentOffset.x / self.scrollView.frame.width) }
        ).distinctUntilChanged().share()
            
        pageChanged.bind(to: tabView.rx.selectedIndex, infiniteTabView.rx.selectedIndex).disposed(by: disposeBag)
            
        pageChanged.map { (CGPoint(x: CGFloat($0) * self.scrollView.frame.width, y: 0.0), true) }
            .bind(onNext: scrollView.setContentOffset)
            .disposed(by: disposeBag)
    }
}
