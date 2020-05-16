//
//  HomeView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/16.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import FacebookLogin
import KingfisherSwiftUI
struct HomeView: View {
    @ObservedObject var sheetdbViewModel = SheetdbViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var showSetProfile = false
    @State private var showChangepass = false
    @State private var test = false
    @State private var barcolor=UIColor.systemBackground
    @State private var selectImage: UIImage?
    @EnvironmentObject var userdata:Userdata
    @State private var showMenu=false
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                VStack {
                    
                    List(sheetdbViewModel.data.reversed()) { (data) in
                        PostViewRow(postdata:data).background(            LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom).onAppear { UITableView.appearance().separatorStyle = .none } .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
)
                    
                    
                    
                    }
                    NavigationLink(destination: SetProfileView(showSetprofile: self.$showSetProfile,barcolor:self.$barcolor).environmentObject(self.userdata), isActive: self.$showSetProfile){
                        Text("")
                    }
                    NavigationLink(destination: ChangePasswordView(showChangePassword: self.$showChangepass,barcolor:self.$barcolor).environmentObject(self.userdata), isActive: self.$showChangepass){
                        Text("")
                    }

                                       
                    }.onAppear {
                        print("fetch data")
                    
                    //self.sheetdbViewModel.fetchdata()
                }
                if(showMenu){
                    MenuView(showSetProfile: self.$showSetProfile,showChangePassword:
                        self.$showChangepass,showMenu: self.$showMenu).offset(x:0,y:0)
                }
                
            }.navigationBarItems( leading: HStack{
                Button(action: {
                    var tempuser=self.userdata.user
                    tempuser.oktatoken=nil
                    DispatchQueue.main.async {
                        self.userdata.user=tempuser
                        
                    }
                    self.viewRouter.currentPage="unlogged"
                }
                    
                    
                    , label: {Text("登出").foregroundColor(.primary).frame(width:60)})
                Spacer()
                Text("dteproof  ").frame(width:150).font(.custom("EdwardianScriptITC", size: 50)).foregroundColor(.primary)
                Spacer()
                Button(action: {
                    withAnimation{
                        self.showMenu.toggle()
                    }
                }){Image(systemName: "list.dash").font(.system(size: 23)).foregroundColor(.primary).frame(width:60)}
                
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
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Userdata())
    }
}
