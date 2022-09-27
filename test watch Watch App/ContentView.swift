//
//  ContentView.swift
//  test watch Watch App
//
//  Created by Leevi on 23.9.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "info")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hoi.")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
