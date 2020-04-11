//
//  APIService.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 22/03/2020.
//

import Foundation

typealias CompletionHandler = (Result<[Contact], Error>) -> ()

class DataService {
    
    static let shared = DataService()
    
    func fetchContacts(completion: @escaping CompletionHandler) {
        guard let mainURL = Bundle.main.url(forResource: "data", withExtension: "json") else { return }
        let subURL = dataFilePath()
        loadFile(mainPath: mainURL, subPath: subURL) { (result) in
            switch result {
            case .success(let contacts):
                completion(.success(contacts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    private func loadFile(mainPath: URL, subPath: URL, completion: @escaping CompletionHandler) {
        if FileManager.default.fileExists(atPath: subPath.path) {
            decodeData(from: subPath) { (result) in
                switch result {
                case .success(let contacts):
                    guard !contacts.isEmpty else {
                        self.decodeData(from: mainPath, completion: completion)
                        return
                    }
                    completion(.success(contacts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            self.decodeData(from: mainPath, completion: completion)
        }
    }
    
    private func decodeData(from url: URL, completion: @escaping CompletionHandler) {
        if let data = try? Data.init(contentsOf: url) {
            do {
                let decoder = JSONDecoder()
                let contacts = try decoder.decode([Contact].self, from: data)
                completion(.success(contacts))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
    }
    
    func saveContacts(contacts: [Contact]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(contacts)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding contacts array: \(error.localizedDescription)")
        }
    }
    
    private func dataFilePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("data.json")
    }
}
