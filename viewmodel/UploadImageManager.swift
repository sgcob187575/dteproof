//
//  UploadImageManager.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/3.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
class UploadImage:ObservableObject{
    @Published var selectimages=[UIImage]()
    @Published var imagesURL=[String]()
    @Published var showError=false
    @Published var errortext="上傳成功"
    @Published var publishercount=0
    @Published var selectvedio=[AVAsset]()

    public var imagepublishers=[AnyPublisher<UploadImageResult, Error>]()
    public var videopublishers=[AnyPublisher<UploadVideoResult, Error>]()

    var imagecancellable:AnyCancellable?
    var videocancellable:AnyCancellable?
    var sheetcancellable:AnyCancellable?

    func upload(newrow:Sheetdbget){
        self.errortext="上傳中請稍候"
        self.showError=true
        for index in selectimages.indices{
            imagepublishers.append( DataManager.shared.upImagetoalbumPublisher(uiImage: selectimages[index]))
        }
        for index in selectvedio.indices{
            imagepublishers.append( DataManager.shared.upVideotoalbumPublisher(avasset:selectvedio[index]))
        }

        let upstream=Publishers.MergeMany(imagepublishers).collect()

        imagecancellable=upstream.sink(receiveCompletion: { (result) in
            switch result{
                
            case .finished:
                print("imageOK")
                self.showError=true
                self.errortext="快好了再一下下"

            case .failure(_):
                self.showError=true
                self.errortext="上傳失敗晚點再傳"
            }
        }) { (pub) in
            for i in pub.indices{
                self.errortext="上傳中請稍候\(i)"
                self.imagesURL.append(pub[i].data.link)
                
            }
            let uprow=Sheetdbget(imageURL: self.imagesURL, text: newrow.text, group: newrow.group, read: newrow.read, date: newrow.date, upload: newrow.upload,uploadimage: newrow.uploadimage, uploadlogin: newrow.uploadlogin,locationname: newrow.locationname)
            self.uploadsheet(row: uprow)
            
        }
                
    }
    func uploadsheet(row:Sheetdbget)
    {
        sheetcancellable =                DataManager.shared.postSheetdbPublisher(newrow: row).sink(receiveCompletion: { (result) in
            switch result{
                
            case .finished:
                self.showError=true
                self.errortext="上傳成功"
            case .failure(let error):
                self.showError=true
                self.errortext="上傳失敗"
                print(error)
            }
        }, receiveValue: { (count) in
            print("success:",count)
            })
    }

}
