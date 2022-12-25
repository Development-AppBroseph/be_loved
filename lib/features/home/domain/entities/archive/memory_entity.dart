import 'package:equatable/equatable.dart';

class MemoryEntity extends Equatable {
  final int currentSize;
  final int maxSize;

  MemoryEntity({
    required this.currentSize,
    required this.maxSize,
  });


  String getInGigabytesMaxSize(){
    return (maxSize/1024/1024).toInt().toString();
  }
  String getInGigabytesCurrentSize(){
    double res = currentSize/1024/1024;
    if(res <= 0.049){
      return '0';
    }else{
      res = res.toPrecision(1);
    }
    return res.toString();
  }
  


  @override
  List<Object> get props => [
    currentSize,
    maxSize
  ];
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}