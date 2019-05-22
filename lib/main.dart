import 'package:flutter/material.dart';
import 'package:flutter_gallery/page/page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'http/PictureFetcher.dart';
import 'model/picture.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';

void main() => runApp(MyApp());

typedef void IndexChangeCallback(int index);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Picture> pictureList = new List<Picture>();
  int page = 0;
  int currentIndex = 0;
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getPage().then((value) {
      print(value);
      page = value;
      _fetchPictures(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: new Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [
                Colors.grey.shade400,
                Colors.grey.shade500,
              ],
            ),
          ),
          child: new Stack(
            children: <Widget>[
              new Center(
                child: new GalleryPageView(pictureList, (index) {
                  print("滚动到第$index页");
                  currentIndex = index;
                }),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : new Container(),
              new Align(
                alignment: FractionalOffset.bottomRight,
                child: new IconButton(
                  onPressed: _refresh,
                  icon: Icon(Icons.refresh),
                ),
              ),
              new Align(
                alignment: FractionalOffset.bottomLeft,
                child: new IconButton(
                  onPressed: _saveImage,
//              onPressed: _refresh,
                  icon: Icon(Icons.file_download),
                ),
              ),
            ],
          ),
        ));
  }

  void _refresh() {
    print("refresh");
    _fetchPictures(++page);
  }

  void _fetchPictures(int page) async {
    final _fetcher = PictureFetcher();
    List<Picture> pictureList = await _fetcher.fetchPictures(page: page);
    print(pictureList.length);
    _incrementPage();
    setState(() {
      this.pictureList = pictureList;
    });
  }

  _incrementPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('current page $page is saved');
    await prefs.setInt('page', page);
  }

  void _saveImage() {
    print("_saveImage:${pictureList[currentIndex].download_url}");
    _onImageSaveButtonPressed(pictureList[currentIndex].download_url);
  }

  _onImageSaveButtonPressed(String url) async {
    print("_onImageSaveButtonPressed:$url");
    setState(() {
      isLoading = true;
    });
    await http
        .get(url)
        .then((response) =>
            ImagePickerSaver.saveFile(fileData: response.bodyBytes))
        .then((filePath) {
      print("已经保存到：$filePath");
      _scaffoldKey.currentState?.showSnackBar(
          new SnackBar(content: Text("已经保存到：$filePath"), action: null));
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<int> _getPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('page') ?? 0;
  }
}
