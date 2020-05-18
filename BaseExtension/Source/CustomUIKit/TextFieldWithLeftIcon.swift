//
//  TextFieldWithLeftIcon.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 12/13/19.
//  Copyright © 2019 Chu Van Truong. All rights reserved.
//

import UIKit

class TextFieldWithLeftIcon: D_TextField {
    
    var iconImage: UIImage?
    var secureBtn: UIButton?
    lazy var leftViewContainer = UIView()
    
    init(insets: UIEdgeInsets = .zero, isSecure: Bool = false, image: UIImage?, sizeImage: CGSize, sizeFrame: CGSize) {
        self.iconImage = image
        var insetsParent: UIEdgeInsets = insets
        if isSecure {
            insetsParent.right = 35
        }
        super.init(insets: insetsParent)
        
        let leftIcon = UIImageView(image: iconImage)
        leftIcon.contentMode = .scaleAspectFit
        leftIcon.tintColor = .systemGray2
        
        leftViewContainer.frame = CGRect(x: 0, y: 0, width: sizeFrame.width, height: sizeFrame.height)
        leftViewContainer.addSubview(leftIcon)
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.centerXAnchor.constraint(equalTo: leftViewContainer.centerXAnchor, constant: 0).isActive = true
        leftIcon.centerYAnchor.constraint(equalTo: leftViewContainer.centerYAnchor).isActive = true
        leftIcon.setFrame(sizeImage)
        
        //leftView = leftViewContainer
        addSubview(leftViewContainer)
        leftViewMode = .always
        
        if isSecure {
            isSecureTextEntry = true
            
            secureBtn = UIButton().image(UIImage(systemName: "eye.slash.fill")?.withTintColor(.systemGray2))
            secureBtn?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(secureBtn ?? UIButton())
            secureBtn?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            secureBtn?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
            secureBtn?.addTarget(self, action: #selector(changeSecureText), for: .touchUpInside)
        }
    
    }
    
    @objc fileprivate func changeSecureText() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            secureBtn?.image(UIImage(systemName: "eye.slash.fill")?.withTintColor(.systemGray2))
        } else {
            secureBtn?.image(UIImage(systemName: "eye.fill")?.withTintColor(.systemGray2))
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
