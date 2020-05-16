//
//  LoginView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/3.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
struct LoginView: View {
    @State private var account=""
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var password=""
    @State private var showAlert=false
    @EnvironmentObject var userdata:Userdata
    @State private var alertmessage="請稍後"
    @State private var alerttitle="登入中"
    @State private var saving=false
    @State private var showRegister=false
    @State private var wrongpass=false


    var body: some View {
            ZStack{
                LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom)
                VStack{
                    LogoView(x:-174,y:20).scaledToFit().frame(height:80).padding().offset(y:-30)
                    accountfield(account: $account)
                    passworedfield(password: $password)
                    loginbutton(showAlert: $showAlert, saving: $saving, wrongpass: $wrongpass, alerttitle: $alerttitle, alertmessage: $alertmessage, account: $account, password: $password)

                    regibutton()

                    fblogbutton(showAlert: $showAlert, saving: $saving ,alerttitle: $alerttitle, alertmessage: $alertmessage)
                        
                        
                        
                    
                    
                }.alert(isPresented: $showAlert) { () -> Alert in
                    if wrongpass{
                        return Alert(title: Text(self.alerttitle),message: Text(self.alertmessage), primaryButton: .default(Text("ok"), action: {
                            self.saving=false
                        }), secondaryButton: .default(Text("忘記密碼"), action: {
                                            self.viewRouter.currentPage="forgot"
                        }))

                    }
                    return Alert(title: Text(self.alerttitle),message: Text(self.alertmessage), dismissButton: .default(Text("ok"), action: {
                        self.wrongpass=false
                        self.saving=false
                    }))
                }
                if(saving){ZStack{
                    Spacer()}.edgesIgnoringSafeArea(.all).background(Color.gray.opacity(0.2)
                    )
                    
                }
                
            
        }
    }
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView().environmentObject(Userdata())
        }
    }
    struct regibutton:View {
        @EnvironmentObject var viewRouter:ViewRouter
        var body: some View{
            Button(action: {
                self.viewRouter.currentPage="register"
            }){
                Text("Sign up").foregroundColor(.white).font(.system(size: 25)).padding(.bottom,10).padding(.top,10).frame(width:300).background(Color.init(red: 254/255, green: 175/255, blue: 128/255)).cornerRadius(30).offset(y:10)                        }

        }
    }
    struct  fblogbutton:View {
        @Binding var showAlert:Bool
        @Binding var saving:Bool
        @Binding var alerttitle:String
        @Binding var alertmessage:String
        @EnvironmentObject var userdata:Userdata
        @EnvironmentObject var viewRouter:ViewRouter
        var body: some View{
            Button(action: {
                self.showAlert=true
                self.alerttitle="登入中"
                self.alertmessage="請稍候"
                self.saving=true
                LogManager.shared.fblogin { (result) in
                    switch result{
                    case .success(let user):
                        DispatchQueue.main.async {
                            self.userdata.user=user
                            self.showAlert=false
                            self.viewRouter.currentPage="logged"
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }){
                Image("fblogo").renderingMode(.original).resizable().scaledToFit().frame(width:100)
            }
        }
    }
    struct accountfield:View{
        @Binding var account:String
        @EnvironmentObject var userdata:Userdata
        var body: some View{
            ZStack(alignment: .leading){
                if(account==""){
                    Text("帳號..").padding().foregroundColor(.lairGray)
                }
            TextField("", text: $account).accentColor(Color.init(.black)).foregroundColor(.gray).keyboardType(.emailAddress).padding().frame(width:400).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1)).autocapitalization(.none).onAppear{
                if self.userdata.user.profile?.email != nil{
                    self.account=self.userdata.user.profile!.email
                }
            }
        }
        }
    }
    struct passworedfield:View {
        @Binding var password:String
        @EnvironmentObject var userdata:Userdata

        var body: some View{
            ZStack(alignment: .leading){
            if(password==""){
                Text("密碼..").padding().foregroundColor(.lairGray)
            }
                SecureField("", text: $password).foregroundColor(.gray).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).padding().frame(width:400).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))

        }
        }
    }
    struct loginbutton:View {
        @Binding var showAlert:Bool
        @Binding var saving:Bool
        @Binding var wrongpass:Bool
        @EnvironmentObject var viewRouter:ViewRouter

        @Binding var alerttitle:String
        @Binding var alertmessage:String
        @Binding var account:String
        @Binding var password:String
        @EnvironmentObject var userdata:Userdata
        var body: some View{
            Button(action: {
                self.showAlert=true
                self.alerttitle="登入中"
                self.alertmessage="請稍候"
                self.saving=true
                guard self.account != "" else{
                    self.alerttitle="請輸入帳號"
                    self.alertmessage=""

                    return
                }
                guard self.password != "" else{
                    self.alerttitle="請輸入密碼"
                    self.alertmessage=""

                    return
                }

                LogManager.shared.auth(account: self.account, password: self.password) { (result) in
                    switch result{
                    case .success(let personResult):
                        DispatchQueue.main.async {
                            if personResult.status=="SUCCESS"{
                                self.userdata.user.oktaid=personResult._embedded.user.id
                                self.userdata.user.oktalogin=personResult._embedded.user.profile.login
                                self.userdata.user.oktatoken=personResult.sessionToken
                                self.alerttitle="登入成功"
                                self.alertmessage=""
                                LogManager.shared.getProfile(login:self.userdata.user.oktalogin!){ (result) in
                                    switch result {
                                    case .success(let personResult):
                                        let tempuser=User(profile: personResult.profile, oktatoken: self.userdata.user.oktatoken, oktaid: self.userdata.user.oktaid, fbid: self.userdata.user.fbid)
                                        DispatchQueue.main.async {
                                            self.userdata.user=tempuser
                                            self.viewRouter.currentPage="logged"
                                        }
                                    case .failure(let networkError):
                                        print(networkError)                                                        }
                                }
                            }
                            
                        }
                        
                    case .failure(let networkError ):
                        switch networkError{
                        case .errorPassword:
                            self.wrongpass=true
                            self.alerttitle="登入失敗"
                            self.alertmessage="信箱或密碼錯誤"
                            
                        case  .invalidUrl,.responseFailed,.invalidData,.requestFailed,.imageDownloadFailed,.datatypeError,.duplicateUser:
                            self.alerttitle="登入失敗"
                            self.alertmessage="請聯絡作者"
                        }
                    }
                }
            }){
                Text("Login").foregroundColor(.white).font(.system(size: 25)).padding(.bottom,10).padding(.top,10).frame(width:300).background(Color.init(red: 254/255, green: 175/255, blue: 128/255)).cornerRadius(30)
            }
        }
    }
}
