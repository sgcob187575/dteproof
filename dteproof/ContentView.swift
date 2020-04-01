//
//  ContentView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/3/4.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import FacebookLogin
func authn(account:String,password:String) {
    let api_token = "001_jfExIBUFpjSq6m5SCXKDGN4XfPg7Vvj_PXipxd"
    let domain = "dev-261926.okta.com"
    let query="https://\(domain)/api/v1/authn"
    if let urlStr = query.addingPercentEncoding(withAllowedCharacters:
        .urlQueryAllowed){
        
        if let url = URL(string: urlStr) {
            let authorization = "SSWS \(api_token)"
            let content_type="application/json"
            
            
            
            var request = URLRequest(url: url)
            let log=Log(username: account, password: password)
            if let data = try? JSONEncoder().encode(log){
                print(String(data: data, encoding: .utf8))
                request.httpMethod = "POST"
                request.setValue(content_type, forHTTPHeaderField: "Content-Type")
                request.setValue(authorization, forHTTPHeaderField: "Authorization")
                request.httpBody=data
                URLSession.shared.dataTask(with: request) { (retdata, response , error) in
                    let decoder=JSONDecoder()
                    if let retdata = retdata,let content=String(data: retdata, encoding: .utf8),let personResult = try? decoder.decode(Authjason.self, from: retdata){
                        print(personResult)
                        
                    }
                    else{
                        print(error)
                    }
                }.resume()
                
            }
        }
    }
}

struct ContentView: View {
    let manager = LoginManager()
    @State var ID = ""
    @State var imageURL=""
    @State var email=""
    @State var name=""
    var body: some View {
        
        VStack {
            Button(action: {
                authn(account: "jack1@test.com", password: "Abcd1234")
            }, label: {
                Text("okta登入")
            })
            Button(action: {
                
                let manager = LoginManager()
                manager.logIn(permissions: [.publicProfile, .email]) { (result) in
                    if case LoginResult.success(granted: _, declined: _, token: _) = result {
                        print("login ok")
                    } else {
                        print("login fail")
                    }
                    
                }
                if let accessToken = AccessToken.current {
                    Profile.loadCurrentProfile { (profile, error) in
                        if let profile = profile {
                            self.imageURL="\(profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300))!)"
                            
                        }
                    }
                }
                let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
                request.start { (response, result, error) in
                    if let result = result as? [String:String] {
                        self.ID=result["id"]!
                        self.email=result["email"]!
                        self.name=result["name"]!
                    }
                }
                
            }
                
                , label: {Text("登入")})
            Text(ID)
            Text(email)
            Text(name)
            Text(imageURL)
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
