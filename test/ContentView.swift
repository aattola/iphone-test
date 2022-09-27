//
//  ContentView.swift
//  test
//
//  Created by Leevi on 16.9.2022.
//

import SwiftUI
import Alamofire

struct Projekti: Decodable {
    var name: String
    var desc: String
    var id: Int
    var beta: Bool?
    var url: String
}

struct Lista: Decodable {
    var projects: [Projekti]
    var mainText: String
}

struct ContentView: View {
    @State var teksti = "kissa"
    @State var projektit: Lista = Lista(projects: [], mainText: "")
    
    func fetchPost() {
        AF.request("https://api.jeffe.co/projects").responseDecodable(of: Lista.self) { response in
            
            switch response.result {
            case Result.success(let listaus):
                projektit = listaus
            case Result.failure(let virhe):
                print(virhe)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach (projektit.projects, id: \.id) { projekti in
                        NavigationLink(destination: ProjektiView(projekti: projekti)) {
                            HStack {
                                Text(projekti.name)
                                Text(String(projekti.id))
                            }
                        }
                    }
                }.navigationTitle("Lista")
                
                
                Image("oontaa")
                    .resizable(resizingMode: .stretch)
                    .frame(width: 300.0, height: 300.0)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                    
                    
                Text("Morjensta")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 15.0)
                Text(teksti)
                
                TextField("Placeholder", text: $teksti).onSubmit {
                    print("submit")
                }
                
                Button(action: {
                    print("MOROOOOO")
                    fetchPost()
                }, label: {
                    Text("Testinamiska")
                }).buttonStyle(.borderedProminent)
                
     
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
