//
//  Add_Mood_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 09/08/22.
//

import UIKit

class Add_Mood_ViewController: UIViewController {
    
    
    @IBOutlet weak var mood_switch_select: UITextField!
    
    
    var switch_picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func add_mood_save_button(_ sender: UIButton) {

        
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    
    }
    
}
