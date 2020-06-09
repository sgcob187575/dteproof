//
//  ImagepickerviewController.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/4.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import SwiftUI
import BSImagePicker
import Photos
struct imagePickerviewController:UIViewControllerRepresentable {
    private func authorize(_ authorized: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async(execute: authorized)
            default:
                break
            }
        }
    }
    public func presentImagePicker(_ imagePicker: ImagePickerController, animated: Bool = true, select: ((_ asset: PHAsset) -> Void)?, deselect: ((_ asset: PHAsset) -> Void)?, cancel: (([PHAsset]) -> Void)?, finish: (([PHAsset]) -> Void)?, completion: (() -> Void)? = nil) {
        authorize {
            // Set closures
            imagePicker.onSelection = select
            imagePicker.onDeselection = deselect
            imagePicker.onCancel = cancel
            imagePicker.onFinish = finish

            // And since we are using the blocks api. Set ourselfs as delegate
            imagePicker.imagePickerDelegate = imagePicker
        }
    }
    public static var currentAuthorization : PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    @EnvironmentObject var uploadimages: UploadImage
    func makeUIViewController(context: Context) -> ImagePickerController {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 15
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.settings.selection.unselectOnReachingMax = true
        let start = Date()
        
        self.presentImagePicker(imagePicker, select: { (asset) in
            print("Selected: \(asset)")
        }, deselect: { (asset) in
            print("Deselected: \(asset)")
        }, cancel: { (assets) in
            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            print("Finished with selections: \(assets)")
            self.uploadimages.selectimages.removeAll()
            for i in 0...assets.count-1{
                print(i)
                let options = PHImageRequestOptions()
                options.isSynchronous=true
                let manager = PHImageManager.default()
                if assets[i].mediaType == .video {
                    
                    
                    manager.requestAVAsset(forVideo: assets[i], options: nil) { (video, avmix, info) in
                        DispatchQueue.main.async {
                        self.uploadimages.selectvedio.append(video!)
                        }
                    }
                    
                    
                }
                else{
                    
                    manager.requestImage(for: assets[i], targetSize: CGSize(width:1280,height:1280), contentMode: .aspectFit, options: options, resultHandler: { (result, info) in
                        self.uploadimages.selectimages.append(result!)
                    })
                    
                    
                    
                }
                
            }
            
        }, completion: {
            let finish = Date()
            print(finish.timeIntervalSince(start))
        })


        return imagePicker

    }
    
    func updateUIViewController(_ uiViewController: ImagePickerController, context: Context) {
        
    }
    typealias UIViewControllerType = ImagePickerController
    
    
    
    
}
struct SingleImagePickerController: UIViewControllerRepresentable {
    
    @Binding var selectImage: UIImage?
    @Binding var showSelectPhoto: Bool
    
    func makeCoordinator() -> SingleImagePickerController.Coordinator {
        Coordinator(self)
    }
        
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var imagePickerController: SingleImagePickerController
        
        init(_ imagePickerController: SingleImagePickerController) {
            self.imagePickerController = imagePickerController
            
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePickerController.showSelectPhoto = false
            imagePickerController.selectImage = info[.originalImage] as? UIImage
        }
        
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SingleImagePickerController>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<SingleImagePickerController>) {
    }
    
    
}
