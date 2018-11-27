//
//  Collection.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import Foundation

class Collection: ICollection {
    
    private var model: IModel
    static var instance: ICollection? = nil
    
    init(_ model:IModel) {
        self.model = model
    }
    
    public class func getInstance(_ model:IModel) -> Collection {
        guard let i = instance as? Collection else  {
            instance = Collection(model)
            return instance as! Collection
        }
        return i
    }
 
    var models = [String:IModel]()
    
    func getCollectionName() -> String {
        return ""
    }
    
    func addModel(_ model: IModel) {
        models[model.getId()] =  model
    }
    
    func removeModel(_ id: String) {
        guard models.index(forKey: id) != nil else {
            return
        }
        models.remove(at:models.index(forKey:id)!)
    }
    
    func removeModel(_ model:IModel) {
        removeModel(model.getId())
    }
    
    func clear() {
        models.removeAll()
    }
    
    func newModel(_ id:String?) -> IModel {
        return model.newModel(id)
    }
    
    func getName() -> String {
        return model.getCollection()
    }
    
    func getModels(_ filter:[String:Any]?=nil) -> [String:IModel]? {
        return filter == nil ? models : models.filter { key,model in
            guard let filter_fields = filter else { return true }
            for (field) in filter_fields {
                let model_fields = model.getFields()
                guard let model_field_value = model_fields[field.key] else {return false}
                if model_field_value != field.value as! _OptionalNilComparisonType { return false }
            }
            return true
        }
    }

}
