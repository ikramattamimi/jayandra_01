class UniqueIntGenerator {
  int _counter = 0;

  int generateUniqueInt() {
    int timestamp = DateTime.now().second;
    print(timestamp);
    int uniqueInt = timestamp * 1000 + _counter;
    _counter++;
    return uniqueInt;
  }
}
