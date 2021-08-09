//
//  SectionModel.swift
//  TaskMe
//
//  Created by Юлия Караневская on 7.08.21.
//

import Foundation
import RealmSwift

class SectionModel: Object {
    
    @objc dynamic var name: String = ""
    //forward relationship
    var tasks = List<TaskModel>()
}
