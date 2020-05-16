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
    var cancellable: AnyCancellable?
    
    
    func fetchdata() {
        
       
        
        cancellable = DataManager.shared.getSheetdbPublisher(sql:"").sink(receiveCompletion: { (completion) in
                if case .failure = completion {
                    print("errorfetch")
                }
            }) {[weak self] (value) in
                guard let self = self else { return }
                self.data = value
        }
        
    }
}
