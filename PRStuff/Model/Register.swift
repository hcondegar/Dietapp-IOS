//
//  Register.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 24/5/22.
//

import Foundation

struct Register: Hashable, Codable, Identifiable{
    var id: Int
    var date: Int
    var consumed: Int
    var item: String
}
