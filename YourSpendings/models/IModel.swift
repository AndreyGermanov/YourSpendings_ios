//
//  IModel.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation
protocol IModel {
    func getId() -> String
    func getFields() -> [String:Any?]
    func setFields(_ data:[String:Any])
    func getCollection() -> String
    func newModel(_ id:String?) -> IModel
}
