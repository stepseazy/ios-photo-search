//
//  PhotoInteractor.swift
//  Photo Viewer
//
//  Created by Hendrik brutsaert on 11/28/19.
//  Copyright © 2019 Hendrik brutsaert. All rights reserved.
//

import Foundation

struct PhotoResponse: Decodable {
    let results: [Photo]
}

class PhotoInteractor {
    static var shared = PhotoInteractor()
    let accessKey = "480933fb4c5f27e255f1d4b70373a6e3311af54ba18f01cb407bb81b5dbc4c07"
    private var task: URLSessionDataTask?
    var error: Error?

    func getPhotos(query: String, completionHandler: @escaping ([Photo], Error?) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/search/photos") else {
            return
        }
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(accessKey)"
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)

        request.allHTTPHeaderFields = headers
//        request.httpMethod = "GET"

        let session = URLSession.shared
        task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, let photos = self.photosFromJSONResponse(data) {
                completionHandler(photos, nil)
            }
        }
        task?.resume()
    }

    func photosFromJSONResponse(_ data: Data) -> [Photo]? {

        do {
            let photoResponse = JSONDecoder().decode(PhotoResponse.self, from: data)
            return photoResponse.results
        } catch {
            self.error = error
        }
        return nil
    }

}
