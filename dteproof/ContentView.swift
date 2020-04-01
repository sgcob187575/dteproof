//
//  ContentView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/3/4.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import FacebookLogin
struct ContentView: View {
    let manager = LoginManager()
    @State var ID = ""
    @State var imageURL=""
    @State var email=""
    @State var name=""
    var body: some View {
        
        VStack {
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
