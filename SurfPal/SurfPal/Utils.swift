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

func getItemWithPrevAndNext<T>(
  _ array: [T], currentItem: T
) -> (prev: T, current: T, next: T)? where T: Equatable {
  guard let currentIndex = array.firstIndex(of: currentItem) else {
    return nil
  }
  let itemCount = array.count
  let previousIndex = currentIndex == 0 ? itemCount - 1 : currentIndex - 1
  let nextIndex = (currentIndex + 1) % itemCount
  let previousItem = array[previousIndex]
  let nextItem = array[nextIndex]
  return (previousItem, currentItem, nextItem)
}
