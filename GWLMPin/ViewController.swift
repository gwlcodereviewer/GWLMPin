//
//  ViewController.swift
//  GWLMPin
//
//  Created by MAC-51 on 11/02/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mpinView: GWLMPinView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mpinView.onSuccessCodeEnter = { pin in
            
        }
    }


}

