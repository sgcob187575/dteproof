//
//  ContentView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/3/4.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import FacebookLogin
import KingfisherSwiftUI
        




struct ContentView: View {
    @EnvironmentObject var userdata:Userdata
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var select=1

    var body: some View{
        TabView(selection: $select){
            HomeView().environmentObject(userdata).tabItem {
                VStack{
                    Image(systemName: "house")
                }
            }.tag(1)
            UploadfileView(selecttab:$select).tabItem {
                VStack{
                    Image(systemName: "plus.app")
                }
            }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
