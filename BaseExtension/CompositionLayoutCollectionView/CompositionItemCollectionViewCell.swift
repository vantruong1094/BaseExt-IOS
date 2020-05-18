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
        D_VStack(titleLabel, viewHidden).padding([.left, .right, .bottom], amount: 16)
        titleLabel.text = LoremIpsum.name()
    }
    
    func configureCell(_ index: IndexPath) {
        if index.row % 2 == 0 {
            viewHidden.isHidden = true
        } else {
            viewHidden.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
