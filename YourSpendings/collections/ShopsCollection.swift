//
//  ShopsCollection.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation

class ShopsCollection : Collection {
    
    public override class func getInstance(_ model:IModel) -> ShopsCollection {
        guard let i = instance as? ShopsCollection else  {
            instance = ShopsCollection(model)
            return instance as! ShopsCollection
        }
        return i
    }
    
    
    
}
