//
//  MenuView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/10.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @Binding var showSetProfile:Bool
    @Binding var showChangePassword:Bool
    @Binding var showMenu:Bool
    var body: some View {
        ZStack{
        VStack{
            
            listbutton(showMenu: self.$showMenu, showSet: self.$showSetProfile,text: "個人資料",imagename: "person.crop.circle")
            listbutton(showMenu: self.$showMenu, showSet: self.$showChangePassword, text: "變更密碼", imagename: "lock")
        }
        }.background(Color.gray)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showSetProfile: .constant(false), showChangePassword: .constant(false), showMenu: .constant(true))
    }
}

struct listbutton: View {
    @Binding var showMenu:Bool
    @Binding var showSet:Bool
    var text:String
    var imagename:String

    var body: some View {
        ZStack {
            Button(action: {
                self.showMenu=false
                
                self.showSet=true
                
            }){HStack(spacing:30){
                Image(systemName: imagename).resizable().scaledToFit().frame(height:40)
                Text(text)
            }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
            .foregroundColor(.white)                }.listRowBackground(Color.gray).background(Rectangle()
            .frame(width:300,height: 1.0, alignment: .bottomTrailing)
            .foregroundColor(Color.white).offset(y:30))

        }
    }
}
