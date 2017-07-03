/*Observable<t> is a swift library for value observing
 It is simple class for allowing you to have observable patterns
 Creates an observable property for data binding*/

import Foundation

class Observable<T> {
  typealias Observer = (T) -> Void
  var observer: Observer?

  func observe(_ observer: Observer?) {
    self.observer = observer
    observer?(value)
  }

  var value: T {
    didSet {
      observer?(value)
    }
  }

  init(_ value: T) {  //simply takes an initial value for observer
    self.value = value
  }
}
/*typealias defines an alternative name for an existing type
 
 
 */
