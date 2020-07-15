//
//  PageTwoViewController.swift
//  Pss Pension Estimator
//
//  Created by David Graham on 16/6/20.
//  Copyright © 2020 David Graham. All rights reserved.
//

import UIKit

class ObservedLabelAnimate: SpringLabel {

	override var text: String? {
		didSet {
			if let text = text {
				if oldValue != text {
					animation = "fadeInLeft"
					duration = 1.2
					animate()
				}
			}
		}
	}
}

class PensionCalculationDetailVC: UIViewController, PensionCalculatorFilterVCDelegate{
	
	@IBOutlet weak var actAnnualAccText: ObservedLabelAnimate!
	@IBOutlet weak var totalABMIncreaseFromLastState: ObservedLabelAnimate!
	@IBOutlet weak var totalAbmAtRetirementLabel: ObservedLabelAnimate!
	@IBOutlet weak var yearsToRetirement: ObservedLabelAnimate!
	@IBOutlet weak var eastFASAtRetirementLabel: ObservedLabelAnimate!
	@IBOutlet weak var fasXABMLabel: ObservedLabelAnimate!
	@IBOutlet weak var grossPension: ObservedLabelAnimate!
	@IBOutlet weak var pensionFactor: ObservedLabelAnimate!
	@IBOutlet weak var untaxedPortion: ObservedLabelAnimate!
	@IBOutlet weak var taxableIncome60PlusLabel: ObservedLabelAnimate!
	@IBOutlet weak var taxableLabel: ObservedLabelAnimate!
	@IBOutlet weak var medicarePayableLabel: ObservedLabelAnimate!
	@IBOutlet weak var totalTaxLiabilityLabel: ObservedLabelAnimate!
	@IBOutlet weak var tenTaxOffsetLabel: ObservedLabelAnimate!
	@IBOutlet weak var taxLiabilityAfterOffsetLabel: ObservedLabelAnimate!
	@IBOutlet weak var netPensionLabel: ObservedLabelAnimate!
	@IBOutlet weak var fornightLabel: ObservedLabelAnimate!
	
	var pf = PensionList()
	var tp = TaxPayableList()
	var resultData = ResultData()
	var calculatedSaveData = CalculatedSaveData()

    override func viewDidLoad() {
			super.viewDidLoad()
			calculateData()
			updateData()
    }
	
	override func willMove(toParent parent: UIViewController?) {
			super.willMove(toParent: parent)
			if parent == nil {
				print("pressed back")
			}
	}
	
