//
//  CardFormViewController.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 14.10.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import UIKit

class CardFormViewController: UIViewController {

    @IBOutlet weak var carNumberField: UITextField!
    @IBOutlet weak var CardHolderNameField: UITextField!
    @IBOutlet weak var expirationDateField: UITextField!
    @IBOutlet weak var ccvField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cardNumberEntered(_ sender: Any) {
    }
    
    @IBAction func cardHolderNameEntered(_ sender: Any) {
    }
    
    @IBAction func expirationDateEntered(_ sender: Any) {
    }
    
    @IBAction func ccvEntered(_ sender: Any) {
    }
    
    @IBAction func cardSubmitPressed(_ sender: Any) {
        
    }
    
}
