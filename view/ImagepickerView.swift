//
//  ImagepickerView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/19.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct ImagepickerView: View {
    @Binding var selectImage:UIImage?
    var size:CGFloat=32
    @Binding var showSelectPhoto:Bool
    var buttonMask: some View {
        // 2
        ZStack {
            // 3
            Rectangle()
                .foregroundColor(.white)
                .frame(width: size * 2, height: size * 2)
            // 4
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                ZStack {
               
                    Rectangle()
                    .frame(width: size * 7, height: size * 2)
                    .foregroundColor(.lairBackgroundPink)
                    .shadow(color: .lairShadowGray, radius: 3, x: 3, y: 3)
                    .shadow(color: .white, radius: 3, x: -3, y: -3)
                    .clipShape(RoundedRectangle(cornerRadius: size * 8 / 16))
                    Text("選擇大頭貼").foregroundColor(.black).font(.custom("SentyGoldenBell", size: 30))

                }.shadow(
                color: Color.white.opacity(0.9),
                radius: 10,
                x: -5,
                y: -5)
                .shadow(
                    color: Color.lairShadowGray.opacity(0.5),
                    radius: 10,
                    x: 5,
                    y: 5)
            
                    .onTapGesture {
                        self.showSelectPhoto = true
                        
                }
            }
            
            ZStack{
                if selectImage != nil {
                    Image(uiImage: selectImage!).renderingMode(.original).resizable().scaledToFit().frame(width:400).cornerRadius(30)
                    
                }
                else {
                    Image(systemName: "photo").renderingMode(.original).resizable().scaledToFit().frame(width:400).hidden()
                    
                }
            }
        }
        
        
    }
}


struct ImagepickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagepickerView(selectImage: .constant(.none), showSelectPhoto: .constant(false))
    }
}
