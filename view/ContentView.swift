//
//  ContentView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/3/4.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import FacebookLogin
import KingfisherSwiftUI
import Alamofire
func getImage() {
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID f79138fb7a32d37",
        ]
    AF.request("https://api.imgur.com/3/album/B52Qztm/image/DBp7rO5", method: .get,headers: headers).responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { (response) in
        switch response.result {
        case .success(let result):
            print(result.data.link)
        case .failure(let error):
            print(error)
        }
    }
    }
        




struct ContentView: View {
    @EnvironmentObject var userdata:Userdata
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View{
        TabView{
            HomeView().environmentObject(userdata).tabItem {
                VStack{
                    Image(systemName: "house")
                    Text("Home")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
