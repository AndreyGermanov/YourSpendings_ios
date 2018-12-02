//
//  Model.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation

class Model: IModel {

    var fields = [String:Any?]()
    
    func getFieldTypes() -> [String:Type] { return [String:Type]() }
    
    func newModel(_ id:String?=nil) -> IModel {
        return id == nil ? Model() : Model(id!)
    }
    
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
            setFieldValue(key,value:data[key])
        }
    }
    
    func setFieldValue(_ fieldName:String,value:Any?) {
        switch getFieldType(fieldName) {
        case .STRING: fields[fieldName] = Model.getStringFromAny(value)
        case .INT: fields[fieldName] = Model.getIntFromAny(value)
        case .DOUBLE: fields[fieldName] = Model.getDoubleFromAny(value)
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
    
    static func getStringFromAny(_ value:Any?) -> String? {
        guard let value = value as? String else { return nil }
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func getIntFromAny(_ value:Any?) -> Int? {
        if value == nil { return nil }
        if value is Int { return value as? Int}
        let strValue = getStringFromAny(value)
        if strValue == nil {return nil}
        return Int.init(strValue!)
    }
    
    static func getDoubleFromAny(_ value:Any?) -> Double? {
        if value == nil { return nil }
        if value is Double? { return value as? Double}
        let strValue = getStringFromAny(value)
        if strValue == nil {return nil}
        let dblValue =  Double.init(strValue!)
        if dblValue != nil { return dblValue!}
        let intValue = getIntFromAny(value)
        if intValue == nil { return nil }
        return Double.init(intValue!)
    }
    
    func getFieldType(_ fieldName:String) -> Type {
        let types = getFieldTypes()
        guard let result = types[fieldName] else { return Type.STRING }
        return result
    }
    
    func isEqual(_ fieldName:String,value:Any?) -> Bool {
        let fieldValue = fields[fieldName]
        if fieldValue == nil {
            if value == nil { return true }
            return false
        }
        guard let value = value else { return false }
        switch getFieldType(fieldName) {
        case .STRING: return isEqualStrings(fieldValue!!,value:value)
        case .INT: return isEqualInts(fieldValue!!,value:value)
        case .DOUBLE: return isEqualDoubles(fieldValue!!,value:value)
        }
    }
    
    func isEqualStrings(_ fieldValue: Any, value:Any) -> Bool {
        guard let fieldValue = fieldValue as? String else { return false }
        guard let value = value as? String else { return false }
        return fieldValue == value
    }
    
    func isEqualInts(_ fieldValue: Any, value:Any) -> Bool {
        guard let fieldValue = fieldValue as? Int else { return false }
        guard let value = value as? Int else { return false }
        return fieldValue == value
    }
    
    func isEqualDoubles(_ fieldValue: Any, value:Any) -> Bool {
        guard let fieldValue = fieldValue as? Double else { return false }
        guard let value = value as? Double else { return false }
        return fieldValue == value
    }
}
