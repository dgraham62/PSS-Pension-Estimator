//
//  CalculationModel.swift
//  Pss Pension Estimator
//
//  Created by Israel Mayor on 7/6/20.
//  Copyright © 2020 David Graham. All rights reserved.
//

import Foundation

struct PensionTable {
	let age: Int
	let pf: Double
}

struct PensionList {
	let list: [PensionTable]
		init() {
			list = 	[PensionTable(age: 60, pf: 11.0),
								PensionTable(age: 61, pf: 10.8),
								PensionTable(age: 62, pf: 10.6),
								PensionTable(age: 63, pf: 10.4),
								PensionTable(age: 64, pf: 10.2),
								PensionTable(age: 65, pf: 10.0),
								PensionTable(age: 66, pf: 9.8),
								PensionTable(age: 67, pf: 9.6),
								PensionTable(age: 68, pf: 9.4),
								PensionTable(age: 69, pf: 9.2),
								PensionTable(age: 70, pf: 9.0),
								PensionTable(age: 71, pf: 8.8),
								PensionTable(age: 72, pf: 8.6),
								PensionTable(age: 73, pf: 8.4),
								PensionTable(age: 74, pf: 8.2),
								PensionTable(age: 75, pf: 8.0)
								]
		}
}

struct TaxPayable {
	let taxableIncomeStart: Double
	let taxableIncomeEnd: Double
	let taxOnPlus: Double
	let taxOnCents: Double
	let taxOnOver: Double
}

struct TaxPayableList {
	let list: [TaxPayable]
	init() {
		list = [TaxPayable(taxableIncomeStart: 0, taxableIncomeEnd: 18200, taxOnPlus: 0, taxOnCents: 0, taxOnOver: 0),
						TaxPayable(taxableIncomeStart: 18201, taxableIncomeEnd: 37000, taxOnPlus: 0, taxOnCents: 0.19, taxOnOver: 18200),
						TaxPayable(taxableIncomeStart: 37001, taxableIncomeEnd: 90000, taxOnPlus: 3572, taxOnCents: 0.325, taxOnOver: 37000),
						TaxPayable(taxableIncomeStart: 90001, taxableIncomeEnd: 180000, taxOnPlus: 20797, taxOnCents: 0.37, taxOnOver: 90000),
						TaxPayable(taxableIncomeStart: 180001, taxableIncomeEnd: 100000000, taxOnPlus: 54097, taxOnCents: 0.45, taxOnOver: 180000)
		]
	}
}


/*
//	var isOver10Years = Bool()
//	var recordContributionSelected = Int()

	
	
	var empContributionVal = ""
	var totalAccrualVal = ""
	
	var retirementAgeText  = "" //retirementAgeTextField
	var ambText = "" // ambTextTextField
	var salaryIncreaseText = "" //salaryIncreaseTextField
	var fasTextVal = ""
	var actualAnnualAccrualVal = ""
	
	var dobDate = Date()
	var stateDate = Date()
	
*/

struct CalculatedSaveData {
	var isOver10Years: Bool?
	var recordContributionSelected: Int?
	let empContributionVal: String?
	let totalAccrualVal: String?
	var retirementAgeText: String?
	let ambText: String?
	var salaryIncreaseText: String?
	let fasTextVal: String?
	var actualAnnualAccrualVal: String?
	let dobDate: Date?
	let stateDate: Date?
	
	init(isOver10Years: Bool? = nil, recordContributionSelected: Int? = nil, empContributionVal: String? = nil, totalAccrualVal: String? = nil, retirementAgeText: String? = nil, ambText: String? = nil, salaryIncreaseText: String? = nil, fasTextVal: String? = nil, actualAnnualAccrualVal: String? = nil, dobDate: Date? = nil, stateDate: Date? = nil) {
		
		self.isOver10Years = isOver10Years
		self.recordContributionSelected = recordContributionSelected
		self.empContributionVal = empContributionVal
		self.totalAccrualVal = totalAccrualVal
		self.retirementAgeText = retirementAgeText
		self.ambText = ambText
		self.salaryIncreaseText = salaryIncreaseText
		self.fasTextVal = fasTextVal
		self.actualAnnualAccrualVal = actualAnnualAccrualVal
		self.dobDate = dobDate
		self.stateDate = stateDate
	}
	
	
	
}

struct ResultData {
	let actAnnualText: String?
	let abmIncrease: String?
	let totalAbmAtRetirement: String?
	let yearsToRetirement: String?
	let eastFASAtRetirement: String?
	let fasXABM: String?
	let grossPension: String?
	let pensionFactor: String?
	let untaxedPortion: String?
	let taxableIncome60Plus: String?
	let taxable: String?
	let medicarePayable: String?
	let totalTaxLiability: String?
	let tenTaxOffset: String?
	let taxLiabilityAfterOffset: String?
	let netPension: String?
	let fornight: String?
	
	init(actAnnualText: String? = nil, abmIncrease: String? = nil, totalAbmAtRetirement: String? = nil, yearsToRetirement: String? = nil, eastFASAtRetirement: String? = nil, fasXABM: String? = nil, grossPension: String? = nil, pensionFactor: String? = nil, untaxedPortion: String? = nil, taxableIncome60Plus: String? = nil, taxable: String? = nil, medicarePayable: String? = nil, totalTaxLiability: String? = nil, tenTaxOffset: String? = nil, taxLiabilityAfterOffset: String? = nil, netPension
		: String? = nil, fornight: String? = nil) {
		self.actAnnualText = actAnnualText
		self.abmIncrease = abmIncrease
		self.totalAbmAtRetirement = totalAbmAtRetirement
		self.yearsToRetirement = yearsToRetirement
		self.eastFASAtRetirement = eastFASAtRetirement
		self.fasXABM = fasXABM
		self.grossPension = grossPension
		self.pensionFactor = pensionFactor
		self.untaxedPortion = untaxedPortion
		self.taxableIncome60Plus = taxableIncome60Plus
		self.taxable = taxable
		self.medicarePayable = medicarePayable
		self.totalTaxLiability = totalTaxLiability
		self.tenTaxOffset = tenTaxOffset
		self.taxLiabilityAfterOffset = taxLiabilityAfterOffset
		self.netPension = netPension
		self.fornight = fornight
	}
}


struct ContributionList {
	let list: [String]
	init() {
		list = ["0%", "2%", "3%", "4%", "5%", "6%", "7%", "8%", "9%", "10%"]
	}
}

struct Under10Years {
	let list: [String]
	init() {
		list = ["0.11","0.15", "0.17", "0.19", "0.21", "0.22", "0.23", "0.24", "0.25", "0.26"]
	}
}

struct Over10Years {
	let list: [String]
	init() {
		list = ["0.11", "0.15", "0.17", "0.19", "0.21", "0.23", "0.25", "0.27", "0.29", "0.31"]
	}
}

struct PensionFactor {
	let list: [String]
	init() {
		list = ["11.0", "10.8", "10.6", "10.4", "10.2", "10.0", "9.8", "9.6", "9.4", "9.2, 9.0", "8.8", "8,6", "8.4", "8.2", "7.0"]
	}
}

struct RetirementAge {
	var list: [String]
	init() {
		list = ["60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75"]
	}
}
