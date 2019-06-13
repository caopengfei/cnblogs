
class BlogEntity{
  //编号
  int Id;
  //标题	string
  String Title;
  //链接
  String Url;
  //说明
  String Description;
  //作者
  String Author;
  //博客名
  String BlogApp;
  //头像链接
  String Avatar;
  //发布时间
  DateTime PostDate;
  //浏览次数
  int ViewCount;
  //评论次数
  int CommentCount;
  //	点击次数
  int DiggCount;

  BlogEntity(this.Id, this.Author,this.Avatar,this.BlogApp,this.CommentCount,this.Description,this.DiggCount,this.PostDate,this.Title,this.Url,this.ViewCount);

  BlogEntity.fromJson(Map<String, dynamic> json)
      : Id = int.parse(json['Id'].toString()),
        Author = json['Author'],
        Avatar = json['Avatar'],
        BlogApp = json['BlogApp'],
        Description = json['Description'],
        PostDate = DateTime.parse(json['PostDate'].toString()),
        Title = json['Title'],
        Url = json['Url'],
        ViewCount = int.parse(json['ViewCount'].toString()),
        DiggCount = int.parse(json['DiggCount'].toString()),
        CommentCount =int.parse(json['CommentCount'].toString());

  Map<String, dynamic> toJson() =>
      {
        'Id': Id,
        'Author': Author,
        'Avatar': Avatar,
        'BlogApp': BlogApp,
        'Description': Description,
        'PostDate': PostDate,
        'Title': Title,
        'Url': Url,
        'ViewCount': ViewCount,
        'DiggCount': DiggCount,
        'CommentCount': CommentCount,
      };
}