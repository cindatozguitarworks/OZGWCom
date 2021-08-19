//
//  BLEManager.swift
//  SwiftUIBLUE
//
//  Created by Cynthia Anderson on 9/9/20.
//

import Foundation
import CoreBluetooth



class BLEManager: NSObject, ObservableObject, CBPeripheralDelegate, CBCentralManagerDelegate  {
   
   var myCentral: CBCentralManager!
   private var myPeripheral: CBPeripheral!
   
   //Characteristics
  private var redCharacteristic:  CBCharacteristic!
  private var greenCharacteristic:  CBCharacteristic!
  private var dataStringCharacteristic: CBCharacteristic!
 
   
   @Published var peripherals = [Peripheral]()
   
   
   @Published var isSwitchedOn = false
   @Published var buttonZeroState = " OFF "
   @Published var buttonZeroisOn: Bool = false
   @Published var buttonOneState = " OFF "
   @Published var buttonOneisOn: Bool = false
   
   @Published var redLEDState = " OFF "
   @Published var greenLEDState = " OFF "
   @Published var redLEDisOn: Bool = false
   @Published var greenLEDisOn: Bool = false
 //  @Published var
   @Published var dataLine: String =  "0123456"
 
   @Published var convertedDataLine: [UInt8] = [00, 01,02,03,04,05,06,07,08,09,10,11]
   @Published var receivedDataLine : String =  "test"
   
   
   //MARK: -  ** INIT
   override init() {
      super.init()
      
      myCentral = CBCentralManager(delegate: self, queue: nil)
      myCentral.delegate = self
      
   }//init
   
   //MARK: -  ** DID UPDATE STATE
   //MARK : - MAKE MORE ROBUST
   func centralManagerDidUpdateState(_ central: CBCentralManager) {
      if central.state == .poweredOn {
         isSwitchedOn = true
         myCentral.scanForPeripherals(withServices: [tiSimpleLinkLEDServiceUUID])
      }else{
         isSwitchedOn = false
      }
   }//Update State
   
   //MARK: -  ** DID DISCOVER
   //MARK : - MAKE MORE ROBUST
   func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
      
      var peripheralName: String!
      
