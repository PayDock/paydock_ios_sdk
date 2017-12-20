//
//  VaultViewController.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 12.11.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import UIKit

class VaultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- variable
    var paymentSource :[PaymentSource]?
    
    //MARK:-lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Table function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCellTableViewCell") as! CustomCellTableViewCell
        var itemDictionary = paymentSource?[indexPath.row].toDictionary()
        if itemDictionary != nil{
             if let primary = itemDictionary!["primary"] as? Bool{
                if primary == true {
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "icTick", in: frameworkBundle , compatibleWith: nil)
                    cell.primaryImg.image = image
                }else{
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "", in: frameworkBundle , compatibleWith: nil)
                    cell.primaryImg.image = image
                }
            }
            if itemDictionary!["type"] as!String == "bsb"{
                if let accountNumber = itemDictionary!["account_number"] as? String
                {
                     cell.numberLabel.text = accountNumber
                }
                if let accountName = itemDictionary!["account_name"] as? String {
                    print("accountname\(accountName)")
                    cell.nameLabel.text = accountName
                }
                let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                let image = UIImage(named: "icBank" , in: frameworkBundle , compatibleWith: nil)
                cell.typeImg.image = image
            }else{ //card
                if let scheme = itemDictionary!["card_scheme"] as? String
                {
                    let cardName = ["visa","mastercard","amex","diners" ,"cup"]
                    let cardimg = ["icvisa","icmastercard","icamex","icdiners","iccup"]
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    var flag = false
                    for i in 0 ..< cardName.count{
                        if scheme == cardName[i]  { //fill imageview with suitable card
                            let image = UIImage(named: cardimg[i], in: frameworkBundle , compatibleWith: nil)
                            cell.typeImg.image = image
                            flag = true
                        }
                    }
                    if flag == false{
                        let image = UIImage(named: "icdefault", in: frameworkBundle , compatibleWith: nil)
                        cell.typeImg.image = image
                    }
                }
                if let last4number = itemDictionary!["card_number_last4"] as? String{
                        cell.numberLabel.text = last4number
                }
                if let accountName = itemDictionary!["card_name"] as? String{
                    cell.nameLabel.text = accountName
                }
         }
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (paymentSource?.count)!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var itemDictionary = paymentSource?[indexPath.row].toDictionary()
        
        if itemDictionary != nil{
            if let paymentSourceId = itemDictionary!["id"] as? String{
                print("payment_source_id \(paymentSourceId)")
            }
        }
    }
}
