//
//  VertailuView.swift
//  test
//
//  Created by Leevi on 27.9.2022.
//

import SwiftUI
import Alamofire

struct EtsiParams: Encodable {
    let sid: String
    let id: Int
}

struct Kaveri: Decodable {
    var nimi: String
}

struct EtsiKurssi: Decodable {
    var code: String
    var nimi: String
    var ryhmaId: Int
}

struct EtsiResponse: Decodable {
    var samatKurssit: [EtsiKurssi]?
}

struct VertailuView: View {
    var sid: String
    var vertailtavanId: Int
    var vertailtavanNimi: String
    @State var virhe = ""
    @State var vertailu: EtsiResponse = EtsiResponse(samatKurssit: [])
    
    func getVertailuInfo(sid: String, id: Int) {
        let params = EtsiParams(sid: sid, id: id)
        let url = "https://lukkari.jeffe.co/api/kurssitarkastaja/etsi"
    
        AF.request(url, method: .post, parameters: params).responseDecodable(of: EtsiResponse.self) { response in
        
            virhe = ""
            switch response.result {
            case .success(let resp):
                vertailu = resp
             case let .failure(error):
                virhe = "Virhe hakiessa dataa. Voi olla että hänestä ei ole dataa"
                print(error)
             }

        }
    }
    
    var body: some View {
        VStack {
            Text("").onAppear() {
                getVertailuInfo(sid: sid, id: vertailtavanId)
            }
            
            List {
                Section("Samat kurssit") {
                    if (vertailu.samatKurssit?.isEmpty != nil) {
                        ForEach(vertailu.samatKurssit ?? [], id: \.ryhmaId) { ryhma in
                            NavigationLink(destination: GroupView(group: CustomGroup(Id: ryhma.ryhmaId, CourseCode: ryhma.code), sid: sid)) {
                                HStack {
                                    Text(ryhma.nimi)
                                    Spacer()
                                    Text(ryhma.code)
                                }
                            }
                        }
                    }
                }
            }.navigationTitle(vertailtavanNimi)
        }
    }
}

