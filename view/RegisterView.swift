//
//  RegisterView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/3.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
struct RegisterView: View {
    @State private var email=""
    @State private var displayname=""
    @State private var imageURL:String?
    @State private var password=""
    @State private var confirmpassword=""
    @State private var showSelectPhoto = false
    @State private var selectImage:UIImage?
    @EnvironmentObject var userdata:Userdata
    @State private var alertmessage="請稍後"
    @State private var alerttitle="儲存中"
    @State private var showAlert=false
    @State private var saving=false
    @State private var changesuccess=false
    @EnvironmentObject var viewRouter:ViewRouter
    @State private var step=0
    @State private var showwrong=false
    @State private var wrongString=""
    @State private var question=""
    @State private var ans=""
    var body: some View {
        ZStack{
            LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom)
            VStack{
                LogoView(x:-174,y:20).scaledToFit().frame(height:80).padding().offset(y:-30)
                if step==0{
                    emailfield(email: $email)
                }
                if step==1{
                    passwordfield(password: $password,text: "密碼...")
                    passwordfield(password: $confirmpassword,text: "再次輸入密碼...")
                }
                if step==2{
                    displaynamefield(displayname:$displayname)
                }
                
                if step==3{
                    ImagepickerView(selectImage: $selectImage,size: 32, showSelectPhoto: $showSelectPhoto).sheet(isPresented: $showSelectPhoto) {
                            SingleImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectPhoto)
                        }
                    
                }
                if step==4{
                    recoveryfield(text: "設定密碼回覆問題", recovery: $question)
                    recoveryfield(text: "答案", recovery: $ans)

                    
                }
                if showwrong{
                    Text(wrongString).foregroundColor(.red)
                }
                HStack{
                    Spacer()
                    if step>0{
                        Button(action: {self.showwrong=false
                            self.step-=1}){
                            Pributton()
                        }
                    }
                    else{
                        Button(action: {self.viewRouter.currentPage="unlogged"}){
                            Pributton()
                        }
                    }
                    Spacer()
                    if step<5{
                        
                        nextstepbutton(step: $step, email: $email, displayname: $displayname, password: $password, confirmpassword: $confirmpassword, showwrong: $showwrong, wrongString: $wrongString, showAlert: $showAlert, saving: $saving, alerttitle: $alerttitle, alertmessage: $alertmessage, selectImage: $selectImage, changesuccess: $changesuccess,question: $question,ans:$ans)
                    }
                    
                    Spacer()
                }
            }
            
        }.alert(isPresented: $showAlert) { () -> Alert in
            return Alert(title: Text(self.alerttitle),message: Text(self.alertmessage), dismissButton: .default(Text("ok"), action: {
                if self.changesuccess{
                    self.viewRouter.currentPage="unlogged"                }
                else{
                    self.saving=false
                }
            }))
        }
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environmentObject(Userdata()).environmentObject(ViewRouter())
    }
}

struct emailfield: View {
    @Binding var email:String
    var body: some View {
        ZStack(alignment: .leading){
                if(email==""){
                    Text("請輸入信箱").padding().foregroundColor(.lairGray)
                }
            TextField("", text: $email).accentColor(Color.init(.black)).foregroundColor(.gray).keyboardType(.emailAddress).padding().frame(width:400).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1)).autocapitalization(.none).onAppear{
            }
        }
    }
}
struct recoveryfield:View{
    var text:String
    @Binding var recovery:String
    var body: some View{
        ZStack(alignment: .leading){
            if(recovery==""){
                Text(text).padding().foregroundColor(.lairGray)
            }
        TextField("", text: $recovery).accentColor(Color.init(.black)).foregroundColor(.gray).keyboardType(.emailAddress).padding().frame(width:400).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1)).autocapitalization(.none).onAppear{
        }
    }
    }
}

struct passwordfield: View {
    @Binding var password:String
    var text:String
    var body: some View {
        ZStack(alignment: .leading){
                if(password==""){
                    Text(text).padding().foregroundColor(.lairGray)
                }
            SecureField("", text: $password).accentColor(Color.init(.black)).foregroundColor(.gray).keyboardType(.emailAddress).padding().frame(width:400).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1)).autocapitalization(.none).onAppear{
            }
        }
    }
}

