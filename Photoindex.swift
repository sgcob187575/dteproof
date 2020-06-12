//
//  Photoindex.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/24.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct Photoindex: View {
    var postdata:Sheetdbget
    var total:Int{
        postdata.imageURL.count
    }
    @Binding var currentindex:Int
    var pridisplay:Int{
        if currentindex==0{
            return 0
        }
        else if currentindex==total-1{
            if total<3{
                return currentindex-1
            }
            return total-3
        }
        else{
            return currentindex-1

        }
    }
    var lastdisplay:Int{
        if currentindex==0{
            if total == 1 || total == 2{
                return total-1
            }
            return 2
        }
        else if currentindex==total-1{
            return total-1
        }
        else{
            return currentindex+1

        }

    }
    @State var temp=["","",""]
    var body: some View {
        HStack{
            if pridisplay>=1{
                if pridisplay != 1 {
                smallcircle(index: pridisplay-2, size: 15, currentindex: $currentindex,pridisplay: pridisplay)
                }
                smallcircle(index: pridisplay-1, size: 20, currentindex: $currentindex,pridisplay: pridisplay)
                
            }
            if postdata.imageURL.count>3{
                ForEach(temp.indices,id:\.self){(index) in
                    smallcircle(index: self.pridisplay+index, size: 30, currentindex: self.$currentindex,pridisplay: self.pridisplay)
                    
                }

            }
            else{
                ForEach(postdata.imageURL.indices, id: \.self)
                {(index) in
                    smallcircle(index: self.pridisplay+index, size: 30, currentindex: self.$currentindex,pridisplay: self.pridisplay)
                    
                }
            }
            if total-1-lastdisplay>=1{
                smallcircle(index: lastdisplay+1, size: 20, currentindex: $currentindex,pridisplay: pridisplay)
                
                if total-1-lastdisplay != 1{
                smallcircle(index: lastdisplay+2, size: 15, currentindex: $currentindex,pridisplay: pridisplay)
                               }
            }

        }        
    }
}
struct smallcircle: View {
    var index: Int
    var size:CGFloat
    @Binding var currentindex: Int
    let choose=Color.blue
    let notchoose=Color.gray
    var pridisplay:Int
    var body: some View {
        ZStack{
            Circle.init().foregroundColor(index == self.currentindex ? choose : notchoose).frame(width:size)
            if index>=pridisplay && index<=pridisplay+2{
            Text("\(index+1)").foregroundColor(.white)
            }
        }
    }
}
struct Photoindex_Previews: PreviewProvider {
    static var previews: some View {
        Photoindex(postdata:Sheetdbget(imageURL: [""], text: "", group: "", read: "", date: "", upload: "", uploadimage: "", uploadlogin: "", locationname: ""), currentindex: .constant(0))
    }
}
