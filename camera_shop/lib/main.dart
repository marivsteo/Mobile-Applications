import 'package:flutter/material.dart';

import 'AnimatedList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<Camera> _list;
  Camera _selectedItem;
  int i = 1;
  AddPage addPage = AddPage();

  @override
  void initState() {
    super.initState();
    _list = ListModel<Camera>(
      listKey: _listKey,
      initialItems: <Camera>[
        Camera("Sony A7S3", "full-frame", "f1.2", "24.2", "35mm full-frame"),
        Camera("Sony a6300", "full-frame", "f1.4", "24.2", "35mm full-frame"),
        Camera("Sony a6400", "full-frame", "f1.3", "24.2", "35mm full-frame"),
        Camera("Sony A7R3", "full-frame", "f1.1", "24.2", "35mm full-frame"),
        Camera("Sony A73", "full-frame", "f1.5", "24.2", "35mm full-frame"),
        Camera("Canon EOS R", "full-frame", "f1.5", "24.2", "35mm full-frame"),
        Camera("Canon EOS R5", "full-frame", "f1.7", "24.2", "35mm full-frame"),
        Camera("Canon EOS R6", "mirror-less", "f1.0", "24.2", "35mm full-frame"),
      ],
      removedItemBuilder: _buildRemovedItem,
    );
    i++;
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
      onDoubleTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  Widget _buildRemovedItem(
      Camera item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() async {
    final int index =
    _selectedItem == null ? _list.length : _list.indexOf(_selectedItem);
    final Camera item = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => addPage,
        ));

    _list.insert(index, item);
    i++;
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  void _update() async {
    if (_selectedItem != null) {
      final Camera item = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditPage(),
              settings: RouteSettings(arguments: _selectedItem)));

      final int index =
      _selectedItem == null ? _list.length : _list.indexOf(_selectedItem);

      setState(() {
        // _list.setProperty()
        _list.update(index, item);
        _selectedItem = null;
      });
    }
  }

  void _details() {
    if (_selectedItem != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailScreen(),
              settings: RouteSettings(arguments: _selectedItem)));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Text('Camera Shop'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _insert,
              tooltip: 'Insert a new item',
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: _remove,
              tooltip: 'Remove the selected item',
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _update,
              tooltip: 'Update the selected item',
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _details,
              tooltip: 'Details of the selected item',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: _buildItem,
          ),
        ));
  }
}

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int i = 1;
  int index;
  var nameController = TextEditingController();
  var typeController = TextEditingController();
  var megaPixelsController = TextEditingController();
  var apertureController = TextEditingController();
  var sensorTypeController = TextEditingController();

  _AddPageState();

  void save() {
    i++;

    Navigator.pop(
        context,
        Camera(nameController.text, typeController.text, apertureController.text,
            megaPixelsController.text, sensorTypeController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Camera'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save_alt_rounded),
              onPressed: save,
              tooltip: 'Insert a new item',
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Name", contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: typeController,
                decoration: InputDecoration(
                    labelText: "Type", contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: apertureController,
                decoration: InputDecoration(
                    labelText: "Aperture", contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: megaPixelsController,
                decoration: InputDecoration(
                    labelText: "Number of mega-pixels", contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: sensorTypeController,
                decoration: InputDecoration(
                    labelText: "Type of sensor", contentPadding: EdgeInsets.all(10)),
              ),
            ),
          ],
        ));
  }
}

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  var nameController = TextEditingController();
  var typeController = TextEditingController();
  var megaPixelsController = TextEditingController();
  var apertureController = TextEditingController();
  var sensorTypeController = TextEditingController();

  _EditPageState();

  void edit() {
    Navigator.pop(
        context,
        Camera(nameController.text, typeController.text, apertureController.text,
            megaPixelsController.text, sensorTypeController.text));
  }

  @override
  Widget build(BuildContext context) {
    final Camera item = ModalRoute.of(context).settings.arguments;
    nameController.text = item.name;
    typeController.text = item.type;
    apertureController.text = item.aperture;
    megaPixelsController.text = item.megaPixels;
    sensorTypeController.text = item.sensorType;

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Camera'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save_alt_rounded),
              onPressed: edit,
              tooltip: 'Save changes',
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Name", contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: typeController,
                decoration: InputDecoration(
                    labelText: "Type", contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: apertureController,
                decoration: InputDecoration(
                    labelText: "Aperture", contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: megaPixelsController,
                decoration: InputDecoration(
                    labelText: "Number of mega-pixels", contentPadding: EdgeInsets.all(10)),
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: sensorTypeController,
                decoration: InputDecoration(
                    labelText: "Type of sensor", contentPadding: EdgeInsets.all(10)),
              ),
            ),
          ],
        ));
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Camera item = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: Column(
          children: <Widget>[
            Text(
              "Type: " + item.type,
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.purple),
            ),
            Text(
              "Aperture: " + item.aperture,
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo[200]),
            ),
            Text(
              "Number of mega-pixels: " + item.megaPixels,
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigoAccent),
            ),
            Text(
              "Type of sensor: " + item.sensorType,
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigoAccent),
            ),
          ],
        ));
  }
}

