//
//  ViewController.swift
//  Demo_app_swift
//
//  Created by Oleksandr Omelchenko on 18.10.17.
//  Copyright © 2017 Oleksandr Omelchenko. All rights reserved.
//

import UIKit
@testable import PayDock
class ViewController: UIViewController {

    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardHolderNameField: UITextField!
    @IBOutlet weak var expirationDateField: UITextField!
    @IBOutlet weak var ccvField: UITextField!
    @IBOutlet weak var lblVCardH: UILabel!
    @IBOutlet weak var lblVNo: UILabel!
    @IBOutlet weak var lblVdate: UILabel!
    @IBOutlet weak var lblVccv: UILabel!
    @IBOutlet weak var lblerr: UILabel!

    
   
    let gatewayId: String = "5620de31361b787230cb7d74"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
//        let storyboard = UIStoryboard(name: "cardForm", bundle: frameworkBundle)
//        let controller = storyboard.instantiateViewController(withIdentifier: "TestVC") as UIViewController
//
//        self.present(controller, animated: true, completion: nil)
 
        //Demo-app-swift
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func cardSubmitPressed(_ sender: Any) {
        
        var valid = true
        if (cardNumberField.text == "")
        {
            valid = false
            lblVNo.text="card no is required";
        }
        if (cardHolderNameField.text == "")
        {
            valid = false
            lblVCardH.text="Name is required";
        }
        
        if (ccvField.text == "")
        {
            valid = false
            lblVccv.text="CCV is required";
        }
        if (expirationDateField.text == "")
        {
            valid = false
            lblVdate.text="expiration Date Field value is required";
        }
        
        
        if(valid ){
            var date = expirationDateField.text!
            var dateArr = date.characters.split{$0 == "/"}.map(String.init)
            let month: String = dateArr[0]
            let year: String? = dateArr.count > 1 ? dateArr[1] : nil
            
            PayDock.setSecretKey(key: "")
            PayDock.setPublicKey(key: "1b0496942b784d96b660d01542aa0ceba45dd9e9")
            PayDock.shared.isSandbox = true
            
            let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
            let card = Card(gatewayId: gatewayId,
                            name: cardHolderNameField.text!,
                            number: cardNumberField.text!,
                            expireMonth: Int(month)!,
                            expireYear: Int(year!)!,
                            ccv: ccvField.text,
                            address: address)
            let paymentSource = PaymentSource.card(value: card)
            let customerRequest = CustomerRequest(firstName: "Test_first_name",
                                                  lastName: "Test_last_name",
                                                  email: "Test@test.com",
                                                  reference: "customer Refrence",
                                                  phone: nil,
                                                  paymentSource: paymentSource)
            
            let tokenRequest = TokenRequest(customer: customerRequest,
                                            address: address,
                                            paymentSource: paymentSource)
            PayDock.shared.create(token: tokenRequest) { (token) in
                
                do {
                    let token: String = try token()
                    print(token)
                } catch let error {
                    debugPrint(error)
                    self.lblerr.text = error.localizedDescription
                }
            }
        }
    }
    
}

