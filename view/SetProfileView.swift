//
//  SetProfileView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/10.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
struct SetProfileView: View {
    @EnvironmentObject var userdata:Userdata
    @State private var displayname=""
    @State private var phone=""
    @State private var selectImage:UIImage?
    @State private var showSelectImage=false
    @State private var showAlert=false
    @Binding var showSetprofile:Bool
    @Binding var barcolor:UIColor
    @State private var alertstring="儲存中請稍後"
    @State private var saving=false
    
    
    
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom)

            VStack{
                if(selectImage != nil){
                    Image(uiImage: selectImage!).resizable().scaledToFit().frame(width:80).clipShape(Circle()).padding(.top,10)
                }
                else{
                    KFImage(URL(string: userdata.user.profile!.imageURL!)).resizable().scaledToFit().frame(width:80).clipShape(Circle()).padding(.top,10)
                }
                Button(action: {
                    self.showSelectImage=true
                }){
                    Text("更換大頭貼")
                }.sheet(isPresented: $showSelectImage) {
                    ImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectImage)
                }
                profilefield(displayname: self.$displayname, defult: userdata.user.profile!.displayName,text:"名稱：")
                profilefield(displayname: self.$phone, defult: userdata.user.profile!.phone,text:"手機：")
                Spacer()
                
            }.navigationBarTitle("編輯個人資料", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showAlert=true
                    self.saving=true
                    self.barcolor=UIColor.black
                    self.alertstring="儲存中請稍候"
                    if self.selectImage != nil{
                        self.alertstring="照片上傳中"
                        NetworkManager.shared.uploadImagetoimgue(uiImage: self.selectImage!) { (result) in
                            switch result{
                            case .success(let imageURL):
                                self.alertstring="照片上傳成功，再稍等一下下"
                                self.showAlert=true
                                
                                
                                var tempuser=self.userdata.user
                                tempuser.profile!.displayName=self.displayname == "" ? self.userdata.user.profile!.displayName:self.displayname
                                tempuser.profile!.imageURL=imageURL
                                NetworkManager.shared.editProfile(id: self.userdata.user.oktaid!, profile: tempuser.profile!) { (result) in
                                    switch result{
                                    case .success(_):
                                        DispatchQueue.main.async {
                                            self.userdata.user=tempuser
                                            self.alertstring="儲存成功"
                                            self.showAlert=true
                                        }
                                    case .failure(let error):
                                        print(error)
                                        self.alertstring="儲存失敗"
                                        self.showAlert=true
                                        
                                    }
                                    
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    else{
                        var tempuser=self.userdata.user
                        tempuser.profile!.displayName=self.displayname == "" ? self.userdata.user.profile!.displayName:self.displayname
                        tempuser.profile!.phone=self.phone == "" ? self.userdata.user.profile!.phone:self.phone
                        NetworkManager.shared.editProfile(id: self.userdata.user.oktaid!, profile: tempuser.profile!) { (result) in
                            switch result{
                            case .success(_):
                                self.alertstring="儲存成功"
                                self.showAlert=true
                                DispatchQueue.main.async {
                                    self.userdata.user=tempuser
                                    
                                    self.barcolor=UIColor.init(red: 125/255 , green: 125/255, blue: 125/255, alpha: 1)
                                    
                                }
                            case .failure(let error):
                                print(error)
                                self.alertstring="儲存失敗"
                                self.showAlert=true
                                
                            }
                            
                        }
                        
                    }
                }){
                    Text("完成").foregroundColor(Color(.label))
                }
                .alert(isPresented: $showAlert) { () -> Alert in
                    return Alert(title: Text(self.alertstring), dismissButton: .default(Text("ok"), action: {
                        self.showSetprofile=false
                    }))
                    }
                    
            )
            if(saving){ZStack{
                Spacer()}.edgesIgnoringSafeArea(.all).background(Color.gray.opacity(0.2)
                )
                
            }
            
        }
    }
}

struct SetProfileView_Previews: PreviewProvider {
 static var previews: some View {
    SetProfileView(showSetprofile: .constant(true), barcolor: .constant(.gray)).environmentObject(Userdata())
 }
 }

struct profilefield: View {
    @Binding var displayname:String
    var defult:String?
    var text:String
    var body: some View {
        ZStack{
        HStack{
            Text(text).padding().foregroundColor(.black)
            ZStack(alignment: .leading){
            if(displayname == ""){
                Text(defult!).padding().foregroundColor(.lairGray)
            }
                TextField("", text: $displayname).foregroundColor(.black)
            }
        }.background(Rectangle()
            .frame(width:300,height: 1.0, alignment: .bottomTrailing)
            .foregroundColor(Color.gray).offset(y:18))
            
        }
    }
}
