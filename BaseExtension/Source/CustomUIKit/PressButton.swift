//
//  PressButton.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 12/17/19.
//  Copyright © 2019 Chu Van Truong. All rights reserved.
//

import UIKit

class PressButton: UIButton {
    
    public var bgHighLightColor = UIColor.systemRed
    public var bgUnHighLightColor = UIColor.systemPink
    public var titleHighLightColor = UIColor.white
    public var titleUnHighLightColor = UIColor.white
    
    init() {
        super.init(frame: .zero)
        setUnHighLight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            print("isHighlighted")
            isHighlighted ? setHighLight() : setUnHighLight()
        }
    }
    
    func setHighLight() {
        backgroundColor = bgHighLightColor
        setTitleColor(titleHighLightColor, for: .normal)
    }
    
    func setUnHighLight() {
        backgroundColor = bgUnHighLightColor
        setTitleColor(titleUnHighLightColor, for: .normal)
    }
}
