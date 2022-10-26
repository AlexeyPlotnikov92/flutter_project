import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  const Pagination({Key? key}) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

enum _MaterialListType {
  oneLine,

  oneLineWithAvatar,

  twoLine,

  threeLine,
}

class _PaginationState extends State<Pagination> {
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 5, keepScrollOffset: true);





  Widget customScrollView1() {
    _scrollController.addListener(() {});
    return CustomScrollView(
      shrinkWrap: false,
      primary: false,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      slivers: <Widget>[
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text(
                  'grid item $index',
                  style:
                      TextStyle(fontSize: 12, decoration: TextDecoration.none),
                ),
              );
            },
            childCount: 20,
          ),

          /// Устанавливаем свойства сетки:
          ///SliverGridDelegateWithMaxCrossAxisExtent：
          /// Рассчитываем количество элементов в соответствии с установленной максимальной шириной раскрытия
          ///SliverGridDelegateWithFixedCrossAxisCount:
          /// Количество элементов в строке можно фиксировать
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,

            /// коэффициент масштабирования высоты элемента, по умолчанию 1; меньше 1 означает увеличение, больше 1 означает уменьшение
            childAspectRatio: 1,
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index % 9)],
              child: Text(
                'SliverList item $index',
                style: TextStyle(fontSize: 12, decoration: TextDecoration.none),
              ),
            );
          }, childCount: 20),
        ),
        SliverFixedExtentList(
          /// фиксированная высота элемента
          itemExtent: 50,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text(
                  'list item $index',
                  style:
                      TextStyle(fontSize: 12, decoration: TextDecoration.none),
                ),
              );
            },
            childCount: 20,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            Text(
              "SliverList SliverChildListDelegate",
              style: TextStyle(fontSize: 12, decoration: TextDecoration.none),
            ),
            Image.asset("assets/flutter-mark-square-64.png"),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Text(
                "SliverPadding SliverChildListDelegate",
                style: TextStyle(fontSize: 12, decoration: TextDecoration.none),
              ),
              Image.asset("assets/flutter-mark-square-64.png"),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: Text(
            "SliverToBoxAdapter",
            style: TextStyle(fontSize: 16, decoration: TextDecoration.none),
          ),
        ),
      ],
    );
  }

  List<String> items = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget listView3() {
    // коллекция виджетов элемента
    return ListView.builder(
      // Устанавливаем количество элементов
      itemCount: items.length,
      itemBuilder: (BuildContext context, int position) {
        return getItem(items.elementAt(position));
      },
    );
  }

  void changeItemType(_MaterialListType type) {
    print("changeItemType");
  }


  Widget getItem(String item) {
    // if (i.isOdd) {
    //   return Divider();
    // }
    return GestureDetector(
      // child: Padding(
      //   padding: EdgeInsets.all(10.0),
      //   child: ListTile(
      //       dense: true,
      //       title: Text('Two-line ' + item),
      //       trailing: Radio<_MaterialListType>(
      //         value: _MaterialListType.twoLine,
      //         groupValue: _MaterialListType.twoLine,
      //         onChanged: changeItemType,
      //       )),
      // ),
      onTap: () {
        setState(() {
          // print('row $i');
        });
      },
      onLongPress: () {},
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      body: listView3(),
    );
  }
}
