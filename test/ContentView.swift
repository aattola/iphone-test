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

struct WilmaResponse: Decodable {
    var sid: String
    var ok: Bool
}

struct Login: Encodable {
    let username: String
    let password: String
}

struct SIDAuth: Encodable {
    let sid: String
}

struct Group: Decodable {
    var CourseId: Int
    var Caption: String
    var CourseCode: String
    var CourseName: String
    var Name: String
    var Id: Int
}

struct GroupResponse: Decodable {
    var currentGroups: [Group]
    var futureGroups: [Group]
    //    let grouped: [String: [Group]]
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @State var nimi = ""
    @State var salasana = ""
    @State var errorMessage = ""
    @State var loading = false
    @Binding public var sid: String

    func kirjaudu(name: String, pass: String) {
        loading = true
        let login = Login(username: name, password: pass)
        AF.request("https://lukkari.jeffe.co/api/wilma/login", method: .post, parameters: login).responseDecodable(of: WilmaResponse.self) { response in
            
            loading = false
            switch response.result {
            case Result.success(let wResponse):
                sid = wResponse.sid
                dismiss()
                
            case Result.failure(let virhe):
                print(virhe)
                errorMessage = "Salasana tai tunnus on väärin!"
            }
        }
    }

    var body: some View {
        VStack {
            Form {
                TextField("Käyttäjätunnus", text: $nimi).onSubmit {
                    print("submit")
                }
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Salasana", text: $salasana).onSubmit {
                    kirjaudu(name: nimi, pass: salasana)
                }.textContentType(.password)
                
                if loading {
                    ProgressView()
                } else {
                    Button("Kirjaudu sisään") {
                        kirjaudu(name: nimi, pass: salasana)
                    }
                }
            
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red)
                }
            }
        }
    }
}

struct ContentView: View {
    @State var active: Bool = false
    @State private var showingSheet = false
    @State var sid: String = ""
    @State var groups: GroupResponse = GroupResponse(currentGroups: [], futureGroups: [])
    
    func fetchGroups(sessionId: String) {
        let params = SIDAuth(sid: sessionId)
    
        AF.request("https://lukkari.jeffe.co/api/v2/wilma/groups", method: .post, parameters: params).responseDecodable(of: GroupResponse.self) { response in
            
            switch response.result {
            case Result.success(let ryhmat):
                groups = ryhmat
            case Result.failure(let virhe):
                print(virhe)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Nyt") {
                        ForEach (groups.currentGroups, id: \.CourseId) { ryhma in
                            NavigationLink(destination: GroupView(group: CustomGroup(Id: ryhma.Id, CourseCode: ryhma.CourseCode), sid: sid)) {
                                HStack {
                                    Text(ryhma.CourseName)
                                    Spacer()
                                    Text(ryhma.Caption)
                                }
                            }
                        }
                    }
                    
                    Section("Tulossa") {
                        ForEach (groups.futureGroups, id: \.CourseId) { ryhma in
                            NavigationLink(destination: GroupView(group: CustomGroup(Id: ryhma.Id, CourseCode: ryhma.CourseCode), sid: sid)) {
                                HStack {
                                    Text(ryhma.CourseName)
                                    Spacer()
                                    Text(ryhma.Caption)
                                }
                            }
                        }
                    }
                    
                    Section("Asetukset") {
                        if !sid.isEmpty {
                            VStack {
                                NavigationLink(destination: ToinenSivu(sid: sid)) {
                                    Text("Tietoja")
                                }
                            }
                        }
                        
                        if sid.isEmpty {
                            Button("Kirjaudu sisään") {
                                 showingSheet.toggle()
                            }
                                .onAppear() {
                                    showingSheet.toggle()
                                }
                            .sheet(isPresented: $showingSheet, onDismiss: {
                                fetchGroups(sessionId: sid)
                            }) {
                                 SheetView(sid: $sid)
                             }
                        } else {
                            Button("Kirjaudu ulos") {
                                sid = ""
                                groups = GroupResponse(currentGroups: [], futureGroups: [])
                                showingSheet.toggle()
                            }
                        }
                    }
                }.navigationTitle("Kurssit")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
