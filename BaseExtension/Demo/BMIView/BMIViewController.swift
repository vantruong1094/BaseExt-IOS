//
//  BMIViewController.swift
//  BaseExtension
//
//  Created by TruongCV on 6/21/21.
//  Copyright © 2021 Chu Van Truong. All rights reserved.
//

import UIKit

class BMIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let bmiView = BMIView()
        view.addSubview(bmiView)
        bmiView.edgesToSuperview(excluding: .bottom, insets: .init(top: 16, left: 16, bottom: 0, right: 16), usingSafeArea: true)
        bmiView.height(80)
    }

}
