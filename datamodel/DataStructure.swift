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
import Photos
import BSImagePicker
import MapKit

let startword=["s","a"]

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
    var intro:String?
    var addcode:String

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
struct Sheetdbget:Codable ,Identifiable{
    var id:String{imageURL[0]}
    //https://sheetdb.io/api/v1/5tpif3zsl56dh
    var imageURL:[String]
    var text:String
    var group:String
    var valid:String
    var date:String
    var upload:String
    var uploadimage:String
    var uploadlogin:String
    var locationname:String?
    enum CodingKeys: CodingKey {
        case imageURL
        case text
        case group
        case valid
        case date
        case upload
        case uploadimage
        case uploadlogin
        case locationname
    }
    init(imageURL:[String],text:String,group:String,valid:String,date:String,upload:String,uploadimage:String,uploadlogin:String,locationname:String?) {
        self.imageURL=imageURL
        self.text=text
        self.group=group
        self.valid=valid
        self.upload=upload
        self.date=date
        self.uploadimage=uploadimage
        self.uploadlogin=uploadlogin
        self.locationname=locationname
    }

    init(from decoder: Decoder) throws {
         
       
        let container = try decoder.container(keyedBy: CodingKeys.self)
         
        
        text = try container.decode(String.self, forKey: .text)
        group = try container.decode(String.self, forKey: .group)

        valid = try container.decode(String.self, forKey: .valid)
        date = try container.decode(String.self, forKey: .date)

        upload = try container.decode(String.self, forKey: .upload)
        uploadimage = try container.decode(String.self, forKey: .uploadimage)
        uploadlogin = try container.decode(String.self, forKey: .uploadlogin)
        locationname = try container.decode(String.self, forKey: .locationname)


         
        let imageString = try container.decode(String.self, forKey: .imageURL)
       if let areaData = imageString.data(using: .utf8), let imageURL = try? JSONDecoder().decode([String].self, from: areaData) {
            self.imageURL = imageURL
        } else {
            self.imageURL = []
        }
    }

    
}
struct Newaddrowdata:Codable {
    struct Addrowdata:Codable {
        let login:String
        let addcode:String
    }
    let data:[Addrowdata]
}
struct Creat:Decodable{
    let created:Int
}
struct Newrowdata:Encodable{
    let data:[Sheetdbget]
}
class OurImage: Codable, Identifiable {
    // JSON field
    let imageURL: String
    let id = UUID()
    var text:String?
    var group:Int
    var valid:Bool
    var date:String
    var upload:String
    
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
extension Data {
    mutating func appendString(_ string: String) {
        append(string.data(using: .utf8)!)
    }
}

extension Date{
    func date2String(dateFormat:String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
}
extension String{
    func string2Date(dateFormat:String = "yyyy-MM-dd") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: self)
        return date!
    }
}
extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
