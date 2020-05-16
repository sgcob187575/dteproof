//
//  PostViewRow.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/5.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//
import SwiftUI
import KingfisherSwiftUI
import AKVideoImageView
struct PostViewRow: View {
    var postdata:Sheetdbget
    @State private var showtext=false
    @State var imageindex=0
    @State var drag:CGFloat=0
    @State var showProfile=false
    @State var videoURL=[String]()
    var body: some View {
        ZStack {
            NavigationLink(destination: ProfileView(postlogin:postdata.uploadlogin), isActive: self.$showProfile){
                Text("")
                
            }.frame(width:0).hidden()
            VStack(alignment:.leading,spacing: 5){
                
                HStack {
                    
                    KFImage(URL(string: postdata.uploadimage)).resizable().scaledToFit().frame(width:50).clipShape(Circle()).padding(10)
                    Text(postdata.upload).foregroundColor(.black)
                    Spacer()
                    Text(postdata.date).foregroundColor(.black).padding()
                }.background(Rectangle()
                .frame(height: 1.0, alignment: .bottom)
                .foregroundColor(Color.white).offset(y:30))
                ScrollView(.horizontal){
                    VStack(alignment: .leading, spacing: 0){
                    HStack{
                        ForEach(postdata.imageURL.filter({
                            !Validfield.shared.isVideo(url:$0)   }), id: \.self){(imageurl) in
                            KFImage(URL(string:imageurl)).resizable().scaledToFit().frame(width:400,height: 300)
                            
                        }

                        ForEach(postdata.imageURL.filter({
                        Validfield.shared.isVideo(url:$0)   }), id: \.self){(imageurl) in
                            VideoviewController(urlstring: imageurl).frame(width:400,height: 300)                        }
                    }.padding(.bottom,20)
                        
                    }
                }.onTapGesture {
                    withAnimation(.easeInOut) {                             self.showtext.toggle()

                    }
                }
            }

            if self.showtext{
                Color.gray.opacity(0.8).onTapGesture {
                    withAnimation(.easeInOut) {                             self.showtext.toggle()

                    }
                }
            Text(postdata.text).foregroundColor(.black).padding(.init(top: 25, leading: 50, bottom: 25, trailing: 50)).background(ZStack{
                LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom).cornerRadius(30).scaleEffect(x: 0.9, y: 0.9)
                Image("對話框").resizable()}).onTapGesture {
                    withAnimation(.easeInOut) {                             self.showtext.toggle()

                    }
                }
        }
        }
    }
}

struct PostViewRow_Previews: PreviewProvider {
    static var previews: some View {
        PostViewRow(postdata: Sheetdbget(imageURL: ["https://i.imgur.com/vtBEfQy.jpg"], text: "hello,iamssssssssssssssssssssssssssssssssssssssssssssssss", group: "a", valid: "a", date: "20200520", upload: "小豪",uploadimage: "https://i.imgur.com/BQWTAOT.jpg",uploadlogin: "l"))
    }
}
