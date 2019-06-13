import 'package:flutter/material.dart';
import 'entity/news.dart';
import 'package:dio/dio.dart';
import 'application.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewsInfoPage extends StatefulWidget {
  final NewsEntity info;
  NewsInfoPage(this.info);
  @override
  NewsInfoPageState createState() => new NewsInfoPageState();
}

class NewsInfoPageState extends State<NewsInfoPage> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('新闻'),
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
              children: [
                Expanded(
                  child: Text('${widget.info.ViewCount} 阅读 ${widget.info.CommentCount} 评论'),
                ),
                Text(Application.getTime(widget.info.DateAdded)),
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
                        );
                      }));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getInfo() async {
    try {
      Response response = await Application.SystemDio.get(
          "https://api.cnblogs.com/api/newsitems/${widget.info.Id}/body");
      if (response == null || response.statusCode != 200) return;
//      print('第${_default_page_index}页数据：' + response.data.toString());
//      List<BlogEntity> data = List.generate(response.data.length, (index) {
//        return BlogEntity.fromJson(response.data[index]);
//      }).toList();
      setState(() {
//        _liDefault.addAll(data);
        content = response.data.toString();
        print(content);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(NewsInfoPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
