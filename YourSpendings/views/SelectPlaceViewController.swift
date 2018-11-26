//
//  ViewController.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class SelectPlaceViewController: UIViewController {

    @IBAction func onAddPlaceClick(_ sender: UIBarButtonItem) {
        Store.currentShopLatitude = ""
        Store.currentShopName = ""
        Store.currentShopLongitude = ""
        performSegue(withIdentifier: "editPlaceSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
