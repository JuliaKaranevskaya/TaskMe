//
//  TaskModel.swift
//  TaskMe
//
//  Created by Юлия Караневская on 7.08.21.
//

import Foundation
import RealmSwift

class TaskModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var creationDate: Date?
    //reverse relationship
    var parentSection = LinkingObjects(fromType: SectionModel.self, property: "tasks")
}
