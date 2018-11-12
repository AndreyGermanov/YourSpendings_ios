//
//  ShopTests.swift
//  YourSpendingsTests
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import XCTest
import FirebaseCore
@testable import YourSpendings

class ShopTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetShopToDB() {
        let db = DatabaseManager.getAdapter()
        let shop1 = Shop()
        shop1["name"] = "Magnit"
        db.persistModel(model:shop1) { err in
            shop1["name"] = "Magnit3"
            Thread.sleep(forTimeInterval:10)
            db.persistModel(model:shop1) {err in
               
            }
        }
        Thread.sleep(forTimeInterval:30)
    }
    

    
}
