extension BoolX on bool {
  int compareTo(bool other) {
    if (this == other) {
      return 0;
    } else if (this == true && other == false) {
      return -1;
    } else {
      return 1;
    }
  }
}
