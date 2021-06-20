//
//  PageTitleView.swift
//

import UIKit

class PageTitleButton: UIButton {
}

protocol PageTitleViewDelegate: NSObjectProtocol {
    func pageTitleView(pageTitleView: PageTitleView, index: Int)
}

class PageTitleView: UIView {

    var index: Int = 0
    var resetIndex: Int?

    init(frame: CGRect, delegate: PageTitleViewDelegate, titleNames: [String], configure: PageTitleViewConfigure) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.77)
        self.delegateTitleView = delegate
        self.titleNames = titleNames
        self.configure = configure
        self.setupSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private weak var delegateTitleView: PageTitleViewDelegate?
    private var titleNames: [String] = []
    private var configure: PageTitleViewConfigure!
    private var allTitleTextWidth: CGFloat = 0.0
    private var allWidth: CGFloat = 0.0
    var btnMArr: [PageTitleButton] = []
    private var tempBtn: UIButton?
    var signBtnIndex: Int = 0
    private var signBtnClick: Bool = false

    private var startR: CGFloat = 0.0
    private var startG: CGFloat = 0.0
    private var startB: CGFloat = 0.0

    private var endR: CGFloat = 0.0
    private var endG: CGFloat = 0.0
    private var endB: CGFloat = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if index < btnMArr.count - 1 {
            P_btn_action(button: btnMArr[index])
        }
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        if self.configure.needBounces == false {
            scrollView.bounces = false
        }
        return scrollView
    }()
    private lazy var bottomSeparator: UIView = {
        let bottomSeparator = UIView()
        let size = self.frame.size
        let height: CGFloat = 0.5
        bottomSeparator.frame = CGRect(x: 0, y: size.height - height, width: size.width, height: height)
        bottomSeparator.backgroundColor = configure.bottomSeparatorColor
        return bottomSeparator
    }()
    private lazy var indicator: UIView = {
        let indicator = UIView()
        indicator.backgroundColor = configure.indicatorColor
        if configure.indicatorCornerRadius > 0.5 * indicator.frame.size.height {
            indicator.layer.cornerRadius = 0.5 * indicator.frame.size.height
        } else {
            indicator.layer.cornerRadius = configure.indicatorCornerRadius
        }
        if configure.indicatorStyle == .Cover {
            let tempSize = self.P_size(string: btnMArr[0].currentTitle!, font: self.configure.titleFont)
            let tempIndicatorHeight = tempSize.height
            if configure.indicatorHeight > self.frame.size.height {
                indicator.frame.origin.y = 0
                indicator.frame.size.height = self.frame.size.height
            } else if configure.indicatorHeight < tempIndicatorHeight {
                indicator.frame.origin.y = 0.5 * (self.frame.size.height - tempIndicatorHeight)
                indicator.frame.size.height = tempIndicatorHeight
            } else {
                indicator.frame.origin.y = 0.5 * (self.frame.size.height - configure.indicatorHeight)
                indicator.frame.size.height = configure.indicatorHeight
            }

            indicator.layer.borderWidth = configure.indicatorBorderWidth
            indicator.layer.borderColor = configure.indicatorBorderColor.cgColor

        } else {
            let indicatorHeight = configure.indicatorHeight
            indicator.frame.size.height = indicatorHeight
            indicator.frame.origin.y = self.frame.size.height - indicatorHeight - configure.indicatorToBottomDistance
        }
        return indicator
    }()
}

extension PageTitleView {
    private func setupSubviews() {
        let tempView = UIView()
        self.addSubview(tempView)
        self.addSubview(self.scrollView)
        self.setupTitleButtons()

        if configure.showBottomSeparator {
            self.addSubview(self.bottomSeparator)
        }

        if configure.showIndicator {
            self.scrollView.insertSubview(self.indicator, at: 0)
        }
    }
}

