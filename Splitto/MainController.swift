//
//  MainController.swift
//  Splitto
//
//  Created by Krishna Panchal on 01/01/24.
//

import UIKit
import IQKeyboardManagerSwift

class MainController: UIViewController,UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var billTF: UITextField!
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var btnZero: UIButton!
    @IBOutlet weak var btnTen: UIButton!
    @IBOutlet weak var btnFifteen: UIButton!
    @IBOutlet weak var btnTwenty: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnCalculate: UIButton!
    
    //MARK: - Variables
    var tip = 1.0
    var totalBillIs = 0.0
    var finalPay = "0.0"
    var noOfPeopleInGroup = 2 {
        didSet {
            groupLbl.text = "\(noOfPeopleInGroup)"
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        billTF.setLeftPadding(10)
        
        billTF.delegate = self
    }
    
    //MARK: - @IBAction
    @IBAction func buttonPlusPressed(_ sender: UIButton) {
        noOfPeopleInGroup += 1
    }
    
    @IBAction func buttonMinusPressed(_ sender: UIButton) {
        if noOfPeopleInGroup <= 2 {return}
        noOfPeopleInGroup -= 1
    }
    
    @IBAction func tipsButtonAction(_ sender: UIButton) {
        updateTipsBtn(selectedBtn: sender)
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        guard let billAmount = billTF.text?.trimmingCharacters(in: .whitespaces) , !billAmount.isEmpty else {
            totalLbl.text = "Please enter bill total!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.billTF.becomeFirstResponder()
            }
            return
        }
        let billDot = billAmount.replacingOccurrences(of: ",", with: ".")
        totalBillIs = Double(billDot) ?? 0
        let result = totalBillIs * tip / Double(noOfPeopleInGroup)
        finalPay = String(format: "%.2f", result)
        totalLbl.text = finalPay
    }
    
    //MARK: TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard by resigning the first responder
            textField.resignFirstResponder()
            return true
        }
        
        // You can also add a tap gesture recognizer to dismiss the keyboard when tapping outside the text field
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
}

//MARK: - Helping methods
extension MainController {
    
    private  func setupView() {
        billTF.layer.cornerRadius  =  billTF.frame.height/2
        billTF.layer.masksToBounds = true
        groupLbl.layer.cornerRadius  = 10
        groupLbl.layer.masksToBounds = true
        
        let tipsBtnArray = [btnZero , btnTen , btnFifteen , btnTwenty]
        for button in tipsBtnArray {
            button?.layer.cornerRadius = 10
        }
        
        let stepperBtns = [btnPlus , btnMinus]
        for button in stepperBtns {
            button?.layer.cornerRadius = button!.frame.height/2
        }
        btnCalculate.layer.cornerRadius = btnCalculate.frame.height/2
        updateTipsBtn(selectedBtn:btnZero)
    }
    
    func updateTipsBtn(selectedBtn: UIButton) {
        let tipsBtnArray = [btnZero , btnTen , btnFifteen , btnTwenty]
        for button in tipsBtnArray {
            button?.backgroundColor =  selectedBtn == button ? #colorLiteral(red: 0.6382895112, green: 0.8350121975, blue: 0.9969195724, alpha: 1) : #colorLiteral(red: 0.7568627451, green: 0.8862745098, blue: 0.9921568627, alpha: 1)
        }
        if selectedBtn == btnZero {
            tip = 1.0
        } else if selectedBtn == btnTen {
            tip = 1.1
        } else if selectedBtn == btnFifteen {
            tip = 1.15
        } else {
            tip = 1.20
        }
    }
}

//MARK: - Padding
extension UITextField {
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

