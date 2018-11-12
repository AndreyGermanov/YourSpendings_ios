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
    
}
