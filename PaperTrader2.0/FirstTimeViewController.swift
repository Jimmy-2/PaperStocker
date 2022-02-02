//
//  FirstTimeViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/28/21.
//

import UIKit

class FirstTimeViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var startingAmount: UITextField!
    @IBOutlet var okButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dailyBalances = [DailyBalance]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startingAmount.delegate = self
        
        
    }
    
    //MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedChars = "1234567890"
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharSet = CharacterSet(charactersIn: string)
        
        return allowedCharSet.isSuperset(of: typedCharSet)
        
    }
    
    // MARK: - Actions
    @IBAction func buttonPressed() {
        let defaultsss = UserDefaults.standard
        var startingAmountStr: String?
        if startingAmount.text! == "" {
            
            startingAmountStr = defaultsss.string(forKey: "ifNil")
            
            
        }else {
            startingAmountStr = startingAmount.text!
        }
        
        defaultsss.set(startingAmountStr, forKey: "balanceAmount")
        
        
        
        
        userDefaults.defaults.setNotNew()
        
        dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
        
        
    }

    
    
}
