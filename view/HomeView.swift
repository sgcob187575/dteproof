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
    @State private var showSearch = false
    @State private var test = false
    @State private var barcolor=UIColor.systemBackground
    @State private var selectImage: UIImage?
    @EnvironmentObject var userdata:Userdata
    @State private var showMenu=false
    @State private var loading=""
    @ObservedObject var locationManager = LocationManager.shared
    @State private var searchoffset:CGFloat=0
    @State private var canRefresh=true
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                NavigationLink(destination: SetProfileView(showSetprofile: self.$showSetProfile,barcolor:self.$barcolor).environmentObject(self.userdata), isActive: self.$showSetProfile){
                    Text("")
                }
                NavigationLink(destination: ChangePasswordView(showChangePassword: self.$showChangepass,barcolor:self.$barcolor).environmentObject(self.userdata), isActive: self.$showChangepass){
                    Text("")
                }
                NavigationLink(destination: CountDownView(), isActive: self.$showCountdown){
                    Text("")
                }
                Text("Loading").offset(y:-UIScreen.main.bounds.height+60)
                VStack {
                    
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
                                        self.sheetdbViewModel.cancellable=nil
                                        self.sheetdbViewModel.fetchdata(sql:sql)
                                        
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
                            
                            
                        }.listRowBackground(Color.init(red: 202/255, green: 230/255, blue: 242/255)).onAppear {
                            self.locationManager.getLocation()
                            UITableView.appearance().separatorStyle = .none } .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
                        
                        
                    }
                }.offset(y:-70).onAppear {
                    print("fetch data")
                    let sql="/search_or?uploadlogin[]=\(self.userdata.user.profile!.login)&uploadlogin[]=\(self.userdata.user.profile!.partner ?? "")"
                    self.sheetdbViewModel.fetchdata(sql:sql)
                }
                if(showMenu){
                    MenuView(showSetProfile: self.$showSetProfile,showChangePassword:
                        self.$showChangepass,showMenu: self.$showMenu, showcountdown: self.$showCountdown,showSearch: self.$showSearch).offset(x:0,y:0)
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
            Color.white.frame(height:250)
            VStack {
                Picker(selection: $mode, label: Text("")) {
                    ForEach(0..<types.count) { (index) in
                        Text(self.types[index])
                    }
                }.colorMultiply( .gray).pickerStyle(SegmentedPickerStyle()).padding()
                if mode == 1{
                    HStack {
                        DatePicker("", selection: Binding(get: {self.date}, set: {
                            self.date=$0
                            if self.date.date2String(dateFormat: "yyyy-MM") == Date().date2String(dateFormat: "yyyy-MM"){
                                self.sheetdbViewModel.cancelsearch()
                            }
                            else{
                            self.sheetdbViewModel.searchdatawithdate(self.date)
                            }
                        }), in: ClosedRange<Date>(uncheckedBounds: (lower: DateComponents(calendar: Calendar.current, year: 2014, month: 10, day: 31 ).date!, upper: Date())),displayedComponents: .date).colorMultiply( .black)
                            .labelsHidden()
                            .frame( height: 150.0)
                        
                        
                    }
                    
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
                
            }
            Image(systemName: "xmark.circle.fill").font(.system(size: 30)).foregroundColor(.black).onTapGesture {
                self.showSearch=false
                self.searchoffset=0
                
            }.offset(x:UIScreen.main.bounds.width/2-30,y:-105)
            
        }
    }
}
