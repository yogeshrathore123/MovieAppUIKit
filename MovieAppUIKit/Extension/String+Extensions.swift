//
//  String+Extensions.swift
//  MovieAppUIKit
//
//  Created by Yogesh Rathore on 17/06/25.
//

import Foundation

extension String {
    
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
