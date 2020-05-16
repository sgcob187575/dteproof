//
//  Forgotpasswordview.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/23.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct Forgotpasswordview: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userdata:Userdata
    @State private var account=""
    @State private var showAlert=false
    @State private var alertmessage=""
    @State private var alerttitle="請輸入正確格式信箱"
    @State private var showforgot=false
    @State private var forgoturl=""

    var body: some View {
    ZStack{
            LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom)
            VStack{
                LogoView(x:-174,y:20).scaledToFit().frame(height:80).padding().offset(y:-30)
                accountfield(account: $account)
                HStack {
                                    Text("返回").foregroundColor(.white).font(.system(size: 25)).padding(.bottom,10).padding(.top,10).frame(width:100).background(Color.init(red: 254/255, green: 175/255, blue: 128/255)).cornerRadius(30)
                                        .onTapGesture {
                        self.viewRouter.currentPage="unlogged"
                    }
                                    Text("送出").foregroundColor(.white).font(.system(size: 25)).padding(.bottom,10).padding(.top,10).frame(width:100).background(Color.init(red: 254/255, green: 175/255, blue: 128/255)).cornerRadius(30)
.onTapGesture {
                        guard Validfield.shared.validateEmail(email: self.account) else{
                            self.alerttitle="請輸入正確格式信箱"
                            self.showAlert=true
                            return
                        }
                        LogManager.shared.getID(login: self.account) { (result) in
                            switch result{
                                case .success(let id):
                                LogManager.shared.forgot(userId: id) { (result) in
                                    switch result{
                                    case .success(let url):
                                        self.forgoturl=url
                                        self.showforgot=true
                                    case .failure(let error):
                                        
                                        print(error)
                                    }
                                }
                            case .failure(let error):
                                self.alerttitle="無此用戶"
                                self.showAlert=true
                                print(error)
                            }
                        }
                    }
                }
                
            }.alert(isPresented: $showAlert) { () -> Alert in
                return Alert(title: Text(self.alerttitle),message: Text(self.alertmessage), dismissButton: .default(Text("ok"), action: {
                    
                }))
            }.sheet(isPresented: $showforgot) {
                SafariViewController(url: URL(string: self.forgoturl)!)
            }
        
    }
    }

}

struct Forgotpasswordview_Previews: PreviewProvider {
    static var previews: some View {
        Forgotpasswordview()
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
