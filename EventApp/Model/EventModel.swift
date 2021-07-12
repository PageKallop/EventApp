//
//  EventModel.swift
//  EventApp
//
//  Created by Page Kallop on 6/24/21.
//

import Foundation

class EventModel {
    
    let title: String
    let subtitle: String
    let imageURL: URL?
    let imageData: Data? = nil
    
    
    init (
         title: String,
         subtitle: String,
         imageURL: URL?
    
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
     
    }
}
