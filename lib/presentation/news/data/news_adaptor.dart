import 'package:bit_connect/presentation/news/model/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class NewsAdaptor extends TypeAdapter<NewsModel> {
  @override
  NewsModel read(BinaryReader reader) {
    final title = reader.readString();
    final detail = reader.readString();
    final uploadDate = Timestamp.fromMillisecondsSinceEpoch(reader.readInt());
    final imgUrl = reader.readString();

    return NewsModel(
      title: title,
      detail: detail,
      uploadDate: uploadDate,
      imgUrl: imgUrl,
    );
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, NewsModel obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.detail);
    writer.writeInt(obj.uploadDate.millisecondsSinceEpoch);
    writer.writeString(obj.imgUrl);
  }
}
