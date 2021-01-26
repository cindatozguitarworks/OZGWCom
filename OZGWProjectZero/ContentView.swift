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
               HStack {
                  Label("", systemImage:
                   bleManager.isSwitchedOn ? "guitars.fill" : "guitars" )
            Text("Tau-6")
               .font(.title)
               .frame(maxWidth: .infinity, alignment: .center)
               }
               //MARK:-START SCAN
                                   //    HStack (spacing: 10){
                                          
                                  Button(action: {
                                     self.bleManager.startScanning()
                                 //    print(" Start Scanning")
                                  }){
                                    Text("Start Scan   ")
                                 } //Start Button
                       //     }
                        //         .font(.headline)
                                  .font(.body)

//MARK:- LIST PERIPHERAL
               List(bleManager.peripherals){
           peripheral in
                   HStack{
                Text(peripheral.name)
                  Spacer()
                  Text(String(peripheral.rssi))
               }
               }  .lineLimit(1)
               .frame( height: 48) //list
                
           //     Spacer()
        //        Spacer()

               //MARK:- TEXT FIELD
             //  VStack(alignment: .leading){
//                  HStack{
//               Text(" Sent Data Line ")
//                  .font(.headline)
//
//                     TextField("Enter Data Line", text: $bleManager.dataLine,  onEditingChanged:  { (changed) in print ("Dataline in OnEditing Changed -  \(changed)" )
//                 }) {
//                 print ("Dataline onCommit")
//                 }
//                  .textFieldStyle(RoundedBorderTextFieldStyle())
//                  .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                  .background(Color .blue)
//                  }//hstack
//                  HStack{
//                 Text(" Received Data  ")
//                  .font(.headline)
//
//                     TextField("", text: $bleManager.dataLine,  onEditingChanged:  { (changed) in print ("Dataline in OnEditing Changed -  \(changed)" )
//                 }) {
//                 print ("Dataline onCommit")
//                 }
//                  .textFieldStyle(RoundedBorderTextFieldStyle())
//                  .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                  .background(Color .blue)
//                  }//hstack
//                 // Text(" Converted Data Line: \(bleManager.dataLine)")
                 // print(bleManager.dataLine.utf8.map{UInt($0)})
        //       }//vstack
             //  Spacer()
               
//MARK:- RED LIGHT
            //   VStack {
                VStack (spacing: 20){
                  HStack{
               //   HStack {
                     Text("RED ")
                     
                     Button(action: {
                        self.bleManager.writetoRedLED()
                   
                     }){
                        Text(bleManager.redLEDState)
                    
                      Label("", systemImage:
                          bleManager.redLEDisOn ? "circle.fill" : "circle" )
                     }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                     //red Light
           
                //     }.padding()
                   
          
               //      HStack {
//MARK:- GREEN LIGHT
                      Text("GREEN ")
                      
                      Button(action: {
                         self.bleManager.writetoGreenLED()
                     
                      }){
                         Text(bleManager.greenLEDState)
                       //   Text(bleManager.buttonZeroState)
                       Label("", systemImage:
                           bleManager.greenLEDisOn ? "circle.fill" : "circle" )
                      }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                      //Green Light
                      
               //   }.padding() // HStack Green Light

               }//Hstack
                  .font(.body)
                   Spacer()
                  
//MARK:- BUTTON 0
                  VStack{
                  HStack{
               Text(" Data Out ")
                  .font(.title)
                  
                     TextField("Enter Data Line", text: $bleManager.dataLine,  onEditingChanged:  { (changed) in print ("Entering Data to Send- changed? \(changed)" )
                 }) {
               //  print ("Dataline onCommit")
                 }
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                  .background(Color .blue)
                  }//hstack
                   HStack {
                      
                   Text("Writing Data   ") //"guitars")
                      
                   Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                         Text(bleManager.buttonZeroState)
                      Label("", systemImage:
                          bleManager.buttonZeroisOn ? "circle" : "circle.fill" )
                      }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                   }.padding() // HStack But0
             
                  }//Vstack
                  
                Spacer()
                  
                  //MARK:- BUTTON 1
                VStack {
                  HStack{
                 Text(" Data In  ")
                  .font(.title)
                  
                     TextField("", text: $bleManager.receivedDataLine,  onEditingChanged:  { (changed) in print ("Printing received data - Changed? -  \(changed)" )
                 }) {
               //  print ("Dataline onCommit")
                 }
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                  .background(Color .blue)
                  }//hstack
                  
            HStack{
                Text("Reading Data   " )

               Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Text(bleManager.buttonOneState)
               Label("", systemImage:
                    bleManager.buttonOneisOn ? "circle" : "circle.fill" )
                }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                }.padding()  //HStack But1
         }//Vstack
                Spacer()
                  

             .alignmentGuide(.lastTextBaseline) { dimension in 6 }
             .padding()
                
                }
//             }//VSTACK
            //    .font(.title)
             .frame(maxWidth: .infinity, alignment: .center)
            }//vstack
//      } //Navigation View
     } //body
 } //View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

