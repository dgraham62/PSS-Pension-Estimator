//
//  ToolbarPickerView.swift
//  Nogard Global
//
//  Created by Israel Mayor on 6/13/20.
//  Copyright © 2020 Istrael Mayor. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ToolbarPickerViewDelegate {
	@objc optional func didTapDoneP()
	@objc optional func didTapCancelP()
	@objc optional func didTapDoneDP()
	@objc optional func didTapCancelDP()
}

class ToolbarPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
	  public private(set) var datePicker = UIDatePicker()
		public var isDatePIcker = false
		//public var selectedDate = Date()
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
			let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44.0)))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
				datePicker.datePickerMode = .date
				//datePicker.date = selectedDate
			
		//	print("selected ---> \(selectedDate)")
        self.toolbar = toolBar
    }

    @objc func doneTapped() {
			if isDatePIcker {
				self.toolbarDelegate?.didTapDoneDP?()
			} else {
				self.toolbarDelegate?.didTapDoneP?()
			}
    }

    @objc func cancelTapped() {
			if isDatePIcker {
				self.toolbarDelegate?.didTapCancelDP?()
			} else {
				self.toolbarDelegate?.didTapCancelP?()
			}
    }
}
