//
//  Constants.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 5/24/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct GAD {
	let APP_ID = "ca-app-pub-8634347401168086~2150700679"
	
	let BANNER_AD_ID = "ca-app-pub-8634347401168086/3974918236"
	let TEST_BANNER_AD_ID = "ca-app-pub-3940256099942544/2934735716"
	
	let INTERSTITIAL_AD_ID = "ca-app-pub-8634347401168086/3718229912"
	let TEST_INTERSTITIAL_AD_ID = "ca-app-pub-3940256099942544/4411468910"
	
	let TESTERS = [
		kGADSimulatorID,
		"b5cb93d8dabd109b2e7e31197ebeb1d5",	//Jeff Test
		"6723689deb3d914ffca3f87b8272d1f8"	//Jeff Main
	] as [Any]
}

struct ToolBoxImages {
	let signalIconImages = [#imageLiteral(resourceName: "Signal 1:4"), #imageLiteral(resourceName: "Signal 2:4"), #imageLiteral(resourceName: "Signal 3:4"), #imageLiteral(resourceName: "Signal 4:4")]
	let carrierIconImages = [#imageLiteral(resourceName: "AT&T")]
	let wifiIconImages = [#imageLiteral(resourceName: "Wifi 1:3"), #imageLiteral(resourceName: "Wifi 2:3"), #imageLiteral(resourceName: "Wifi 3:3")]
	let batteryIconImages = [#imageLiteral(resourceName: "Battery 10%"), #imageLiteral(resourceName: "Battery 50%"), #imageLiteral(resourceName: "Battery 100%")]
	let batteryChargingIconImages = [#imageLiteral(resourceName: "Battery Charging 10%"), #imageLiteral(resourceName: "Battery Charging 50%"), #imageLiteral(resourceName: "Battery Charging 100%")]
}

struct StatusBarImages {
	let signalIconImages = [#imageLiteral(resourceName: "Wifi 0"), #imageLiteral(resourceName: "Wifi 1"), #imageLiteral(resourceName: "Wifi 2"), #imageLiteral(resourceName: "Wifi 3")]
	let serviceProviders = ["AT&T", "MetroPCS", "Sprint", "T-Mobile", "Verizon"]
	let wifiIconImages = [#imageLiteral(resourceName: "Signal 0"), #imageLiteral(resourceName: "Signal 1"), #imageLiteral(resourceName: "Signal 2"), #imageLiteral(resourceName: "Signal 3"),#imageLiteral(resourceName: "Signal 4")]
	let batteryIconImages = [#imageLiteral(resourceName: "Battery 10"), #imageLiteral(resourceName: "Battery 50"), #imageLiteral(resourceName: "Battery 100")]
	let batteryChargingIconImages = [#imageLiteral(resourceName: "Battery Charging 10"), #imageLiteral(resourceName: "Battery Charging 50"), #imageLiteral(resourceName: "Battery Charging 100")]
	let batteryChargingIconImagesX = [#imageLiteral(resourceName: "Battery X Charging 10%"), #imageLiteral(resourceName: "Battery X Charging 50%"), #imageLiteral(resourceName: "Battery X Charging 100%")]
}
