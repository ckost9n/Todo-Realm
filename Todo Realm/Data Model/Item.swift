//
//  Item.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var dateCreated: Date
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
