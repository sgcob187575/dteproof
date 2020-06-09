//
//  DemoCollectionViewController.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/20.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class WallCollectionViewController: UICollectionViewController {
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    func setupCompositionalLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets=NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2,
        trailing: 2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                              heightDimension: .fractionalWidth(0.33))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
     func setupDataSource() {
         dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) { (collectionView, indexPath, imageurl) -> UICollectionViewCell? in
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WallCollectionViewCell.self)", for: indexPath) as? WallCollectionViewCell
            if Validfield.shared.isVideo(url: imageurl){
                cell?.imageView.kf.setImage(with: URL(string: "https://i.imgur.com/bU4owbx.jpg")!)
            }
            else{
                if let url = URL(string: imageurl){
                    cell?.imageView.kf.setImage(with: url)

                }
                    else {
                    print(imageurl)
                }
            }
            
             return cell
         }
         collectionView.dataSource = dataSource
     }
     
     func setupData(images: [String]) {
             var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
             snapshot.appendSections([.photo])
             snapshot.appendItems(images)
        dataSource.apply(snapshot)
    }
         
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         setupDataSource()
         setupCompositionalLayout()
     }

    
}
