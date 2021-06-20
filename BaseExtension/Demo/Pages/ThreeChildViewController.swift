//
//  ThreeChildViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 6/20/21.
//  Copyright © 2021 Chu Van Truong. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ThreeChildViewController: UIViewController, IndicatorInfoProvider {

    let label = UILabel().text("ThreeChildViewController")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\(self.classForCoder)")
        view.addSubview(label)
        label.centerInSuperview()
        view.backgroundColor = UIColor.random
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Three")
    }

}
