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
import AVKit
class test:Identifiable,ObservableObject{
    @Published var testdata:Sheetdbget?
    init() {
        self.testdata=nil
    }
}
struct PostViewRow: View {
    var postdata:Sheetdbget
    @EnvironmentObject var userdata:Userdata
    @State var test1=test()
    @State private var showtext=false
    @State var imageindex=0
    @State var photoindex=0
    @State var drag:CGFloat=0
    @State var showProfile=false
    @State var videoURL=[String]()
    @Binding var searchoffset:CGFloat
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom)
            NavigationLink(destination: ProfileView(postlogin:postdata.uploadlogin), isActive: self.$showProfile){
                Text("")
                
            }.frame(width:0).hidden()

            VStack(alignment:.leading,spacing: 5){
                
                HStack {
                    
                    KFImage(URL(string: postdata.uploadimage)).resizable().scaledToFit().frame(width:50).clipShape(Circle()).padding(10)
                    ZStack(alignment:.leading){
                    Text(postdata.upload).foregroundColor(.black)
                        Text(postdata.locationname!).font(.system(size: 15)).foregroundColor(.blue).offset(y:17).frame(height:16)

                    }
                    Spacer()
                    Text(postdata.date).foregroundColor(.black).padding()
                }.background(Rectangle()
                .frame(height: 1.0, alignment: .bottom)
                .foregroundColor(Color.white).offset(y:30))
                PhotoCollectionView(post:postdata,postdata:$test1,searchoffest: $searchoffset,show:$showtext,photoindex:$photoindex ).frame(width:400,height: 300)
                HStack{
                    Spacer()
                    Photoindex(postdata: postdata, currentindex: $photoindex).frame(width:300)
                    Spacer()

                }
                
                
            }

            if self.showtext{
                Color.gray.opacity(0.8).onTapGesture {
                    withAnimation(.easeInOut) {
                        UIApplication.shared.endEditing()

                        self.searchoffset=0
                        self.showtext.toggle()
                        

                    }
                }.onAppear(){
                    if self.userdata.user.profile!.login != self.postdata.uploadlogin && self.postdata.read != "TRUE"{
                        DataManager.shared.readed(group: self.postdata.group, newrow: self.postdata,login: self.userdata.user.profile!.login)
                    }
                }
                Text(postdata.read=="FALSE" ?  postdata.text : postdata.text+"\n❤️").foregroundColor(.black).padding(.init(top: 25, leading: 50, bottom: 25, trailing: 50)).background(ZStack{
                LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom).cornerRadius(30).scaleEffect(x: 0.9, y: 0.9)
                
                Image("對話框").resizable()}).onTapGesture {
                    withAnimation(.easeInOut) {
                        UIApplication.shared.endEditing()

                        self.searchoffset=0
                        self.showtext.toggle()

                    }
                }
                
        }
        }.frame(width:UIScreen.main.bounds.width)
    }
}

struct PostViewRow_Previews: PreviewProvider {
    static var previews: some View {
        PostViewRow(postdata: Sheetdbget(imageURL: ["https://i.imgur.com/vtBEfQy.jpg"], text: "hello,iamssssssssssssssssssssssssssssssssssssssssssssssss", group: "a", read: "a", date: "20200520", upload: "小豪",uploadimage: "https://i.imgur.com/BQWTAOT.jpg",uploadlogin: "l",locationname: nil),searchoffset: Binding<CGFloat>.constant(0))
    }
}