extension PageTitleView {
    private func setupTitleButtons() {
        let titleCount = titleNames.count
        let selfSize = self.frame.size

        titleNames.forEach { (title) in
            allTitleTextWidth += P_size(string: title, font: configure.titleFont).width
        }
        
        allWidth = CGFloat(ceilf(Float(allTitleTextWidth + configure.titleAdditionalWidth * CGFloat(titleCount))))
        let VSeparatorW: CGFloat = 1.0
        var VSeparatorH: CGFloat = selfSize.height - configure.verticalSeparatorReduceHeight
        if VSeparatorH <= 0 {
            VSeparatorH = selfSize.height
        }
        let VSeparatorY: CGFloat = 0.5 * (selfSize.height - VSeparatorH)
        
        if allWidth <= selfSize.width {
            let btnY: CGFloat = 0
            var btnW: CGFloat = self.frame.size.width / CGFloat(titleCount)
            var btnH: CGFloat = 0.0
            if configure.indicatorStyle == .Default || configure.indicatorStyle == .FitTitle {
                btnH = selfSize.height - configure.indicatorHeight
            } else {
                btnH = selfSize.height
            }

            let paddingBtn: CGFloat = (self.frame.size.width - allTitleTextWidth) / CGFloat((titleCount + 1))
            var btnX: CGFloat = paddingBtn/2
            if configure.indicatorStyle == .DynamicTitle {
                btnX = 16.0
            }
            for index in 0..<titleCount {
                let btn = PageTitleButton()
                if configure.indicatorStyle == .FitTitle {
                    btnW = P_size(string: titleNames[index], font: configure.titleFont).width + paddingBtn
                } else if configure.indicatorStyle == .DynamicTitle {
                    btnW = P_size(string: titleNames[index], font: configure.titleFont).width + configure.titleAdditionalWidth
                } else {
                    btnX = btnW * CGFloat(index)
                }
                btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
                if configure.indicatorStyle == .FitTitle || configure.indicatorStyle == .DynamicTitle {
                    btnX += btnW
                }
                btn.tag = index
                btn.titleLabel?.font = configure.titleFont
                btn.setTitle(titleNames[index], for: .normal)
                btn.setTitleColor(configure.titleColor, for: .normal)
                btn.setTitleColor(configure.titleSelectedColor, for: .selected)
                btn.addTarget(self, action: #selector(P_btn_action(button:)), for: .touchUpInside)
                btnMArr.append(btn)
                scrollView.addSubview(btn)
                
                if configure.showVerticalSeparator {
                    let VSeparator = UIView()
                    if index != 0 {
                        let VSeparatorX = btnW * CGFloat(index) - 0.5
                        VSeparator.frame = CGRect(x: VSeparatorX, y: VSeparatorY, width: VSeparatorW, height: VSeparatorH)
                        VSeparator.backgroundColor = configure.verticalSeparatorColor
                        scrollView.addSubview(VSeparator)
                    }
                }
            }
            scrollView.contentSize = CGSize(width: selfSize.width, height: selfSize.height)

        } else {
            var btnX: CGFloat = 0.0
            let btnY: CGFloat = 0.0
            var btnH: CGFloat = 0.0
            if configure.indicatorStyle == .Default {
                btnH = selfSize.height - configure.indicatorHeight
            } else {
                btnH = selfSize.height
            }
            let VSeparatorW: CGFloat = 1.0
            var VSeparatorH: CGFloat = selfSize.height - configure.verticalSeparatorReduceHeight
            if VSeparatorH <= 0 {
                VSeparatorH = selfSize.height
            }
            let VSeparatorY = 0.5 * (selfSize.height - VSeparatorH)

            for index in 0..<titleCount {
                let btn = PageTitleButton()
                let tempSize = P_size(string: titleNames[index], font: configure.titleFont)
                let btnW: CGFloat = tempSize.width + configure.titleAdditionalWidth
                btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
                btnX += btnW
                btn.tag = index
                btn.titleLabel?.font = configure.titleFont
                btn.setTitle(titleNames[index], for: .normal)
                btn.setTitleColor(configure.titleColor, for: .normal)
                btn.setTitleColor(configure.titleSelectedColor, for: .selected)
                btn.addTarget(self, action: #selector(P_btn_action(button:)), for: .touchUpInside)
                btnMArr.append(btn)
                scrollView.addSubview(btn)
                
                if configure.showVerticalSeparator {
                    let VSeparator = UIView()
                    if index < titleCount - 1 {
                        let VSeparatorX = btnX - 0.5
                        VSeparator.frame = CGRect(x: VSeparatorX, y: VSeparatorY, width: VSeparatorW, height: VSeparatorH)
                        VSeparator.backgroundColor = configure.verticalSeparatorColor
                        scrollView.addSubview(VSeparator)
                    }
                }
            }
            let scrollViewWidth: CGFloat = (scrollView.subviews.last?.frame.maxX)!
            scrollView.contentSize = CGSize(width: scrollViewWidth, height: self.frame.size.height)
        }
        
        if configure.titleGradientEffect {
            P_setupStartColor(color: configure.titleColor)
            P_setupEndColor(color: configure.titleSelectedColor)
        }
    }
}

extension PageTitleView {

    func setPageTitleView(progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        if targetIndex < 0 || targetIndex > btnMArr.count - 1 {
            return
        }
        let originalBtn: UIButton = btnMArr[originalIndex]
        let targetBtn: UIButton = btnMArr[targetIndex]
        signBtnIndex = targetBtn.tag

        if allWidth > self.frame.size.width {
            if signBtnClick == false {
                self.P_selectedBtnCenter(button: targetBtn)
            }
            signBtnClick = false
        }

        if allWidth <= self.bounds.size.width {
            if configure.indicatorScrollStyle == .Default || configure.indicatorStyle == .FitTitle {
                P_staticIndicatorScrollStyleDefault(progress: progress, originalBtn: originalBtn, targetBtn: targetBtn)
            } else {
                P_staticIndicatorScrollStyleHalfAndEnd(progress: progress, originalBtn: originalBtn, targetBtn: targetBtn)
            }
        } else {
            if configure.indicatorScrollStyle == .Default || configure.indicatorStyle == .FitTitle {
                P_indicatorScrollStyleDefault(progress: progress, originalBtn: originalBtn, targetBtn: targetBtn)
            } else {
                P_indicatorScrollStyleHalfAndEnd(progress: progress, originalBtn: originalBtn, targetBtn: targetBtn)
            }
        }

        if configure.titleGradientEffect == true {
            P_titleGradientEffect(progress: progress, originalBtn: originalBtn, targetBtn: targetBtn)
        }

        let configureTitleSelectedFont = configure.titleSelectedFont
        let defaultTitleFont = UIFont.systemFont(ofSize: 15)
        if configureTitleSelectedFont.fontName == defaultTitleFont.fontName && configureTitleSelectedFont.pointSize == defaultTitleFont.pointSize {
            if configure.titleTextZoom == true {

                let originalBtnZoomRatio = (1 - progress) * configure.titleTextZoomRatio
                originalBtn.transform = CGAffineTransform(scaleX: originalBtnZoomRatio + 1, y: originalBtnZoomRatio + 1)

                let targetBtnZoomRatio = progress * configure.titleTextZoomRatio
                targetBtn.transform = CGAffineTransform(scaleX: targetBtnZoomRatio + 1, y: targetBtnZoomRatio + 1)
            }
        }
    }
}

extension PageTitleView {

    func addBadge(index: Int) {
        let btn = btnMArr[index]

        let badge = UIView()
        badge.layer.backgroundColor = configure.badgeColor.cgColor
        badge.layer.cornerRadius = CGFloat(0.5 * configure.badgeSize)
        badge.tag = 2018 + index
        let btnTextWidth = P_size(string: btn.currentTitle!, font: configure.titleFont).width
        let btnTextHeight = P_size(string: btn.currentTitle!, font: configure.titleFont).height

        let badgeX = 0.5 * (btn.frame.size.width - btnTextWidth) + btnTextWidth + configure.badgeOff.x
        let badgeY = 0.5 * (btn.frame.size.height - btnTextHeight) + configure.badgeOff.y - configure.badgeSize
        let badgeWidth = configure.badgeSize
        let badgeHeight = badgeWidth
        badge.frame = CGRect(x: badgeX, y: badgeY, width: badgeWidth, height: badgeHeight)
        btn.addSubview(badge)
    }
    
    func removeBadge(index: Int) {
        let btn = btnMArr[index]
        btn.subviews.forEach { (button) in
            if button.tag != 0 {
                button.removeFromSuperview()
            }
        }
    }
}

extension PageTitleView {

    func resetTitle(title: String, index: Int) {
        let btn = btnMArr[index]
        btn.setTitle(title, for: .normal)
        if self.signBtnIndex == index {
            if configure.indicatorStyle == .Default || configure.indicatorStyle == .Cover || configure.indicatorStyle == .FitTitle {
                let tempSize = P_size(string: btn.currentTitle!, font: configure.titleFont)
                var tempIndicatorWidth = configure.indicatorAdditionalWidth + tempSize.width
                if tempIndicatorWidth > btn.frame.size.width {
                    tempIndicatorWidth = btn.frame.size.width
                }
                indicator.frame.size.width = tempIndicatorWidth
                indicator.center.x = btn.center.x
            }
        }
    }

    func resetIndicatorColor(color: UIColor) {
        indicator.backgroundColor = color
    }

    func resetTitleColor(color: UIColor, selectedColor: UIColor) {
        btnMArr.forEach { (button) in
            button.setTitleColor(color, for: .normal)
            button.setTitleColor(selectedColor, for: .selected)
        }
    }
    
    func resetTitleColor(color: UIColor, selectedColor: UIColor, indicatorColor: UIColor) {
        resetTitleColor(color: color, selectedColor: selectedColor)
        resetIndicatorColor(color: indicatorColor)
    }
}

extension PageTitleView {
    private func P_size(string: String, font: UIFont) -> CGSize {
        let attrDict = [NSAttributedString.Key.font: font]
        let attrString = NSAttributedString(string: string, attributes: attrDict)
        return attrString.boundingRect(with: CGSize(width: 0, height: 0), options: .usesLineFragmentOrigin, context: nil).size
    }
    
    @objc private func P_btn_action(button: UIButton) {
        P_changeSelectedButton(button: button)

        if allWidth > self.frame.size.width {
            signBtnClick = true
            P_selectedBtnCenter(button: button)
        }

        P_changeIndicatorWithButton(button: button)

        if delegateTitleView != nil {
            delegateTitleView?.pageTitleView(pageTitleView: self, index: button.tag)
        }
        signBtnIndex = button.tag
    }
    
    func P_changeSelectedButton(button: UIButton) {
        print("P_changeSelectedButton")
        if configure.selectionConfig == .custom {
            var indexSelected = -1
            for (index, item) in btnMArr.enumerated() where button == item {
                indexSelected = index
            }
            
            if indexSelected != -1 {
                changeSelectedButtonforCustom(button: button, indexSelected: indexSelected)
            }
        } else {
            
            if tempBtn == nil {
                button.isSelected =  true
                tempBtn = button
            } else if tempBtn != nil && tempBtn == button {
                button.isSelected = true
            } else if tempBtn != nil && tempBtn != button {
                print("button set selected: \(button.titleLabel?.text ?? "null")")
                tempBtn!.isSelected = false
                button.isSelected = true
                tempBtn = button
            }

            let configureTitleSelectedFont = configure.titleSelectedFont
            let defaultTitleFont = UIFont.systemFont(ofSize: 15)
            if configureTitleSelectedFont.fontName == defaultTitleFont.fontName && configureTitleSelectedFont.pointSize == defaultTitleFont.pointSize {
                
                if configure.titleTextZoom == true {
                    btnMArr.forEach { (button) in
                        button.transform = .identity
                    }
                    let afterZoomRatio: CGFloat = 1 + configure.titleTextZoomRatio
                    button.transform = CGAffineTransform(scaleX: afterZoomRatio, y: afterZoomRatio)
                }
                
                if configure.titleGradientEffect == true {
                    btnMArr.forEach { (button) in
                        button.titleLabel?.textColor = configure.titleColor
                    }
                    button.titleLabel?.textColor = configure.titleSelectedColor
                }
            } else {
                
                if configure.titleGradientEffect == true {
                    btnMArr.forEach { (button) in
                        button.titleLabel?.textColor = configure.titleColor
                        button.titleLabel?.font = configure.titleFont
                    }
                    button.titleLabel?.textColor = configure.titleSelectedColor
                    button.titleLabel?.font = configure.titleSelectedFont
                } else {
                    btnMArr.forEach { (button) in
                        button.titleLabel?.font = configure.titleFont
                    }
                    button.titleLabel?.font = configure.titleSelectedFont
                }
            }
        }
    }
    
    func changeSelectedButtonforCustom(button: UIButton, indexSelected: Int) {
//        for item in btnMArr {
//            item.titleLabel?.textColor = UIColor(hex: "#D2D2D2")
//        }
//        button.isSelected = true
//        tempBtn = button
//        btnMArr[indexSelected].titleLabel?.textColor = configure.titleSelectedColor
//        let nextSelectedIndex = indexSelected + 1
//        let preSelectedIndex = indexSelected - 1
//
//        if preSelectedIndex >= 0 {
//            btnMArr[preSelectedIndex].titleLabel?.textColor = UIColor(hex: "#8B8B8B")
//        }
//
//        if nextSelectedIndex < btnMArr.count {
//            btnMArr[nextSelectedIndex].titleLabel?.textColor = UIColor(hex: "#8B8B8B")
//        }

    }

    func P_selectedBtnCenter(button: UIButton) {
        var offsetX = button.center.x - self.frame.size.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffsetX = scrollView.contentSize.width - self.frame.size.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }

    func P_changeIndicatorWithButton(button: UIButton) {
        UIView.animate(withDuration: configure.indicatorAnimationTime) {
            if self.configure.indicatorStyle == .Fixed {
                self.indicator.frame.size.width = self.configure.indicatorFixedWidth
                self.indicator.center.x = button.center.x
                return
            }
            
            if self.configure.indicatorStyle == .Dynamic {
                self.indicator.frame.size.width = self.configure.indicatorDynamicWidth
                self.indicator.center.x = button.center.x
                return
            }

            let tempSize = self.P_size(string: button.currentTitle!, font: self.configure.titleFont)
            var tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width
            if tempIndicatorWidth > button.frame.size.width {
                tempIndicatorWidth = button.frame.size.width
            }
            self.indicator.frame.size.width = tempIndicatorWidth
            self.indicator.center.x = button.center.x
        }
    }
}

extension PageTitleView {

    private func P_staticIndicatorScrollStyleDefault(progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        // 改变按钮的选择状态
        if progress >= 0.8 {
            P_changeSelectedButton(button: targetBtn)
        }

        if configure.indicatorStyle == .Fixed {
            let btnWidth = self.frame.size.width / CGFloat(titleNames.count)
            let targetBtnMaxX = CGFloat(targetBtn.tag + 1) * btnWidth
            let originalBtnMaxX = CGFloat(originalBtn.tag + 1) * btnWidth
            let targetBtnIndicatorX = targetBtnMaxX - 0.5 * (btnWidth - configure.indicatorFixedWidth) - configure.indicatorFixedWidth
            let originalBtnIndicatorX = originalBtnMaxX - 0.5 * (btnWidth - configure.indicatorFixedWidth) - configure.indicatorFixedWidth
            
            let totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX
            indicator.frame.origin.x = originalBtnIndicatorX + progress * totalOffsetX
            return
        }

        if configure.indicatorStyle == .Dynamic {
            let originalBtnTag = originalBtn.tag
            let targetBtnTag = targetBtn.tag
            let btnWidth = self.frame.size.width / CGFloat(titleNames.count)
            let targetBtnMaxX = CGFloat(targetBtn.tag + 1) * btnWidth
            let originalBtnMaxX = CGFloat(originalBtn.tag + 1) * btnWidth
            
            if originalBtnTag <= targetBtnTag {
                if progress <= 0.5 {
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * progress * btnWidth
                } else {
                    let targetBtnIndicatorX = targetBtnMaxX - 0.5 * (btnWidth - configure.indicatorDynamicWidth) - configure.indicatorDynamicWidth
                    indicator.frame.origin.x = targetBtnIndicatorX + 2 * (progress - 1) * btnWidth
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth
                }
            } else {
                if progress <= 0.5 {
                    let originalBtnIndicatorX = originalBtnMaxX - 0.5 * (btnWidth - configure.indicatorDynamicWidth) - configure.indicatorDynamicWidth
                    indicator.frame.origin.x = originalBtnIndicatorX - 2 * progress * btnWidth
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * progress * btnWidth
                } else {
                    let targetBtnIndicatorX = targetBtnMaxX - configure.indicatorDynamicWidth - 0.5 * (btnWidth - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnIndicatorX
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth
                }
            }
            return
        }
        
        let btnWidth = targetBtn.frame.width

        let targetBtnTextWidth: CGFloat = P_size(string: targetBtn.currentTitle!, font: self.configure.titleFont).width
        let originalBtnTextWidth: CGFloat = P_size(string: originalBtn.currentTitle!, font: self.configure.titleFont).width
        var targetBtnMaxX: CGFloat = 0.0
        var originalBtnMaxX: CGFloat = 0.0

        if configure.titleTextZoom == true {
            targetBtnMaxX = CGFloat(targetBtn.tag + 1) * btnWidth
            originalBtnMaxX = CGFloat(originalBtn.tag + 1) * btnWidth
        } else {
            targetBtnMaxX = targetBtn.frame.maxX
            originalBtnMaxX = originalBtn.frame.maxX
        }
        let targetIndicatorX = targetBtnMaxX - targetBtnTextWidth - 0.5 * (btnWidth - targetBtnTextWidth + configure.indicatorAdditionalWidth)
        let originalIndicatorX = originalBtnMaxX - originalBtnTextWidth - 0.5 * (btnWidth - originalBtnTextWidth + configure.indicatorAdditionalWidth)
        let totalOffsetX = targetIndicatorX - originalIndicatorX

        let targetBtnRightTextX = targetBtnMaxX - 0.5 * (btnWidth - targetBtnTextWidth)

        let originalBtnRightTextX = originalBtnMaxX - 0.5 * (btnWidth - originalBtnTextWidth)
        let totalRightTextDistance = targetBtnRightTextX - originalBtnRightTextX

        let offsetX = totalOffsetX * progress
        let distance = progress * (totalRightTextDistance - totalOffsetX)

        indicator.frame.origin.x = originalIndicatorX + offsetX
        
        let tempIndicatorWidth = configure.indicatorAdditionalWidth + originalBtnTextWidth + distance
        if tempIndicatorWidth >= targetBtn.frame.size.width {
            let moveTotalX = targetBtn.frame.origin.x - originalBtn.frame.origin.x
            let moveX = moveTotalX * progress
            indicator.center.x = originalBtn.center.x + moveX
        } else {
            indicator.frame.size.width = tempIndicatorWidth
        }

    }

    private func P_staticIndicatorScrollStyleHalfAndEnd(progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {

        if configure.indicatorScrollStyle == .Half {
            if configure.indicatorStyle == .Fixed {
                if progress >= 0.5 {
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicator.center.x = targetBtn.center.x
                        self.P_changeSelectedButton(button: targetBtn)
                    }
                } else {
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicator.center.x = originalBtn.center.x
                        self.P_changeSelectedButton(button: originalBtn)
                    }
                }
                return
            }

            if progress >= 0.5 {
                let tempSize = P_size(string: targetBtn.currentTitle!, font: configure.titleFont)
                let tempIndicatorWidth = tempSize.width + configure.indicatorAdditionalWidth
                
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    if tempIndicatorWidth >= targetBtn.frame.size.width {
                        self.indicator.frame.size.width = targetBtn.frame.size.width
                    } else {
                        self.indicator.frame.size.width = tempIndicatorWidth
                    }
                    self.indicator.center.x = targetBtn.center.x
                    self.P_changeSelectedButton(button: targetBtn)
                }
            } else {
                let tempSize = P_size(string: originalBtn.currentTitle!, font: configure.titleFont)
                let tempIndicatorWidth = tempSize.width + configure.indicatorAdditionalWidth
                
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    if tempIndicatorWidth >= targetBtn.frame.size.width {
                        self.indicator.frame.size.width = originalBtn.frame.size.width
                    } else {
                        self.indicator.frame.size.width = tempIndicatorWidth
                    }
                    self.indicator.center.x = originalBtn.center.x
                    self.P_changeSelectedButton(button: originalBtn)
                }
            }
            return
        }

        if self.configure.indicatorStyle == .Fixed {
            if progress == 1.0 {
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    self.indicator.center.x = targetBtn.center.x
                    self.P_changeSelectedButton(button: targetBtn)
                }
            } else {
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    self.indicator.center.x = originalBtn.center.x
                    self.P_changeSelectedButton(button: originalBtn)
                }
            }
            return
        }

        if progress == 1.0 {
            let tempSize = P_size(string: targetBtn.currentTitle!, font: configure.titleFont)
            let tempIndicatorWidth = tempSize.width + configure.indicatorAdditionalWidth
            
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                if tempIndicatorWidth >= targetBtn.frame.size.width {
                    self.indicator.frame.size.width = targetBtn.frame.size.width
                } else {
                    self.indicator.frame.size.width = tempIndicatorWidth
                }
                self.indicator.center.x = targetBtn.center.x
                self.P_changeSelectedButton(button: targetBtn)
            }
        } else {
            let tempSize = P_size(string: originalBtn.currentTitle!, font: configure.titleFont)
            let tempIndicatorWidth = tempSize.width + configure.indicatorAdditionalWidth
            
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                if tempIndicatorWidth >= targetBtn.frame.size.width {
                    self.indicator.frame.size.width = originalBtn.frame.size.width
                } else {
                    self.indicator.frame.size.width = tempIndicatorWidth
                }
                self.indicator.center.x = originalBtn.center.x
                self.P_changeSelectedButton(button: originalBtn)
            }
        }
    }

    private func P_indicatorScrollStyleDefault(progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {

        if progress >= 0.8 {
            P_changeSelectedButton(button: targetBtn)
        }

        if configure.indicatorStyle == .Fixed {
            let targetIndicatorX = targetBtn.frame.maxX - 0.5 * (targetBtn.frame.size.width - configure.indicatorFixedWidth) - configure.indicatorFixedWidth
            let originalIndicatorX = originalBtn.frame.maxX - configure.indicatorFixedWidth - 0.5 * (originalBtn.frame.size.width - configure.indicatorFixedWidth)
            let totalOffsetX = targetIndicatorX - originalIndicatorX
            let offsetX = totalOffsetX * progress
            indicator.frame.origin.x = originalIndicatorX + offsetX
            return
        }

        if self.configure.indicatorStyle == .Dynamic {
            let originalBtnTag = originalBtn.tag
            let targetBtnTag = targetBtn.tag
            if originalBtnTag <= targetBtnTag {
                let btnCenterXDistance = targetBtn.center.x - originalBtn.center.x
                if progress <= 0.5 {
                    indicator.frame.size.width = 2 * progress * btnCenterXDistance + configure.indicatorDynamicWidth
                } else {
                    let targetBtnX = targetBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (targetBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnX + 2 * (progress - 1) * btnCenterXDistance
                    indicator.frame.size.width = 2 * (1 - progress) * btnCenterXDistance + configure.indicatorDynamicWidth
                }
            } else {

                let btnCenterXDistance = originalBtn.center.x - targetBtn.center.x
                if progress <= 0.5 {
                    let originalBtnX = originalBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (originalBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = originalBtnX - 2 * progress * btnCenterXDistance
                    indicator.frame.size.width = 2 * progress * btnCenterXDistance + configure.indicatorDynamicWidth
                } else {
                    let targetBtnX = targetBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (targetBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnX
                    indicator.frame.size.width = 2 * (1 - progress) * btnCenterXDistance + configure.indicatorDynamicWidth
                }
            }
            return
        }

        if configure.titleTextZoom && configure.showIndicator {
            print("标题文字缩放属性与指示器下划线、遮盖样式下不兼容，但固定及动态样式下兼容")
            return
        }

        let totalOffsetX = targetBtn.frame.origin.x - originalBtn.frame.origin.x

        let totalDistance = targetBtn.frame.maxX - originalBtn.frame.maxX

        var offsetX: CGFloat = 0.0
        var distance: CGFloat = 0.0

        let targetBtnTextWidth = P_size(string: targetBtn.currentTitle!, font: configure.titleFont).width
        let tempIndicatorWidth = configure.indicatorAdditionalWidth + targetBtnTextWidth
        if tempIndicatorWidth >= targetBtn.frame.size.width {
            offsetX = totalOffsetX * progress
            distance = progress * (totalDistance - totalOffsetX)
            indicator.frame.origin.x = originalBtn.frame.origin.x + offsetX
            indicator.frame.size.width = originalBtn.frame.size.width + distance
        } else {
            offsetX = totalOffsetX * progress + 0.5 * configure.titleAdditionalWidth - 0.5 * configure.indicatorAdditionalWidth
            distance = progress * (totalDistance - totalOffsetX) - configure.titleAdditionalWidth

            indicator.frame.origin.x = originalBtn.frame.origin.x + offsetX
            indicator.frame.size.width = originalBtn.frame.size.width + distance + configure.indicatorAdditionalWidth
        }
    }

    private func P_indicatorScrollStyleHalfAndEnd(progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {

        if configure.indicatorScrollStyle == .Half {

            if configure.indicatorStyle == .Fixed {
                if progress >= 0.5 {
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicator.center.x = targetBtn.center.x
                        self.P_changeSelectedButton(button: targetBtn)
                    }
                } else {
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicator.center.x = originalBtn.center.x
                        self.P_changeSelectedButton(button: originalBtn)
                    }
                }
                return
            }

            if progress >= 0.5 {
                let tempSize = P_size(string: targetBtn.currentTitle!, font: configure.titleFont)
                let tempIndicatorWidth = configure.indicatorAdditionalWidth + tempSize.width
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    if tempIndicatorWidth >= targetBtn.frame.size.width {
                        self.indicator.frame.size.width = targetBtn.frame.size.width
                    } else {
                        self.indicator.frame.size.width = tempIndicatorWidth
                    }
                    self.indicator.center.x = targetBtn.center.x
                    self.P_changeSelectedButton(button: targetBtn)
                }
            } else {
                let tempSize = P_size(string: originalBtn.currentTitle!, font: configure.titleFont)
                let tempIndicatorWidth = configure.indicatorAdditionalWidth + tempSize.width
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    if tempIndicatorWidth >= originalBtn.frame.size.width {
                        self.indicator.frame.size.width = originalBtn.frame.size.width
                    } else {
                        self.indicator.frame.size.width = tempIndicatorWidth
                    }
                    self.indicator.center.x = originalBtn.center.x
                    self.P_changeSelectedButton(button: targetBtn)
                }
            }
            return
        }

        if configure.indicatorStyle == .Fixed {
            if progress == 1.0 {
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    self.indicator.center.x = targetBtn.center.x
                    self.P_changeSelectedButton(button: targetBtn)
                }
            } else {
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    self.indicator.center.x = originalBtn.center.x
                    self.P_changeSelectedButton(button: originalBtn)
                }
            }
            return
        }

        if progress == 1.0 {
            let tempSize = P_size(string: targetBtn.currentTitle!, font: configure.titleFont)
            let tempIndicatorWidth = configure.indicatorAdditionalWidth + tempSize.width
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                if tempIndicatorWidth >= targetBtn.frame.size.width {
                    self.indicator.frame.size.width = targetBtn.frame.size.width
                } else {
                    self.indicator.frame.size.width = tempIndicatorWidth
                }
                self.indicator.center.x = targetBtn.center.x
                self.P_changeSelectedButton(button: targetBtn)
            }
        } else {
            let tempSize = P_size(string: originalBtn.currentTitle!, font: configure.titleFont)
            let tempIndicatorWidth = configure.indicatorAdditionalWidth + tempSize.width
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                if tempIndicatorWidth >= originalBtn.frame.size.width {
                    self.indicator.frame.size.width = originalBtn.frame.size.width
                } else {
                    self.indicator.frame.size.width = tempIndicatorWidth
                }
                self.indicator.center.x = originalBtn.center.x
                self.P_changeSelectedButton(button: originalBtn)
            }
        }
    }
}

