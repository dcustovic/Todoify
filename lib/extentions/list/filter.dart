// filtering our list of things based on where clause
extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) {
    return map((items) => items.where(where).toList());
  }
}
