//
//  CardFormViewController.swift
//  
//
//  Created by Oleksandr Omelchenko on 13.10.17.
//  Copyright © 2017 Oleksandr Omelchenko. All rights reserved.
//

import UIKit

protocol delegateError : class{
    func errormessage(error : String)->Void
}
class CardFormViewController: UIViewController ,UITextFieldDelegate ,delegateError{
    

    @IBOutlet weak var imgCard: UIImageView!
    
    @IBOutlet weak var cardNumberField: UITextField!
    
    @IBOutlet weak var cardHolderNameField: UITextField!
    
    @IBOutlet weak var expirationDateField: UITextField!
    
    @IBOutlet weak var ccvField: UITextField!
    
    @IBOutlet weak var lblVNumber: UILabel!
    
    @IBOutlet weak var lblVName: UILabel!
    
    @IBOutlet weak var lblVExp: UILabel!
    
    @IBOutlet weak var lblVccv: UILabel!
    
    @IBOutlet weak var lblVGError: UILabel!
    // MARK:- variable
    var gatewayId: String = ""
    var address :Address? = nil
    var customerRequest: CustomerRequest? = nil
    
    var completionHandler :(_
        result: @escaping () throws -> String) -> Void = {_ in
        
    }
    var cardType : CardType?
    var normal_Card_Spaces = [4, 9, 14 ]
    var SHORT_CARD_SPACES = [4, 11 ]
    var spaceIndics : [Int]?
    var constantsUi = ConstantsUi()
    var backspace = false
    var backspaceForSlash = false
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    //MARK:- lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumberField.delegate = self
        cardHolderNameField.delegate = self
        expirationDateField.delegate = self
        ccvField.delegate = self
        
