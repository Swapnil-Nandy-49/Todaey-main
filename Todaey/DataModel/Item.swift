//
//  Item.swift
//  Todaey
//
//  Created by Swapnil Nandy on 23/4/20.
//  Copyright © 2020 Swapnil Nandy. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date? 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
