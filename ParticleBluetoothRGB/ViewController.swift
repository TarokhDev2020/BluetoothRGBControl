//
//  ViewController.swift
//  ParticleBluetoothRGB
//
//  Created by Tarokh on 11/10/20.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {

    // define some variables
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    // define some @IBOutlets
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    // Characteristics
    private var redChar: CBCharacteristic?
    private var greenChar: CBCharacteristic?
    private var blueChar: CBCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // define some functions
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central state is not powerd on!")
        }
        else {
            print("Central Scanning for", ParticlePeripheral.particleLEDServiceUUID)
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.centralManager.stopScan()
        self.peripheral = peripheral
        self.peripheral.delegate = self
        self.centralManager.connect(self.peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your particle board")
            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleLEDServiceUUID {
                    print("LED service found")
                    peripheral.discoverCharacteristics([ParticlePeripheral.redLEDCharacteristicUUID, ParticlePeripheral.greenLEDCharacteristicUUID, ParticlePeripheral.blueLEDCharacteristicUUID], for: service)
                    return
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ParticlePeripheral.redLEDCharacteristicUUID {
                    print("Red LED characteristic found!")
                    redChar = characteristic
                    redSlider.isEnabled = true
                }
                else if characteristic.uuid == ParticlePeripheral.greenLEDCharacteristicUUID {
                    print("Green LED characteristic found!")
                    greenChar = characteristic
                    greenSlider.isEnabled = true
                }
                else if characteristic.uuid == ParticlePeripheral.blueLEDCharacteristicUUID {
                    print("Blue LED characteristic found!")
                    blueChar = characteristic
                    blueSlider.isEnabled = true
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            print("Disconnected")
            redSlider.isEnabled = false
            redSlider.value = 0
            greenSlider.isEnabled = false
            greenSlider.value = 0
            blueSlider.isEnabled = false
            blueSlider.value = 0
            self.peripheral = nil
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID)
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    @IBAction func redSliderValueChanged(_ sender: UISlider) {
        print("Red:", redSlider.value)
        let slider:UInt8 = UInt8(redSlider.value)
        writeLEDValueToChar(withcharacteristic: redChar!, withValue: Data([slider]))
    }
    
    @IBAction func greenSliderValueChanged(_ sender: UISlider) {
        print("Green: ", greenSlider.value)
        let slider:UInt8 = UInt8(greenSlider.value)
        writeLEDValueToChar(withcharacteristic: greenChar!, withValue: Data([slider]))
    }
    
    @IBAction func blueSliderValueChanged(_ sender: UISlider) {
        print("Blue: ", blueSlider.value)
        let slider:UInt8 = UInt8(blueSlider.value)
        writeLEDValueToChar(withcharacteristic: blueChar!, withValue: Data([slider]))
    }
    
    private func writeLEDValueToChar(withcharacteristic characteristic: CBCharacteristic, withValue value: Data) {
        if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {
            peripheral.writeValue(value, for: characteristic, type: .withoutResponse)
        }
    }
    
}