extension PageTitleView {
    private func P_titleGradientEffect(progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {

        let targetProgress = progress
        let originalProgress = 1 - targetProgress
        
        let r = endR - startR
        let g = endG - startG
        let b = endB - startB
        let originalColor: UIColor = UIColor.init(red: startR +  r * originalProgress, green: startG +  g * originalProgress, blue: startB +  b * originalProgress, alpha: 1.0)
        let targetColor: UIColor = UIColor.init(red: startR + r * targetProgress, green: startG + g * targetProgress, blue: startB + b * targetProgress, alpha: 1.0)

        originalBtn.titleLabel?.textColor = originalColor
        targetBtn.titleLabel?.textColor = targetColor
    }
}

extension PageTitleView {
    private func P_setupStartColor(color: UIColor) {
        let components = getRGBComponents(color: color)
        startR = components[0]
        startG = components[1]
        startB = components[2]
    }
    private func P_setupEndColor(color: UIColor) {
        let components = getRGBComponents(color: color)
        endR = components[0]
        endG = components[1]
        endB = components[2]
    }
    
    private func getRGBComponents(color: UIColor) -> [CGFloat] {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let data = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let context = CGContext(data: data, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: rgbColorSpace, bitmapInfo: 1)
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: 1, height: 1))
        var components: [CGFloat] = []
        for i in 0..<3 {
            components.append(CGFloat(data[i])/255.0)
        }
        return components
    }
}
