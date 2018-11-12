//
//  DatabaseManager.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation

class DatabaseManager {
    static func getAdapter() -> IDatabaseAdapter {
        return FirebaseDatabaseAdapter()
    }
}
