import 'dart:io';
import 'dart:typed_data';

class MultipartFile {
  late final Stream stream;

  MultipartFile.fromBytes(Uint8List data) {
    stream = Stream.fromIterable(data);
  }

  MultipartFile.fromStream(Stream<int> data) {
    stream = data;
  }

  MultipartFile.fromFile(File data) {
    stream = data.openRead();
  }
}
