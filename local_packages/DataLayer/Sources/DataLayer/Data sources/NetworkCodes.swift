import Foundation

public enum NetworkCodes: Int {
    case ok = 200
    case okPost = 201
    case noBody = 204
    case notModifier = 304
    case badRequest = 400
    case authFailed = 401
    case notAllowed = 403
    case notExist = 404
    case methodNotAllowed = 405
    case unsupportedMedia = 415
    case dataValidationFailed = 422
    case tooManyRequests = 429
    case serverError = 500
}
