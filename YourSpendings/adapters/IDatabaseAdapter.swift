//
//  IDatabaseAdapter.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation

protocol IDatabaseAdapter {
    func persistModel(model:IModel,callback: @escaping (Error?) -> Void)
    //func loadModel(id:String)
    func loadCollection(collection: ICollection, callback: @escaping () -> Void)
}
