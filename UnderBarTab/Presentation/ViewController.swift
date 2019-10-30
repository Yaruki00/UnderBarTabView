//
//  ViewController.swift
//  UnderBarTab
//
//  Created by Yuta Kawabe on 2019/10/30.
//  Copyright © 2019 yuta kawabe. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet private weak var tabView: UnderBarTabView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabView()
        self.bind()
    }
}

extension ViewController {
    
    private func setupTabView() {
        self.tabView.setup(type: .fixed(width: UIScreen.main.bounds.width / 5))
        self.tabView.setData(["1", "2", "3", "4", "5"])
    }
    
    private func bind() {
        let pageChanged = Observable.merge(
            tabView.rx.tapAt.asObservable(),
            scrollView.rx.didEndDecelerating.map { Int(self.scrollView.contentOffset.x / self.scrollView.frame.width) }
        ).distinctUntilChanged().share()
            
        pageChanged.bind(to: tabView.rx.selectedIndex).disposed(by: disposeBag)
            
        pageChanged.map { (CGPoint(x: CGFloat($0) * self.scrollView.frame.width, y: 0.0), true) }
            .bind(onNext: scrollView.setContentOffset)
            .disposed(by: disposeBag)
    }
}
