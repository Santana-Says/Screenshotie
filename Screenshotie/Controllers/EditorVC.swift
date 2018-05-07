//
//  BarEditorVC.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 4/24/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

class EditorVC: UIViewController {
	//MARK: - IBOutlets
	
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
	
	@IBOutlet weak var toolBoxBtn: UIButton!
	@IBOutlet weak var toolsView: UIView!
	@IBOutlet weak var iconToggle: UISegmentedControl!
	
	private var isOpen = false
	var screenshot: UIImage?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imageView.image = screenshot
		timeLbl.text = DateFormatter.localizedString(from: timePicker.date, dateStyle: .none, timeStyle: .short)
		roundCorners()
    }
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	//MARK: IBActions
	
	@IBAction func toolBoxBtnAction(_ sender: Any) {
		toggleToolbox()
		
	}
	@IBAction func shareBtnAction(_ sender: Any) {
		toggleToolbox()
		toolBoxBtn.isHidden = true
		
		captureScreenshot()
		if let image = screenshot {
			let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
			present(vc, animated: true)
		}
		toolBoxBtn.isHidden = false
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
	
	//MARK: Helper Functions
	
	private func toggleToolbox() {
		if isOpen {
			toolsView.isHidden = true
			isOpen = false
		} else {
			toolsView.isHidden = false
			isOpen = true
		}
	}
	
	private func captureScreenshot() {
		
		let layer = UIApplication.shared.keyWindow!.layer
		let scale = UIScreen.main.scale
		
		// Creates UIImage of same size as view
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
		layer.render(in: UIGraphicsGetCurrentContext()!)
		screenshot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
	}
	
	private func roundCorners() {
		toolsView.layer.cornerRadius = 10
		toolBoxBtn.layer.cornerRadius = toolBoxBtn.frame.width / 2
		toolsView.layer.masksToBounds = true
	}
}
