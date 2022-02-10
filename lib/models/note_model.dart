class Note {
  late int id;
  late DateTime createTime;
  DateTime? editTime;
  late String title;
  late String content;

  Note({
    required this.id,
    required this.createTime,
    this.editTime,
    required this.title,
    required this.content,
  });

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = DateTime.parse(json['createTime']);
    editTime = (json['editTime'] != "null" && json['editTime'] != null) ? DateTime.parse(json['editTime']) : null;
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'createTime' : createTime.toString(),
    'editTime' : editTime.toString(),
    'title' : title,
    'content' : content,
  };
}