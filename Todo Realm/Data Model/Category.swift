//
//  Category.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var hexColor: String = ""
    @Persisted var items = List<Item>()
}
