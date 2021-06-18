//
//  CompositionItemCollectionViewCell.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 3/3/20.
//  Copyright © 2020 Chu Van Truong. All rights reserved.
//

import UIKit
import LoremIpsum
class CompositionItemCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel().text(.black).text("title").font(UIFont.systemFont(ofSize: 16)).numberOfLines(0)
    let viewHidden = UIView().setBackground(color: .green).setHeight(50)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        //D_VStack(titleLabel).padding([.left, .right, .bottom], amount: 16)
        addSubview(titleLabel)
        titleLabel.edgesToSuperview()
        
    }
    
    func configureCell(_ index: IndexPath) {
        titleLabel.text = "Maecenas id erat non metus viverra semper efficitur in mauris. Morbi varius mi ex, vel mattis odio vehicula sit amet. Vestibulum non nisi bibendum"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
