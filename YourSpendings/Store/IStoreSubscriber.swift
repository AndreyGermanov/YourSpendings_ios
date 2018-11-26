//
//  IStoreSubscriber.swift
//  YourSpendings
//
//  Created by user on 26.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

protocol IStoreSubscriber: AnyObject {
    func onStateChange(_ prevState:AppState)
}
