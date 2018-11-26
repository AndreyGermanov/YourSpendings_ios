//
//  NewPlaceViewController.swift
//  YourSpendings
//
//  Created by user on 13.11.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class NewPlaceViewController: UIViewController, IStoreSubscriber {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    let detectButton: UIButton = UIButton(type: UIButtonType.custom)
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let activeField = activeField else {
            return
        }
        switch (activeField) {
        case latitudeField:
            activeField.text = "14.3"
        case longitudeField:
            activeField.text = "5.3"
        default: break
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