      if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
         peripheralName = name
      } else {
         peripheralName = "Unknown"
      }
   
      let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue)
      print(newPeripheral)
      peripherals.append(newPeripheral)
      
     
      myPeripheral = peripheral
      myPeripheral.delegate = self
      
    myCentral.stopScan()
    myCentral.connect(myPeripheral)
 
   }//didDiscover
   
   //MARK: -  ** DID CONNECT
   func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
     print("Connected!")
   //  projectZeroPeripheral.discoverServices(nil) **************
      myPeripheral.discoverServices([tiSimpleLinkLEDServiceUUID,tiSimpleLinkBUTServiceUUID,tiSimpleLinkDATAServiceUUID])
   }//did connect
   
   //MARK: -  ** DID DISCOVER SERVICES
   func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
     
     guard let services = peripheral.services else { return }

      
     for service in services {
       print(service)
    //  if service.uuid == tiSimpleLinkLEDServiceUUID {
       myPeripheral.discoverCharacteristics(
         [
             //  myPeripheral.
                 tiSimpleLinkBUT0UUID,
              // myPeripheral.
                 tiSimpleLinkBUT1UUID,
            //  myPeripheral.
                 tiSimpleLinkDATAStringUUID,
        //myPeripheral.tiSimpleLinkDATAStreamUUID],
         //myPeripheral.
              tiSimpleLinkLED0UUID,
          //  myPeripheral.
              tiSimpleLinkLED1UUID ],
              for: service);
          }
    // }
   }//discover services
   
   //MARK: - ** DID DISCOVER CHARACTERISTICS
   func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                   error: Error?) {
      
          print ("Characteristic count =\(service.characteristics!.count)")
     guard let characteristics = service.characteristics else { return }

     for characteristic in characteristics {
       print(characteristic)
      
      if characteristic.uuid == tiSimpleLinkLED0UUID {
          print ("LED0 Characteristic found",characteristic)
       
          redCharacteristic = characteristic
         //unmask red slider
        //    redSlider.isEnabled = true
      }else if
         characteristic.uuid == tiSimpleLinkLED1UUID {
         print ("LED1 Characteristic found",characteristic)
      
         greenCharacteristic = characteristic
      //unmask red slider
     //    greenSlider.isEnabled = true
      }else if
         characteristic.uuid ==  tiSimpleLinkDATAStringUUID {
         print ("String Characteristic found",characteristic)
      
         dataStringCharacteristic = characteristic
       
      }else if
         characteristic.uuid == tiSimpleLinkBUT0UUID {
         print ("BUT0 Characteristic found",characteristic)
      
      }else if
         characteristic.uuid == tiSimpleLinkBUT1UUID {
         print ("BUT1 Characteristic found",characteristic)
       
      }
      
      if characteristic.properties.contains(.read) {
         print(" contains .read$$$$$$$$$$$$$")
         peripheral.readValue(for: characteristic)
       //  peripheral.setNotifyValue(true, for: characteristic)
        
      }
      if characteristic.properties.contains(.notify) {
         print("contains .notify&&&&&&&&&&&&&*********&&&&&&&&&&&&&&&&&&&&&&&&&&")
         peripheral.setNotifyValue(true, for: characteristic)

      }
     }
   }//discover characteristics
   
   // MARK: - ** DID UPDATE VALUE PERIPHERAL
   //**Must read the characteristic first, and then are notified when the characteristic is read
 func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                   error: Error?) {
   
     switch characteristic.uuid {
     // MARK: - ** BUTTON WRITE 0
     case  tiSimpleLinkBUT0UUID :
       let buttonOnOff = buttonState(from: characteristic)
           buttonZeroState = buttonOnOff
      print("BUTTON 0",buttonOnOff)
      
      if buttonZeroisOn {
         
         print(dataLine)
         let newDataLine: [UInt8] =  dataLine.utf8.map{UInt8($0)}
       
         //  ***FOR WRITE STRING****
             //  print(newDataLine[0],newDataLine[1],newDataLine[2])
         print(dataLine.count)
         
            let data = Data(bytes: newDataLine, count: dataLine.count)
         
              
              print("sent data Line")

         print(data)
         
         myPeripheral.writeValue(data, for: dataStringCharacteristic, type: .withResponse )
         
                                  //, type: .withoutResponse )
              //STOP HERE****
           print(data)
         
            buttonZeroisOn = false
      } else  { buttonZeroisOn = true }
     // MARK: - ** BUTTON READ 1
     case tiSimpleLinkBUT1UUID  :
         let buttonOnOff = buttonState(from: characteristic)
         print("BUTTON 1",buttonOnOff)
         print(buttonOneisOn)
         buttonOneState = buttonOnOff
      
      startReading()
         //read data line
         
       //  dataStringCharacteristic = characteristic
        
     // guard let dataIn = dataStringCharacteristic.value else {
    //       return
     //    }
   //      print("setup read data buffer ", dataIn[0] ,dataIn[1],dataIn[2],dataIn[3])
   
//            myPeripheral.readValue(for: dataStringCharacteristic)
//      print("Read the new data line here!!!!!")
//      
//   //***DEAL WITH STRING***
//         
//   
//        guard let dataIn = dataStringCharacteristic.value else {return}
//         
//         print (dataStringCharacteristic.value?.count ?? 0)
//         
//         let dataIn2 = [UInt8](dataIn)
//         
//         receivedDataLine = ""
//   //check for neg count here***
//         for i in  0...dataIn.count-1 {
//          print( "\(dataIn2[i])", UnicodeScalar(dataIn2[i]))
//            receivedDataLine += String(UnicodeScalar(dataIn2[i]))
//       }
//         
//        // receivedDataLine = String(Int(dataIn2[0]+dataIn2[1]+dataIn2[2]))
//         
    //     receivedDataLine += "A"
//         
//    //     print(dataIn2[0],Int(dataIn2[0]),String(Int(dataIn2[0])))
//        print( receivedDataLine )
//         
//         
//       //  ,dataIn2[1])
//        // ,dataIn2[2],dataIn2[3])
          
      if buttonOneisOn {
            buttonOneisOn = false
         
      } else  { buttonOneisOn = true }
      
      print(buttonOneisOn)
     // let convertedDataLine: [UInt8] =  dataLine.utf8.map{UInt8($0)}
   //  case BoardPeripheral.tiSimpleLinkDATAStreamUUID  :
    //  /Users/cynthiaanderson/Cindy/MyApps/TalkingtoBoard/OZGWComm/OZGWProjectZero.xcodeproj    //  bytesToSend
   //   let data = Data(bytesToSend)

      //Using Characteristic 2AF1 with Properties WriteWithoutResponse
    //  peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
  //    print("doneStream")
  //    peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
 //     print("doneStream")
     // MARK: - ** READ STRING
  case tiSimpleLinkDATAStringUUID  :
   
   guard let dataIn = dataStringCharacteristic.value else {return}
      
//***DEAL WITH STRING***

print ("Length of data read after ", dataStringCharacteristic.value?.count ?? 0)

   
   if dataIn.count == 0 {
      receivedDataLine = ""
   }else {
let dataIn2 = [UInt8](dataIn)

receivedDataLine = ""

for i in  0...dataIn.count-1 {
print( "\(dataIn2[i])", UnicodeScalar(dataIn2[i]))
receivedDataLine += String(UnicodeScalar(dataIn2[i]))
}
   }//else
     
    //  bytesToSend
//    let dataOut = Data(bytes: convertedDataLine, count: 12)
//
//      //Using Characteristic 2AF1 with Properties WriteWithoutResponse
//   peripheral.writeValue(dataOut, for: characteristic, type: CBCharacteristicWriteType.withResponse)
//
//      print("sentString")
////
//     peripheral.readValue(for: characteristic)
//      guard let dataIn = characteristic.value else {return}
//////
//     print("read data", dataIn[0],dataIn[1],dataIn[2],dataIn[3])
//////
  //  let counter = UInt16(dataIn)
      
 //    for i in0 ...counter {
//       print( dataIn[i]) }
      
   //   print(Data())
 //     peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
//    print("doneString")
  
 //     peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
//      print("doneString")
   
       default:
         print("Unhandled Characteristic UUID: \(characteristic.uuid)")
     }
      
   }  //UPDATE PERIPHERAL
   
   
   //MARK: - ** START, STOP SCAN
   func startScanning() {
      print("startScanning")
  //    myCentral.scanForPeripherals(withServices: nil, options: nil)
      
      myCentral.scanForPeripherals(withServices: [tiSimpleLinkLEDServiceUUID])
      
   }//start scan
   
   func stopScanning() {
      print("stop scanning")
      myCentral.stopScan()
   }//stop scanning
   
   //MARK: - ** BUTTON STATE
    func buttonState(from characteristic: CBCharacteristic) -> String {
     guard let characteristicData = characteristic.value,
       let byte = characteristicData.first else { return "Error" }
      print(byte)
     switch byte {
       case 0:
         
         return "Off"
         
       case 1: return "On"
       default:
         return "Reserved for future use"
     }
   }//Button State
   
   
   //MARK: - ** WRITE TO THE LEDS
   
   private var bytesToSend: [UInt8] = [00, 01,02,03,04,05,06,07,08,09,10,11]
      //  let data = Data(bytesToSend)
   //    peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
   
   func writetoGreenLED() {
    
      var byteToSend: [UInt8]
     // let convertedDataLine: [UInt8] =  dataLine.utf8.map{UInt8($0)}
      
      
      print(greenLEDisOn)
   
      if (greenLEDisOn == true) {
         byteToSend = [00]
         greenLEDisOn = false
         greenLEDState = " OFF "
      } else {
         byteToSend = [01]
         greenLEDisOn = true
         greenLEDState = " ON  "
      }
      
//      //CHANGED TO SEND LINE OF DATA
// //    bytesToSend = byteToSend + bytesToSend
      
      

      //STOP HERE****
      
//      guard let dataIn = dataStringCharacteristic.value else {return}
//      print("setup read data buffer ", dataIn[0],dataIn[1],dataIn[2],dataIn[3])
//
//         myPeripheral.readValue(for: dataStringCharacteristic)
//
//
//        guard let dataIn2 = dataStringCharacteristic.value else {return}
//        print("read data", dataIn2[0],dataIn2[1],dataIn2[2],dataIn2[3])
       

    let  data2 = Data(bytes: &byteToSend, count: 1)

      print(data2)
      print(byteToSend)
   print("Green LED is ON/OFF")

      myPeripheral.writeValue(data2, for: greenCharacteristic, type: .withResponse )
      print("Green LED is ON/OFF")
   }
   
   func writetoRedLED() {
    
      var byteToSend: [UInt8]
      
     print(redLEDisOn)
      
      if (redLEDisOn == true) {
         byteToSend = [00]
         redLEDisOn = false
         redLEDState = " OFF  "
      } else {
         byteToSend = [01]
         redLEDisOn = true
         redLEDState = " ON   "
      }
  
      let data = Data(bytes: &byteToSend, count: 1)
      
      print(data)
      print(byteToSend)
         
      myPeripheral.writeValue(data, for: redCharacteristic, type: .withResponse )
      
      print("RED LED is ON/OFF")

      
      }
      
   
 //   func writetoredLED( withValue: Data) {
      //Check if it has the right property
     // if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {
  //       myPeripheral.writeValue(withValue, for: redCharacteristic, type: .withoutResponse )
    
