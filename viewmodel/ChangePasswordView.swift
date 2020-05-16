//
//  ChangePasswordView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/16.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
struct ChangePasswordView: View {
    @EnvironmentObject var userdata:Userdata
    @State private var showAlert=false
    @State private var originpass=""
    @State private var newpass=""
    @State private var confirmpass=""
    @Binding var showChangePassword:Bool
    @Binding var barcolor:UIColor
    @State private var alertmessage="請稍後"
    @State private var alerttitle="儲存中"
    @State private var saving=false
    @State private var changesuccess=false
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom)
            VStack{
                    LogoView(x:-174,y:20).scaledToFit().frame(height:80).padding().offset(y:-30)

                    cpasswordfield(text: "舊密碼", password: self.$originpass)
                    cpasswordfield(text: "新密碼", password: self.$newpass)
                    cpasswordfield(text: "確認密碼", password: self.$confirmpass)

                
            }.navigationBarTitle("變更密碼", displayMode: .inline)
                .navigationBarItems(trailing: savebutton(showAlert: self.$showAlert, originpass: self.$originpass, newpass: self.$newpass, confirmpass: self.$confirmpass, showChangePassword: self.$showChangePassword, barcolor: self.$barcolor, alertmessage: self.$alertmessage, alerttitle: self.$alerttitle, saving: self.$saving, changesuccess: self.$changesuccess)
                    
            )
            if(saving){ZStack{
                Spacer()}.edgesIgnoringSafeArea(.all).background(Color.gray.opacity(0.2)
                )
                
            }
            
            
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(showChangePassword: .constant(true), barcolor: .constant(.gray))    }
}
struct savebutton: View {
    @Binding var showAlert:Bool
    @Binding var originpass:String
    @Binding var newpass:String
    @Binding var confirmpass:String
    @Binding var showChangePassword:Bool
    @Binding var barcolor:UIColor
    @Binding var alertmessage:String
    @Binding var alerttitle:String
    @Binding var saving:Bool
    @Binding var changesuccess:Bool
    @EnvironmentObject var userdata:Userdata

    var body: some View {
        Button(action: {
            self.showAlert=true
            self.saving=true
            self.barcolor=UIColor.black
            self.alerttitle="儲存中"
            self.alertmessage="請稍候"
            guard Validfield.shared.validatePassword(password: self.newpass) else{
                self.alerttitle="輸入錯誤"
                self.alertmessage="密碼請同時包含8個以上的大小寫字母及數字"
                return
            }
            guard self.newpass==self.confirmpass else{
                self.alerttitle="輸入錯誤"
                self.alertmessage="新密碼及確認密碼不一致"
                return
            }
            LogManager.shared.changePassword(id: self.userdata.user.oktaid!, origin: self.originpass, new: self.newpass) { (result) in
                switch result{
                case .success(let state):
                    if state=="Password has been used too recently"{
                        self.alerttitle="儲存失敗"
                        self.alertmessage="此密碼之前用過了"
                    }
                    else if state=="Old Password is not correct"{
                        self.alerttitle="儲存失敗"
                        self.alertmessage="XXX舊密碼錯誤XXX"
                    }
                    else if state=="success"{
                        self.changesuccess=true
                        self.alerttitle="儲存成功"
                        self.alertmessage="密碼已變更"
                    }
                    else {
                        self.alerttitle="儲存失敗"
                        self.alertmessage=state
                    }
                case .failure(let error):
                    print(error)
                    self.alerttitle="儲存失敗"
                    self.alertmessage="請聯絡作者"
                    
                }
            }
        }){
            Text("完成").bold().foregroundColor(Color(.label))
        }
        .alert(isPresented: $showAlert) { () -> Alert in
            return Alert(title: Text(self.alerttitle),message: Text(self.alertmessage), dismissButton: .default(Text("ok"), action: {
                if self.changesuccess{
                    self.showChangePassword=false
                }
                else{
                    self.saving=false
                }
            }))
        }
    }
}

struct cpasswordfield: View {
    var text:String
    @Binding var password:String
    var body: some View {
        HStack{
            ZStack(alignment: .leading){
            if(password==""){
                Text(text).padding().foregroundColor(.lairGray)
            }
                SecureField("", text: $password).foregroundColor(.black).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).padding().frame(width:350).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
            }}
    }
}
