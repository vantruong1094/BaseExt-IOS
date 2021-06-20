//
//  PageTitleViewConfiguration.swift
//


import UIKit

enum SelectionConfigStyle: Int {
    case custom = 0
    case `default` = 1
}

enum IndicatorStyle: Int {
    case Default = 0
    case Cover = 1
    case Fixed = 2
    case Dynamic = 3
    case FitTitle = 4
    case DynamicTitle = 5
}

enum IndicatorScrollStyle: Int {
    case Default = 0
    case Half = 1
    case End = 2
}

class PageTitleViewConfigure: NSObject {

    var needBounces: Bool = true
    var showBottomSeparator: Bool = true
    var bottomSeparatorColor: UIColor = .lightGray
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    var titleColor: UIColor = .black
    var titleSelectedColor: UIColor = .red
    var titleGradientEffect: Bool = false
    var titleTextZoom: Bool = false
    var titleTextZoomRatio: CGFloat = 0.1
    var titleAdditionalWidth: CGFloat = 20.0

    var showIndicator: Bool = true
    var indicatorColor: UIColor = .red
    var indicatorHeight: CGFloat = 1.0
    var indicatorAnimationTime: TimeInterval = 0.3
    var indicatorStyle: IndicatorStyle = .Default
    var indicatorCornerRadius: CGFloat = 0.0
    var indicatorToBottomDistance: CGFloat = 0.0
    var indicatorBorderWidth: CGFloat = 0.0
    var indicatorBorderColor: UIColor = .clear
    var indicatorAdditionalWidth: CGFloat = 0.0
    var indicatorFixedWidth: CGFloat = 20.0
    var indicatorDynamicWidth: CGFloat = 20.0
    var indicatorScrollStyle: IndicatorScrollStyle = .Default

    var showVerticalSeparator: Bool = false
    var verticalSeparatorColor: UIColor = .red
    var verticalSeparatorReduceHeight: CGFloat = 0.0
    var selectionConfig: SelectionConfigStyle = .default
    
    var badgeColor: UIColor = .red
    var badgeSize: CGFloat = 7.0
    var badgeOff: CGPoint = .zero
    var heightTitleView: CGFloat = 34.0
    
    init(height: CGFloat = 34.0) {
        self.heightTitleView = height
    }
    
    func setConfigureFillTitle(numTab: Int) {
        indicatorColor = UIColor.red
        titleFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleColor = UIColor.black
        titleSelectedColor = UIColor.red
        indicatorAdditionalWidth = UIScreen.main.bounds.width/CGFloat(numTab)
        showBottomSeparator = false
        needBounces = false
    }
}
