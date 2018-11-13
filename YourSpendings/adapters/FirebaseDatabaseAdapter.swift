//
//  FirebaseDatabaseAdapter.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseDatabaseAdapter: IDatabaseAdapter {

    
    let db = Firestore.firestore()

    func persistModel(model: IModel, callback: @escaping (Error?) -> Void) {
        let id = model.getId()
        var fields = model.getFields()
        fields.remove(at:fields.index(forKey: "id")!)
        db.collection(model.getCollection()).document(id).setData(fields) { err in
            callback(err)
        }
    }
    
    func loadCollection(collection: ICollection, callback: @escaping () -> Void) {
        db.collection(collection.getName()).getDocuments { (snapshot, err) in
            if (err != nil) {
                print("Could not load collection. Error: \(String(describing: err))")
                return
            }
            guard let snapshot = snapshot else {
                print("Could not load collection")
                return
            }
            for doc in snapshot.documents {
                let model = collection.newModel(doc.documentID)
                model.setFields(doc.data())
                collection.addModel(model)
            }
            callback()
        }
    }
    
}
