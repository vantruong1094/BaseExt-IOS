//
//  BMIView.swift
//

import UIKit

class BMIView: UIView {
    
    let bmiSlider = CustomColorSlider()
    let fontText = UIFont.systemFont(ofSize: 12, weight: .light)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let content = UIView().D_VStack(
            bmiSlider,
            UIView().D_HStack(
                UIView().D_VStack(
                    UILabel().textAlignment(.center).text("Underweight").font(fontText),
                    UILabel().textAlignment(.center).text("< 18.5").font(fontText)
                ),
                UIView().D_VStack(
                    UILabel().textAlignment(.center).text("Healthy").font(fontText),
                    UILabel().textAlignment(.center).text("18.5 - 24.9").font(fontText)
                ),
                UIView().D_VStack(
                    UILabel().textAlignment(.center).text("Overweight").font(fontText),
                    UILabel().textAlignment(.center).text("25 - 29.9").font(fontText)
                ),
                UIView().D_VStack(
                    UILabel().textAlignment(.center).text("Obese").font(fontText),
                    UILabel().textAlignment(.center).text(">30").font(fontText)
                ),
                distribution: .equalSpacing
            )
        )
        addSubview(content)
        content.edgesToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
