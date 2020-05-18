//
//  CompositionLayoutViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 3/3/20.
//  Copyright © 2020 Chu Van Truong. All rights reserved.
//

import UIKit

class CompositionLayoutViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .vertical
        
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(cellWithClass: CompositionItemCollectionViewCell.self)
        c.backgroundColor = .white
        return c
    }()
    
    var collectionV: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        collectionV = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionV.backgroundColor = .white
        collectionV.register(cellWithClass: CompositionItemCollectionViewCell.self)
        view.addSubview(collectionV)
        collectionV.edgesToSuperview()
        collectionV.dataSource = self
        collectionV.delegate = self
        
//        view.addSubview(collectionView)
//        collectionView.edgesToSuperview()
//        collectionView.dataSource = self
//        collectionView.delegate = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(8), trailing: nil, bottom: nil)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension CompositionLayoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CompositionItemCollectionViewCell.self, for: indexPath)
        cell.configureCell(indexPath)
        return cell
    }
    
}

extension CompositionLayoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt ---> \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 100)
    }
}

