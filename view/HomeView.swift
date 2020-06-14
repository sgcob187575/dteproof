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
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var showSetProfile = false
    @State private var showChangepass = false
    @State private var showCountdown = false
    @State private var showupload = false
    @State private var showSearch = false
    @State private var barcolor=UIColor.systemBackground
    @State private var selectImage: UIImage?
    @EnvironmentObject var userdata:Userdata
    @State private var showMenu=false
    @State private var loading=""
    @ObservedObject var locationManager = LocationManager.shared
    @State private var searchoffset:CGFloat=0
    @State private var canRefresh=true
    @State private var timer:Timer?
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                NavigationLink(destination: SetProfileView(showSetprofile: self.$showSetProfile,barcolor:self.$barcolor), isActive: self.$showSetProfile){
                    Text("")
                }
                NavigationLink(destination: UploadfileView(showupload: self.$showupload), isActive: self.$showupload){
                    Text("")
                }
                
                NavigationLink(destination: ChangePasswordView(showChangePassword: self.$showChangepass) ,isActive: self.$showChangepass){
                    Text("")
                }
                NavigationLink(destination: CountDownView(), isActive: self.$showCountdown){
                    Text("")
                }
                List{
                    GeometryReader  { (g:GeometryProxy) -> Text in
                        let frame=g.frame(in: CoordinateSpace.global)
                        let sql="/search_or?uploadlogin[]=\(self.userdata.user.profile!.login)&uploadlogin[]=\(self.userdata.user.profile!.partner ?? "")"
                        
                        if frame.origin.y>150{
                            DispatchQueue.main.async {
                                self.loading="Loading"
                                
                            }
                            
                            if self.canRefresh{
                                
                                print("fetchagain")
                                
                                DispatchQueue.main.async {
                                    self.canRefresh=false
                                    self.timer=Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
                                        self.canRefresh=true
                                    })
                                    self.sheetdbViewModel.cancellable=nil
                                    self.sheetdbViewModel.fetchdata(sql:sql,login: self.userdata.user.profile!.login)
                                    
                                }
                                
                            }
                            return Text(self.loading)
                            
                        }
                        else{
                            DispatchQueue.main.async {
                                self.loading=""
                                
                            }
                            return Text(self.loading)
                        }
                    }.frame(height: self.loading=="" ? 0 : 30).offset(y:self.loading=="" ? 0:-50)
                    
                    ForEach(sheetdbViewModel.appeardata.sorted(by: { return $0.date>$1.date                        }),id:\.id){ (data) in
                        PostViewRow(postdata:data,searchoffset: self.$searchoffset).offset(x:-15)
                        
                        
                    }.listRowBackground(Color.init(red: 202/255, green: 230/255, blue: 242/255))
                    
                    
                }.frame(height:UIScreen.main.bounds.height)
                    .onAppear {
                        UITableView.appearance().separatorStyle = .none
                        print("fetch data")
                        let sql="/search_or?uploadlogin[]=\(self.userdata.user.profile!.login)&uploadlogin[]=\(self.userdata.user.profile!.partner ?? "")"
                        self.sheetdbViewModel.fetchdata(sql:sql,login: self.userdata.user.profile!.login)
                        self.locationManager.getLocation()
                }
                if(showMenu){
                    MenuView(showSetProfile: self.$showSetProfile,showChangePassword:
                        self.$showChangepass,showMenu: self.$showMenu, showcountdown: self.$showCountdown,showSearch: self.$showSearch,showupload: self.$showupload).offset(x:0,y:-60)
                }
                if(showSearch){
                    searchBarView(sheetdbViewModel: sheetdbViewModel,showSearch: $showSearch,searchoffset: $searchoffset)
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
                        self.showSearch=false
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
        })
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Userdata())
    }
}
struct searchBarView:View {
    var sheetdbViewModel: SheetdbViewModel
    @Binding var showSearch:Bool
    @State var query=""
    @State var mode=0
    @State private var date=Date()
    @Binding var searchoffset:CGFloat
    
    
    let types=["內容","日期"]
    
    var body: some View{
        ZStack {
            Color("back").frame(height:UIScreen.main.bounds.height/3)
            VStack(spacing:5) {
                Picker(selection: $mode, label: Text("")) {
                    ForEach(0..<types.count) { (index) in
                        Text(self.types[index])
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding(.init(top: 20, leading: 5, bottom: 0, trailing: 5))
                if mode == 1{
                    DatePicker("", selection: Binding(get: {self.date}, set: {
                        self.date=$0
                        if self.date.date2String(dateFormat: "yyyy-MM") == Date().date2String(dateFormat: "yyyy-MM"){
                            self.sheetdbViewModel.cancelsearch()
                        }
                        else{
                            self.sheetdbViewModel.searchdatawithdate(self.date)
                        }
                    }), in: ClosedRange<Date>(uncheckedBounds: (lower: DateComponents(calendar: Calendar.current, year: 2014, month: 10, day: 31 ).date!, upper: Date())),displayedComponents: .date)
                        .labelsHidden()
                        .frame(height:UIScreen.main.bounds.height/7).clipped()
                    
                    
                    
                }
                if mode == 0{
                    SearchBar(text: Binding(get: {
                        return self.query}, set: {(text) in
                            self.query=text
                            if self.query == ""{
                                self.sheetdbViewModel.cancelsearch()
                            }
                            else{
                                self.sheetdbViewModel.searchdatawithtext(self.query)
                            }
                    }),searchoffset:$searchoffset).offset(y:searchoffset)
                }
                Spacer()
            }.frame(height:UIScreen.main.bounds.height/3)
            Image(systemName: "xmark.circle.fill").font(.system(size: 30)).onTapGesture {
                self.showSearch=false
                self.searchoffset=0
                
            }.offset(x:UIScreen.main.bounds.width/2-30,y:-105)
            
        }
    }
}
