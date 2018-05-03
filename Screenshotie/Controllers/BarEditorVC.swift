//
//  BarEditorVC.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 4/24/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

class BarEditorVC: UIViewController {
	@IBOutlet weak var statusBarView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var signalImg: UIImageView!
	@IBOutlet weak var carrierImg: UIImageView!
	@IBOutlet weak var wifiImg: UIImageView!
	@IBOutlet weak var timeLbl: UILabel!
	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var alarmImg: UIImageView!
	@IBOutlet weak var bluetoothImg: UIImageView!
	@IBOutlet weak var batteryImg: UIImageView!
	@IBOutlet weak var chargingImg: UIImageView!
	@IBOutlet weak var iconToggle: UISegmentedControl!
	@IBOutlet weak var toolsView: UIView!
	
	var screenshot: UIImage?
	var isOpen = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imageView.image = screenshot
		timeLbl.text = DateFormatter.localizedString(from: timePicker.date, dateStyle: .none, timeStyle: .short)
    }
	
	override var prefersStatusBarHidden: Bool {
		return true
	}

	@IBAction func toolBoxBtnAction(_ sender: Any) {
		if isOpen {
			toolsView.isHidden = true
			isOpen = false
		} else {
			toolsView.isHidden = false
			isOpen = true
		}
		
	}
	
	@IBAction func timePickerChanged(_ sender: UIDatePicker) {
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateStyle = .none
		dateFormatter.timeStyle = .short
		
		let strTime = dateFormatter.string(from: timePicker.date)
		timeLbl.text = strTime
	}
	
	@IBAction func statusIconToggled(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			alarmImg.isHidden = false
		case 1:
			bluetoothImg.isHidden = false
		case 2:
			chargingImg.isHidden = false
		default:
			alarmImg.isHidden = true
			bluetoothImg.isHidden = true
			chargingImg.isHidden = true
		}
	}
}
