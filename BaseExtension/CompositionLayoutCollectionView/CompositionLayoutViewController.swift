//
//  CompositionLayoutViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 3/3/20.
//  Copyright © 2020 Chu Van Truong. All rights reserved.
//

import UIKit

class CompositionLayoutViewController: UIViewController {
    enum Section {
        case main
    }
    
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
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    var data: [String] = [
        "Maecenas id erat non metus viverra semper efficitur in mauris. Morbi varius mi ex, vel mattis odio vehicula sit amet. Vestibulum non nisi bibendum",
        "Vestibulum sit amet urna eu odio vestibulum gravida. Integer finibus tellus eget lacus malesuada, eu viverra risus interdum. Curabitur dignissim ullamcorper augue, aliquam consectetur lectus tristique et. Sed sed ipsum eleifend, varius erat ut, aliquam urna. Phasellus at convallis lorem. Nulla bibendum id magna et volutpat. Suspendisse potenti. Nulla pharetra imperdiet lorem, a commodo ipsum semper at. Maecenas pretium scelerisque nunc at accumsan. Integer gravida, massa non aliquet fringilla, justo nulla molestie mi, id pulvinar turpis lorem eu lorem.",
        "Ut dapibus, ligula et elementum cursus, lorem sapien rhoncus nunc, nec bibendum massa sapien sed neque. Cras sit amet ex erat. Suspendisse facilisis semper libero, a placerat orci molestie non. Donec pretium est ut pulvinar porttitor. Vivamus in tristique tellus. Phasellus ac sem ipsum. Morbi sit amet mollis nisi. Nulla facilisi."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        configureDataSource()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        collectionV = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionV.backgroundColor = .white
        collectionV.register(cellWithClass: CompositionItemCollectionViewCell.self)
        view.addSubview(collectionV)
        collectionV.edgesToSuperview()

//        view.addSubview(collectionView)
//        collectionView.edgesToSuperview()
//        collectionView.dataSource = self
//        collectionView.delegate = self
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(8), trailing: nil, bottom: .fixed(8))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
//        return UICollectionViewCompositionalLayout { (numSection, evn) -> NSCollectionLayoutSection? in
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .estimated(50))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(8), trailing: nil, bottom: .fixed(8))
//            //item.contentInsets.bottom = 16
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .estimated(50))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                           subitems: [item])
//
//            let section = NSCollectionLayoutSection(group: group)
//            return section
//        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionV) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            let cell = collectionView.dequeueReusableCell(withClass: CompositionItemCollectionViewCell.self, for: indexPath)

            // Populate the cell with our item description.
            cell.configureCell(indexPath)

            // Return the cell.
            return cell
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(["data", "a", "v","g", "n","h" , "r", "y", "k"])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

