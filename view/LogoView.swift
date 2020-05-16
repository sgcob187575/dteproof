//
//  LogoView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/16.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct LogoView: View {
    var x:CGFloat
    var y:CGFloat
    var body: some View {
        ZStack{
            Image("logo").resizable().scaledToFit().frame(height:100).transformEffect(.init(scaleX: -1, y: 1)).blur(radius: 2).shadow(radius: 7).rotationEffect(Angle.init(degrees: 180)).offset(x:x,y:y).opacity(0.5)
            Image("logo").resizable().scaledToFit().frame(height:100).shadow(radius: 7)

        }
    }
}
