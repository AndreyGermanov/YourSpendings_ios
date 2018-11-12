//
//  ShopsCollectionTests.swift
//  YourSpendingsTests
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import XCTest
import FirebaseCore
@testable import YourSpendings

class ShopsCollectionTests: XCTestCase {
    
    func testShopsCollectionNewModel() {
        let shops = ShopsCollection.getInstance(Shop())
        let shop1 = shops.newModel("12345")
        print("Collection name: \(shop1.getCollection())")
    }
    
    func testShopsCollectionLoadModels() {
        let db = DatabaseManager.getAdapter()
        let shops = ShopsCollection.getInstance(Shop())
        db.loadCollection(collection: shops) {
            let models = shops.getModels()
            for item in models {
                guard let model = item.value as? Shop else {
                    continue
                }
                print("Model id: \(model.getId()), name:\(model["name"]),collection:\(model.getCollection())")
            }
        }
        Thread.sleep(forTimeInterval: 50)
        
    }
}
