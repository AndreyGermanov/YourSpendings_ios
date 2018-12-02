//
//  NewPlaceViewController.swift
//  YourSpendings
//
//  Created by user on 13.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewPlaceViewController: BaseController {

    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    let detectButton: UIButton = UIButton(type: UIButtonType.custom)
    var activeField: UITextField?
    let shops = ShopsCollection.getInstance(Shop())
    var placeMarker = MKPlacemark()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap)))
        setupForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillFormFromState()
        updateMap()
    }
    
    func setupForm() {
        nameField.delegate = self
        latitudeField.delegate = self
        longitudeField.delegate = self
        var detectButtonFrame = detectButton.frame;
        let height = latitudeField.frame.size.height-6;
        detectButtonFrame.size = CGSize(width: height, height: height)
        detectButton.frame = detectButtonFrame
        detectButton.setImage(UIImage(named: "detect.png"), for: .normal)
        detectButton.addTarget(self, action: #selector(handleCoordinateButtonClick), for: .touchUpInside)
        longitudeField.addTarget(self,action:#selector(textDidChange),for:.editingChanged)
        latitudeField.addTarget(self,action:#selector(textDidChange),for:.editingChanged)
    }
    
    func fillFormFromState() {
        nameField.text = Store.currentShopName
        latitudeField.text = Store.currentShopLatitude
        longitudeField.text = Store.currentShopLongitude
    }
    
    func updateMap() {
        map.removeAnnotations(map.annotations)
        let lat = Shop.getDoubleFromAny(Store.currentShopLatitude)!
        let lon = Shop.getDoubleFromAny(Store.currentShopLongitude)!
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center:center,span:MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        map.setRegion(region,animated:true)
        //placeMarker = MKPlacemark(coordinate: center)
        map.addAnnotation(MKPlacemark(coordinate:center))
    }
    
    @IBAction func onDoneClick(_ sender: UIBarButtonItem) {
        if !validateForm() { return }
        var shop = Shop()
        if !Store.currentShopId.isEmpty {
            let model = shops.getModelById(Store.currentShopId) as? Shop
            if model == nil { return} else { shop = model! }
        }
        sender.isEnabled = false
        shop.setFields(["name": Store.currentShopName,
                        "latitude":Store.currentShopLatitude,
                        "longitude":Store.currentShopLongitude]
        )
        DatabaseManager.getAdapter().persistModel(model: shop) { err in
            ShopsCollection.getInstance(shop).addModel(shop)
            sender.isEnabled = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func validateForm() -> Bool {
        updateState()
        var error = Shop.validateName(Store.currentShopName, id: nil)
        if error != nil { showAlert("Name",message:error!); return false }
        error = Shop.validateLatitude(Store.currentShopLatitude)
        if error != nil { showAlert("Latitude",message:error!); return false }
        error = Shop.validateLongitude(Store.currentShopLongitude)
        if error != nil { showAlert("Longitude",message:error!); return false }
        return true
    }
    
    func updateState() {
        Store.currentShopName = nameField.text!
        Store.currentShopLongitude = longitudeField.text!
        Store.currentShopLatitude = latitudeField.text!
    }
}

extension NewPlaceViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        if textField === latitudeField || textField === longitudeField {
            textField.rightView = detectButton
            textField.rightViewMode = .always
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === latitudeField || textField == longitudeField {
            textField.rightView = nil
            if textField === latitudeField {
                Store.currentShopLatitude = textField.text!
            }
            if textField === longitudeField {
                Store.currentShopLongitude = textField.text!
            }
        }
        if textField === nameField {
            Store.currentShopName = textField.text!
        }
        activeField = nil
    }
    
    @objc func textDidChange(textField:UITextField) {
        updateState()
        if Shop.validateLatitude(Store.currentShopLatitude) != nil || Shop.validateLongitude(Store.currentShopLongitude) != nil {return}
        updateMap()
    }
}

extension NewPlaceViewController {
    @objc
    func handleCoordinateButtonClick() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return
        case .restricted, .denied:
            return
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100.0
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }
    @objc func onViewTap() {
        guard let activeField = activeField else {
            return
        }
        activeField.endEditing(true)
        activeField.resignFirstResponder()
    }
}

extension NewPlaceViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        guard let activeField = activeField else {
            return
        }
        if activeField === latitudeField {
            latitudeField.text = lastLocation.coordinate.latitude.description
        }
        if activeField === longitudeField {
            longitudeField.text = lastLocation.coordinate.longitude.description
        }
        updateState()
        updateMap()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension NSRange {
    func toTextRange(_ textInput:UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
}
