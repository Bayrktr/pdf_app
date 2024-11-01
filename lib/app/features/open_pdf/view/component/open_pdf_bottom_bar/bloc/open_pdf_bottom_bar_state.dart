import 'package:equatable/equatable.dart';

class OpenPdfBottomBarState with EquatableMixin {
  OpenPdfBottomBarState({
    this.isShow = true,
  });

  final bool isShow;

  @override
  List<Object?> get props => [isShow];

  OpenPdfBottomBarState copyWith({
    bool? isShow,
  }) =>
      OpenPdfBottomBarState(
        isShow: isShow ?? this.isShow,
      );
}