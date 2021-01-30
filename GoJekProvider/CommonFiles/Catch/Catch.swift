//
//  Catch.swift
//  GoJekProvider
//
//  Created by apple on 22/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class Cache {
    
    static let shared: NSCache<AnyObject, UIImage> = {
        return NSCache<AnyObject,UIImage>()
    }()
    
    class func image(forUrl urlString: String?, completion: @escaping (UIImage?)-> ()){
        
        DispatchQueue(label: ProcessInfo().globallyUniqueString, qos: .background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil) .async {
            var image : UIImage? = nil
            guard  let url = urlString else {
                completion(image)
                return
            }
            image = Cache.shared.object(forKey: url as AnyObject) // Retrieve Image From cache If available
            if image == nil, !url.isEmpty, let _url = URL(string: url) {  // If Image is not available, then download
                URLSession.shared.dataTask(with: _url, completionHandler: { (data, response, error) in
                    guard data != nil, let imageData = UIImage(data: data!), let responseUrl = response?.url?.absoluteString else {
                        completion(nil)
                        return
                    }
                    Cache.shared.setObject(imageData, forKey: responseUrl as AnyObject)
                    completion(imageData) // return Image
                }).resume()
            }
            completion(image)
        }
    }
}
