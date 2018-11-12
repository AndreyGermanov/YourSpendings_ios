//
//  Model.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation

class Model: IModel {
    
    func newModel(_ id:String?=nil) -> IModel {
        return id == nil ? Model() : Model(id!)
    }
    
    var fields = [String:Any?]()
    
    convenience init() {
        self.init(NSUUID().uuidString)
    }
    
    init(_ id:String) {
        fields["id"] = id;
    }
    
    subscript(index:String) -> Any? {
        get {
            guard let result = fields[index] else {
                return nil
            }
            return result
        }
        set(newValue) {
            fields[index] = newValue
        }
    }
    
    func getId() -> String {
        return fields["id"] as! String
    }
    
    func getFields() -> [String:Any?] {
        return fields;
    }
    
    func setFields(_ data:[String:Any]) {
        for key in data.keys {
            fields[key] = data[key]
        }
    }
    
    func getCollection() -> String {
        return ""
    }
    
    func getStringValue(_ fieldName:String) -> String? {
        guard let value = fields[fieldName] as? String else {
            return nil
        }
        return value
    }
    
    func getDoubleValue(_ fieldName:String) -> Double? {
        guard let value = fields[fieldName] as? Double else {
            return nil
        }
        return value
    }
}
