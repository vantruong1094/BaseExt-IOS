//
//  MaterialTextField.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 12/17/19.
//  Copyright © 2019 Chu Van Truong. All rights reserved.
//

import UIKit

class MaterialTextField: UIView {
    
    let textField = D_TextField(insets: UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0))
    let lbText = UILabel().font(UIFont.systemFont(ofSize: 14))
    
    init(placeHolder: String, labelText: String = "") {
        super.init(frame: .zero)
        textField.placeholder(placeHolder)
        lbText.text = labelText
        D_VStack(lbText.setHeight(14),
                 textField,
            Divider().setHeight(1).setBackground(color: .systemGray6))
        lbText.isHidden = labelText.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
