import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DragScrollSheetWithFab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Messages'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          )
        ],
      ),
    );
  }
}

class DragScrollSheetWithFab extends StatefulWidget {
  @override
  _DragScrollSheetWithFabState createState() => _DragScrollSheetWithFabState();
}

class _DragScrollSheetWithFabState extends State<DragScrollSheetWithFab> {
  double _initialSheetChildSize = 0.5;
  double _dragScrollSheetExtent = 0;

  double _widgetHeight = 0;
  double _fabPosition = 0;
  double _fabPositionPadding = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // render the floating button on widget
        _fabPosition = _initialSheetChildSize * context.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: Text(
              'Height: ${_widgetHeight.toStringAsFixed(2)}, \nExtent: ${_dragScrollSheetExtent.toStringAsFixed(2)}, \nFabYPosition: ${_fabPosition.toStringAsFixed(2)}'),
        ),
        Positioned(
          bottom: _fabPosition + _fabPositionPadding,
          right:
              _fabPositionPadding, // Padding to create some space on the right
          child: FloatingActionButton(
            child: Icon(Icons.my_location),
            onPressed: () => print('Add'),
          ),
        ),
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (DraggableScrollableNotification notification) {
            setState(() {
              _widgetHeight = context.size.height;
              _dragScrollSheetExtent = notification.extent;

              // Calculate FAB position based on parent widget height and DraggableScrollable position
              _fabPosition = _dragScrollSheetExtent * _widgetHeight;
            });
            return;
          },
          child: DraggableScrollableSheet(
            initialChildSize: _initialSheetChildSize,
            maxChildSize: 0.5,
            minChildSize: 0.1,
            builder: (context, scrollController) => ListView.builder(
              controller: scrollController,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.grey,
                  child: ListTile(
                    title: Text('Item $index'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