            // Do any additional setup after loading the view, typically from a nib.
        cardHolderNameField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        ccvField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        cardNumberField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
          expirationDateField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
    }
    
    
    
    
    func GetDateFromString(DateStr: String)-> Date
    {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let DateArray = DateStr.components(separatedBy: "/")
        let components = NSDateComponents()
        components.year = Int(DateArray[2])!
        components.month = Int(DateArray[1])!
        components.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = calendar?.date(from: components as DateComponents)
        
        return date!
    }

    override func viewDidAppear(_ animated: Bool) {
      
       expirationDateField.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    //MARK:- IBoutlet
    
    @IBAction func cardSubmitPressed(_ sender: Any) {
        
        var valid = true
        if (cardNumberField.text == "")
        {
            valid = false
            requireMessage(textfield: cardNumberField)
        }
        if (cardHolderNameField.text == "")
        {
            valid = false
            requireMessage(textfield: cardHolderNameField )
       }
        
        if (ccvField.text == "")
        {
            valid = false
            requireMessage(textfield: ccvField)
        }
        if (expirationDateField.text == "")
        {
            valid = false
            requireMessage(textfield: expirationDateField)
        }
       
        if(valid ){
            let date = expirationDateField.text!
            var dateArr = date.split{$0 == "/"}.map(String.init)
            let month: String = dateArr[0]
            let year: String? = dateArr.count > 1 ? dateArr[1] : nil
           
            let cardNumber = cardNumberField.text!.replacingOccurrences(of: " ", with: "")
            
           
            let card = Card(gatewayId: gatewayId, name: cardHolderNameField.text!, number: cardNumber, expireMonth: Int(month)!, expireYear: Int(year!)!, ccv: ccvField.text!, address: address)
        
            let paymentSource = PaymentSource.card(value: card)
            let tokenRequest = TokenRequest(customer: customerRequest, address: address, paymentSource: paymentSource)
            PayDock.shared.create(token: tokenRequest, completion: completionHandler)
   
        }
        
    }
    // MARK:- Textfield function
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch  textField.tag {
        case 0:
            validateMessage(textfield: cardNumberField)
       case 1:
            validateMessage(textfield: cardHolderNameField)
        case 2:
            validateMessage(textfield: expirationDateField )
        case 3:
            validateMessage(textfield: ccvField)
        default:
            print("default")
        }
    }

    func textFieldDidChange(textField: UITextField){
      
       
            if textField.tag == 0{
            if textField.text != ""{
                let textWithoutSpace =  textField.text!.removeWhitespaces() // remove space
                if Int(textWithoutSpace) != nil { //number
                    print("Valid Integer")
                    validateMessage(textfield: cardNumberField)
                    updateCardType(creditCardNumber : textField.text!)
                if cardType?.mMaxCardLength! == 15{
                    spaceIndics = SHORT_CARD_SPACES
                }else{
                    spaceIndics = normal_Card_Spaces
                }
                addSpaceToCardField(creditCardTextFieldNumber: textField.text!,spaceArray: spaceIndics!)
                    let maxflag =  cardType?.greaterThanMax(creditCardNumber: textWithoutSpace)
                   if maxflag == true { //greater than max
                      invalideMessage(textfield:  cardNumberField)
                      //   lblCardType.text = ""
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "icdefault", in: frameworkBundle , compatibleWith: nil)
                    imgCard.image = image
                    }else{
                     lblVNumber.text = ""
                 }
                }else{//notnumber
                    invalideMessage(textfield: cardNumberField)
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "icdefault", in: frameworkBundle , compatibleWith: nil)
                    imgCard.image = image
                }
            }
        }else if textField.tag == 1{
            var flag = true
            for chr in textField.text! {
                if (!(chr >= "a" && chr <= "z" ) && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
                    flag = false
                }
            }
            if flag == false {
                 invalideMessage(textfield: cardHolderNameField)
             }else{
                validateMessage(textfield: cardHolderNameField )
            }
            
            
        }else if textField.tag == 2{
                detectvalidateDateWhenTyping(str: textField.text!)
        }else if textField.tag == 3{
                validateMessage(textfield: ccvField)
             if textField.text != ""{
                testValiditeOfCCV(str: textField.text!)
            }else{
                validateMessage(textfield: ccvField)
               }
            
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        var flag = true
        print("textfieldtag\(textField.tag)")
        switch textField.tag {
        case 0:
            
            let textWithoutSpace =  textField.text!.removeWhitespaces() // remove space
            let str = textWithoutSpace.count
            if Int(textWithoutSpace) != nil {
                print("Valid Integer")
                validateMessage(textfield: cardNumberField)
               if (cardType!.mMinCardLength)! > str ||  (cardType!.mMaxCardLength)! < str{
                    invalideMessage(textfield: cardNumberField)
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "icdefault", in: frameworkBundle , compatibleWith: nil)
                    imgCard.image = image
                }
            }
            else {
                if (textField.text != ""){
                    invalideMessage(textfield: cardNumberField)
                }else{
                    requireMessage(textfield: cardNumberField)
                }
            }
        case 1:
            for chr in textField.text! {
                if (!(chr >= "a" && chr <= "z" ) && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
                   flag = false
                    
                }
            }
            if flag == false {
                invalideMessage(textfield: cardHolderNameField )
                
            }else{
                validateMessage(textfield: cardHolderNameField)
                if textField.text! == ""{
                    requireMessage(textfield: cardHolderNameField)
                }
            }
            
        case 2 :
            let str = textField.text!
            var date = str.removeSlash()
            if date.count == 4 {
                      let dateFormatterGet = DateFormatter()
                     dateFormatterGet.dateFormat = "MM/YY"
                    if let date = dateFormatterGet.date(from: textField.text!) as? Date {
                        validateMessage(textfield:expirationDateField)
                        
                                 if validationOfDate() {
                                        validateMessage(textfield: expirationDateField)
                                    
                                 }else{ //not valid
                                         invalideMessage(textfield: expirationDateField)
                                 }
                 } else {
                      // invalid format
                      invalideMessage(textfield: expirationDateField)
                 }
            }else if date.count == 0  { // smaller than 4
                requireMessage(textfield:expirationDateField )
            }else{   // not 4 not zero
                invalideMessage(textfield: expirationDateField)
            }
        case 3 :
            if textField.text != ""{
                testValiditeOfCCV(str: textField.text!)
            }else{
                requireMessage(textfield: ccvField)
            }
            
        default:
            print("default")
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)
        let isBackSpace: Int = Int(strcmp(char, "\u{8}"))
        if isBackSpace == -8 {
            backspace = true
            backspaceForSlash = true
        }else{
            backspace = false
            backspaceForSlash = false
        }
        return true
    }
    func errormessage(error : String)->Void{
        self.lblVGError.text = error
    }
    
    //MARK:- function for cardNumber
    func updateCardType(creditCardNumber : String){
         cardType  = CardType.getCreditCardType(creditCardNumber: creditCardNumber)
         let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
         let image = UIImage(named: cardType!.mImageResource!, in: frameworkBundle , compatibleWith: nil)
        imgCard.image = image
        }
    func addSpaceToCardField(creditCardTextFieldNumber : String , spaceArray : [Int]){
        var str = creditCardTextFieldNumber
        let textWithoutSpace =  str.removeWhitespaces()
        for item in spaceArray{
            if (item == textWithoutSpace.count && backspace == false) {
                  str.insert(" ", at: str.index(str.startIndex, offsetBy: item))
                break
            }
        }
        cardNumberField.text = str
    }
    func testValiditeOfCCV(str:String){
         let num = Int(str)
         if num != nil { //number
            if cardType?.mCardScheme == "AMEX" {
                
           
                 if str.count > 4{
                     invalideMessage(textfield:ccvField)
                 } else{
                     validateMessage(textfield: ccvField)
                 }
            
          }else{ //notamex
                if str.count > 3{
                      invalideMessage(textfield: ccvField)
                } else{
                    validateMessage(textfield: ccvField)
               }
          }
        }else{//notnumber
            invalideMessage(textfield: ccvField)
        }
        
    }
   //
    func validationOfDate()->Bool{
        let date = Date() //current date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        let result = formatter.string(from: date)
        print(result)
        
        
        let r = "02/" +  result
        print(r)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd/MM/yy"
        let currentdate = dateFormatter1.date(from:r)
        let dateString = "02/" + expirationDateField.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let s = dateFormatter.date(from:dateString)
         if s! >= currentdate!{
            return true
        }else{
            return false
        }
    }
    // function for datewhen typing
    func detectvalidateDateWhenTyping(str:String){
        let date = str.removeSlash()
         guard   str != "" else{  //empty
              validateMessage(textfield:expirationDateField)
         return
         }
        guard str[0] == "0" || str[0] == "1" else { //not start with 0 or 1
             invalideMessage(textfield:expirationDateField)
        return
        }
        guard Int(date) != nil else{ // not number
              invalideMessage(textfield: expirationDateField)
        return
        }
        validateMessage(textfield:expirationDateField)
        if str.count == 2 && str[1] != "/" && backspaceForSlash == false{
            expirationDateField.text = str + "/"
        }
        if date.count > 4 {
            invalideMessage(textfield:expirationDateField)
        }
    }
    func invalideMessage(textfield:UITextField){
        let myColor = UIColor.red
        textfield.layer.borderColor = myColor.cgColor
        textfield.layer.borderWidth = 1.0
        switch textfield.tag{
        case 0 :
            lblVNumber.text = constantsUi.cardNumberIsInvalid
        case 1:
             lblVName.text = constantsUi.cardNameIsInvalid
        case 2:
             lblVExp.text = constantsUi.expiryIsInvalid
        case 3:
            lblVccv.text = constantsUi.securityCodeInvalid
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
            lblVNumber.text = constantsUi.cardNumberIsRequired
        case 1:
            lblVName.text = constantsUi.cardNameIsRequired
        case 2:
            lblVExp.text = constantsUi.expiryIsRequired
        case 3:
            lblVccv.text = constantsUi.securityCodeIsRequired
        default:
            print("")
        }
    }
    func validateMessage(textfield:UITextField){
        let myColor = UIColor.clear
        textfield.layer.borderColor = myColor.cgColor
        textfield.layer.borderWidth = 1.0
        switch textfield.tag{
        case 0 :
            lblVNumber.text = ""
        case 1:
            lblVName.text = ""
        case 2:
            lblVExp.text = ""
        case 3:
            lblVccv.text = ""
        default:
            print("")
        }
    }
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
        
    }
    func removeSlash() -> String {
        return components(separatedBy: "/").joined()
    }
}
