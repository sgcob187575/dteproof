//
//  StartView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/17.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import AVFoundation
import MediaPlayer
struct StartView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var timer:Timer?
    @State private var timer2:Timer?
    @State private var count=0
    @State private var shownextbutton=false
    @State private var setvolume=true
    @State private var showtext=true
    @State private var intro=startword[0]
    let player=AVPlayer(url: Bundle.main.url(forResource: "想見你", withExtension: "mp3")!)
    
    
    var body: some View {
        ZStack{
            if setvolume{
            Text("").onDisappear(){
                MPVolumeView.setVolume(0.5)
            }
            }
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
                        self.player.pause()
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
            do {
               try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            self.player.volume=0.5
            if self.viewRouter.currentPage=="start"{
            self.player.play()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                self.setvolume=false
                self.timer2=Timer.scheduledTimer(withTimeInterval: 5, repeats: true){_ in
                    self.intro=startword[self.count]
                    withAnimation(Animation.linear(duration: 0.5)){
                        self.showtext.toggle()
                    }
                    if self.count==startword.count-1{
                        self.timer2!.invalidate()
                    }
                    
                }
            }
            
            self.timer=Timer.scheduledTimer(withTimeInterval: 5, repeats: true){_ in
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
extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        // Need to use the MPVolumeView in order to change volume, but don't care about UI set so frame to .zero
        let volumeView = MPVolumeView(frame: .zero)
        // Search for the slider
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        // Update the slider value with the desired volume.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
        // Optional - Remove the HUD
            }
}
