//
//  DataStructure.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/4/1.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
struct Log:Encodable {
    var username:String
    var password:String
}
struct Person: Codable ,Identifiable{
    var id:String
    var name:String
    var email:String
    var imageURL:String
    var gender:String
}
struct OktaProfile:Codable {
    var login:String
}
struct User:Codable {
    var id:String
    var profile:OktaProfile
}
struct Embedded:Codable {
    var user:User
}
struct Authjason:Codable{
    var status:String
    var sessionToken:String
    var _embedded:Embedded
}
