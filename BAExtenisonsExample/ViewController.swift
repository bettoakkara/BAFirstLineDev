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
    @IBOutlet weak var button: BALoadingButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        BALogger.d("this is debug text".capitalizingFirstLetter())
        BALogger.Print_json(["key1": "value1","key2": "value2","key3": "value3","key4": "value4"])

    }

    override func viewDidAppear(_ animated: Bool) {
        view_cr.layer.roundCorners([.topRight, .topLeft], radius: 10)
    }

    @IBAction func BABtn(_ sender: BALoaderButton) {

        print("clicked on BABTN")

    }

    @IBAction func buttonClick(_ sender: Any) {

        if button.isLoading {
            button.hideLoader()
        }else{
            button.showLoader([BAButtonViews.background,.imageview,.shadow,.titleLabel], userInteraction: true, loaderType : .ball_Spin,color:  #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)) {
                    print("helllo... ")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: DispatchTimeInterval.seconds(4)) ) {
                    self.button.hideLoader()
                }
            }
        }

    }


    @IBOutlet weak var baloaderbtn: BALoaderButton!


    
}