	@IBAction func settingBarBtnPressed(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: "modalToFilter", sender: nil)
	}
	
	fileprivate func calculateData() {
		resultData = ResultData(actAnnualText: calculatedSaveData.actualAnnualAccrualVal, abmIncrease: getABMIncrease(), totalAbmAtRetirement: getTotalABMAtRetirement(), yearsToRetirement: getYearsToRetirementValue(), eastFASAtRetirement: getEastFASAtRetirement(), fasXABM: getFASxABM(), grossPension: getGrossPension(), pensionFactor: getPensionFactor(), untaxedPortion: getUntaxedPortion(), taxableIncome60Plus: getTaxableIncome60Plus(), taxable: getTaxPayable(), medicarePayable: getMedicarePayable(), totalTaxLiability: getTotalTaxLiability(), tenTaxOffset: get10TaxOffest(), taxLiabilityAfterOffset: getTaxLiabilityAfterOffset(), netPension: getNetPension60Plus(), fornight: getFornightlyPension())
	}
	
	fileprivate func checkIfNumberIsNan(double: Double?) -> Bool {
		if double?.isNaN ?? Bool() {
				return true
			} else {
				return false
		}
	}
	
	fileprivate func updateData() {
			if resultData.actAnnualText == "" {
					actAnnualAccText.text = "0"
			} else {
					actAnnualAccText.text = resultData.actAnnualText
			}
			totalABMIncreaseFromLastState.text = resultData.abmIncrease
			totalAbmAtRetirementLabel.text = String(format: "%.2f", resultData.totalAbmAtRetirement?.doubleValue ?? 0)
			yearsToRetirement.text = resultData.yearsToRetirement
			eastFASAtRetirementLabel.text = "$\(resultData.eastFASAtRetirement?.doubleValue.withCommas() ?? "")"
			fasXABMLabel.text = "$\(resultData.fasXABM?.doubleValue.withCommas() ?? "")"
			grossPension.text = checkIfNumberIsNan(double: resultData.grossPension?.doubleValue) ? "$0" : "$\(resultData.grossPension?.doubleValue.withCommas() ?? "")"
			pensionFactor.text = resultData.pensionFactor
			untaxedPortion.text =  checkIfNumberIsNan(double: resultData.untaxedPortion?.doubleValue) ? "$0" : String(format: "%.2f", resultData.untaxedPortion?.doubleValue ?? 0) + "%"
			taxableIncome60PlusLabel.text = checkIfNumberIsNan(double: resultData.taxableIncome60Plus?.doubleValue) ? "$0" : "$\(resultData.taxableIncome60Plus?.doubleValue.withCommas() ?? "")"
			taxableLabel.text = "$\(resultData.taxable?.doubleValue.withCommas() ?? "")"
			medicarePayableLabel.text = "$\(resultData.medicarePayable?.doubleValue.withCommas() ?? "")"
			totalTaxLiabilityLabel.text = "$\(resultData.totalTaxLiability?.doubleValue.withCommas() ?? "")"
			tenTaxOffsetLabel.text = checkIfNumberIsNan(double: resultData.tenTaxOffset?.doubleValue) ? "$0" : "$\(resultData.tenTaxOffset?.doubleValue.withCommas() ?? "")"
			taxLiabilityAfterOffsetLabel.text = checkIfNumberIsNan(double: resultData.taxLiabilityAfterOffset?.doubleValue) ? "$0" : "$\(resultData.taxLiabilityAfterOffset?.doubleValue.withCommas() ?? "")"
			netPensionLabel.text =  checkIfNumberIsNan(double: resultData.netPension?.doubleValue) ? "$0" : "$\(resultData.netPension?.doubleValue.withCommas() ?? "")"
			fornightLabel.text = checkIfNumberIsNan(double: resultData.fornight?.doubleValue) ? "$0" : "$\(resultData.fornight?.doubleValue.withCommas() ?? "")"
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "modalToFilter" {
			let vc = segue.destination as! PensionCalculatorFilterVC
			vc.resultData = resultData
			vc.calculatedSaveData = calculatedSaveData
			vc.delegate = self
		}
	}
	
	// MARK: - PensionCalculatorFilterVCDelegate
	
	
	func updateData(retirementText: String, recordContributionSelected: Int, salTextField: String, actualAnnualAccrualVal: String, isOver10Years: Bool) {
		calculatedSaveData.retirementAgeText = retirementText
		calculatedSaveData.recordContributionSelected = recordContributionSelected
		calculatedSaveData.salaryIncreaseText = salTextField
		calculatedSaveData.actualAnnualAccrualVal = actualAnnualAccrualVal
		calculatedSaveData.isOver10Years = isOver10Years
		calculateData()
		updateData()
	}
	
fileprivate func getFornightlyPension() -> String {
	let a = getNetPension60Plus().doubleValue / 26
	return String(format: "%.0f", a)
}

fileprivate func getTaxLiabilityAfterOffset() -> String {
	let g = getGrossPension().doubleValue
	let t = getTotalTaxLiability().doubleValue
	let to = get10TaxOffest().doubleValue
	let i: Double
	let a: Double
	if g < 100000 {
		i = 0
		let aa = getTotalTaxLiability().doubleValue
		let tt = get10TaxOffest().doubleValue
		let z:Double = aa - tt
		if z < 0 {
			a = 0
		} else {
			a = z
		}
	} else {
		i = (g - 100000) / 10
		a = t - to + i
	}
	return String(format: "%.0f", a)
}

fileprivate func getNetPension60Plus() -> String {
	let g = getGrossPension().doubleValue
	let t = getTaxLiabilityAfterOffset().doubleValue
	let a = g - t
	return String(format: "%.0f", a)
}

fileprivate func get10TaxOffest() -> String {
	let t = getTaxableIncome60Plus().doubleValue
	let a = t * 0.1
	return String(format: "%.0f", a)
}

fileprivate func getTotalTaxLiability() -> String {
	let t = getTaxPayable().doubleValue
	let m = getMedicarePayable().doubleValue
	let a = t + m
	return String(format: "%.0f", a)
}

