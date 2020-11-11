import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String title = 'ListView with an Overview';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: title),
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
  final List<int> _items = List<int>.generate(200, (index) => index + 1);

  int sum = 0;
  int topIndex = 0;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  void updateSum() {
    sum = 0;
    for (int i = 0; i <= topIndex; i++) {
      sum += _items[i];
    }
    print("updateSum = $sum");
    // return sum;
  }

  Widget _buildContainer() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      color: Colors.lightBlue[200],
      child: Center(
          child: Text(
        "Sum = $sum",
        style: TextStyle(fontSize: 30),
      )),
    );
  }

  Widget _buildBoth() {
    return ValueListenableBuilder<Iterable<ItemPosition>>(
      valueListenable: itemPositionsListener.itemPositions,
      builder: (context, positions, child) {
        if (positions.isNotEmpty) {
          // print(positions);
          topIndex = positions
              .where(
                (ItemPosition position) => (position.itemLeadingEdge >= 0),
              )
              .reduce(
                (ItemPosition min, ItemPosition position) => position.itemTrailingEdge < min.itemTrailingEdge ? position : min,
              )
              .index;
        }

        updateSum();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContainer(),
            Expanded(
              child: _buildListView(),
            )
          ],
        );
        // updateSum();
        // return _buildListView();
      },
    );
  }

  Widget _buildListView() {
    return ScrollablePositionedList.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: topIndex == index ? 80 : 50,
          child: Container(
            color: topIndex == index ? Colors.orange[100] : Colors.grey[200],
            child: Center(child: Text(_items[index].toString())),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
          ),
        );
      },
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(_items);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBoth(),
    );
  }
}
