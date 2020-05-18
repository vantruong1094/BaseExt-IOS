//
//  ViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 12/9/19.
//  Copyright © 2019 Chu Van Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let label1 = UILabel().text("label1").font(UIFont.systemFont(ofSize: 12)).text(UIColor.green)
    let label2 = UILabel().text("label2").font(UIFont.systemFont(ofSize: 14)).text(UIColor.red)
    let label3 = UILabel().text("label3").font(UIFont.systemFont(ofSize: 16)).text(UIColor.orange)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        view.D_VStack(Spacer().setHeight(8),label1, label2, label3, UIView(),
                      spacing: 4).padding([.horizontalMargins], amount: 16)
    }


}

