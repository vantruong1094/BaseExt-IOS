//
//  DemoBarTitlePagingViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 6/20/21.
//  Copyright © 2021 Chu Van Truong. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DemoBarTitlePagingViewController: ButtonBarPagerTabStripViewController {

    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        // change selected bar color
        view.backgroundColor = .white
        let bView = ButtonBarView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.buttonBarView = bView
        view.addSubview(bView)
        bView.backgroundColor = .systemPink
        bView.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets.zero, usingSafeArea: true)
        bView.height(50)
        
        let scrollContentView = UIScrollView()
        self.containerView = scrollContentView
        view.addSubview(scrollContentView)
        scrollContentView.edgesToSuperview(excluding: .top, insets: UIEdgeInsets.zero, usingSafeArea: true)
        scrollContentView.topToBottom(of: buttonBarView)
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = blueInstagramColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.blueInstagramColor
        }
        super.viewDidLoad()
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        return [OneChildViewController(), TwoChildViewController(), ThreeChildViewController()]
    }
}
