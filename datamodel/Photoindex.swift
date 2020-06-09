//
//  Photoindex.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/23.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct Photoindex: View {
    var total:Int
    let choose=Color.blue
    let notchoose=Color.gray
    var currentindex:Int
    var pridisplay:Int{
        if currentindex==0{
            return 0
        }
        else if currentindex==total-1{
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

    var body: some View {
        HStack{
            if pridisplay>=1{
                if pridisplay != 1 {
                smallcircle(color: self.notchoose,size: 15,index: "")
                }
                smallcircle(color: self.notchoose,size: 20,index: "")
            }
            ForEach(pridisplay..<lastdisplay+1){(index) in
                if index==self.currentindex{
                    smallcircle(color: self.choose,size: 30,index: "\(index+1)")
                }
                else{
                    smallcircle(color: self.notchoose,size: 30,index: "\(index+1)")

                }
            }
            if total-1-lastdisplay>=1{
                smallcircle(color: self.notchoose,size: 20,index: "")
                if total-1-lastdisplay != 1{
                smallcircle(color: self.notchoose,size: 15,index: "")
                }
            }
            Text("\(currentindex):")

        }
        
    }
}
struct smallcircle: View {
    var color:Color
    var size:CGFloat
    var index:String
    var body: some View {
        ZStack{
            Circle.init().foregroundColor(color).frame(width:size)
            Text(index).foregroundColor(.white)
        }
    }
}

struct Photoindex_Previews: PreviewProvider {
    static var previews: some View {
        Photoindex(total: 2, currentindex: 0)
    }
}
