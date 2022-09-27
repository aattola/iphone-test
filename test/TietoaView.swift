//
//  ToinenSivu.swift
//  test
//
//  Created by Leevi on 27.9.2022.
//

import SwiftUI
import Alamofire

struct WilmaInfoResponse: Decodable {
    var Name: String
    var WilmaId: String
    var ApiVersion: Int
    var FormKey: String
    var PrimusId: Int
    var School: String
    var AllowSaveExcuse: Bool
    var Photo: String
    var EarlyEduUser: Bool
}

struct GenericVammainenLukkariResponse: Decodable {
    var ok: Bool
    var data: WilmaInfoResponse?
}

struct GenericLukkariResponse: Decodable {
    var ok: Bool
    var info: GenericVammainenLukkariResponse
}

struct ToinenSivu: View {
    var sid: String
    @State var info: GenericVammainenLukkariResponse = GenericVammainenLukkariResponse(ok: false)
    
    func getWilmaInfo(sid: String) throws {
        let params = SIDAuth(sid: sid)

        AF.request("https://lukkari.jeffe.co/api/wilma/info", method: .post, parameters: params).validate().responseDecodable(of: GenericLukkariResponse.self) { response in
            
            switch response.result {
            case .success(let jeppist):
                let data = jeppist.info.data
                    info.data = data
                    info.ok = true
                 case let .failure(error):
                     print(error)
                 }

        }
    }

    
    var body: some View {
        VStack {
            
            
            if !info.ok {
                ProgressView().onAppear() {
                    do {
                        try getWilmaInfo(sid: sid)
                    } catch {
                        print("error")
                    }
                }
            } else {
                List {
                    Text(info.data!.Name)
                    Text(info.data!.School)
                    Text(String(info.data!.PrimusId))
                    
                }.navigationTitle("Tietoja")
            }
            
            
            Text("Laattola & Co")
                .font(.system(size: 12, weight: .light, design: .serif))
                .italic()
        }
    }
}

