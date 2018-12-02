//
//  Shop.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation
import CoreLocation

class Shop: Model {
    
    override func getFieldTypes() -> [String:Type] {
        return ["name":Type.STRING,"latitude":Type.DOUBLE,"longitude":Type.DOUBLE]
    }
    
    var name: String? {
        get { return getStringValue("name") }
        set { fields["name"] = newValue }
    }
    
    var latitude: Double? {
        get { return getDoubleValue("latitude") }
        set { fields["latitude"] = newValue }
    }
    
    var longitude: Double? {
        get { return getDoubleValue("longitude") }
        set { fields["longitude"] = newValue }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        get {
            if latitude != nil && longitude != nil {
                return CLLocationCoordinate2D(latitude:latitude!,longitude:longitude!)
            } else { return nil }
        }
        set {
            guard let coordinate = newValue else { return }
            fields["latitude"] = coordinate.latitude
            fields["longitude"] = coordinate.longitude
        }
    }
    
    override func getCollection() -> String {
        return "shops"
    }
    
    override func newModel(_ id:String?=nil) -> IModel {
        return id == nil ? Shop() : Shop(id!)
    }
    
    static func validateName(_ value:Any?,id: String?) -> String? {
        guard let name = Model.getStringFromAny(value) else { return "Name is required" }
        if name.isEmpty { return "Name is required" }
        let models = ShopsCollection.getInstance(Shop()).getModels(["name":name])
        guard var foundModels = models else { return nil }
        if id == nil && foundModels.count>0 { return "Place with specified name already exists" }
        foundModels = foundModels.filter { key, model in model.getId() != id }
        if foundModels.count > 0 { return "Place with specified name already exists"}
        return nil
    }
    
    static func validateLatitude(_ value: Any?) -> String? {
        if !validateCoordinate(value) { val in !val.isLess(than:0.0) && val<=90.0} {
            return "Incorrect value"
        }
        return nil
    }
    
    static func validateLongitude(_ value: Any?) -> String? {
        if !validateCoordinate(value) { val in !val.isLess(than:0.0) && val<=180.0} {
            return "Incorrect value"
        }
        return nil
    }
    
    static func validateCoordinate(_ value: Any?,condition: (_ val:Double) -> Bool) -> Bool {
        guard let result = getDoubleFromAny(value) else { return false }
        return condition(result)
    }

}
