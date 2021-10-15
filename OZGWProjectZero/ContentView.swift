//
//  ContentView.swift
//  OZGWProjectZero
//
//  Created by Cynthia Anderson on 10/22/20.
//

import SwiftUI

struct ContentView: View {
   
   @ObservedObject var bleManager = BLEManager()

    var body: some View {
       
      VStack (spacing: 10) {
//MARK:- TITLE
        HStack{
      
         Label("   ", systemImage: bleManager.isSwitchedOn ? "guitars.fill" : "guitars")
           
           Spacer()
           Spacer()
           
           
           if bleManager.isSwitchedOn {
              Text("Bluetooth is Switched ON")
                 .foregroundColor(.green)
           } else {
              Text("Bluetooth is Switched OFF")
              .foregroundColor(.red)
           }
           Spacer()
         }//Hstack

            Text("Tau-6")
                 .font(.title)
                 .frame(maxWidth: .infinity, alignment: .center)
         
//MARK:- LIST PERIPHERAL
         VStack (spacing: 20){
            Spacer()
            
            List(bleManager.peripherals){
               peripheral in
               HStack{
               Text(peripheral.name)
               Spacer()
               Text(String(peripheral.rssi))
            }
            }.lineLimit(1)
            .frame(height: 100)
            

     //    Spacer()
                  
//MARK:- WRITE
     VStack{
         HStack{
            Text(" Data Sent ")
             
            TextField("Enter Data Line", text: $bleManager.dataLine,  onEditingChanged:  { (changed) in print ("Entering Data to Send- changed? \(changed)" )
                 }) {
               //  print ("Dataline onCommit")
                 }
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                  .background(Color .black)
            Spacer()
                  }//hstack
      
                     
            // MARK: - ** Write button
            Button(action: {
               self.bleManager.startWriting()                }){
      
                  if (bleManager.buttonZeroisOn) {
                  Text(" WRITE ")
                        .font(.title2)
                  }else {
                     Text(" WRITE ")
                        .font(.title3)
                        .bold()
                  }
                  
               }.padding(6.0)
                .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: 1)
               
      
            }//Vstack
                  
                Spacer()
                  
                  //MARK:- BUTTON 1
            VStack {
              HStack{
                 Text(" Data Read  ")
                
                     TextField("", text: $bleManager.receivedDataLine,  onEditingChanged:  { (changed) in print ("Printing received data - Changed? -  \(changed)" )
                 }) {
               //  print ("Dataline onCommit")
                 }
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                  .background(Color .blue)
                 Spacer()
                 
                  }//hstack
                  
           
                Text("Reading Data   " )
               // MARK: - ** First button
               Button(action: {
                  self.bleManager.startReading()
             
               }){
                     if (bleManager.buttonOneisOn) {
                     Text(" READ ")
                           .font(.title2)
                     }else {
                        Text(" READ ")
                           .font(.title3)
                           .bold()
                     }
                  
                }.padding(6.0)
            
               .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: 1)
               
      }//Vstack
                Spacer()
//MARK:- RED LIGHT
                        HStack{
                           
                            Text("RED ")
                            Button(action: {
                                    self.bleManager.writetoRedLED()
                            }){
                                    Text(bleManager.redLEDState)
                                    Label("", systemImage:
                                      bleManager.redLEDisOn ? "circle.fill" : "circle" )
                              }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                        
            //MARK:- GREEN LIGHT
                            Text("GREEN ")
                            Button(action: {
                                    self.bleManager.writetoGreenLED()
                            }){
                                   Text(bleManager.greenLEDState)
                                   Label("", systemImage:
                                       bleManager.greenLEDisOn ? "circle.fill" : "circle" )
                                  }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                                 
                           }//Hstack
                           .font(.body)
                        Spacer()

             .alignmentGuide(.lastTextBaseline) { dimension in 6 }
             .padding()
                
                }
             .frame(maxWidth: .infinity, alignment: .center)
            }//vstack
     } //body
 } //View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

