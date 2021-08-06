//
//  ContentView.swift
//  BetterRest
//
//  Created by MAC on 4/8/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var colors = [ 1 , 2, 3, 4,5,6,7,8,9,10,11,12]
       
    
    var body: some View {
        NavigationView {
       Form{
           Section(){
               Text("Your Recommended Bed Tim:")
                   .font(.headline)
                   
        
               Text(calculateBedtime())
                   .font(.largeTitle)
                  .foregroundColor(Color(UIColor.systemOrange))
               
              
               
           }
    Section{
            Text("When do you want to wake up?")
                        .font(.headline)

                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
           }
           Section {
            Text("Desired amount of sleep")
                .font(.headline)

            Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                Text("\(sleepAmount, specifier: "%g") hours")
            }
           }
           
           Section {
            Text("Daily coffee intake")
                .font(.headline)

               Picker("Please choose how many cup", selection: $coffeeAmount) {
                               ForEach(colors, id: \.self) {
                                   Text("\($0)")
                               }
                           }
               if coffeeAmount == 1{
                           Text(" \(coffeeAmount)cup")
               }else{
                   Text(" \(coffeeAmount)cups")
               }
           }
        
    }
        .navigationBarTitle("BetterRest")
        

        
        }
        
        
}
    
    static   var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
   
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short

           
            return  formatter.string(from: sleepTime)

            // more code here
        } catch {
          return "Sorry, there was a problem calculating your bedtime."
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

