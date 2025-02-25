//
//  String+Extensions.swift
//  MovieApp_SwiftUI+Combine
//
//  Created by Salman_Macbook on 24/02/25.
//

import Foundation

extension String {
    
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
}
