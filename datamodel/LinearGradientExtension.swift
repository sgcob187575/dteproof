/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

extension LinearGradient {
  public static var lairDiagonalDarkBorder: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.white, .lairGray]),
      startPoint: UnitPoint(x: -0.2, y: 0.5),
      endPoint: .bottomTrailing
    )
  }
  
  public static var lairDiagonalLightBorder: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.white, .lairLightGray]),
      startPoint: UnitPoint(x: 0.2, y: 0.2),
      endPoint: .bottomTrailing
    )
  }
  
  public static var lairHorizontalDark: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.lairShadowGray, .lairDarkGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }
  
  public static var lairHorizontalDarkReverse: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.lairDarkGray, .lairShadowGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }
  
  public static var lairHorizontalDarkToLight: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [
        .lairShadowGray,
        Color.white.opacity(0.0),
        .white]),
      startPoint: .top,
      endPoint: .bottom
    )
  }
  
  public static var lairVerticalLightToDark: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [
        .white,
        Color.white.opacity(0.0),
        .lairShadowGray]),
      startPoint: .top,
      endPoint: .bottom
    )
  }
  
  public static var lairHorizontalLight: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.lairWhite, .lairBackgroundGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }
}
