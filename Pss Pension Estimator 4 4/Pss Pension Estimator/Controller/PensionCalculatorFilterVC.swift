//
//  PensionCalculatorFilterVC.swift
//  Pss Pension Estimator
//
//  Created by Israel Mayor on 7/7/20.
//  Copyright © 2020 David Graham. All rights reserved.
//

import UIKit

protocol PensionCalculatorFilterVCDelegate {
	func updateData(retirementText: String, recordContributionSelected: Int, salTextField: String, actualAnnualAccrualVal: String, isOver10Years: Bool)
}

class PensionCalculatorFilterVC: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	
	@IBOutlet weak var contTextField: UITextField!
	@IBOutlet weak var retirementTextField: UITextField!
	@IBOutlet weak var salTextField: UITextField!
	
	var delegate: PensionCalculatorFilterVCDelegate?
	let defaults = UserDefaults.standard
	fileprivate let pickerView = ToolbarPickerView()
	var contributionList = ContributionList()
	var retirementAge = RetirementAge()
	let under10Years = Under10Years()
	let over10Years = Over10Years()
	

	var resultData = ResultData()
	var calculatedSaveData = CalculatedSaveData()
	
	override func viewDidLoad() {
		 super.viewDidLoad()
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(tap)
		pickerView.dataSource = self
		pickerView.delegate = self
		pickerView.toolbarDelegate = self
		contTextField.inputAccessoryView = pickerView.toolbar
		retirementTextField.inputAccessoryView = pickerView.toolbar
		contTextField.delegate = self
		retirementTextField.delegate = self
		pickerView.reloadAllComponents()
		
		retirementTextField.text = calculatedSaveData.retirementAgeText
		salTextField.text = calculatedSaveData.salaryIncreaseText //salaryIncreaseVal
		if calculatedSaveData.isOver10Years ?? Bool() {
			if let index = over10Years.list.firstIndex(where: {$0 == calculatedSaveData.actualAnnualAccrualVal}) {
					contTextField.text = contributionList.list[index]
				}
			} else {
			if let index = under10Years.list.firstIndex(where: {$0 == calculatedSaveData.actualAnnualAccrualVal}) {
					contTextField.text = contributionList.list[index]
				}
			}
		
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@IBAction func closeBtnPressed(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func updateBtnPressed(_ sender: DesignableButton) {
		let recConSelected = calculatedSaveData.recordContributionSelected
		defaults.set(recConSelected, forKey: "rs")
		let si = salTextField.text
		 defaults.set(si, forKey: "si")
		let cct = calculatedSaveData.actualAnnualAccrualVal
		defaults.set(cct, forKey: "cct")
		defaults.set(calculatedSaveData.isOver10Years, forKey: "oy")
		let ra = retirementTextField.text
		defaults.set(ra, forKey: "ra")
		dismiss(animated: true, completion: nil)
		delegate?.updateData(retirementText: retirementTextField.text ?? "", recordContributionSelected: calculatedSaveData.recordContributionSelected ?? 0, salTextField: salTextField.text ?? "", actualAnnualAccrualVal: calculatedSaveData.actualAnnualAccrualVal ?? "", isOver10Years: calculatedSaveData.isOver10Years ?? Bool())
	}
	
	// MARK: - PickerView Delegate
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if retirementTextField.isFirstResponder {
				return retirementAge.list.count
		} else {
				return contributionList.list.count
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if retirementTextField.isFirstResponder {
				return retirementAge.list[row]
		} else {
				return contributionList.list[row]
		}
	}
	
	//MARK: - UITextFieldDelegate
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == contTextField {
				pickerView.reloadAllComponents()
				pickerView.isDatePIcker = false
				contTextField.inputView = pickerView
			if calculatedSaveData.isOver10Years ?? Bool() {
				if let index = over10Years.list.firstIndex(where: {$0 == calculatedSaveData.actualAnnualAccrualVal}) {
					pickerView.selectRow(index, inComponent: 0, animated: true)
				}
				
			} else {
				if let index = under10Years.list.firstIndex(where: {$0 == calculatedSaveData.actualAnnualAccrualVal}) {
				pickerView.selectRow(index, inComponent: 0, animated: true)
				}
			}
			
		} else if textField == retirementTextField{
			pickerView.reloadAllComponents()
			pickerView.isDatePIcker = false
			retirementTextField.inputView = pickerView
			if let index = retirementAge.list.firstIndex(where: {$0 == calculatedSaveData.retirementAgeText}) {
			pickerView.selectRow(index, inComponent: 0, animated: true)
			}
		}
	}
}

extension PensionCalculatorFilterVC: ToolbarPickerViewDelegate {

	fileprivate func doneActionForContribution(row: Int) {
		contTextField.text = contributionList.list[row]
		calculatedSaveData.recordContributionSelected = row
		if calculatedSaveData.isOver10Years ?? Bool() {
			calculatedSaveData.actualAnnualAccrualVal = over10Years.list[row]
			print("Check over 10 years: \(	over10Years.list[row])")
		} else {
			calculatedSaveData.actualAnnualAccrualVal = under10Years.list[row]
			print("Check under 10 years: \(	under10Years.list[row])")
		}
	}

    func didTapDoneP() {
			let row = self.pickerView.selectedRow(inComponent: 0)
			pickerView.selectRow(row, inComponent: 0, animated: false)
			if retirementTextField.isFirstResponder {
				retirementTextField.text = retirementAge.list[row]
			} else {
				doneActionForContribution(row: row)
			}
			view.endEditing(true)
			pickerView.reloadAllComponents()
    }

    func didTapCancelP() {
			view.endEditing(true)
    }
}

