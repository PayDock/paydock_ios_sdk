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
protocol delegatefillCamera : class{
    func fillField(Number:String,Name:String,Date:String,Ccv:String,CardType:Int)->Void
}
protocol delegateCamera : class{
    func carmeraFunction()->Void
    func loadFunction()
}
class CardFormViewController: UIViewController ,UITextFieldDelegate, delegateError, delegatefillCamera{
    
    //MARK:- IBoutlet
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
      var delegateCamera : delegateCamera? = nil
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
        delegateCamera?.loadFunction()
        cardHolderNameField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        ccvField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        cardNumberField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
          expirationDateField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
       expirationDateField.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
  
    //MARK:- IBoutlet
    
    @IBAction func pressSubmit(_ sender: Any?) {
        
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
    
    
    @IBAction func CameraAction(_ sender: Any) {
        delegateCamera?.carmeraFunction()
    }
    // MARK:- Textfield function
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblVGError.text = ""
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
        
      if textField.tag == 0{//card number field
            if textField.text != ""{
                let textWithoutSpace =  textField.text!.removeWhitespaces() // remove space
                 guard   Int(textWithoutSpace) != nil  else{ // not number
                    invalideMessage(textfield: cardNumberField)
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "icdefault", in: frameworkBundle , compatibleWith: nil)
                    imgCard.image = image
                    return
                    
                }
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
//                    if maxflag == true { //greater than max
//                      invalideMessage(textfield:  cardNumberField)
//                      let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
//                      let image = UIImage(named: "icdefault", in: frameworkBundle , compatibleWith: nil)
//                      imgCard.image = image
//                    }else{
//                     lblVNumber.text = ""
//                    }
                if maxflag == true {
                    textField.deleteBackward()
                }
                
            }
        }else if textField.tag == 1{//card name field
            var flag = true
            for chr in textField.text! {
                if (!(chr >= "a" && chr <= "z" ) && !(chr >= "A" && chr <= "Z") && !(chr == " ")) { //check whether is it character
                    flag = false
                }
            }
            if flag == false {  //not character
                 invalideMessage(textfield: cardHolderNameField)
             }else{
                validateMessage(textfield: cardHolderNameField )
            }
            
            
        }else if textField.tag == 2{ //date field
                detectvalidateDateWhenTyping(str: textField.text!)
        }else if textField.tag == 3{ //ccv
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
        case 0://card number
            
            let textWithoutSpace =  textField.text!.removeWhitespaces() // remove space
            let str = textWithoutSpace.count
            guard   Int(textWithoutSpace) != nil else{ // not number
                if (textField.text != ""){
                    invalideMessage(textfield: cardNumberField)
                }else{
                    requireMessage(textfield: cardNumberField)
                }
                return
            }
                      print("Valid Integer")
                validateMessage(textfield: cardNumberField)
             if cardType != nil{
               if (cardType?.mMinCardLength)! > str ||  (cardType?.mMaxCardLength)! < str{
                    invalideMessage(textfield: cardNumberField)
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "icdefault", in: frameworkBundle , compatibleWith: nil)
                    imgCard.image = image
                }
             }
            
        case 1: //card name
            for chr in textField.text! {
                if (!(chr >= "a" && chr <= "z" ) && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
                   flag = false
                    
                }
            }
            if flag == false { //not character
                invalideMessage(textfield: cardHolderNameField )
                
            }else{
                validateMessage(textfield: cardHolderNameField)
                if textField.text! == ""{
                    requireMessage(textfield: cardHolderNameField)
                }
            }
            
        case 2 : //date
            let str = textField.text!
            let date = str.removeSlash()
            if date.count == 4 {
                      let dateFormatterGet = DateFormatter()
                     dateFormatterGet.dateFormat = "MM/YY"
                if dateFormatterGet.date(from: textField.text!) != nil {
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
        case 3 :  // ccv
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
        if isBackSpace == -8 { // press backspace
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
     func fillField(Number:String,Name:String,Date:String,Ccv:String,CardType:Int){
          updateCardType(creditCardNumber : Number)
          cardNumberField.text = Number
          cardHolderNameField.text = Name
          expirationDateField.text = Date
          ccvField.text = Ccv
     }
    
    //MARK:- function for cardNumber
    func updateCardType(creditCardNumber : String){  //get type of card 
         cardType  = CardType.getCreditCardType(creditCardNumber: creditCardNumber)
         let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
         let image = UIImage(named: cardType!.mImageResource!, in: frameworkBundle , compatibleWith: nil)
        imgCard.image = image
        }
    func addSpaceToCardField(creditCardTextFieldNumber : String , spaceArray : [Int]){
        var str = creditCardTextFieldNumber
       for item in spaceArray{
             if (item == str.count && backspace == false) {
                  str.insert(" ", at: str.index(str.startIndex, offsetBy: item))
                  break
            }
        }
        cardNumberField.text = str
    }
    func testValiditeOfCCV(str:String){
         let num = Int(str)
        guard   num != nil else{ // not number
            invalideMessage(textfield: ccvField)
            return
        }
         if cardType?.mCardScheme == "AMEX" {
                 if str.count > 4{
//                     invalideMessage(textfield: ccvField)
                    ccvField.deleteBackward()
                 } else{
                     validateMessage(textfield: ccvField)
                 }
            
            }else{ //notamex
                if str.count > 3{
//                      invalideMessage(textfield: ccvField)
                    ccvField.deleteBackward()
                } else{
                    validateMessage(textfield: ccvField)
               }
           }
       
        
    }
   //validate of date after typing
    func validationOfDate()->Bool{
        let date = Date() //current date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        let result = formatter.string(from: date)
        let r = "02/" +  result
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd/MM/yy"
        let currentdate = dateFormatter1.date(from:r)
        let dateString = "02/" + expirationDateField.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let s = dateFormatter.date(from:dateString)
         if s! >= currentdate!{ //compare date with current date
            return true
        }else{
            return false
        }
    }
    // function for date when typing
    func detectvalidateDateWhenTyping(str:String){
        let date = str.removeSlash()//date with no slash
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
            expirationDateField.text = str + "/" // add slash after 2 digit
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
