/// Created by Chandan Jana on 12-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class LevelImageData {
  String? levelId;
  String? levelName;
  String? imageByteArray;
  String? imageName;

  LevelImageData(
      {this.levelId, this.levelName, this.imageByteArray, this.imageName});

  LevelImageData.fromJson(Map<String, dynamic> json) {
    levelId = json['levelId'];
    levelName = json['levelName'];
    imageByteArray = json['imageByteArray'];
    imageName = json['imageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['levelId'] = this.levelId;
    data['levelName'] = this.levelName;
    data['imageByteArray'] = this.imageByteArray;
    data['imageName'] = this.imageName;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
