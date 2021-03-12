//
//  ContentView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-10.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Text("myPlace")
                    .bold()
                    .font(Font.system(size: 60, weight: .bold))
                Image("Logo")
                    .offset(x: 0, y: -50)
                    .padding(.bottom, 100)
                    .shadow(color: .gray, radius: 3, x: 0.0, y: 5)
                Spacer()
                NavigationLink(
                    destination: RegisterView(),
                    label: {
                        Text(LocalizedStringKey("Register"))
                    })
                    .frame(width: 150, alignment: .center)
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color("MainBlue"))
                    .cornerRadius(5)
                Text(LocalizedStringKey("AlreadyHaveAccount?"))
                    .padding(.vertical, 8.0)
                    
                NavigationLink(
                    destination: LogInView(),
                    label: {
                        Text(LocalizedStringKey("LogInHere"))
                    })
                Spacer() 
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
