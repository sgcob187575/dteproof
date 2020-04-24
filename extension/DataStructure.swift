//
//  DataStructure.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/1.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
let startword=["您好","這個APP的作者是陳昱豪","用來上傳圖片到imgur","現在這裡打的字是廢話","但是我做完之後","會改成有用的話","送給有意義的人"]

class ViewRouter: ObservableObject {
    
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    
    var currentPage: String = "page1" {
        didSet {
            objectWillChange.send(self)
        }
    }
}
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
struct Newpassword:Encodable {
    var oldPassword:Password
    var newPassword:Password
}
struct Register:Codable {
    var profile:OktaProfile?
    var credentials:Credentials
}
struct Editprofile:Codable {
    var profile:OktaProfile?
    
}
struct Provider :Decodable{
    let type:String
}
struct Returnpass:Decodable{
    let provider:Provider
}
struct Errorpass:Decodable{
    let errorCauses:[ErrorCauses]
}
struct ErrorCauses:Decodable{
    let errorSummary:String
}
struct Credentials:Codable {
    var password:Password
    var recovery_question:Recovery
}
struct Recovery:Codable {
    var question:String
    var answer:String
}
struct Password:Codable {
    var value:String
}
struct Log:Encodable {
    var username:String
    var password:String
}
struct OktaProfile:Codable {
    var login:String
    var displayName:String
    var email:String
    var imageURL:String?
    var partner:String?
    var phone:String?

}
struct User:Codable {
    var logstate:Bool{
        if oktatoken==nil{
            return false
        }
        else{
            return true
        }
    }
    var profile:OktaProfile?
    var oktalogin:String?
    var oktatoken:String?
    var oktaid:String?
    var fbid:String?
}
class Userdata : ObservableObject{
    @Published var user = User(){
        didSet{
            let encoder=JSONEncoder()

            if let data = try? encoder.encode(user){
                UserDefaults.standard.set(data,forKey: "user")
            }
        }
    }
    init(){
        //print(user.profile!)
        if let data = UserDefaults.standard.data(forKey: "user"){
            let decorder=JSONDecoder()
            
            if let decodeData=try? decorder.decode(User.self, from: data){
                user=decodeData
            }
        }
    }
    
}
struct Loginuser:Codable {
    struct login :Codable{
        var login:String
    }
    var id:String
    var profile:login
}
struct Embedded:Codable {
    var user:Loginuser
}
struct Authjason:Codable{
    var status:String
    var sessionToken:String
    var _embedded:Embedded
}
struct recoverURL:Codable {
    var resetPasswordUrl:String
}
struct recoverBody:Codable {
    var id:String
    let sendEmail=false
}

struct GetProfile:Codable{
    var id:String
    var profile:OktaProfile
}
struct UploadImageResult: Decodable {
    struct Data: Decodable {
        let link: String
    }
    let data: Data
}
class OurImage: Codable, Identifiable {
    // JSON field
    let imageURL: String
    let id = UUID()
    var text:String?
    // 收到禮物的人，將禮物送給 giftee
    var group:Int
    // 是否已送出禮物
    var valid:Bool    // 是否已得到禮物
    var date:String
    var upload:String
}
struct ImagePickerController: UIViewControllerRepresentable {
    
    @Binding var selectImage: UIImage?
    @Binding var showSelectPhoto: Bool
    
    func makeCoordinator() -> ImagePickerController.Coordinator {
        Coordinator(self)
    }
        
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var imagePickerController: ImagePickerController
        
        init(_ imagePickerController: ImagePickerController) {
            self.imagePickerController = imagePickerController
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePickerController.showSelectPhoto = false
            imagePickerController.selectImage = info[.originalImage] as? UIImage
        }
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerController>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerController>) {
    }
    
    
}
class ImageData: ObservableObject {
    
    @Published var  ourimages = [OurImage]()
        
    init() {
        URLSession.shared.dataTask(with: URL(string: "https://sheetdb.io/api/v1/5tpif3zsl56dh")!) { data, response, error in
            guard let data = data, let array = try? JSONDecoder().decode([OurImage].self, from: data) else {
                print(String(describing: error))
                return
            }
            DispatchQueue.main.async {
                self.ourimages = array
            }
            
        }.resume()
    }
    
}


