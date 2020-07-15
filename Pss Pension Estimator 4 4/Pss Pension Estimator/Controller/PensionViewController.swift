
import UIKit

class PensionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
	@IBOutlet weak var birthDateText: UITextField!
	@IBOutlet weak var yearPicker: UITextField!
	@IBOutlet weak var ambText: UITextField!
	@IBOutlet weak var fasText: UITextField!
	@IBOutlet weak var empContribution: UITextField!
	@IBOutlet weak var totalAccrualText: UITextField!
	@IBOutlet weak var currentContributionsText: UITextField!
	@IBOutlet weak var fulltimeText: UITextField!
	@IBOutlet weak var retirementAgeTextField: UITextField!
	@IBOutlet weak var salaryIncreaseText: UITextField!
	@IBOutlet weak var statementDate: UITextField!
	@IBOutlet weak var statementDataLabel: UILabel!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	let defaults = UserDefaults.standard
		var isRecalculateData = false
	
	fileprivate let pickerView = ToolbarPickerView()
	var isOver10Years = Bool()
	var recordContributionSelected = Int()
	
	var contributionList = ContributionList()
	let under10Years = Under10Years()
	let over10Years = Over10Years()
	let pensionFactor = PensionFactor()
	var retirementAge = RetirementAge()
    
	// Initial Value setup
	var pf = PensionList()
	var tp = TaxPayableList()
	var resultData = ResultData()
	var calculatedSaveData = CalculatedSaveData()
	
	var actualAnnualAccrualVal = ""
	var dobDate = Date()
	var stateDate = Date()
	
	var fasTextVal = ""
	var empContributionVal = ""
	var totalAccrualVal = ""


	override func viewDidLoad(){
		super.viewDidLoad()
		setupInitialData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadSaveData()
	}

	// MARK: - Helper Methods
	
	fileprivate func setupInitialData() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(tap)
		pickerView.dataSource = self
		pickerView.delegate = self
		pickerView.toolbarDelegate = self
		currentContributionsText.delegate = self
		fulltimeText.delegate = self
		birthDateText.delegate = self
		statementDate.delegate = self
		salaryIncreaseText.delegate = self
		fasText.delegate = self
		empContribution.delegate = self
		totalAccrualText.delegate = self
		retirementAgeTextField.delegate = self
		currentContributionsText.inputAccessoryView = pickerView.toolbar
		retirementAgeTextField.inputAccessoryView = pickerView.toolbar
		birthDateText.inputAccessoryView = pickerView.toolbar
		statementDate.inputAccessoryView = pickerView.toolbar
		pickerView.reloadAllComponents()
	}
	
	fileprivate func saveLocalData() {
		view.endEditing(true)
		let dobVal = dobDate.toString()
		defaults.set(dobVal, forKey: "dobVal")
		let stateVal = stateDate.toString()
		defaults.set(stateVal, forKey: "stateVal")
		let recConSelected = recordContributionSelected
		defaults.set(recConSelected, forKey: "rs")
		let si = salaryIncreaseText.text
		 defaults.set(si, forKey: "si")
		let cct = actualAnnualAccrualVal
		defaults.set(cct, forKey: "cct")
		defaults.set(isOver10Years, forKey: "oy")
		let text = ambText.text
		defaults.set(text, forKey: "text")
		let fas = fasTextVal
		defaults.set(fas, forKey: "fas")
		let empCont = empContributionVal
		defaults.set(empCont, forKey: "empCont")
		let tat = totalAccrualVal
		defaults.set(tat, forKey: "tat")
		let ft = fulltimeText.text
		defaults.set(ft, forKey: "ft")
		let ra = retirementAgeTextField.text
		defaults.set(ra, forKey: "ra")
	}
	
	 func loadSaveData() {
		print("loaddddd")
		view.endEditing(true)
		let text = defaults.string(forKey: "text")
		 ambText.text = text
		 let fas = defaults.string(forKey: "fas")
		 fasTextVal = fas ?? ""
		 fasText.text = "$\(fasTextVal)"
		 let empCont = defaults.string(forKey: "empCont")
		 empContributionVal = empCont ?? ""
		 empContribution.text = "$\(empContributionVal)"
		 let tat = defaults.string(forKey: "tat")
		 totalAccrualVal = tat ?? ""
		 totalAccrualText.text = "$\(totalAccrualVal)"
		 let cct = defaults.string(forKey: "cct")
		 let isOver10yr = defaults.bool(forKey: "oy")
		 isOver10Years = isOver10yr
		 actualAnnualAccrualVal = cct ?? ""
		 if isOver10Years {
			 segmentedControl.selectedSegmentIndex = 0
			 if let index = over10Years.list.firstIndex(where: {$0 == cct}) {
				 currentContributionsText.text = contributionList.list[index]
			 }
		 } else {
			 segmentedControl.selectedSegmentIndex = 1
			 if let index = under10Years.list.firstIndex(where: {$0 == cct}) {
				 currentContributionsText.text = contributionList.list[index]
			 }
		 }
		 let ft = defaults.string(forKey: "ft")
		 fulltimeText.text = ft
		 let ra = defaults.string(forKey: "ra")
		 retirementAgeTextField.text = ra
		 let si = defaults.string(forKey: "si")
		 salaryIncreaseText.text = si
		 let rs = defaults.integer(forKey: "rs")
		 let dv = defaults.string(forKey: "dobVal")
		 let sv = defaults.string(forKey: "stateVal")
		 dobDate = String().toDate(dateString: dv ?? "")
		 stateDate = String().toDate(dateString: sv ?? "")
		 birthDateText.text = dobDate.toString(format: "dd MMM yyyy")
		 statementDate.text = stateDate.toString(format: "dd MMM yyyy")
		 recordContributionSelected = rs
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	// MARK: - PickerView Delegate
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if retirementAgeTextField.isFirstResponder {
				return retirementAge.list.count
		} else {
				return contributionList.list.count
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if retirementAgeTextField.isFirstResponder {
				return retirementAge.list[row]
		} else {
				return contributionList.list[row]
		}
	}
	
	
	//MARK: - UITextFieldDelegate
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == currentContributionsText {
				pickerView.reloadAllComponents()
				pickerView.isDatePIcker = false
				currentContributionsText.inputView = pickerView
			if isOver10Years {
				if let index = over10Years.list.firstIndex(where: {$0 == actualAnnualAccrualVal}) {
					pickerView.selectRow(index, inComponent: 0, animated: true)
				}
				
			} else {
				if let index = under10Years.list.firstIndex(where: {$0 == actualAnnualAccrualVal}) {
				pickerView.selectRow(index, inComponent: 0, animated: true)
				}
			}
			
		} else if textField == retirementAgeTextField{
					pickerView.reloadAllComponents()
			pickerView.isDatePIcker = false
			retirementAgeTextField.inputView = pickerView
			if let index = retirementAge.list.firstIndex(where: {$0 == retirementAgeTextField.text}) {
			pickerView.selectRow(index, inComponent: 0, animated: true)
			}
		} else if textField == birthDateText {
			pickerView.isDatePIcker = true
			pickerView.datePicker.date = dobDate
			birthDateText.inputView = pickerView.datePicker
		} else if textField ==  statementDate {
			pickerView.isDatePIcker = true
			pickerView.datePicker.date = stateDate
			print("check state --> \(stateDate)")
			statementDate.inputView = pickerView.datePicker
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if salaryIncreaseText == textField {
			salaryIncreaseText.text = textField.text ?? ""
		} else if fasText == textField {
			var text = textField.text
			if let i = text?.firstIndex(of: "$") {
				text?.remove(at: i)//10
					fasTextVal = text ?? ""
			} else {
				fasTextVal = textField.text ?? ""
			}
			
		} else if empContribution == textField {
			var text = textField.text
			if let i = text?.firstIndex(of: "$") {
				text?.remove(at: i)//10
					empContributionVal = text ?? ""
			} else {
				empContributionVal = textField.text ?? ""
			}
		} else if totalAccrualText == textField {
			var text = textField.text
			if let i = text?.firstIndex(of: "$") {
					text?.remove(at: i)
					totalAccrualVal = text ?? ""
				} else {
					totalAccrualVal = textField.text ?? ""
				}
		}
	}
        
    @IBAction func calcButton(_ sender: Any) {
			saveLocalData()
	
		
				calculatedSaveData =	CalculatedSaveData(isOver10Years: isOver10Years, recordContributionSelected: recordContributionSelected, empContributionVal: empContributionVal, totalAccrualVal: totalAccrualVal, retirementAgeText: retirementAgeTextField.text ?? "", ambText: ambText.text ?? "", salaryIncreaseText: salaryIncreaseText.text ?? "", fasTextVal: fasTextVal, actualAnnualAccrualVal: actualAnnualAccrualVal, dobDate: dobDate, stateDate: stateDate)
			performSegue(withIdentifier: "segueToDetails", sender: nil)
    }
    
    @IBAction func loadButton(_ sender: Any) {
			loadSaveData()
    }
	
	fileprivate func showAlert(message: String) {
		let ac = UIAlertController(title: "Calculated Data", message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		ac.addAction(okAction)
		present(ac, animated: true, completion: nil)
	}
    
    
  @IBAction func indexChanged(_ sender: Any) {
      switch segmentedControl.selectedSegmentIndex {
      case 0:
				if currentContributionsText.text?.count ?? 0 > 0 {
					print("segmenteed 0")
					isOver10Years = true
					actualAnnualAccrualVal = over10Years.list[recordContributionSelected]
				}
      case 1:
				if currentContributionsText.text?.count ?? 0 > 0 {
					print("segmenteed 1")
					isOver10Years = false
					actualAnnualAccrualVal = under10Years.list[recordContributionSelected]
				}
      default:
          break
        }
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segueToDetails" {
			let vc = segue.destination as! PensionCalculationDetailVC
			vc.resultData = resultData
			vc.calculatedSaveData = calculatedSaveData
		}
	}
	
	
	
}

