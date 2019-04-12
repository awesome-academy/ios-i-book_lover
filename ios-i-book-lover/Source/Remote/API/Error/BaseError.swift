//
//  BaseError.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure(error: ErrorResponse?)
    case apiFailureJSON(error: ErrorResponseJSON?)
    
    var errorMessage: String? {
        switch self {
        case .networkError:
            return "Network Error"
        case .httpError(let code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure(let error):
            if let error = error {
                return error.message
            }
            return "Error"
        case .apiFailureJSON(let error):
            if let error = error {
                return error.message
            }
            return "Error"
        default:
            return "Unexpected Error"
        }
    }
    
    private func getHttpErrorMessage(httpCode: Int) -> String? {
        if (httpCode >= 300) && (httpCode <= 308) {
            // Redirection
            return "It was transferred to a different URL. I'm sorry for causing you trouble"
        }
        if (httpCode >= 400) && (httpCode <= 451) {
            // Client error
            return "An error occurred on the application side. Please try again later!"
        }
        if (httpCode >= 500) && (httpCode <= 511) {
            // Server error
            return "A server error occurred. Please try again later!"
        }
        // Unofficial error
        return "An error occurred. Please try again later!"
    }
}

