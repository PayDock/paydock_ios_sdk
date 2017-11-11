//
//  BSBFormViewController.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 03.11.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import UIKit

class BSBFormViewController: UIViewController,UITextFieldDelegate {

    //MARK:- Outlet
    
    @IBOutlet weak var AccountNumber: UITextField!
    
    @IBOutlet weak var AccountName: UITextField!
    
    @IBOutlet weak var BSBNumber: UITextField!
    
    @IBOutlet weak var AccountNumberValidation: UILabel!
    
    @IBOutlet weak var AccountNameValidationLabel: UILabel!
    
    
    @IBOutlet weak var BSBNumberValidationLabel: UILabel!
    
    
    @IBOutlet weak var GatewayErrorLabel: UILabel!
    
    // MARK:- variable
     var constantsUi = ConstantsUi()
    
    
    
    //MARK:IBAction
    
    @IBAction func pressSubmit(_ sender: Any) {
    }
    //MARK:-lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        AccountNumber.delegate = self
        AccountName.delegate = self
        BSBNumber.delegate = self
        AccountNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        AccountName.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        BSBNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- Function for textfield
    func textFieldDidChange(textField: UITextField){
        switch textField.tag{
        case 0 :
            if Int(textField.text!) != nil { //number
               validateMessage(textfield:AccountNumber)
            }else{//notnumber
                if textField.text != ""{
                    invalideMessage(textfield:AccountNumber)
                }else{
                    validateMessage(textfield: AccountNumber)
                }
            }
        case 1:
             var flag = true
            for chr in textField.text! {
                if (!(chr >= "a" && chr <= "z" ) && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
                    flag = false
                    
                }
            }
            if flag == false {
                invalideMessage(textfield: AccountName)
                
            }else{
                validateMessage(textfield: AccountName)
                
            }
        case 2:
            let num1 = Int(textField.text!)
            if num1 != nil { //number
                validateMessage(textfield: BSBNumber)
            }else{//notnumber
                if textField.text != ""{
                    invalideMessage(textfield:BSBNumber)
                }else{
                    validateMessage(textfield: BSBNumber)
                }
            }
        default :
            print("error")
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag{
        case 0 :
            if Int(textField.text!) != nil {
                validateMessage(textfield: AccountNumber)
            }else{ //notnumber
                if textField.text != ""{
                    invalideMessage(textfield:AccountNumber)
                }else{
                    requireMessage(textfield: AccountNumber)
                }
            }
        case 1 :
            var flag = true
            for chr in textField.text! {
                if (!(chr >= "a" && chr <= "z" ) && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
                    flag = false
                    
                }
            }
            if flag == false {
                invalideMessage(textfield: AccountName)
                
            }else{
                validateMessage(textfield: AccountName)
                if textField.text! == ""{
                    requireMessage(textfield: AccountName)
                }
            }
        case 2:
            let num1 = Int(textField.text!)
            if num1 != nil {
                validateMessage(textfield: BSBNumber)
            }else{ //notnumber
                if textField.text != ""{
                    invalideMessage(textfield: BSBNumber)
                }else{
                    requireMessage(textfield: BSBNumber)
                }
            }
        default :
            print("error")
        }
        
        
        
    }
    func validateMessage(textfield:UITextField){
        let myColor = UIColor.clear
        textfield.layer.borderColor = myColor.cgColor
        textfield.layer.borderWidth = 1.0
        switch textfield.tag{
        case 0 :
            AccountNumberValidation.text = ""
        case 1:
            AccountNameValidationLabel.text = ""
        case 2:
            BSBNumberValidationLabel.text = ""
        default:
            print("")
        }
        
    }
    func invalideMessage(textfield:UITextField){
        let myColor = UIColor.red
        textfield.layer.borderColor = myColor.cgColor
        textfield.layer.borderWidth = 1.0
        switch textfield.tag{
        case 0 :
           AccountNumberValidation.text = constantsUi.accountNumberIsInvalid
        case 1:
            AccountNameValidationLabel.text = constantsUi.bankAccountNameIsInvalide
        case 2:
            BSBNumberValidationLabel.text = constantsUi.bSBNumberIsInvalid
        default:
            print("")
        }
        
    }
    func requireMessage(textfield:UITextField){
        let myColor = UIColor.red
        textfield.layer.borderColor = myColor.cgColor
        textfield.layer.borderWidth = 1.0
        switch textfield.tag{
        case 0 :
            AccountNumberValidation.text = constantsUi.accountNumberIsRequired
        case 1:
            AccountNameValidationLabel.text = constantsUi.bankAccountNameIsRequired
        case 2:
            BSBNumberValidationLabel.text = constantsUi.bSBNumberIsRequired
        default:
            print("")
        }
    }
}
