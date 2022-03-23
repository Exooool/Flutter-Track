import 'dart:convert';

class Article {
  late int newsId;
  late String newsTitle;
  late int userId;
  late String userName;
  late String userImg;
  late String newsTime;
  late int viewNum;
  late List likeNum;
  late int commentNum;
  late String newsContent;
  late String hashtag;
  late String newsImg;
  late String content;
  // 定义命名构造函数
  Article.fromMap(Map<String, dynamic> json) {
    newsId = json['news_id'];
    newsTitle = json['news_title'];
    // author = User.fromMap(json['author']);
    newsTime = json['news_time'];
    viewNum = json['view_num'];
    likeNum = jsonDecode(json['like_num']);
    commentNum = json['comment_num'];
    newsContent = json['news_content'];
    newsImg = json['news_img'];
    hashtag = json['hashtag'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImg = json['user_img'];
    content = json['content'];
    // comment = (json["comment"] as List<dynamic>).map((item) {
    //   return Comment.fromMap(item);
    // }).toList();
  }

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return "文章信息==>> id:$newsId,title:$title,author:$author,postTime:$postTime,tag:$tag,comment:$comment";
  // }
}

// class Comment {
//   late User user;
//   late String comment;
//   Comment.fromMap(Map<String, dynamic> json) {
//     user = User.fromMap(json["user"]);
//     comment = json["comment"];
//   }
//   @override
//   String toString() {
//     // TODO: implement toString
//     return "评论==>> user:$user,commnet:$comment";
//   }
// }

// class User {
//   late String userName;
//   late int userId;
//   late String userImg;

//   User.fromMap(Map<String, dynamic> json) {
//     userName = json["userName"];
//     userId = json["userId"];
//     userImg = json["userImg"];
//   }

//   @override
//   String toString() {
//     // TODO: implement toString
//     return "用户==>> userName:$userName,userId:$userId,userImg:$userImg";
//   }
// }
