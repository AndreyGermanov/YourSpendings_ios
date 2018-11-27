//
//  ICollection.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation
protocol ICollection {
    func getCollectionName() -> String
    func addModel(_ model:IModel)
    func removeModel(_ model:IModel)
    func removeModel(_ id:String)
    func newModel(_ id:String?) -> IModel
    func clear()
    func getName() -> String
    func getModels(_ filter:[String:Any]?) -> [String:IModel]?
}
