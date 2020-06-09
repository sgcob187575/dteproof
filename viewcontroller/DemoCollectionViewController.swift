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

enum Section {
    case photo
    
    
}
class DemoCollectionViewController: UICollectionViewController{
    var delegate:DemoDelegate?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    var player:AVQueuePlayer?
    var playerlooper:AVPlayerLooper?
    var currentPage=0
    func setupCompositionalLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                              heightDimension: .fractionalWidth(0.75))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
            collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    override func collectionView(_ collectionView: UICollectionView,
                         didSelectItemAt indexPath: IndexPath){
        self.delegate?.showtext(self,indexPath)
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentPage = indexPath.row
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage == indexPath.row {
            currentPage = collectionView.indexPath(for: collectionView.visibleCells.first!)!.row
        }
        self.delegate?.returnindex(self, currentPage)
    }
    func setupDataSource() {
         dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) { (collectionView, indexPath, imageurl) -> UICollectionViewCell? in
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotoCollectionViewCell.self)", for: indexPath) as? PhotoCollectionViewCell
            cell?.layer.sublayers?.forEach({ (layer) in
                if layer.name=="player"{
                    layer.removeFromSuperlayer()
                }
            })
            if Validfield.shared.isVideo(url: imageurl){
                let url = URL(string: imageurl)
                self.player = AVQueuePlayer(url: url!)
                self.playerlooper=AVPlayerLooper(player: self.player!, templateItem: AVPlayerItem(url: URL(string: imageurl)!))

                let playerLayer = AVPlayerLayer(player: self.player)
                playerLayer.videoGravity = .resizeAspect
                playerLayer.frame=CGRect(x: 0, y: 0, width: 400, height: 300)
                playerLayer.name="player"
                cell?.layer.addSublayer(playerLayer)
                self.player?.volume=0
                self.player!.play()
                cell?.imageView.image=nil
            }
            else{
                cell?.imageView.kf.setImage(with: URL(string: imageurl)!,placeholder: KFCrossPlatformImage(named: "loading"))
                //layer?

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
        
        collectionView.backgroundView=GradientView()
     }

    
}
class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.init(red: 147/255, green: 210/255, blue: 203/255, alpha: 1)
    @IBInspectable var endColor: UIColor = UIColor.init(red: 244/255, green: 187/255, blue: 212/255,alpha: 1)

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: superview!.frame.size.width,
                                height: superview!.frame.size.height)
        gradient.colors = [startColor.cgColor,UIColor.white.cgColor, endColor.cgColor]
        gradient.zPosition = -1
        layer.addSublayer(gradient)
    }
}
protocol DemoDelegate {
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func showtext(_ View:DemoCollectionViewController,_ indexPath:IndexPath)
    func returnindex(_ View:DemoCollectionViewController,_ pageindex:Int)

}
