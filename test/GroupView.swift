//
//  GroupView.swift
//  test
//
//  Created by Leevi on 27.9.2022.
//

import SwiftUI
import Alamofire

struct ApiResponseGroup: Decodable {
    var ok: Bool
    var Groups: [WilmaGroup]
}

struct WilmaGroup: Decodable {
    var Id: Int
    var Students: [Student]
    var CourseId: Int
    var CourseName: String
    var CourseCode: String
    var Name: String
    var Caption: String
    var StartDate: String
    var EndDate: String
    var Committed: Bool
    var Teachers: [Teacher]
}

struct Student: Decodable {
    var Id: Int
    var Name: String
    var ClassName: String
    var SchoolId: Int
}

struct Teacher: Decodable {
    var TeacherId: Int
    var TeacherName: String
    var TeacherCode: String
}

struct CustomGroup: Decodable {
    var Id: Int
    var CourseCode: String
}

struct GroupView: View {
    var group: CustomGroup
    var sid: String
    @State var ryhma: ApiResponseGroup = ApiResponseGroup(ok: false, Groups: [])
    @State var virhe = ""
    
    func getWilmaInfo(sid: String) {
        let params = SIDAuth(sid: sid)
        let url = "https://lukkari.jeffe.co/api/wilma/groups/\(group.Id)"
        
        AF.request(url, method: .post, parameters: params).responseDecodable(of: ApiResponseGroup.self) { response in
        
            virhe = ""
            switch response.result {
            case .success(let ry):
                ryhma = ry
             case let .failure(error):
                virhe = "Virhe hakiessa dataa. Koitappa kirjautua uudelleen sisään."
                print(error)
             }

        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if ryhma.ok {
                        Section("Tietoa") {
                            HStack {
                                Text("Kurssin nimi")
                                Spacer()
                                Text(ryhma.Groups[0].CourseName)
                            }
                            
                            HStack {
                                Text("Kurssilla oppilaita")
                                Spacer()
                                Text(String(ryhma.Groups[0].Students.count))
                            }
                            
                            HStack {
                                Text("Kurssi alkaa")
                                Spacer()
                                Text(ryhma.Groups[0].StartDate)
                            }
                            
                            HStack {
                                Text("Kurssi loppuu")
                                Spacer()
                                Text(ryhma.Groups[0].EndDate)
                            }
                        }
                        
                        Section("Opettaja(t)") {
                            ForEach(ryhma.Groups[0].Teachers, id: \.TeacherId) { teacher in
                                Text(teacher.TeacherName)
                            }
                        }
                        
                        Section("Oppilaat") {
                            ForEach(ryhma.Groups[0].Students, id: \.Id) { oppilas in
                                NavigationLink(destination: VertailuView(sid: sid, vertailtavanId: oppilas.Id, vertailtavanNimi: oppilas.Name)) {
                                    HStack {
                                        Text(oppilas.Name)
                                        Spacer()
                                        Text(oppilas.ClassName)
                                    }
                                }
                            }
                        }
                    } else {
                        ProgressView().onAppear() {
                            getWilmaInfo(sid: sid)
                        }
                        
                        if !virhe.isEmpty {
                            Text(virhe)
                        }
                    }
                }.navigationTitle(!ryhma.ok ? group.CourseCode : ryhma.Groups[0].CourseCode)
            }
        }
    }
}
