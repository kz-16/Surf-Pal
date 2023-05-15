import RxSwift

extension PrimitiveSequence where Trait == SingleTrait {
    func responseResult<T>() -> Single<T> where Element: BaseResponse<T> {
        return map { response in
            guard response.errorCode == ApiErrorType.none, let result = response.result else {
                if response.errorMessage != nil {
                    throw ApiError(errorType: response.errorCode, message: response.errorMessage)
                } else {
                    throw response.errorCode
                }
            }
            return result
        }
    }
}
