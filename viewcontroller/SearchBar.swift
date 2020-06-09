//
//  SearchBar.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/6/3.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    @Binding var searchoffset:CGFloat
    func makeUIView(context: Context) -> UISearchBar {
        
        let searchBar = UISearchBar()
        
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Search..."
        searchBar.delegate = context.coordinator
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text,$searchoffset)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var searchoffset:CGFloat


        init(_ text: Binding<String>,_ searchoffset:Binding<CGFloat>) {
            self._text = text
            self._searchoffset=searchoffset
        }
        

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            searchBar.showsCancelButton = true
            text = searchText

            print("textDidChange: \(text)")
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            searchoffset = 0
            print("tapcancel")
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
        
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            searchoffset = -300
            searchBar.showsCancelButton = true

            return true
        }
    }
}



