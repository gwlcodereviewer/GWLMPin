//
//  GWLMPinTextField.swift
//  GWLMPin
//
//  Created by MAC-51 on 11/02/21.
//

import UIKit

public class GWLMPinTextField: UITextField, UITextFieldDelegate {

    open var fields: [GWLMPinTextField]?
    weak var fieldDelegate: GWLMPinViewTextDelegate?
    
    open var completion: ((_ code: String)->Void)?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init() {
        super.init(frame: .zero)
        initilize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initilize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initilize()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initilize()
    }
    
    private func initilize() {
        delegate = self
    }
    
    override public func deleteBackward() {
        super.deleteBackward()
//        respondPrevious(field: self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count > 0 {
            textField.backgroundColor = .white
        } else {
            if #available(iOS 9.0, *) {
                textField.backgroundColor = GWLMPinView().fieldBackgroundColor
            } else {
                // Fallback on earlier versions
            }
        }
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        fieldDelegate?.fieldDidBeginEditing(textField)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0  else {
            textField.text = ""
            respondPrevious(field: self)
            return false
        }
        let currentText = textField.text ?? ""
        _ = (currentText as NSString).replacingCharacters(in: range, with: string)
//        let change = prospectiveText.count == 1
//        if change{
        if textField.text!.count == 1, string.count == 1 {
//            textField.text = ""
            respondNext(field: self,text: string)
        } else {
            textField.text = string
            if #available(iOS 9.0, *) {
                textField.backgroundColor = .white
            } else {
                // Fallback on earlier versions
            }
            respondNext(field: self)
        }
        
//        }
        return true
    }
    
    func respondNext(field: GWLMPinTextField,text: String = "") {
        guard let lFields = fields else {
            return
        }
        
        guard let index = lFields.firstIndex(of: field) else{
            return
        }
        
        if index == lFields.count-1 {
            firePasscode(feilds: lFields)
            field.resignFirstResponder()
            return
        }
        
        lFields[index+1].becomeFirstResponder()
        if text.count > 0 {
            if #available(iOS 9.0, *) {
                lFields[index+1].backgroundColor = .white
            } else {
                // Fallback on earlier versions
            }
            lFields[index+1].text = ""
            lFields[index+1].text = text
            if index+1 == lFields.count-1 {
//                lFields[index+1].resignFirstResponder()
                firePasscode(feilds: lFields)
                return
            }
        }
        firePasscode(feilds: lFields)
    }
    
    func respondPrevious(field: GWLMPinTextField) {
        guard let lFields = fields else {
            return
        }

        guard let index = lFields.firstIndex(of: field) else{
            return
        }
     
        if index == 0 {
            lFields[index].resignFirstResponder()
            firePasscode(feilds: lFields)
            return
        }
        if #available(iOS 9.0, *) {
            lFields[index].backgroundColor = GWLMPinView().fieldBackgroundColor
        } else {
            // Fallback on earlier versions
        }
        lFields[index-1].becomeFirstResponder()
        firePasscode(feilds: lFields)
    }
    
    
    func firePasscode(feilds: [GWLMPinTextField]) {
        var passCode = ""
        for item in feilds {
            passCode = passCode + item.text!
        }
        
        if let lCompletion = completion {
            lCompletion(passCode)
        }
    }

}
