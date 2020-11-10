//
//  ParticlePeripheral.swift
//  ParticleBluetoothRGB
//
//  Created by Tarokh on 11/10/20.
//

import Foundation
import CoreBluetooth

class ParticlePeripheral: NSObject {
    
    public static let particleLEDServiceUUID = CBUUID.init(string: "b4250400-fb4b-4746-b2b0-93f0e61122c6")
    public static let redLEDCharacteristicUUID = CBUUID.init(string: "b4250401-fb4b-4746-b2b0-93f0e61122c6")
    public static let greenLEDCharacteristicUUID = CBUUID.init(string: "b4250402-fb4b-4746-b2b0-93f0e61122c6")
    public static let blueLEDCharacteristicUUID = CBUUID.init(string: "b4250402-fb4b-4746-b2b0-93f0e61122c6")
    
}
