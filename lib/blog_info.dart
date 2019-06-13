import 'package:flutter/material.dart';
import 'entity/blog.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'application.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class BlogInfoPage extends StatefulWidget {
  final BlogEntity info;
  BlogInfoPage(this.info);
  @override
  BlogInfoPageState createState() => new BlogInfoPageState();
}

class BlogInfoPageState extends State<BlogInfoPage> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('博文'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.info.Title,
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
            Row(
              children: <Widget>[
                Image.network(
                  widget.info.Avatar,
                  width: 30,
                  height: 30,
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.info.Author,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  Application.getTime(widget.info.PostDate),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Container(
              height: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Html(
                  data: content,
                  padding: EdgeInsets.all(0),
                  linkStyle: const TextStyle(
                    color: Colors.blue,
                    decorationColor: Colors.blue,
                    decoration: TextDecoration.none,
                  ),
                  onLinkTap: (url) {
                    print(url);
                    if (url != null && url.trim().isNotEmpty)
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (_) {
                        return new WebviewScaffold(
                          url: url,
                          appBar: new AppBar(
                            title: new Text(""),
                          ),
                          initialChild: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: const Center(
                              child: Text('加载中.....'),
                            ),
                          ),
                        );
                      }));
                  },
                ),
              ),
            ),
            Row(

            ),
          ],
        ),
      ),
    );
  }

  void _getBlogInfo() async {
    try {
      Response response = await Application.SystemDio
          .get("https://api.cnblogs.com/api/blogposts/${widget.info.Id}/body");
      if (response == null || response.statusCode != 200) return;
//      print('第${_default_page_index}页数据：' + response.data.toString());
//      List<BlogEntity> data = List.generate(response.data.length, (index) {
//        return BlogEntity.fromJson(response.data[index]);
//      }).toList();
      setState(() {
//        _liDefault.addAll(data);
        content = response.data.toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getBlogInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(BlogInfoPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
