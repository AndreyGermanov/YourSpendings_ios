//
//  Store.swift
//  YourSpendings
//
//  Created by user on 26.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

class Store {
    static var appState: AppState = AppState()
    static var subscribers = [IStoreSubscriber]()
    
    static func subscribe(_ subscriber: IStoreSubscriber) {
        if !subscribers.contains(where: { sub in subscriber === sub }) {
            subscribers.append(subscriber)
        }
    }
    
    static func unsubscribe(_ subscriber: IStoreSubscriber) {
        let index = subscribers.index(where: {sub in subscriber === sub})
        guard let foundIndex = index else {
            return
        }
        subscribers.remove(at: foundIndex)
    }
    
    static func notify(_ prevState: AppState) {
        for subscriber in subscribers {
            subscriber.onStateChange(prevState)
        }
    }
    
    static var currentShopId: String {
        get {return appState.currentShopId}
        set {
            let prevState = appState
            appState.currentShopId = newValue
            notify(prevState)
        }
    }
    
    static var currentShopName : String {
        get {return appState.currentShopName}
        set {
            let prevState = appState
            appState.currentShopName = newValue
            notify(prevState)
        }
    }
    
    static var currentShopLatitude: String {
        get { return appState.currentShopLatitude }
        set {
            let prevState = appState
            appState.currentShopLatitude = newValue
            notify(prevState)
        }
    }
    
    static var currentShopLongitude: String {
        get { return appState.currentShopLongitude }
        set {
            let prevState = appState
            appState.currentShopLongitude = newValue
            notify(prevState)
        }
    }
    
}
