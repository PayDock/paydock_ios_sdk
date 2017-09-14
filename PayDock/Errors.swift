//
//  Errors.swift
//  PayDock
//
//  Created by RTA on 15/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// PayDock Errors
///
/// - urlInitFailed:  errors when can not create URL
/// - networkError:  errors when URLSession fails
/// - serverError:  errors that server returns
/// - parsingFailed: errors on mapping json to object
/// - invalidJsonFormat: errors on parsing data to json
public enum Errors: Error {
    case urlInitFailed(reason: urlInitFailedReason)
    case networkError(reason: networkErrorReason)
    case serverError(message: String, details: AnyObject?, status: Int)
    case parsingFailed
    case invalidJsonFormat
    
    var details: AnyObject? {
        switch self {
        case .serverError( _,let details, _): return details
        default: return nil
        }
    }
    var status: Int {
        switch self {
        case .serverError( _, _, let status): return status
        default: return 0
        }
    }
    var message: String? {
        switch self {
        case .serverError(let message, _, _): return message
        default: return nil
        }
    }
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serverError(let message, _, _):
            return NSLocalizedString(message , comment: "")
        default:
            return NSLocalizedString("\(self)", comment: "")
        }
    }
}





/// errors when can not create URL
///
/// - couldNotEncodeParameter: errors when could not encode parameters in url
/// - couldNotCreateUrlWithGivenString: errors when given stirng can not be used to create URL
public enum urlInitFailedReason {
    case couldNotEncodeParameter
    case couldNotCreateUrlWithGivenString
}


/// errors when URLSession fails
///
/// - noResponse: response is nil
/// - unacceptableStatusCode: status code is not accaptable
/// - noDataRecived: data is nil
public enum networkErrorReason {
    case noResponse
    case unacceptableStatusCode
    case noDataRecived
}
