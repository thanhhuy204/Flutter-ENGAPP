import '../domain/entities/game_item.dart';

class GlobalDataSource {
  // --- 1. ANIMALS (Động vật) ---
  static final List<GameItem> animals = [
    const GameItem(id: 'lion', image: 'assets/images/animals/lion.png', nameEn: 'Lion', nameJa: 'ライオン'),
    const GameItem(id: 'tiger', image: 'assets/images/animals/tiger.png', nameEn: 'Tiger', nameJa: 'トラ'),
    const GameItem(id: 'elephant', image: 'assets/images/animals/elephant.png', nameEn: 'Elephant', nameJa: 'ゾウ'),
    const GameItem(id: 'monkey', image: 'assets/images/animals/monkey.png', nameEn: 'Monkey', nameJa: 'サル'),
    const GameItem(id: 'zebra', image: 'assets/images/animals/zebra.png', nameEn: 'Zebra', nameJa: 'シマウマ'),
    const GameItem(id: 'giraffe', image: 'assets/images/animals/giraffe.png', nameEn: 'Giraffe', nameJa: 'キリン'),
    const GameItem(id: 'cat', image: 'assets/images/animals/cat.png', nameEn: 'Cat', nameJa: 'ネコ'),
    const GameItem(id: 'dog', image: 'assets/images/animals/dog.png', nameEn: 'Dog', nameJa: 'イヌ'),
    const GameItem(id: 'parrot', image: 'assets/images/animals/parrot.png', nameEn: 'Parrot', nameJa: 'オウム'),
    const GameItem(id: 'dolphin', image: 'assets/images/animals/dolphin.png', nameEn: 'Dolphin', nameJa: 'イルカ'),
    const GameItem(id: 'shark', image: 'assets/images/animals/shark.png', nameEn: 'Shark', nameJa: 'サメ'),
    const GameItem(id: 'penguin', image: 'assets/images/animals/penguin.png', nameEn: 'Penguin', nameJa: 'ペンギン'),
    const GameItem(id: 'camel', image: 'assets/images/animals/camel.png', nameEn: 'Camel', nameJa: 'ラクダ'),
    const GameItem(id: 'kangaroo', image: 'assets/images/animals/kangaroo.png', nameEn: 'Kangaroo', nameJa: 'カンガルー'),
    const GameItem(id: 'horse', image: 'assets/images/animals/horse.png', nameEn: 'Horse', nameJa: 'ウマ'),
    const GameItem(id: 'duck', image: 'assets/images/animals/duck.png', nameEn: 'Duck', nameJa: 'アヒル'),
    const GameItem(id: 'crab', image: 'assets/images/animals/crab.png', nameEn: 'Crab', nameJa: 'カニ'),
    const GameItem(id: 'fish', image: 'assets/images/animals/fish.png', nameEn: 'Fish', nameJa: 'サカナ'),
  ];

  // --- 2. FRUITS (Trái cây) ---
  static final List<GameItem> fruits = [
    const GameItem(id: 'apple', image: 'assets/images/fruits/apple.png', nameEn: 'Apple', nameJa: 'リンゴ'),
    const GameItem(id: 'banana', image: 'assets/images/fruits/banana.png', nameEn: 'Banana', nameJa: 'バナナ'),
    const GameItem(id: 'grape', image: 'assets/images/fruits/grape.png', nameEn: 'Grape', nameJa: 'ブドウ'),
    const GameItem(id: 'orange', image: 'assets/images/fruits/orange.png', nameEn: 'Orange', nameJa: 'オレンジ'),
    const GameItem(id: 'lemon', image: 'assets/images/fruits/lemon.png', nameEn: 'Lemon', nameJa: 'レモン'),
    const GameItem(id: 'cherry', image: 'assets/images/fruits/cherry.png', nameEn: 'Cherry', nameJa: 'サクランボ'),
    const GameItem(id: 'strawberry', image: 'assets/images/fruits/strawberry.png', nameEn: 'Strawberry', nameJa: 'イチゴ'),
    const GameItem(id: 'watermelon', image: 'assets/images/fruits/watermelon.png', nameEn: 'Watermelon', nameJa: 'スイカ'),
    const GameItem(id: 'mango', image: 'assets/images/fruits/mango.png', nameEn: 'Mango', nameJa: 'マンゴー'),
    const GameItem(id: 'pineapple', image: 'assets/images/fruits/pineapple.png', nameEn: 'Pineapple', nameJa: 'パイナップル'),
    const GameItem(id: 'pear', image: 'assets/images/fruits/pear.png', nameEn: 'Pear', nameJa: 'ナシ'),
    const GameItem(id: 'peach', image: 'assets/images/fruits/peach.png', nameEn: 'Peach', nameJa: 'モモ'),
  ];

  // --- 3. COLORS (Màu sắc) ---
  static final List<GameItem> colors = [
    const GameItem(id: 'red', image: 'assets/images/colors/Red.png', nameEn: 'Red', nameJa: 'あか'),
    const GameItem(id: 'blue', image: 'assets/images/colors/Blue.png', nameEn: 'Blue', nameJa: 'あお'),
    const GameItem(id: 'green', image: 'assets/images/colors/Green.png', nameEn: 'Green', nameJa: 'みどり'),
    const GameItem(id: 'yellow', image: 'assets/images/colors/Yellow.png', nameEn: 'Yellow', nameJa: 'きいろ'),
    const GameItem(id: 'purple', image: 'assets/images/colors/Purple.png', nameEn: 'Purple', nameJa: 'むらさき'),
    const GameItem(id: 'black', image: 'assets/images/colors/Black.png', nameEn: 'Black', nameJa: 'くろ'),
    const GameItem(id: 'white', image: 'assets/images/colors/White.png', nameEn: 'White', nameJa: 'しろ'),
    const GameItem(id: 'orange_col', image: 'assets/images/colors/Orange.png', nameEn: 'Orange', nameJa: 'オレンジいろ'),
    const GameItem(id: 'pink', image: 'assets/images/colors/Pink.png', nameEn: 'Pink', nameJa: 'ピンク'),
  ];

  // Hàm lấy tất cả dữ liệu (dùng cho Spelling hoặc Treasure Hunt level cao)
  static List<GameItem> getAll() {
    return [...animals, ...fruits, ...colors];
  }
}