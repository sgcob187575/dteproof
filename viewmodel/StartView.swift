//
//  StartView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/17.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var timer:Timer?
    @State private var timer2:Timer?
    @State private var count=0
    @State private var shownextbutton=false
    @State private var showtext=true
    @State private var intro=startword[0]
    
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: .init(colors: [Color.init(red: 147/255, green: 210/255, blue: 203/255),Color.white,Color.init(red: 244/255, green: 187/255, blue: 212/255)]), startPoint: .top, endPoint: .bottom)




            VStack{
                LogoView(x:-174,y:20).scaledToFit().frame(height:80).padding().offset(y:30)
                Spacer()
                if showtext{
                    Text(intro).font(.custom("SentyGoldenBell", size: 30)).foregroundColor(.black)
                    
                }
                else{
                    Text(intro).hidden()
                    
                }
                Spacer()
                if(shownextbutton){
                Button(action: {
                    withAnimation(Animation.easeOut(duration: 1)){
                    self.viewRouter.currentPage="unlogged"
                    }
                    
                }){
                    NextButton()
                }.offset(x:100,y:-100)
                }
                else{
                    Button(action: {
                        self.viewRouter.currentPage="unlogged"
                        
                    }){
                        NextButton()
                    }.offset(x:100,y:-100).hidden()

                }
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                self.timer2=Timer.scheduledTimer(withTimeInterval: 3, repeats: true){_ in
                    self.intro=startword[self.count]
                    withAnimation(Animation.linear(duration: 0.5)){
                        self.showtext.toggle()
                    }
                    if self.count==startword.count-1{
                        self.timer2!.invalidate()
                    }
                    
                }
            }
            
            self.timer=Timer.scheduledTimer(withTimeInterval: 3, repeats: true){_ in
                withAnimation(Animation.linear(duration: 0.5)){
                    self.showtext.toggle()
                }
                self.count+=1
                if self.count==startword.count-1{
                    self.timer!.invalidate()
                    withAnimation(Animation.easeIn(duration: 1).delay(1.5)){
                    self.shownextbutton=true
                    }
                    
                }
            }
            
            
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
