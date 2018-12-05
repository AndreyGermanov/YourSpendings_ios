//
//  MapUtils.swift
//  YourSpendings
//
//  Created by user on 04.12.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation
import CoreLocation

func rad2deg(_ rad: Double) -> Double {
    return rad * 180 / Double.pi
}

func deg2rad(_ deg: Double) -> Double {
    return deg * Double.pi / 180
}

func getCenter(_ coordinates:[CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
    var sumX = 0.0,sumY = 0.0,sumZ = 0.0,lat = 0.0,lng = 0.0
    if coordinates.count == 0 { return CLLocationCoordinate2D(latitude:lat,longitude:lng)}
    for coordinate in coordinates {
        lng = deg2rad(coordinate.longitude)
        lat = deg2rad(coordinate.latitude)
        sumX += cos(lat) * cos(lng)
        sumY += cos(lat) * sin(lng)
        sumZ += sin(lat)
    }
    let avgX  = sumX / Double(coordinates.count)
    let avgY = sumY / Double(coordinates.count)
    let avgZ = sumZ / Double(coordinates.count)
    
    lng = atan2(avgY,avgX)
    let hyp = sqrt(avgX*avgX+avgY*avgY)
    lat = atan2(avgZ,hyp)
    return CLLocationCoordinate2D(latitude:rad2deg(lat),longitude:rad2deg(lng))
}
