//
//  ProfileView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/15.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import Combine
struct ProfileView: View {
    var postlogin:String
    @State private var profile:OktaProfile?
    @State private var getsuccess=false
    @State private var cancel:AnyCancellable?
    var body: some View {
        VStack{
            if getsuccess{
                HStack{
                    KFImage(URL(string: profile!.imageURL!)!).resizable().scaledToFit().frame(width:100).clipShape(Circle()).padding(10)
                    VStack{
                    Text(profile!.displayName)
                        Text(profile!.intro == nil ? "" : profile!.intro!).padding()
                    }
                }
                WallCollectionView(login: postlogin)
            }
        }.onAppear() {
            LogManager.shared.getProfile(login: self.postlogin) { (result) in
                switch result{
                case .success(let profile):
                    print("success")
                    self.profile=profile.profile
                    self.getsuccess=true
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(postlogin: "wes741@yahoo.com.tw")    }
}
struct PostListView: View {
    var post:[Sheetdbget]
    var body: some View {
        List(0..<(post.count/3),rowContent: { (rowindex) in
            HStack(spacing:0){
            ForEach(0..<3) { (index) in
                VStack {
                    TestView(post: self.post[rowindex*3+index].imageURL[0])
                    
                }
                
            }.background(LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom))
            
        }})
    }
}

struct TestView: View {
    var post:String
    var body: some View {
        VStack{
        if Validfield.shared.isVideo(url: post){
            Image("video").resizable().scaledToFill().frame(width:UIScreen.main.bounds.width/3-10,height: UIScreen.main.bounds.height/6).clipped()

        }
        else{
            KFImage(URL(string: post)).resizable().scaledToFill().frame(width:UIScreen.main.bounds.width/3-10,height: UIScreen.main.bounds.height/6).clipped()

        }
        }
    }
}
