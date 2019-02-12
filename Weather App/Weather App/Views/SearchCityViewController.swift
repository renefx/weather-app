//
//  SearchCityViewController.swift
//  Weather App
//
//  Created by Renê Xavier on 12/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class SearchCityViewController: UIViewController {

    @IBOutlet weak var searchCityField: UITextField!
    @IBOutlet weak var feedbackField: UILabel!
    @IBOutlet weak var gpsDataSwitch: UISwitch!
    
    let controller = SearchCityPresenter()
    weak var delegate: DefaultCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gpsDataSwitch.isOn = controller.userSwitchEnableGps
        controller.delegate = self
        controller.delegateDefaultCity = self
        searchCityField.delegate = self
        searchCityField.becomeFirstResponder()
    }

    @IBAction func sendSearch() {
        controller.notifyCityChange(continueUsingGPS: gpsDataSwitch.isOn)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        searchCityField.resignFirstResponder()
    }
    
    @IBAction func closeViewController() {
        searchCityField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchCityViewController: SearchCityPresenterDelegate{
    func cityFound(_ feedback: String?) {
        self.feedbackField.text = feedback
    }
    
    func dismissWithoutChangingCity(){
        closeViewController()
    }
}

extension SearchCityViewController: DefaultCityDelegate{
    func defaultCityChanged(_ coodinate: Coordinate) {
        delegate?.defaultCityChanged(coodinate)
        closeViewController()
    }
}

extension SearchCityViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            controller.locationForName(updatedText)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendSearch()
        return false
    }
}
