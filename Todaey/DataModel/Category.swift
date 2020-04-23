//
//  Category.swift
//  Todaey
//
//  Created by Swapnil Nandy on 23/4/20.
//  Copyright © 2020 Swapnil Nandy. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