fileprivate func getMedicarePayable() -> String {
	let t:Double = getTaxableIncome60Plus().doubleValue
	let a:Double
	if t >= 26668 {
		a = t * 0.02
		return String(format: "%.0f", a)
	} else {
		return "0"
	}
}

fileprivate func getTaxPayable() -> String {
	let t:Double = getTaxableIncome60Plus().doubleValue //40000 --> 4547
	
	if let index = tp.list.firstIndex(where: {t >= $0.taxableIncomeStart && t <= $0.taxableIncomeEnd}) {
		let m = t - tp.list[index].taxOnOver
		let x = m * tp.list[index].taxOnCents
		let a = x + tp.list[index].taxOnPlus
			return String(format: "%.0f", a)
	} else {
		return ""
	}
}

fileprivate func getTaxableIncome60Plus() -> String {
	let g = getGrossPension().doubleValue
	let u = getUntaxedPortion().doubleValue
	let a = g * u / 100
	return String(format: "%.0f", a)
}

fileprivate func getUntaxedPortion() -> String {
	let e =  calculatedSaveData.empContributionVal?.doubleValue ?? 0
	let t = calculatedSaveData.totalAccrualVal?.doubleValue ?? 0
	print("e --> \(e)")
	print("t --> \(t)")
	let a = e / t * 100
	print("a --> \(a)")
	return String(format: "%.8f", a)
}

fileprivate func getGrossPension() -> String {
	let f = getFASxABM().doubleValue
	let p = getPensionFactor().doubleValue
	let a = f / p
	return String(format: "%.0f", a)
}

fileprivate func getPensionFactor() -> String {
	let age = Int(calculatedSaveData.retirementAgeText ?? "")
	let a: Double
	if 	let index = pf.list.firstIndex(where: {$0.age == age}) {
		a = pf.list[index].pf
	} else {
		a = 0
	}
	return String(format: "%.2f", a)
}

fileprivate func getFASxABM() -> String {
	let a = getTotalABMAtRetirement().doubleValue
	let e = getEastFASAtRetirement().doubleValue
	let x = a * e
	return String(format: "%.0f", x)
}

fileprivate func getTotalABMAtRetirement() -> String {
	let c = calculatedSaveData.ambText?.doubleValue ?? 0
	let a = Double(getABMIncrease()) ?? 0
	let x = c + a
	return String(format: "%.8f", x)
}

fileprivate func getEastFASAtRetirement() -> String{
	let s = calculatedSaveData.salaryIncreaseText?.doubleValue ?? 0
	let y = getYearsToRetirementValue().doubleValue
	let f = calculatedSaveData.fasTextVal?.doubleValue ?? 0
	let r = s / 100
	let a = f * (pow((1 + r / 1), (y * 1)))
	return String(format: "%.0f", a)
}

fileprivate func getABMIncrease() -> String {
	let a = calculatedSaveData.actualAnnualAccrualVal?.doubleValue ?? 0
	let y =	getYearsToRetirementValue().doubleValue
	let b = Double(a * y)
	return String(format: "%.2f", b)
}

fileprivate func addRetirementDateWithDOB(retirementAge: String, dob: Date) -> Date {
	var dayComponent	= DateComponents()
	dayComponent.year = Int(retirementAge)
	print("check retire \(retirementAge)")
	return Calendar.current.date(byAdding: dayComponent, to: dob) ?? Date()
}

fileprivate func getYearsToRetirementValue() -> String {
	let components = Calendar.current.dateComponents([.year, .month, .day], from: calculatedSaveData.stateDate ?? Date(), to: addRetirementDateWithDOB(retirementAge: calculatedSaveData.retirementAgeText ?? "", dob: calculatedSaveData.dobDate ?? Date()))
	var totalYears = Double(components.year!)
	totalYears += Double(components.month!) / 12.0
	totalYears += Double(components.day!) / 365.25
	let num = String(format: "%.3f", totalYears).doubleValue
	var dexample: Decimal =  Decimal(num) //1.345//Decimal(num)
	var drounded: Decimal = Decimal()
	NSDecimalRound(&drounded, &dexample, 2, .down)
	return "\(drounded)"
}
}
