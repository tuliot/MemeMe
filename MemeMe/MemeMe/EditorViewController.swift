//
//  ViewController.swift
//  MemeMe
//
//  Created by Tulio Troncoso on 8/22/16.
//  Copyright © 2016 Tulio. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    // MARK: Editor Properties
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    @IBOutlet weak var topTextField: UITextField!

    @IBOutlet weak var bottomTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

