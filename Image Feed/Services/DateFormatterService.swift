//
//  DateFormatterService.swift
//  Image Feed
//
//  Created by Павел Врухин on 26.07.2023.
//

import Foundation

final class DateFormatterService {
    
    static let shared = DateFormatterService()
    
    lazy var inputImageDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    lazy var outputImageDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private init() {}
}
