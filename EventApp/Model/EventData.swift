//
//  EventData.swift
//  EventApp
//
//  Created by Page Kallop on 6/24/21.
//

import Foundation

struct EventData: Codable{
    
    let performers : [Performers]
}

struct Performers: Codable {
    
    let type : String
    let name : String
    let image : String
    let url : String 
}
