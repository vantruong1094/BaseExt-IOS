//
//  DemoPagingViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 6/20/21.
//  Copyright © 2021 Chu Van Truong. All rights reserved.
//

import UIKit

class DemoPagingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPagingView()
    }
    
    func setupPagingView() {
        let pagingVC = BasePagingViewController()
        pagingVC.childVCs = [OneChildViewController(), TwoChildViewController(), ThreeChildViewController(), ThreeChildViewController()]
        add(pagingVC, containerView: view)
    }

}

extension UIViewController {
    func add(_ childViewController: UIViewController, containerView: UIView) {
        addChild(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(childViewController.view)
        NSLayoutConstraint.activate([
            childViewController.view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            childViewController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            childViewController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            childViewController.view.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        childViewController.didMove(toParent: self)
    }
    
    func remove(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}