//}//writeLED
   
   

 
   //MARK: - ** START WRITING
func startWriting() {
   
   print(dataLine)
   
  let newDataLine: [UInt8] =  dataLine.utf8.map{UInt8($0)}

   //  ***FOR WRITE STRING****      //  print(newDataLine[0],newDataLine[1],newDataLine[2])
     print(dataLine.count)
 
       let data = Data(bytes: newDataLine, count: dataLine.count)

        print("sent data Line")
       print(data)

    myPeripheral.writeValue(data, for: dataStringCharacteristic, type: .withResponse )
//                            //, type: .withoutResponse )

    print(data)
}
   //MARK: - ** START READING
   
   func startReading() {
      
    //  guard let dataIn = dataStringCharacteristic.value else {return}
     //
      
      print ("Length of data before read", dataStringCharacteristic.value?.count ?? 0)
      
      myPeripheral.readValue(for: dataStringCharacteristic)
      
      print("Read the new data line here!!!!!")
         
   //   guard let dataIn = dataStringCharacteristic.value else {return}
         
//***DEAL WITH STRING***

//print ("Length of data read after ", dataStringCharacteristic.value?.count ?? 0)
//
//let dataIn2 = [UInt8](dataIn)
//
//receivedDataLine = ""
////check for neg count here***
//for i in  0...dataIn.count-1 {
// print( "\(dataIn2[i])", UnicodeScalar(dataIn2[i]))
//   receivedDataLine += String(UnicodeScalar(dataIn2[i]))
   


// receivedDataLine = String(Int(dataIn2[0]+dataIn2[1]+dataIn2[2]))



 //    print(dataIn2[0],Int(dataIn2[0]),String(Int(dataIn2[0])))
//print( "HI", receivedDataLine )


//  ,dataIn2[1])
// ,dataIn2[2],dataIn2[3])
 
   
   }

} //BLEManagerClass