struct displaynamefield: View {
    @Binding var displayname:String
    var body: some View {
        ZStack(alignment: .leading){
                if(displayname==""){
                    Text("暱稱").padding().foregroundColor(.lairGray)
                }
            TextField("", text: $displayname).accentColor(Color.init(.black)).foregroundColor(.gray).keyboardType(.emailAddress).padding().frame(width:400).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1)).autocapitalization(.none).onAppear{
            }
        }
    }
}

struct nextstepbutton: View {
    @Binding var step:Int
    @Binding var email:String
    @Binding var displayname:String
    @Binding var password:String
    @Binding var confirmpassword:String
    @Binding var showwrong:Bool
    @Binding var wrongString:String
    @Binding var showAlert:Bool
    @Binding var saving:Bool
    @Binding var alerttitle:String
    @Binding var alertmessage:String
    @Binding var selectImage:UIImage?
    @Binding var changesuccess:Bool
    @EnvironmentObject var userdata:Userdata
    @Binding var question:String
    @Binding var ans:String


    var body: some View {
        Button(action: {
            self.showwrong=false
            switch self.step{
            case 0:
                guard Validfield.shared.validateEmail(email: self.email) else{
                    self.showwrong=true
                    if self.email==""{
                        self.wrongString="請輸入信箱"
                        
                    }
                    else{
                        self.wrongString="請輸入正確格式信箱"

                    }
                    self.email=""
                    return
                }
                self.step+=1

            case 1:
                guard Validfield.shared.validatePassword(password: self.password) else{
                    self.showwrong=true
                    
                    self.wrongString="密碼請同時包含8個以上的大小寫字母及數字"
                    self.password=""
                    return
                }
                
                guard self.password==self.confirmpassword else{
                    self.showwrong=true
                    
                    self.password=""
                    self.confirmpassword=""
                    self.wrongString="確認密碼不符"
                    return
                }
                self.step+=1

            case 2:
                guard self.displayname != "" else{
                self.showwrong=true
                
                self.wrongString="請輸入暱稱"
                return
            }
                self.step+=1
            case 3:
                guard self.selectImage != nil else{
                    self.showwrong=true
                    self.wrongString="請選擇大頭照"
                    return
                }
                self.step+=1

            case 4:
                
                guard self.question != "" else{
                    self.showwrong=true
                    self.wrongString="請設定問題"
                    return
                }
                guard self.ans != "" else{
                    self.showwrong=true
                    self.wrongString="請設定答案"
                    return
                }
                guard self.ans.count >= 4  else{
                    self.showwrong=true
                    self.wrongString="答案必須超過四的字"
                    return
                }


                self.showAlert=true
                self.saving=true
                self.alerttitle="註冊中"
                self.alertmessage="請稍候"
                let pswdChars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
                let rndPswd = String((0..<7).map{ _ in pswdChars[Int(arc4random_uniform(UInt32(pswdChars.count)))]})
                LogManager.shared.regis(reg: Register(profile: OktaProfile(login: self.email, displayName: self.displayname, email: self.email,addcode: rndPswd), credentials: Credentials(password: Password(value: self.password),recovery_question: Recovery(question: self.question, answer: self.ans))), regImg: self.selectImage!, completion: { (result) in
                    switch result{
                    case.success(let profile):
                        self.alerttitle="註冊成功"
                        self.alertmessage=""
                        let tempuser=User(profile: profile.profile, oktaid: profile.id)
                        DispatchQueue.main.async{
                            self.userdata.user=tempuser
                        }
                        self.changesuccess=true
                    case .failure(let error):
                        switch error {
                        case .duplicateUser:
                            self.alerttitle="註冊失敗"
                            self.alertmessage="重複的信箱，您已註冊過"
                        default:
                            print(error)
                        }
                        
                    }
                })

            default:
                return
            


            }
                        
            
            
            
        }){
            NextButton()
        }
    }
}
