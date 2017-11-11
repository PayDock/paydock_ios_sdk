//
//  CardType.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 07.11.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import UIKit

class CardType: NSObject {
    var mCardScheme : String?
    var mImageResource : String?
    var mMinCardLength : Int?
    var mMaxCardLength : Int?
  init(cardScheme:String,imageResource:String,minCardLength:Int,maxCardlength:Int){
       mCardScheme = cardScheme
       mImageResource = imageResource
       mMinCardLength = minCardLength
       mMaxCardLength = maxCardlength
    }
    override init(){
        mCardScheme = "Default Card"
        mMinCardLength = 16
        mMaxCardLength = 16
    }
  static  func getCreditCardType(creditCardNumber : String)-> CardType{
        let   regexVisa = "^4\\d*"
        let   regexMaster = "^(222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720|5[1-5])\\d*"
        let   regexAMEX = "^3[47]\\d*"
        let   regexDiners = "^(30[0-5]|309|36|3[8-9])\\d*"
        let   regexCUP  = "^62\\d*"

        let pattern = [regexVisa,regexMaster,regexAMEX,regexDiners,regexCUP]
        let cardName = ["Visa","MasterCard","AMEX","Diners Club" ,"China Union Pay"]
        let cardimg = ["icvisa","icmastercard","icamex","icdiners","iccup"]
        let cardMinLength = [16,16,15,14,16]
        let cardMaxLength = [16,16,15,19,19]
        var checKType = false
    
        for i in 0 ..< pattern.count{
          do {
            let regex = try NSRegularExpression(pattern: pattern[i],
                                                options: .caseInsensitive)
            checKType = regex.matches(in: creditCardNumber,
                                      options: [],
                                      range: NSMakeRange(0, creditCardNumber.count)).count > 0
            
           } catch {
            checKType = false
          }
            if checKType == true{
                return CardType(cardScheme: cardName[i], imageResource: cardimg[i], minCardLength: cardMinLength[i], maxCardlength: cardMaxLength[i])
            }
        }//end for
        return CardType(cardScheme: "Default Card", imageResource: "icdefault", minCardLength: 16, maxCardlength: 16)
    }
    func isvalid(creditCardNumber : String)->Bool{
        if creditCardNumber.count == 0 || creditCardNumber.count > mMaxCardLength! ||  creditCardNumber.count < mMinCardLength! {
            return false
        }
        return true
    }
    func greaterThanMax(creditCardNumber : String)->Bool{
        if creditCardNumber.count > mMaxCardLength! {
            return true
        }
        return false
    }
  }
