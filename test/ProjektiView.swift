//
//  ProjektiView.swift
//  test
//
//  Created by Leevi on 23.9.2022.
//

import SwiftUI

struct ProjektiView: View {
    var projekti: Projekti
    
    var body: some View {
        VStack {
            Text(projekti.name)
                .foregroundColor(.primary)
                .font(.title)
                .padding()
            HStack {
                Label(projekti.desc, systemImage: "info")
            }
            .foregroundColor(.secondary)
        }
    }
}
