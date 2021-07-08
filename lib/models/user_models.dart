class UserModel {
  String _responsecode = "";
  String _responsemsg = "";
  late User _user;

  UserModel({required String responsecode, required String responsemsg, required User user}) {
    this._responsecode = responsecode;
    this._responsemsg = responsemsg;
    this._user = user;
  }

  String get responsecode => _responsecode;
  String get responsemsg => _responsemsg;
  User get user => _user;
  
  UserModel.fromJson(Map<String, dynamic> json) {
    _responsecode = json['responsecode'];
    _responsemsg = json['responsemsg'];
    _user = (json['user'] != null ? new User.fromJson(json['user']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this._responsecode;
    data['responsemsg'] = this._responsemsg;
    data['user'] = this._user.toJson();
    return data;
  }
}

class User {
  int _id = 0;
  String _level = "";
  String _photo = "";
  String _name = "";
  String _email = "";

  User({
    int id = 0,
    String level = "",
    String photo = "",
    String name = "",
    String email = ""
      }) {
    this._id = id;
    this._level = level;
    this._photo = photo;
    this._name = name;
    this._email = email;
  }

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _level = json['level'];
    _photo = json['photo'];
    _name = json['name'];
    _email = json['email'];
  }

  int get id => _id;
  String get level => _level;
  String get photo => _photo;
  String get name => _name;
  String get email => _email;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['level'] = this._level;
    data['photo'] = this._photo;
    data['name'] = this._name;
    data['email'] = this._email;

    return data;
  }
}