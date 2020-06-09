//
//  MotherView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/16.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var userdata=Userdata()

    var body: some View {
        ZStack {
            if viewRouter.currentPage=="start"{
                StartView().environmentObject(viewRouter)
            }
            else if viewRouter.currentPage=="logged"{
                ContentView().environmentObject(userdata).environmentObject(viewRouter).environment(\.managedObjectContext, managedObjectContext)
            } else if viewRouter.currentPage=="unlogged"{
                LoginView().environmentObject(userdata).environmentObject(viewRouter)
                
            }else if viewRouter.currentPage=="register"{
                RegisterView().environmentObject(userdata).environmentObject(viewRouter)
            }else if viewRouter.currentPage=="forgot"{
                Forgotpasswordview().environmentObject(userdata).environmentObject(viewRouter)
            }
        }.onAppear{
            if self.userdata.user.profile==nil{
                self.viewRouter.currentPage="start"

            }
            else if self.userdata.user.logstate{
                self.viewRouter.currentPage="logged"
            }
            else{
                self.viewRouter.currentPage="unlogged"

            }
        }

    }
}
