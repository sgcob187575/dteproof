//
//  UploadfileView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/25.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import Photos
import Combine


struct UploadfileView: View {
    @Binding var selecttab:Int
    @State private var showSelectPhoto=true
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var test = false
    @State private var barcolor=UIColor.systemBackground
    @EnvironmentObject var userdata:Userdata
    @State private var imageasset=[PHAsset]()
    @ObservedObject var uploadimage=UploadImage()
    @State private var imagetext=""
    @State var can:AnyCancellable?
    @State var imagesURL=[String]()
    @State var imagedate=Date()
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                VStack {
                    HStack {
                        if uploadimage.selectimages.count != 0{
                            
                            ZStack(alignment:.topTrailing) {
                                Rectangle().stroke(Color.black,lineWidth: 0.5).frame(width:150,height: 100)
                                Image(uiImage: uploadimage.selectimages[0]).resizable().scaledToFit().frame(width:150,height:100).onTapGesture {
                                self.showSelectPhoto=true
                            }
                                if uploadimage.selectimages.count>1{
                                    multiicon().scaledToFit().frame(height:20).offset(x:-7,y:5)
                                }
                            }
                        }
                        else{
                            Image(systemName: "photo").resizable().scaledToFit().frame(width:150,height:100).onTapGesture {
                                self.showSelectPhoto=true
                            }
                        }
                        MultilineTextField("加入相片說明...", text: $imagetext, onCommit: {
                            print("Final text: \(self.imagetext)")
                        }).frame(width:UIScreen.main.bounds.width-200,height:90)
                        
                        Spacer()
                                        }
                        DatePicker("日期", selection: $imagedate, displayedComponents: .date)

                }.sheet(isPresented: $showSelectPhoto) {
                    imagePickerviewController().environmentObject(self.uploadimage)                }
            }.alert(isPresented: Binding(get: {
                self.uploadimage.showError
            }, set: { (_) in
                if  self.uploadimage.errortext=="上傳成功" || self.uploadimage.errortext=="上傳失敗"{
                    self.selecttab=1

                }
                self.uploadimage.selectimages.removeAll()
                self.uploadimage.imagesURL.removeAll()
                self.uploadimage.imagepublishers.removeAll()
                self.imagetext=""
                self.uploadimage.showError.toggle()
            })){
                Alert(title: Text(self.uploadimage.errortext))
            }.navigationBarItems( leading: HStack{
                Image(systemName: "lessthan").resizable().foregroundColor(.primary).frame(width:20,height: 25).padding().onTapGesture {
                    self.selecttab=1
                }
                Spacer()
                Text("新貼文").frame(width:150).foregroundColor(.primary)
                Spacer()
                
                Button(action: {
                    self.uploadimage.upload(newrow: Sheetdbget(imageURL: [String](), text: self.imagetext, group: UUID().uuidString, valid: "true", date: self.imagedate.date2String(dateFormat: "yyyy-MM-dd"), upload: self.userdata.user.profile!.displayName,uploadimage: self.userdata.user.profile!.imageURL!, uploadlogin: self.userdata.user.profile!.login))
                    print(self.userdata.user.profile!.imageURL!)
                
                   
                    

                    
                }){                Text("上傳").foregroundColor(.primary).frame(width:60)
                }
            }.frame(width:UIScreen.main.bounds.width,height: 60).background(Rectangle()
                .frame(height: 1.0, alignment: .bottom)
                .foregroundColor(Color.gray).offset(y:30))
            )
        } .background(NavigationConfigurator { nc in
            nc.navigationBar.barTintColor = self.barcolor
            nc.navigationBar.tintColor=UIColor.label
            nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
        })           .navigationViewStyle(StackNavigationViewStyle())
        
    }
    struct multiicon:View {
        var body: some View{
            ZStack{
                Rectangle().foregroundColor(.white).cornerRadius(5).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.5))
                Rectangle().foregroundColor(.white).cornerRadius(5).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.5)).offset(x:5,y:5)
            }
        }
    }
}
struct UploadfileView_Previews: PreviewProvider {
    static var previews: some View {
        UploadfileView(selecttab: .constant(2))
    }
}
