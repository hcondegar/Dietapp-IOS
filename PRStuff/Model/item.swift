//
//  item.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 24/5/22.
//

import Foundation
import SwiftUI

struct Item: Hashable, Codable, Identifiable{
    var id: Int
    var name: String
    var recomendedAmmount: Int
    
}
