//
//  BasePagingViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 6/20/21.
//  Copyright © 2021 Chu Van Truong. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BasePagingViewController: BarPagerTabStripViewController, PageTitleViewDelegate {

    var childVCs = [UIViewController]()
    var pageDidMove: ((Int) -> Void)?
    var currentPage = 0
    lazy var defaultIndexTab = 0
    var pageTitleView: PageTitleView!
    var titlesName: [String] = ["AAA", "BBB", "CCC", "DDD"]
    var hasMovePaging: Bool = false
    
    deinit {
        print("deinit DrawingPagerViewController")
    }
    
    override func viewDidLoad() {
        configPagingView()
        super.viewDidLoad()
        view.backgroundColor = .white
        containerView.bounces = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if defaultIndexTab != 0 {
            moveToViewController(at: defaultIndexTab, animated: false)
        }
    }
    
    private func configPagingView() {
        let bView = BarView()
        self.barView = bView
        view.addSubview(bView)
        bView.backgroundColor = .systemPink
        bView.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets.zero, usingSafeArea: true)
        bView.height(0)
        
        let config = PageTitleViewConfigure()
        config.setConfigureFillTitle(numTab: titlesName.count)
        pageTitleView = PageTitleView(frame: .init(x: 0, y: 100, width: view.frame.size.width, height: 40), delegate: self, titleNames: titlesName, configure: config)
        view.addSubview(pageTitleView)
        
        let scrollContentView = UIScrollView()
        self.containerView = scrollContentView
        view.addSubview(scrollContentView)
        scrollContentView.edgesToSuperview(excluding: .top, usingSafeArea: true)
        scrollContentView.topToBottom(of: pageTitleView)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return childVCs
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        print("indexWasChanged: \(indexWasChanged)")
        if hasMovePaging {
            hasMovePaging = false
            return
        }
        pageTitleView.setPageTitleView(progress: progressPercentage, originalIndex: fromIndex, targetIndex: toIndex)
        if indexWasChanged {
            currentPage = toIndex
            pageDidMove?(toIndex)
            
        }
        
    }

    func pageTitleView(pageTitleView: PageTitleView, index: Int) {
        hasMovePaging = true
        moveTo(viewController: childVCs[index], animated: false)
    }
}
