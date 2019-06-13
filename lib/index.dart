import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'entity/blog.dart';
import 'application.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'blog_info.dart';
import 'entity/news.dart';
import 'news_info.dart';
import 'login.dart';

class IndexPage extends StatefulWidget {
  IndexPage(){
    Application.init();
  }
  @override
  IndexPageState createState() => new IndexPageState();
}

class IndexPageState extends State<IndexPage> with SingleTickerProviderStateMixin{
  GlobalKey<EasyRefreshState> _defaultEasyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _defaultHeaderKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _defaultFooterKey =
      new GlobalKey<RefreshFooterState>();
  GlobalKey<EasyRefreshState> _essenceEasyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _essenceHeaderKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _essenceFooterKey =
      new GlobalKey<RefreshFooterState>();
  GlobalKey<EasyRefreshState> _newsEasyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _newsHeaderKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _newsFooterKey =
      new GlobalKey<RefreshFooterState>();
  TabController _tabController;
  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('博客园'),
//          actions: <Widget>[
//            IconButton(icon: Icon(Icons.search), onPressed: () {}),
//          ],
          bottom: TabBar(
            controller: _tabController,
            onTap: (index){
              _pageController.jumpToPage(index);
            },
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            tabs: [
              new Tab(
                text: '首页',
              ),
              new Tab(
                text: '精华',
              ),
              new Tab(
                text: '新闻',
              ),
            ],
          ),
        ),
        drawer: Container(
          alignment: Alignment.topLeft,
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.7,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(new MaterialPageRoute(builder: (_) {
                            return new LoginPage();
                          }));
                        },
                        padding: EdgeInsets.only(bottom: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipOval(
                              child: Image.network(
                                Application.User == null
                                    ? 'http://hbimg.b0.upaiyun.com/79e75e5d00341d770a89d081d2f11617e2be3577eda-VrL3fb_fw658'
                                    : Application.User.Avatar,
                                width: 80,
                                height: 80,
                              ),
                            ),
                            Text(
                              Application.User == null
                                  ? '未登录'
                                  : Application.User.DisplayName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                    Flexible(
                      child:Container()
                    ),
                    Offstage(
                      offstage: Application.User == null ? true : false,
                      child: FlatButton(
                        onPressed: () {
                          //Todo 点击注销事件
                        },
                        child: Text('注销',style: TextStyle(color:Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('设置'),
              ),
              Divider(),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if(index==0 && _liDefault.length==0) _getDefaultArticlesHttp();
            if(index==1 && _liEssence.length==0) _getEssenceArticlesHttp();
            if(index==2 && _liNews.length==0) _getNewsArticlesHttp();
            //标签进行相应的改变
            _tabController.animateTo(index);
          },
          children: [
            _buildDefaultArticlesWidget(),
//            Text('首页'),
//            Text('精华'),
            _buildEssenceArticlesWidget(),
//            Text('新闻'),
            _buildNewsArticlesWidget(),
          ],
        ),
      ),
    );
  }

  List<BlogEntity> _liDefault = new List();
  int _default_page_index = 0;
  static const int _default_page_site = 10;
  //展示“首页”数据
  Widget _buildDefaultArticlesWidget() {
    return EasyRefresh(
      key: _defaultEasyRefreshKey,
      autoLoad: false,
      behavior: ScrollOverBehavior(),
      refreshHeader: BezierCircleHeader(
        key: _defaultHeaderKey,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      refreshFooter: BezierBounceFooter(
        key: _defaultFooterKey,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      onRefresh: () async {
        _default_page_index = 0;
        _liDefault.clear();
        await _getDefaultArticlesHttp();
      },
      loadMore: () async {
        await _getDefaultArticlesHttp();
      },
      child: ListView.separated(
          itemBuilder: (context, index) {
            final BlogEntity blog = _liDefault[index];
            return GestureDetector(
              onTap: () {
//                Application.router.navigateTo(context, '/blog/info');
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new BlogInfoPage(blog);
                }));
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            blog.Avatar,
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              blog.Author,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(Application.getTime(blog.PostDate)),
                        ],
                      ),
                      Text(
                        blog.Title,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        blog.Description,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('${blog.ViewCount} 阅读 ${blog.CommentCount} 评论'),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: _liDefault.length),
    );
  }

  Future _getDefaultArticlesHttp() async {
    try {
      _default_page_index++;
      Response response = await Application.SystemDio.get(
          "https://api.cnblogs.com/api/blogposts/@sitehome",
          queryParameters: {
            "pageIndex": _default_page_index,
            "pageSize": _default_page_site
          });
      if (response == null || response.statusCode != 200) return;
      print('【首页】第${_default_page_index}页数据：' + response.data.toString());
      List<BlogEntity> data = List.generate(response.data.length, (index) {
        return BlogEntity.fromJson(response.data[index]);
      }).toList();
      setState(() {
        _liDefault.addAll(data);
      });
    } catch (e) {
      _default_page_index--;
      print(e);
    }
  }

  List<BlogEntity> _liEssence = new List();
  int _essence_page_index = 0;
  static const int _essence_page_site = 10;
  //展示“精华”数据
  Widget _buildEssenceArticlesWidget() {
    return EasyRefresh(
      key: _essenceEasyRefreshKey,
      autoLoad: false,
      behavior: ScrollOverBehavior(),
      refreshHeader: BezierCircleHeader(
        key: _essenceHeaderKey,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      refreshFooter: BezierBounceFooter(
        key: _essenceFooterKey,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      onRefresh: () async {
        _essence_page_index = 0;
        _liEssence.clear();
        await _getEssenceArticlesHttp();
      },
      loadMore: () async {
        await _getEssenceArticlesHttp();
      },
      child: ListView.separated(
          itemBuilder: (context, index) {
            final BlogEntity blog = _liEssence[index];
            return GestureDetector(
              onTap: () {
//                Application.router.navigateTo(context, '/blog/info');
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new BlogInfoPage(blog);
                }));
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            blog.Avatar,
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              blog.Author,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(Application.getTime(blog.PostDate)),
                        ],
                      ),
                      Text(
                        blog.Title,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        blog.Description,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('${blog.ViewCount} 阅读 ${blog.CommentCount} 评论'),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: _liEssence.length),
    );
  }

  Future _getEssenceArticlesHttp() async {
    try {
      _essence_page_index++;
      Response response = await Application.SystemDio.get(
          "https://api.cnblogs.com/api/blogposts/@picked",
          queryParameters: {
            "pageIndex": _essence_page_index,
            "pageSize": _essence_page_site
          });
      if (response == null || response.statusCode != 200) return;
      print('【精华】第${_essence_page_index}页数据：' + response.data.toString());
      List<BlogEntity> data = List.generate(response.data.length, (index) {
        return BlogEntity.fromJson(response.data[index]);
      }).toList();
      setState(() {
        _liEssence.addAll(data);
      });
    } catch (e) {
      _essence_page_index--;
      print(e);
    }
  }

  List<NewsEntity> _liNews = new List();
  int _news_page_index = 0;
  static const int _news_page_site = 10;
  //展示“新闻”数据
  Widget _buildNewsArticlesWidget() {
    return EasyRefresh(
      key: _newsEasyRefreshKey,
      autoLoad: false,
      behavior: ScrollOverBehavior(),
      refreshHeader: BezierCircleHeader(
        key: _newsHeaderKey,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      refreshFooter: BezierBounceFooter(
        key: _newsFooterKey,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      onRefresh: () async {
        _news_page_index = 0;
        _liNews.clear();
        await _getNewsArticlesHttp();
      },
      loadMore: () async {
        await _getNewsArticlesHttp();
      },
      child: ListView.separated(
          itemBuilder: (context, index) {
            final NewsEntity news = _liNews[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new NewsInfoPage(news);
                }));
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                '${news.ViewCount} 阅读 ${news.CommentCount} 评论'),
                          ),
                          Text(Application.getTime(news.DateAdded)),
                        ],
                      ),
                      Text(
                        news.Title,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        news.Summary,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: _liNews.length),
    );
  }

  Future _getNewsArticlesHttp() async {
    try {
      _news_page_index++;
      Response response = await Application.SystemDio.get(
          "https://api.cnblogs.com/api/NewsItems",
          queryParameters: {
            "pageIndex": _news_page_index,
            "pageSize": _news_page_site
          });
      if (response == null || response.statusCode != 200) return;
      print('【新闻】第${_news_page_index}页数据：' + response.data.toString());
      List<NewsEntity> data = List.generate(response.data.length, (index) {
        return NewsEntity.fromJson(response.data[index]);
      }).toList();
      setState(() {
        _liNews.addAll(data);
      });
    } catch (e) {
      _news_page_index--;
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _pageController = new PageController(keepPage: true);
    Application.bindToken().then((cd){
      _getDefaultArticlesHttp();
//      _getEssenceArticlesHttp();
//      _getNewsArticlesHttp();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
  }

  @override
  void didUpdateWidget(IndexPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
