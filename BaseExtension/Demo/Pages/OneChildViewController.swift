//
//  OneChildViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 6/20/21.
//  Copyright © 2021 Chu Van Truong. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class OneChildViewController: UIViewController, IndicatorInfoProvider {
    
    let label = UILabel().text("OneChildViewController")

    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(self.classForCoder)")
        view.addSubview(label)
        label.centerInSuperview()
        view.backgroundColor = UIColor.random
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "One")
    }

}
