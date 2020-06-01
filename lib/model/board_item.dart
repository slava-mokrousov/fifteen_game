class BoardItem {
  bool isEmpty;
  bool isNearEmpty;
  int number;

  BoardItem (int n) {
    this.isEmpty = false;
    this.isNearEmpty = false;
    this.number = n;
}

void swapItem(BoardItem item) {
    this.number = item.number;
    this.isEmpty = item.isEmpty;
    this.isNearEmpty = item.isNearEmpty;
}

}