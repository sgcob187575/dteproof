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
    @State private var intro=""
    @State private var addcode=""
    @State private var selectImage:UIImage?
    @State private var showSelectImage=false
    @State private var showAlert=false
    @Binding var showSetprofile:Bool
    @Binding var barcolor:UIColor
    @State private var alertstring="儲存中請稍後"
    @State private var saving=false
    @State private var showaddpartner=false
    @State private var showbreak=false
    
    
    
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
                        SingleImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectImage)
                    }
                    HStack{
                        if self.userdata.user.profile!.partner == nil || self.userdata.user.profile!.partner == "" {
                                Text("配對密碼：\(addcode)").padding().foregroundColor(.black).background(Rectangle()
                            .frame(width:300,height: 1.0, alignment: .bottomTrailing)
                                .foregroundColor(Color.gray).offset(y:18)).onAppear(){
                                    self.addcode=self.userdata.user.profile!.addcode
                                }
                            Image(systemName: "gobackward").onTapGesture {
                                let pswdChars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
                                let rndPswd = String((0..<7).map{ _ in pswdChars[Int(arc4random_uniform(UInt32(pswdChars.count)))]})

                                self.addcode=rndPswd
                            }

                                NavigationLink(destination: AddPartnerView(showaddpartner: $showaddpartner),isActive: $showaddpartner) {
                                    Image(systemName: "person.badge.plus").renderingMode(.original)

                                }
                                                                
                            
                        }
                        else{
                            HStack{
                                Text("另一半：").padding().foregroundColor(.black)
                                Text(self.userdata.user.profile!.partner!).padding().foregroundColor(.lairGray)
                                Spacer()
                                Text("❌").onTapGesture {
                                    self.showbreak=true
                                    self.showAlert=true
                                }                            }.background(Rectangle()
                                .frame(width:300,height: 1.0, alignment: .bottomTrailing)
                                .foregroundColor(Color.gray).offset(y:18))
                                
                            
                        }
                        
                    }


                    profilefield(displayname: self.$displayname, defult: userdata.user.profile!.displayName,text:"名稱：")
                    profilefield(displayname: self.$phone, defult: userdata.user.profile!.phone,text:"手機：")
                    
                    HStack{
                        Text("自介：").padding().padding(.trailing,-20)
                        MultilineTextField(userdata.user.profile!.intro == nil ? "介紹自己" :userdata.user.profile!.intro!, text: $intro
                            ).frame(width:UIScreen.main.bounds.width-150,height:90).border(Color.gray,width: 1)
                        Spacer()

                    }.frame(width:UIScreen.main.bounds.width)
                    Spacer()
                    
                }.navigationBarTitle("編輯個人資料", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.showAlert=true
                        self.saving=true
                        self.barcolor=UIColor.black
                        self.alertstring="儲存中請稍候"
                        if self.selectImage != nil{
                            self.alertstring="照片上傳中"
                            DataManager.shared.upImage(uiImage: self.selectImage!) { (result) in
                                switch result{
                                case .success(let imageURL):
                                    self.alertstring="照片上傳成功，再稍等一下下"
                                    self.showAlert=true
                                    
                                    
                                    var tempuser=self.userdata.user
                                    tempuser.profile!.addcode=self.addcode
                                    tempuser.profile!.displayName=self.displayname == "" ? self.userdata.user.profile!.displayName:self.displayname
                                    tempuser.profile!.phone=self.phone == "" ? self.userdata.user.profile!.phone:self.phone
                                    tempuser.profile!.imageURL=imageURL
                                    tempuser.profile!.intro=self.intro == "" ? self.userdata.user.profile!.intro:self.intro
                                    LogManager.shared.editProfile(id: self.userdata.user.oktaid!, profile: tempuser.profile!) { (result) in
                                        switch result{
                                        case .success(_):
                                            DataManager.shared.refreshaddcode(login: self.userdata.user.profile!.login, addcode: self.addcode,id:self.userdata.user.oktaid!)
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
                            tempuser.profile!.addcode=self.addcode

                            tempuser.profile!.displayName=self.displayname == "" ? self.userdata.user.profile!.displayName:self.displayname
                            tempuser.profile!.phone=self.phone == "" ? self.userdata.user.profile!.phone:self.phone
                            tempuser.profile!.intro=self.intro == "" ? self.userdata.user.profile!.intro:self.intro
                            LogManager.shared.editProfile(id: self.userdata.user.oktaid!, profile: tempuser.profile!) { (result) in
                                switch result{
                                case .success(_):
                                    self.alertstring="儲存成功"
                                    self.showAlert=true
                                    DataManager.shared.refreshaddcode(login: self.userdata.user.profile!.login, addcode: self.addcode,id:self.userdata.user.oktaid!)

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
                    .alert(isPresented: $showAlert) {
                        if showbreak{
                            return Alert(title: Text("確定要分開嗎？"), message: Text("真的不愛了嗎．．．"), primaryButton: Alert.Button.default(Text("確定"), action: {
                                var tempprofile=self.userdata.user.profile!
                                tempprofile.partner=""
                                LogManager.shared.editProfile(id: self.userdata.user.oktaid!, profile: tempprofile) { (result) in
                                    switch result{
                                        
                                    case .success(_):
                                        print("oktaaddcodesuccess")
                                        LogManager.shared.getProfile(login: self.userdata.user.profile!.partner!) { (result) in
                                            switch result{
                                                
                                            case .success(let getprofile):
                                                var tempprofile=getprofile.profile
                                                tempprofile.partner=""
                                                LogManager.shared.editProfile(id: getprofile.id, profile: tempprofile) { (result) in
                                                    switch result{
                                                        
                                                    case .success(_):
                                                        print("partneroktaaddcodesuccess")
                                                        self.userdata.user.profile!.partner=""

                                                    case .failure(let error):
                                                        print(error)
                                                    }
                                                }

                                            case .failure(_):
                                                print("getprofilefailed")
                                            }
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            }), secondaryButton: Alert.Button.cancel(Text("取消"), action: {
                                print("cancelbreak")
                            }))
                        }
                        else{
                        return Alert(title: Text(self.alertstring), dismissButton: .default(Text("ok"), action: {
                            self.showSetprofile=false
                        }))
                        }
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
                Text(defult == nil ? "設定..." : defult!).padding().foregroundColor(.lairGray)
            }
                TextField("", text: $displayname).foregroundColor(.black)
            }
        }.background(Rectangle()
            .frame(width:300,height: 1.0, alignment: .bottomTrailing)
            .foregroundColor(Color.gray).offset(y:18))
            
        }
    }
}
