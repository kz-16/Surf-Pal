import RxSwift

typealias Block<T, K> = (T) -> K

typealias EmptyBlock = () -> Void
typealias ResultBlock<T> = () -> T
typealias ParameterBlock<T> = (T) -> Void
typealias DoubleParametersBlock<T, U> = (T, U) -> Void

func className(_ obj: Any) -> String {
  // prints more readable results for dictionaries, arrays, Int, etc
  return String(describing: type(of: obj))
}

func className(_ type: AnyClass) -> String {
  return String(describing: type)
}
