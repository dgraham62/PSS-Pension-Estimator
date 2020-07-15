//
//  DisclaimerViewController.swift
//  Pss Pension Estimator
//
//  Created by Israel Mayor on 7/12/20.
//  Copyright © 2020 David Graham. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {
	
	@IBOutlet weak var disclaimerText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
			
			disclaimerText.text = "• An estimate not a prediction. Results are only estimates, the actual amounts may be higher or lower. We cannot predict things that will affect your decision, such as changing interest rates. \n\n • This app is not intended to be your sole source of information when making a financial decision. Consider whether to get advice from a licensed financial adviser \n\n • The information on this App is for general information only. \n\n • It should not be taken as constituting professional advice from the app owner – David Graham. \n\n • David Graham is not a financial adviser. You should consider seeking independent legal, financial, taxation or other advice to check how the app information relates to your unique circumstances. \n\n • David Graham is not liable for any loss caused, whether due to negligence or otherwise arising from the use of, or reliance on, the information provided directly or indirectly, by use of this app."
    }

	
	@IBAction func acceptBtnPressed(_ sender: UIButton) {
		UserDefaults.standard.set(true, forKey: "disclaimerComplete")
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let pensionViewController = storyboard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
			pensionViewController.modalPresentationStyle = .fullScreen
			present(pensionViewController, animated: true, completion: nil)
	}
	
	@IBAction func declineBtnPressed(_ sender: UIButton) {
		let vc = UIAlertController(title: "Confirmation", message: "Are you sure you want to decline? \n\n If you hit 'OK' the app will close", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .destructive) { (alert) in
			exit(0)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
		vc.addAction(okAction)
		vc.addAction(cancelAction)
		present(vc, animated: true, completion: nil)
	}
	

}
