//
//  Food.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 7/6/22.
//

import Foundation

public struct Food : Identifiable, Hashable, Codable {
    public var id : Int
    var name : String
    var values : [String : Float]
}
