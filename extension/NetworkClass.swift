//
//  NetworkClass.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/8.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import SwiftUI
import FacebookLogin
import Alamofire
import KingfisherSwiftUI
import SafariServices

enum NetworkError: Error {
    case errorPassword
    case invalidUrl
    case requestFailed
    case invalidData
    case datatypeError
    case imageDownloadFailed
    case responseFailed
    case duplicateUser
}
struct SafariViewController: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

class Validfield{
    static let shared = Validfield()
    func validateEmail(email: String) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*@)[A-Za-z\\d@._]{8,}$"
        let trimmedString = email.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    func validatePassword(password: String) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    
    
}
class NetworkManager {
    
    static let shared   = NetworkManager()
    private let baseURL = "https://dev-261926.okta.com/api/v1/"
    private let api_token = "001_jfExIBUFpjSq6m5SCXKDGN4XfPg7Vvj_PXipxd"
    private let content_type="application/json"
    private let accept="application/json"
    private init() {}
    func uploadImagetoAlbum(uiimage:UIImage,completion:@escaping(Result<String,NetworkError>)->Void){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer 286d9bf31d2200c23914c19f9d6d0aab0e2e925c","Content-Type":"application/json"
        ]
        AF.upload(multipartFormData: { (data) in
            let imageData = uiimage.jpegData(compressionQuality: 0.9)
            let albumid="B52Qztm"
            if let upalid = try? JSONEncoder().encode(albumid){
                data.append(upalid, withName: "album")
                /*這行*/         print(try? String(data: data.encode(), encoding: .utf8))
            }
            
            data.append(imageData!, withName: "image")
            
            
        }, to: "https://api.imgur.com/3/image", headers: headers).responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let result):
                completion(.success(result.data.link))
            case .failure(let error):
                print(error)
            }
            
        }
    }
    func auth(account: String, password:String, completion: @escaping (Result<Authjason,NetworkError>) -> Void) {
        let endpoint = baseURL + "authn"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUrl))
            return
        }
        let authorization = "SSWS \(api_token)"
        var request = URLRequest(url: url)
        let log=Log(username: account , password: password)
        guard  let data = try? JSONEncoder().encode(log) else{
            completion(.failure(.invalidData))
            return
        }
        request.httpMethod = "POST"
        request.setValue(content_type, forHTTPHeaderField: "Content-Type")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.httpBody=data
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let personResult = try decoder.decode(Authjason.self, from: data)
                completion(.success(personResult))
            } catch {
                do {
                    let errorcause = try JSONDecoder().decode(Errorpass.self, from: data)
                    if errorcause.errorCauses.count==0{
                        completion(.failure(.errorPassword))
                    }
                } catch {
                    completion(.failure(.datatypeError))
                }
            }
        }
        
        task.resume()
        
    }
    func getID(login:String,completion: @escaping (Result<String,NetworkError>) -> Void) {
        let endpoint = baseURL + "users/\(login)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUrl))
            return
        }
        let authorization = "SSWS \(api_token)"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(self.accept, forHTTPHeaderField: "Accept")
        request.setValue(content_type, forHTTPHeaderField: "Content-Type")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let personResult = try decoder.decode(GetProfile.self, from: data)
                completion(.success(personResult.id))
            } catch {
                do {
                    let errorcause = try JSONDecoder().decode(Errorpass.self, from: data)
                    if errorcause.errorCauses.count==0{
                        completion(.failure(.errorPassword))
                    }
                } catch {
                    completion(.failure(.datatypeError))
                }
            }
        }
        
        task.resume()
        
    }
    func forgot(userId:String,completion: @escaping (Result<String,NetworkError>) -> Void) {
        let endpoint = baseURL + "users/\(userId)/credentials/forgot_password?sendEmail=false"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUrl))
            return
        }
                let authorization = "SSWS \(api_token)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(self.accept, forHTTPHeaderField: "Accept")
        request.setValue(content_type, forHTTPHeaderField: "Content-Type")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let personResult = try decoder.decode(recoverURL.self, from: data)

                print(personResult.resetPasswordUrl)
                completion(.success(personResult.resetPasswordUrl))
            } catch {
                do {
                    let errorcause = try JSONDecoder().decode(Errorpass.self, from: data)

                    if errorcause.errorCauses.count==0{
                        completion(.failure(.errorPassword))
                    }
                } catch {

                    completion(.failure(.datatypeError))
                }
            }
        }
        
        task.resume()
        
    }
    func editProfile(id:String,profile:OktaProfile,completion: @escaping (Result<GetProfile,NetworkError>)-> Void ){
        let endpoint = baseURL + "users/\(id)"
        let edit=Editprofile(profile: profile)
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUrl))
            return
        }
        let authorization = "SSWS \(api_token)"
        var request = URLRequest(url: url)
        guard  let data = try? JSONEncoder().encode(edit) else{
            completion(.failure(.invalidData))
            return
        }
        request.httpBody=data
        request.httpMethod = "POST"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue(content_type, forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.responseFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let personResult = try decoder.decode(GetProfile.self, from: data)
                completion(.success(personResult))
            } catch {
                completion(.failure(.datatypeError))
            }
        }
        
        task.resume()
    }
    
    func getProfile(login:String,completion: @escaping (Result<GetProfile,NetworkError>)-> Void ){
        let endpoint = baseURL + "users/\(login)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUrl))
            return
        }
        let authorization = "SSWS \(api_token)"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.responseFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let personResult = try decoder.decode(GetProfile.self, from: data)
                completion(.success(personResult))
            } catch {
                completion(.failure(.datatypeError))
            }
        }
        
        task.resume()
    }
    func uploadImagetoimgue(uiImage:UIImage,completion:@escaping((Result<String,NetworkError>)->Void)){
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID f79138fb7a32d37",
        ]
        AF.upload(multipartFormData: { (data) in
            let imageData = uiImage.jpegData(compressionQuality: 0.9)
            data.append(imageData!, withName: "image")
            
        }, to: "https://api.imgur.com/3/upload", headers: headers).responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let result):
                completion(.success(result.data.link))
            case .failure(let error):
                print(error)
            }
        }
    }
    func regis(reg:Register,regImg:UIImage,completion:@escaping((Result<GetProfile,NetworkError>)->Void)){
        var regiprofile=reg
        self.uploadImagetoimgue(uiImage: regImg, completion: { (response) in
            switch response {
            case .success(let result):
                regiprofile.profile?.imageURL=result
                let endpoint = self.baseURL + "users?activate=true"
                guard let url = URL(string: endpoint) else {
                    completion(.failure(.invalidUrl))
                    return
                }
                if let data = try? JSONEncoder().encode(regiprofile){
                    let authorization = "SSWS \(self.api_token)"
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue(authorization, forHTTPHeaderField: "Authorization")
                    request.setValue(self.content_type, forHTTPHeaderField: "Content-Type")
                    request.setValue(self.accept, forHTTPHeaderField: "Accept")
                    request.httpBody=data
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in                        if let _ = error {
                        print("__error")
                        
                        completion(.failure(.requestFailed))
                        return
                        }
                        
                        guard let data = data else {
                            print("datafaild")
                            completion(.failure(.invalidData))
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            let personResult = try decoder.decode(GetProfile.self, from: data)
                            print(personResult)
                            completion(.success(personResult))
                        } catch {
                            do{
                                let errorpass = try JSONDecoder().decode(Errorpass.self, from: data)
                                if errorpass.errorCauses[0].errorSummary=="login: An object with this field already exists in the current organization"{
                                    completion(.failure(.duplicateUser))
                                }
                            }catch{
                                completion(.failure(.datatypeError))
                            }
                        }
                    }
                    
                    task.resume()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    func fblogin(completion: @escaping (Result<User,NetworkError>)-> Void){
        var user=User()
        var  reg=Register(profile: OktaProfile(login: "", displayName: "", email: ""), credentials: Credentials(password: Password(value: "1234"),recovery_question: Recovery(question: "", answer: "")))
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email]) { (result) in
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                if AccessToken.current != nil {
                    Profile.loadCurrentProfile { (profile, error) in
                        if let profile = profile {
                            reg.profile!.imageURL="\(profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300))!)"
                        }
                        
                    }
                }
                let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
                request.start { (response, result, error) in
                    if let result = result as? [String:String] {
                        user.fbid=result["id"]!
                        reg.profile!.login=result["email"]!
                        reg.profile!.email=result["email"]!
                        reg.profile!.displayName=result["name"]!
                        reg.credentials.password.value=result["id"]!+"PaSS"
                        self.auth(account: reg.profile!.email, password: reg.credentials.password.value) { (result) in
                            switch result{
                            case .success(let personResult):
                                if personResult.status=="SUCCESS"{
                                    user.oktatoken=personResult.sessionToken
                                    user.oktaid=personResult._embedded.user.id
                                    self.getProfile(login: user.oktaid!) { (result) in
                                        switch result{
                                        case .success(let profile):
                                            user.profile=profile.profile
                                            completion(.success(user))
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
                                    }
                                }
                            case .failure(let networkError):
                                switch networkError {
                                case .errorPassword:
                                    if let url=URL(string: reg.profile!.imageURL!),let data=try?Data(contentsOf: url),let uiimage=UIImage(data: data){
                                        self.regis(reg: reg, regImg: uiimage) { (result) in
                                            switch result{
                                            case .success(let profile):
                                                user.oktaid=profile.id
                                                user.profile=profile.profile
                                                self.auth(account: reg.profile!.email, password: reg.credentials.password.value) { (result) in
                                                    switch result{
                                                    case .success(let personResult):
                                                        if personResult.status=="SUCCESS"{
                                                            user.oktatoken=personResult.sessionToken
                                                            
                                                            user.oktaid=personResult._embedded.user.id
                                                        }
                                                        completion(.success(user))
                                                    case .failure(let error):
                                                        print(error)
                                                    }}
                                            case .failure(let error):
                                                completion(.failure(error))
                                            }
                                        }
                                        
                                    }
                                    else {
                                        completion(.failure(.imageDownloadFailed))
                                    }
                                default:
                                    print(networkError)
                                }
                            }
                        }
                    }
                    
                }

            } else {
                print(result)
            }
            
        }
        
                
    }
    func changePassword(id:String,origin:String,new:String,completion: @escaping (Result<String,NetworkError>)-> Void ){
        let endpoint = baseURL + "users/\(id)/credentials/change_password"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUrl))
            return
        }
        let authorization = "SSWS \(api_token)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue(self.content_type, forHTTPHeaderField: "Content-Type")
        let password=Newpassword(oldPassword: Password(value: origin), newPassword: Password(value: new))
        guard  let data = try? JSONEncoder().encode(password) else{
            completion(.failure(.invalidData))
            return
        }
        request.httpBody=data
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let state = try JSONDecoder().decode(Returnpass.self, from: data)
                if state.provider.type=="OKTA"{
                    completion(.success("success"))
                    
                }
            } catch {
                do{
                    let state = try JSONDecoder().decode(Errorpass.self, from: data)
                    completion(.success(state.errorCauses[0].errorSummary))
                }catch{
                    completion(.failure(.datatypeError))
                }
            }
        }
        
        task.resume()
    }
}



