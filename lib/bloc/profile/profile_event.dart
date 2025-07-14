import 'dart:typed_data';

import 'package:equatable/equatable.dart';
abstract class ProfileEvent extends Equatable {
  
  @override
  List<Object?> get props => []; // equatable sınıfından gelen override equatable objeleri içeriklerine göre karşılaştırmamıza yarar
}

class SavePPEvent extends ProfileEvent{
  final Uint8List image;

  SavePPEvent(this.image);

  @override
  List<Object?> get props => [image]; // image değişkenine göre objeleri karşılaştırırken işimze yarayacak
}
