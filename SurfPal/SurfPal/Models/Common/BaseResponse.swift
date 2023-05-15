class BaseResponse<T: Codable>: Codable {

    enum CodingKeys: String, CodingKey {
        case result
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }

    let result: T?
    let errorCode: ApiErrorType
    let errorMessage: String?

    init(result: T?, errorCode: ApiErrorType, errorMessage: String?) {
        self.result = result
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.result = try container.decodeIfPresent(T.self, forKey: .result)
        self.errorCode = try container.decode(ApiErrorType.self, forKey: .errorCode)
        self.errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let result = result {
            try container.encode(result, forKey: .result)
        } else {
            try container.encodeNil(forKey: .result)
        }
        try container.encode(errorCode, forKey: .errorCode)
        if let errorMessage = errorMessage {
            try container.encode(errorMessage, forKey: .errorMessage)
        } else {
            try container.encodeNil(forKey: .errorMessage)
        }
    }
}

