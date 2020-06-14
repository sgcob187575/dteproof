//
//  PhotoCollectionView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/20.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import SwiftUI

struct PhotoCollectionView: UIViewControllerRepresentable,DemoDelegate {
    func returnindex(_ View: DemoCollectionViewController, _ pageindex: Int) {
        photoindex = pageindex
    }
    
    func showtext(_ View: DemoCollectionViewController, _ indexPath: IndexPath) {
        if Validfield.shared.isVideo(url:  View.dataSource.itemIdentifier(for: indexPath)!) {
            if View.player?.volume==0{
                View.player?.volume=1
            }
            else{
                View.player?.volume=0
            }
        }
        else{
            UIApplication.shared.endEditing()
            searchoffest=0
            show=true
        }

    }
    
    var post:Sheetdbget
    @Binding var postdata:test
    @Binding var searchoffest:CGFloat
    @Binding var show:Bool
    @Binding var photoindex:Int
    func makeUIViewController(context: Context) -> DemoCollectionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let demo = storyboard.instantiateViewController(identifier: "DemoCollectionViewController") as? DemoCollectionViewController
        demo?.delegate=self
        self.postdata.testdata=self.post
        return demo!

        
    }

    func updateUIViewController(_ uiViewController: DemoCollectionViewController, context: Context) {
        uiViewController.setupData(images:
            postdata.testdata!.imageURL)


    }
    
    typealias UIViewControllerType = DemoCollectionViewController
    
    
}
struct WallCollectionView: UIViewControllerRepresentable {
    var login:String
    @ObservedObject var wallViewModel = SheetdbViewModel()
    func makeUIViewController(context: Context) -> WallCollectionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let demo = storyboard.instantiateViewController(identifier: "WallCollectionViewController") as? WallCollectionViewController
        wallViewModel.fetchdata(sql: "/search?uploadlogin=\(login)",login: login)
        return demo!

        
    }
    
    func updateUIViewController(_ uiViewController: WallCollectionViewController, context: Context) {
        let imageURL=wallViewModel.data.map { (eachpost)  in
            return eachpost.imageURL[0]
        }
        uiViewController.setupData(images:
            imageURL)


    }
    
    typealias UIViewControllerType = WallCollectionViewController
    
    
}
