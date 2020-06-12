//
//  AddPartnerView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/6/10.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct AddPartnerView: View {
    @EnvironmentObject var userdata:Userdata
    @Environment(\.presentationMode) var presentationMode
    @State var login=""
    @State var addcode=""
    @State var ansaddcode=""
    @State var ansid=""
    @State var showadd=false
    @State var showalert=false
    @State var addsuccess=false
    @State var alerttext=""
    @Binding var showaddpartner:Bool
    var body: some View {
        ZStack{
            LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom).onAppear(){
                self.showaddpartner = !self.addsuccess
            }
            VStack{
                LogoView(x:-174,y:20).scaledToFit().frame(height:80).padding().offset(y:-30)
                loginfield(account: $login,defult: "配對帳號..").alert(isPresented: $showalert) {
                    Alert(title: Text(self.alerttext), dismissButton: .cancel(Text("確定"), action: {
                        self.login=""
                        self.showadd=false
                        self.addcode=""
                        self.showalert=false
                        if self.addsuccess{
                        self.presentationMode.wrappedValue.dismiss()
                        }
                    }))
                }
                if showadd{
                    loginfield(account: $addcode,defult: "配對密碼..")                }
                HStack{
                    Spacer()
                    Pributton().onTapGesture {
                        if self.showadd{
                            withAnimation(.easeIn){
                                self.showadd=false
                            }
                            
                        }
                        else{
                            self.showaddpartner=false
                        }
                    }
                    Spacer()
                    NextButton().onTapGesture {
                        if self.showadd{
                            if self.addcode == self.ansaddcode{
                                var tempprofile=self.userdata.user.profile!
                                tempprofile.partner=self.login
                                LogManager.shared.editProfile(id: self.userdata.user.oktaid!, profile: tempprofile) { (result) in
                                    switch result{
                                        
                                    case .success(_):
                                        print("oktaaddcodesuccess")
                                        LogManager.shared.getProfile(login: self.login) { (result) in
                                            switch result{
                                                
                                            case .success(let getprofile):
                                                var tempprofile=getprofile.profile
                                                tempprofile.partner=self.userdata.user.profile!.login
                                                LogManager.shared.editProfile(id: self.ansid, profile: tempprofile) { (result) in
                                                    switch result{
                                                        
                                                    case .success(_):
                                                        print("partneroktaaddcodesuccess")
                                                        self.alerttext="配對成功"
                                                        self.showalert=true
                                                        self.addsuccess=true
                                                        self.userdata.user.profile!.partner=self.login

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
                                
                                print("doadd")
                            }
                            else{
                                self.alerttext="配對密碼錯誤"
                                self.showalert=true
                            }
                        }
                        else{
                            DataManager.shared.getaddcode(login: self.login) { (result) in
                                switch result{
                                    
                                case .success(let getdata):
                                    if getdata.count==0{
                                        self.alerttext="找不到使用者"
                                        self.showalert=true
                                    }
                                    else{
                                        self.ansaddcode=getdata[0].addcode
                                        self.ansid=getdata[0].id
                                        withAnimation(.easeIn){
                                            self.showadd=true
                                        }
                                        
                                    }
                                case .failure(_):
                                    print("getaddcodeerror")
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        
    }
}

struct AddPartnerView_Previews: PreviewProvider {
    static var previews: some View {
        AddPartnerView(showaddpartner: .constant(true)).environmentObject(Userdata())
        
    }
}
struct loginfield:View{
    @Binding var account:String
    var defult:String
    @EnvironmentObject var userdata:Userdata
    var body: some View{
        ZStack(alignment: .leading){
            if(account==""){
                Text(defult).padding().foregroundColor(.lairGray)
            }
            TextField("", text: $account).accentColor(Color.init(.black)).foregroundColor(.gray).keyboardType(.emailAddress).padding().frame(width:400).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1)).autocapitalization(.none)
        }
    }
}

