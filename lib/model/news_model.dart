class Article {
  late int newsId;
  late String title;
  late User author;
  late String postTime;
  late String content;
  late String tag;
  late String contentImg;
  late List<Comment> comment;

  // 定义命名构造函数
  Article.fromMap(Map<String, dynamic> json) {
    newsId = json['newsId'];
    title = json['title'];
    author = User.fromMap(json['author']);
    postTime = json['postTime'];
    content = json['content'];
    contentImg = json['contentImg'];
    tag = json['tag'];
    comment = (json["comment"] as List<dynamic>).map((item) {
      return Comment.fromMap(item);
    }).toList();
  }

  @override
  String toString() {
    // TODO: implement toString
    return "文章信息==>> id:$newsId,title:$title,author:$author,postTime:$postTime,tag:$tag,comment:$comment";
  }
}

class Comment {
  late User user;
  late String comment;
  Comment.fromMap(Map<String, dynamic> json) {
    user = User.fromMap(json["user"]);
    comment = json["comment"];
  }
  @override
  String toString() {
    // TODO: implement toString
    return "评论==>> user:$user,commnet:$comment";
  }
}

class User {
  late String userName;
  late int userId;
  late String userImg;

  User.fromMap(Map<String, dynamic> json) {
    userName = json["userName"];
    userId = json["userId"];
    userImg = json["userImg"];
  }

  @override
  String toString() {
    // TODO: implement toString
    return "用户==>> userName:$userName,userId:$userId,userImg:$userImg";
  }
}
