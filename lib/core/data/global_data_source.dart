import '../domain/entities/game_item.dart';

class GlobalDataSource {
  // --- 1. ANIMALS (Động vật) ---
  static List<GameItem> animals = [
    const GameItem(id: 'lion', image: 'assets/images/animals/lion.png', nameEn: 'Lion', nameJa: 'ライオン', nameVi: 'Sư tử'),
    const GameItem(id: 'tiger', image: 'assets/images/animals/tiger.png', nameEn: 'Tiger', nameJa: 'トラ', nameVi: 'Con hổ'),
    const GameItem(id: 'elephant', image: 'assets/images/animals/elephant.png', nameEn: 'Elephant', nameJa: 'ゾウ', nameVi: 'Con voi'),
    const GameItem(id: 'monkey', image: 'assets/images/animals/monkey.png', nameEn: 'Monkey', nameJa: 'サル', nameVi: 'Con khỉ'),
    const GameItem(id: 'zebra', image: 'assets/images/animals/zebra.png', nameEn: 'Zebra', nameJa: 'シマウマ', nameVi: 'Ngựa vằn'),
    const GameItem(id: 'giraffe', image: 'assets/images/animals/giraffe.png', nameEn: 'Giraffe', nameJa: 'キリン', nameVi: 'Hươu cao cổ'),
    const GameItem(id: 'cat', image: 'assets/images/animals/cat.png', nameEn: 'Cat', nameJa: 'ネコ', nameVi: 'Con mèo'),
    const GameItem(id: 'dog', image: 'assets/images/animals/dog.png', nameEn: 'Dog', nameJa: 'イヌ', nameVi: 'Con chó'),
    const GameItem(id: 'parrot', image: 'assets/images/animals/parrot.png', nameEn: 'Parrot', nameJa: 'オウム', nameVi: 'Con vẹt'),
    const GameItem(id: 'dolphin', image: 'assets/images/animals/dolphin.png', nameEn: 'Dolphin', nameJa: 'イルカ', nameVi: 'Cá heo'),
    const GameItem(id: 'shark', image: 'assets/images/animals/shark.png', nameEn: 'Shark', nameJa: 'サメ', nameVi: 'Cá mập'),
    const GameItem(id: 'penguin', image: 'assets/images/animals/penguin.png', nameEn: 'Penguin', nameJa: 'ペンギン', nameVi: 'Chim cánh cụt'),
    const GameItem(id: 'camel', image: 'assets/images/animals/camel.png', nameEn: 'Camel', nameJa: 'ラクダ', nameVi: 'Lạc đà'),
    const GameItem(id: 'kangaroo', image: 'assets/images/animals/kangaroo.png', nameEn: 'Kangaroo', nameJa: 'カンガルー', nameVi: 'Chuột túi'),
    const GameItem(id: 'horse', image: 'assets/images/animals/horse.png', nameEn: 'Horse', nameJa: 'ウマ', nameVi: 'Con ngựa'),
    const GameItem(id: 'duck', image: 'assets/images/animals/duck.png', nameEn: 'Duck', nameJa: 'アヒル', nameVi: 'Con vịt'),
    const GameItem(id: 'crab', image: 'assets/images/animals/crab.png', nameEn: 'Crab', nameJa: 'カニ', nameVi: 'Con cua'),
    const GameItem(id: 'fish', image: 'assets/images/animals/fish.png', nameEn: 'Fish', nameJa: 'サカナ', nameVi: 'Con cá'),
  ];

  // --- 2. FRUITS (Trái cây) ---
  static List<GameItem> fruits = [
    const GameItem(id: 'apple', image: 'assets/images/fruits/apple.png', nameEn: 'Apple', nameJa: 'リンゴ', nameVi: 'Quả táo'),
    const GameItem(id: 'banana', image: 'assets/images/fruits/banana.png', nameEn: 'Banana', nameJa: 'バナナ', nameVi: 'Quả chuối'),
    const GameItem(id: 'grape', image: 'assets/images/fruits/grape.png', nameEn: 'Grape', nameJa: 'ブドウ', nameVi: 'Quả nho'),
    const GameItem(id: 'orange', image: 'assets/images/fruits/orange.png', nameEn: 'Orange', nameJa: 'オレンジ', nameVi: 'Quả cam'),
    const GameItem(id: 'lemon', image: 'assets/images/fruits/lemon.png', nameEn: 'Lemon', nameJa: 'レモン', nameVi: 'Quả chanh'),
    const GameItem(id: 'cherry', image: 'assets/images/fruits/cherry.png', nameEn: 'Cherry', nameJa: 'サクランボ', nameVi: 'Quả anh đào'),
    const GameItem(id: 'strawberry', image: 'assets/images/fruits/strawberry.png', nameEn: 'Strawberry', nameJa: 'イチゴ', nameVi: 'Dâu tây'),
    const GameItem(id: 'watermelon', image: 'assets/images/fruits/watermelon.png', nameEn: 'Watermelon', nameJa: 'スイカ', nameVi: 'Dưa hấu'),
    const GameItem(id: 'mango', image: 'assets/images/fruits/mango.png', nameEn: 'Mango', nameJa: 'マンゴー', nameVi: 'Quả xoài'),
    const GameItem(id: 'pineapple', image: 'assets/images/fruits/pineapple.png', nameEn: 'Pineapple', nameJa: 'パイナップル', nameVi: 'Quả dứa'),
    const GameItem(id: 'pear', image: 'assets/images/fruits/pear.png', nameEn: 'Pear', nameJa: 'ナシ', nameVi: 'Quả lê'),
    const GameItem(id: 'peach', image: 'assets/images/fruits/peach.png', nameEn: 'Peach', nameJa: 'モモ', nameVi: 'Quả đào'),
  ];

  // --- 3. COLORS (Màu sắc) ---
  static List<GameItem> colors = [
    const GameItem(id: 'red', image: 'assets/images/colors/Red.png', nameEn: 'Red', nameJa: 'あか', nameVi: 'Màu đỏ'),
    const GameItem(id: 'blue', image: 'assets/images/colors/Blue.png', nameEn: 'Blue', nameJa: 'あお', nameVi: 'Màu xanh dương'),
    const GameItem(id: 'green', image: 'assets/images/colors/Green.png', nameEn: 'Green', nameJa: 'みどり', nameVi: 'Màu xanh lá'),
    const GameItem(id: 'yellow', image: 'assets/images/colors/Yellow.png', nameEn: 'Yellow', nameJa: 'きいろ', nameVi: 'Màu vàng'),
    const GameItem(id: 'purple', image: 'assets/images/colors/Purple.png', nameEn: 'Purple', nameJa: 'むらさき', nameVi: 'Màu tím'),
    const GameItem(id: 'black', image: 'assets/images/colors/Black.png', nameEn: 'Black', nameJa: 'くろ', nameVi: 'Màu đen'),
    const GameItem(id: 'white', image: 'assets/images/colors/White.png', nameEn: 'White', nameJa: 'しろ', nameVi: 'Màu trắng'),
    const GameItem(id: 'orange_col', image: 'assets/images/colors/Orange.png', nameEn: 'Orange', nameJa: 'オレンジいろ', nameVi: 'Màu cam'),
    const GameItem(id: 'pink', image: 'assets/images/colors/Pink.png', nameEn: 'Pink', nameJa: 'ピンク', nameVi: 'Màu hồng'),
  ];

  static List<GameItem> getAll() {
    return [...animals, ...fruits, ...colors];
  }
}