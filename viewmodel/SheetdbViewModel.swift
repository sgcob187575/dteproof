//
//  SheetdbViewModel.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/1.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import Combine
class SheetdbViewModel: ObservableObject {
    @Published var data = [Sheetdbget]()
    @Published var appeardata = [Sheetdbget]()
    var cancellable: AnyCancellable?
    func fetchdata(sql:String,login:String) {
        
       
        
        cancellable = DataManager.shared.getSheetdbPublisher(sql:sql,login: login).sink(receiveCompletion: { (completion) in
                if case .failure = completion {
                    print("errorfetch")
                }
            }) {[weak self] (value) in
                guard let self = self else { return }
                self.data = value
                self.appeardata=value
        }
        
    }
    func searchdatawithdate(_ date:Date){
        self.appeardata=data.filter({ (sheetdb) in
            sheetdb.date.contains(date.date2String(dateFormat: "yyyy-MM"))
        })
    }
    func searchdatawithtext(_ text:String){
        self.appeardata=data.filter({ (sheetdb) in
            sheetdb.text.contains(text)
        })
    }
    func cancelsearch(){
        print("cancel")
        self.appeardata=self.data.filter({ (sheetdbget)  in
            true
        })
    }

}
class SheetdbwallViewModel: ObservableObject {
    @Published var data = [Sheetdbget]()
    var cancellable: AnyCancellable?
    
    func fetchdata(sql:String,login:String) {
        
       
        
        cancellable = DataManager.shared.getSheetdbPublisher(sql:sql,login: login).sink(receiveCompletion: { (completion) in
                if case .failure = completion {
                    print("errorfetch")
                }
            }) {[weak self] (value) in
                guard let self = self else { return }
                self.data = value
        }
        
    }
}
