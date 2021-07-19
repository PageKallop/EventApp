//
//  EventSaved.swift
//  EventApp
//
//  Created by Page Kallop on 6/29/21.
//

import Foundation


struct EventSaved: Equatable {

    static func ==(lhs: EventSaved, rhs: EventSaved) -> Bool {
        return lhs.title == rhs.title 
    }
    
    let title: String
    let subtitle: String

}
