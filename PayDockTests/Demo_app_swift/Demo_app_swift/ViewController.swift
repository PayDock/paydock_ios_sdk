
//
//  ViewController.swift
//  Demo_app_swift
//
//  Created by Oleksandr Omelchenko on 18.10.17.
//  Copyright © 2017 Oleksandr Omelchenko. All rights reserved.
//

import UIKit
@testable import PayDock

class ViewController: UIViewController ,delegateCamera,CardIOPaymentViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    // MARK:- variable
    var delegateError : delegateError? = nil
    var delegatefillCamera :delegatefillCamera? = nil
    let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
    let cardGatewayId: String = "5819a158cd38a5b21a56a099"
    let bsbGatewayId: String = "5819a158cd38a5b21a56a099"
    let customerRequest = CustomerRequest(firstName: "Test_first_name", lastName: "Test_last_name", email: "Test@test.com", reference: "customer Refrence", phone: nil)
    let customerRequest2 = CustomerRequest(firstName: "Promise name", lastName: "Promise last name", email: "Test@test.com", reference: "AUS", phone: nil)
    let queryToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU4NTk1OGFlMjRhMDJmMzAyOTQzNjYzYiIsImxpbWl0IjpudWxsLCJza2lwIjpudWxsLCJpYXQiOjE1MTA0Mjg3Nzd9.A-ygj62jY2aoXN7TmHkHfy5L6tsLUOTXCwaXgZsrrGI"
    
    var completionHandler :(_
        restult: @escaping () throws -> String) -> Void = {_ in
    }
    

    //MARK:- IBAction
        @IBAction func btn1Pressed(_ sender: Any) {
        
        let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
        let storyboard = UIStoryboard(name: "cardForm", bundle: frameworkBundle)
        let controller = storyboard.instantiateViewController(withIdentifier: "CardFormViewController") as! CardFormViewController
        
        controller.address = address
        controller.gatewayId = cardGatewayId
        controller.customerRequest = customerRequest
        controller.delegateCamera = self
        controller.completionHandler = completionHandler
        
        delegateError = controller
        delegatefillCamera = controller
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        addChildViewController(controller)
        
        containerView.addSubview(controller.view)
        
        controller.didMove(toParentViewController: self)
        
    }
    
    @IBAction func btn2Pressed(_ sender: Any) {
        
        let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
        let storyboard = UIStoryboard(name: "cardForm", bundle: frameworkBundle)
        let controller = storyboard.instantiateViewController(withIdentifier: "BSBFormViewController") as! BSBFormViewController
        controller.address = address
        controller.gatewayId = bsbGatewayId
       controller.completionHandler = completionHandler
        delegateError = controller
        controller.customerRequest = customerRequest2
        containerView.subviews.forEach { $0.removeFromSuperview()
        }
        //view.addSubview(containerView)
         addChildViewController(controller)
        
        containerView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    
    @IBAction func btn3Pressed(_ sender: Any) {
        
        let listParams = ListParameters(
            skip: nil, limit: nil, subscription_id: nil, gateway_id: nil, company_id: nil, createdAtFrom: nil, createdAtTo: nil, search: nil, status: nil, isArchived: nil, queryToken: queryToken)
        
                PayDock.shared.getCustomerPaymentSources(with: listParams) { (customersPaymentSourcesResponse) in
                    do {
                        let paymentSourceList = try customersPaymentSourcesResponse()
                        print("*************************************")
                        
                        let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                        let storyboard = UIStoryboard(name: "cardForm", bundle: frameworkBundle)
                        let controller = storyboard.instantiateViewController(withIdentifier: "VaultViewController") as! VaultViewController
                        controller.paymentSource = paymentSourceList
                        self.containerView.subviews.forEach { $0.removeFromSuperview()
                        }
                        self.addChildViewController(controller)
                        self.containerView.addSubview(controller.view)
                        controller.didMove(toParentViewController: self)
                        
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }

      
    }
    // MARK:- lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        PayDock.setSecretKey(key: "")
        PayDock.setPublicKey(key: "774bda747d01571b8efb0b5a102bc945787b1cdb")
        PayDock.shared.isSandbox = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        completionHandler = { (token) in
                do {
                    let token: String = try token()
                    debugPrint(token)
                     self.delegateError?.errormessage(error: token)
                } catch let error {
                    debugPrint(error)
                    self.delegateError?.errormessage(error: error.localizedDescription)
                }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- function

    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {

        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
           // self.resultLabel.text = str as String
          //  print("result\(self.resultLabel.text)")
         print("cardtype\(info.cardType.rawValue)")
           print("cardInfo.cardType\(cardInfo.cardType)")
            print("creditcardnumber \(info.redactedCardNumber)")
            var date = "\(info.expiryMonth)/\( info.expiryYear)"
        delegatefillCamera?.fillField(Number:info.redactedCardNumber,Name:"",Date:date,Ccv:info.cvv,CardType:info.cardType.rawValue)
            
        }else{
            print("result")
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {

      //  resultLabel.text = "user canceled"
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    func carmeraFunction(){
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
//
    }
    func loadFunction(){
        CardIOUtilities.preload()
        if( !CardIOUtilities.canReadCardWithCamera()){
            print("hello")
        }
    }
}

