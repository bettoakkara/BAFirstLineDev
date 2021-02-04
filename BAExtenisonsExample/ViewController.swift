//
//  ViewController.swift
//  BAExtenisonsExample
//
//  Created by Betto Akkara on 03/02/21.
//

import UIKit
import BAExtensions

class ViewController: UIViewController {

    @IBOutlet weak var view_cr: BAGradientView!
    override func viewDidLoad() {
        super.viewDidLoad()

        BALogger.d("this is debug text".capitalizingFirstLetter())
        BALogger.Print_json(["key1": "value1","key2": "value2","key3": "value3","key4": "value4"])

    }

    override func viewDidAppear(_ animated: Bool) {
        view_cr.layer.roundCorners([.topRight, .topLeft], radius: 10)
    }

}

