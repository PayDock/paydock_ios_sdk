//
//  CardFormViewController.swift
//  
//
//  Created by Oleksandr Omelchenko on 13.10.17.
//  Copyright © 2017 Oleksandr Omelchenko. All rights reserved.
//

import UIKit
// XCTest
@testable import PayDock
class CardFormViewController: UIViewController {
    

    
    

    let archiveChargeId: String = "58fdc65674bff715308237be"
    let gatewayId: String = "58fdaffc74bff7153082359d"
    let customerId: String = "58fde04c74bff71530823818"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        /* let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
         let storyboard = UIStoryboard(name: "cardForm", bundle: frameworkBundle)
         let controller = storyboard.instantiateViewController(withIdentifier: "CardFormViewController") as UIViewController
         
         self.present(controller, animated: true, completion: nil)
         */
        //Demo-app-swift
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cardSubmitPressed(_ sender: Any) {
        
        var valid = true
        if (carNumberField.text == "")
        {
            valid = false
            lblVNo.text="card no is required";
        }
        if (CardHolderNameField.text == "")
        {
            valid = false
            lblVValue.text="card value is required";
        }
        
        if (ccvField.text == "")
        {
            valid = false
            lblVccv.text="ccvField no is required";
        }
        if (expirationDateField.text == "")
        {
            valid = false
            lblVdate.text="expiration Date Field value is required";
        }
        
        
        if(valid ){
            var date = expirationDateField.text!
            var dateArr = date.characters.split{$0 == "/"}.map(String.init)
            var month: String = dateArr[0]
            var year: String? = dateArr.count > 1 ? dateArr[1] : nil
            
            PayDock.setSecretKey(key: "")
            PayDock.setPublicKey(key: "1b0496942b784d96b660d01542aa0ceba45dd9e9")
            PayDock.shared.isSandbox = true
            
            let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
            var card = Card(gatewayId: gatewayId, name: CardHolderNameField.text!, number: carNumberField.text!, expireMonth: Int(month)!, expireYear: Int(year!)!, ccv: ccvField.text, address: address)
            let paymentSource = PaymentSource.card(value: card)
            let customerRequest = CustomerRequest(firstName: "Test_first_name", lastName: "Test_last_name", email: "Test@test.com", reference: "customer Refrence", phone: nil, paymentSource: paymentSource)
            let chargeRequest = ChargeRequest(amount: 10, currency: "AUD", reference: "some charge reference", description: "some charge description", customer: customerRequest)
            // let expect = expectation(description: "PayDockSDK.ChargeTest")
            
            PayDock.shared.add(charge: chargeRequest, completion: { (charge) in
                //defer { expect.fulfill() }
                do {
                    let charge = try charge()
                    debugPrint(charge)
                } catch let error {
                    debugPrint(error)
                    self.lblerr.text = error.localizedDescription
                    //XCTFail(error.localizedDescription)
                    
                }
            })
            //self.wai.waitForExpectations(timeout: 1000, handler: nil)
        }
    }
    
}

