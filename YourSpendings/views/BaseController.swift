//
//  BaseController.swift
//  YourSpendings
//
//  Created by user on 27.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    func showAlert(_ title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert,animated:true,completion: nil)
    }

}
