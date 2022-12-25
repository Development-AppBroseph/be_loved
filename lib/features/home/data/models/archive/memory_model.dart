import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';

class MemoryModel extends MemoryEntity{
  MemoryModel({
    required int currentSize,
    required int maxSize,

  }) : super(
    currentSize: currentSize,
    maxSize: maxSize
  );

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      currentSize: json['your_size'],
      maxSize: json['max_size'],
    );
  }
}