import SwiftUI
import UIKit
import AVKit
import SwiftUI
struct VideoPlayer:UIViewControllerRepresentable {
    var urlstring:String
    @Binding var player:AVQueuePlayer
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller=AVPlayerViewController()

        controller.player=self.player
        controller.showsPlaybackControls=false
        return controller

    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = AVPlayerViewController
    
    
}
struct VideoView:View {
    var urlstring:String
    @State var player:AVQueuePlayer
    @State private var looper:AVPlayerLooper?
    @State private var play=false
    @State private var show=false

    var body: some View{
        ZStack {
            Text("loading").onAppear(){
                
                self.looper=AVPlayerLooper(player: self.player, templateItem: AVPlayerItem(url: URL(string: self.urlstring)!))
                self.show=true
            }

            VideoPlayer(urlstring: urlstring, player: $player).onTapGesture {
                print("tap")
                if self.play{
                    self.player.pause()
                    self.play=false

                }
                else{
                    self.player.play()
                    self.play=true
                    print("play")


                }
            }
        }
    }
}
