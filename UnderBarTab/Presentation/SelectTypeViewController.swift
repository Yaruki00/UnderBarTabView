//
//  SelectTypeViewController.swift
//  UnderBarTab
//
//  Created by Yuta Kawabe on 2019/10/30.
//  Copyright © 2019 yuta kawabe. All rights reserved.
//

import Foundation
import UIKit

final class SelectTypeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func transitToNormal(_ sender: Any) {
        self.transitToSampleView(title: "normal", type: .normal)
    }
    
    @IBAction func transitToInfinite(_ sender: Any) {
        self.transitToSampleView(title: "infinite", type: .infinite)
    }
}

extension SelectTypeViewController {
    
    private func transitToSampleView(title: String, type: SampleType) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Sample") as! SampleViewController
        vc.title = title
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
