//
//  ViewController.swift
//  YourSpendings
//
//  Created by user on 12.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class SelectPlaceViewController: UIViewController,IStoreSubscriber {
    
    @IBOutlet weak var placesTable: UITableView!
    let shops = ShopsCollection.getInstance(Shop())
    
    @IBAction func onAddPlaceClick(_ sender: UIBarButtonItem) {
        Store.currentShopLatitude = ""
        Store.currentShopName = ""
        Store.currentShopLongitude = ""
        performSegue(withIdentifier: "editPlaceSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesTable.dataSource = self
        placesTable.delegate = self
        Store.subscribe(self)
        DatabaseManager.getAdapter().loadCollection(collection: ShopsCollection.getInstance(Shop())) {
            self.placesTable.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placesTable.reloadData()
    }
    
    func onStateChange(_ prevState: AppState) {
        placesTable.reloadData()
    }
}

extension SelectPlaceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShopsCollection.getInstance(Shop()).count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        guard let shop = shops.getModelAtIndex(indexPath.row) as? Shop else {
            return cell
        }
        cell.textLabel?.text = shop.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let shop = shops.getModelAtIndex(indexPath.row) as? Shop else { return }
        Store.currentShopId = shop.getId()
        Store.currentShopName = shop.name!
        if let latitude = shop.latitude {
            Store.currentShopLatitude = String(describing: latitude)
        } else {
            Store.currentShopLatitude = ""
        }
        if let longitude = shop.longitude {
            Store.currentShopLongitude = String(describing:longitude)
        } else {
            Store.currentShopLongitude = ""
        }
        performSegue(withIdentifier:"editPlaceSegue",sender:self)
    }
}