extension PensionViewController: ToolbarPickerViewDelegate {

	
	fileprivate func doneActionForContribution(row: Int) {
		currentContributionsText.text = contributionList.list[row]
		recordContributionSelected = row
		if isOver10Years {
			actualAnnualAccrualVal = over10Years.list[row]
			print("Check over 10 years: \(	over10Years.list[row])")
		} else {
			actualAnnualAccrualVal = under10Years.list[row]
			print("Check under 10 years: \(	under10Years.list[row])")
		}
	}

    func didTapDoneP() {
			let row = self.pickerView.selectedRow(inComponent: 0)
			pickerView.selectRow(row, inComponent: 0, animated: false)
			if retirementAgeTextField.isFirstResponder {
				retirementAgeTextField.text = retirementAge.list[row]
			} else {
				doneActionForContribution(row: row)
			}
			view.endEditing(true)
			pickerView.reloadAllComponents()
    }

    func didTapCancelP() {
			view.endEditing(true)
    }
	
	func didTapDoneDP() {
		let formatter = DateFormatter()
		 formatter.dateFormat = "dd MMM yyyy"
		let dateString = formatter.string(from: pickerView.datePicker.date)
		if birthDateText.isFirstResponder {
			dobDate = pickerView.datePicker.date
			birthDateText.text = dateString
		} else if statementDate.isFirstResponder  {
			stateDate = pickerView.datePicker.date
			statementDate.text = dateString
		}
		 self.view.endEditing(true)
	}
	
	func didTapCancelDP() {
		view.endEditing(true)
	}
}

