import 'package:virtual_toy_shop/data/model/avatar.dart';
import 'package:virtual_toy_shop/data/model/user.dart';

class ProfileState {
  bool noConnection;
  User? user;
  List<Avatar>? avatars;
  List<List<Avatar>>? chunkedAvatars;
  String? newName;
  String? newAvatar;
  String? nameError;

  ProfileState({
    this.avatars,
    this.chunkedAvatars,
    this.newAvatar,
    this.newName,
    this.nameError,
    this.user,
    this.noConnection = false,
  });

  ProfileState copyWith({
    bool? noConnection,
    User? user,
    List<Avatar>? avatars,
    List<List<Avatar>>? chunkedAvatars,
    String? newName,
    String? newAvatar,
    String? nameError,
  }) {
    return ProfileState(
      noConnection: noConnection ?? this.noConnection,
      user: user ?? this.user,
      avatars: avatars ?? this.avatars,
      chunkedAvatars: chunkedAvatars ?? this.chunkedAvatars,
      newAvatar: newAvatar ?? this.newAvatar,
      newName: newName ?? this.newName,
      nameError: nameError,
    );
  }
}
