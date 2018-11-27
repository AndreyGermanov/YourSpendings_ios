//
//  NewPlaceViewController.swift
//  YourSpendings
//
//  Created by user on 13.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit
import CoreLocation

class NewPlaceViewController: BaseController, IStoreSubscriber {

    let locationManager = CLLocationManager()
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    let detectButton: UIButton = UIButton(type: UIButtonType.custom)
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap)))
        Store.subscribe(self)
        setupForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillFormFromState()
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
    }
    
    func fillFormFromState() {
        nameField.text = Store.currentShopName
        latitudeField.text = Store.currentShopLatitude
        longitudeField.text = Store.currentShopLongitude
    }
    
    func onStateChange(_ prevState: AppState) {
        fillFormFromState()
    }
    
    @IBAction func onDoneClick(_ sender: Any) {
        var error = Shop.validateName(Store.currentShopName, id: nil)
        if error != nil { showAlert("Name",message:error!); return }
        error = Shop.validateLatitude(Store.currentShopLatitude)
        if error != nil { showAlert("Latitude",message:error!); return }
        error = Shop.validateLongitude(Store.currentShopLongitude)
        if error != nil { showAlert("Longitude",message:error!); return }
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
