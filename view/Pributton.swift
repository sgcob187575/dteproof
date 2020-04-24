//
//  Pributton.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/19.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI

struct Pributton: View {
    var body: some View {
        var size:CGFloat=32
        var buttonMask: some View {
          // 2
          ZStack {
            // 3
            Rectangle()
              .foregroundColor(.white)
              .frame(width: size * 2, height: size * 2)
            // 4
            Image(systemName: "arrowshape.turn.up.left.fill")
              .resizable()
              .scaledToFit()
              .frame(width: size, height: size)
          }
        }
        var button: some View {
          // 2
          ZStack {
            LinearGradient.lairHorizontalDarkReverse
            .frame(width: size, height: size)
            // 3
            Rectangle()
              .inverseMask(buttonMask)
              .frame(width: size * 2, height: size * 2)
              .foregroundColor(.lairBackgroundPink)
                .shadow(color: .lairShadowGray, radius: 3, x: 3, y: 3)
            .shadow(color: .white, radius: 3, x: -3, y: -3)
            .clipShape(RoundedRectangle(cornerRadius: size * 8 / 16))
            }
            .shadow(
              color: Color.white.opacity(0.9),
              radius: 10,
              x: -5,
              y: -5)
            .shadow(
              color: Color.lairShadowGray.opacity(0.5),
              radius: 10,
              x: 5,
              y: 5)
          }

        // 4
        return button
            }
}

struct Pributton_Previews: PreviewProvider {
    static var previews: some View {
        Pributton()
    }
}
