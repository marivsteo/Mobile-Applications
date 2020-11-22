import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  void update(int index, E item) {
    _items[index] = item;
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem(
      {Key key,
      @required this.animation,
      this.onTap,
      @required this.item,
      this.selected = false,
      this.onDoubleTap})
      : assert(animation != null),
        assert(item != null),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final GestureTapCallback onDoubleTap;
  final Camera item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.redAccent);
    return Padding(padding: const EdgeInsets.all(2.0),
    child: SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        child: SizedBox(
          height: 60.0,
          child: Card(
            color: Colors.white70,
            child: Center(
              child: Text('$item', style: textStyle),
            ),
          ),
        ),
      ),
    ),);
  }
}

class Camera {
  String _name;
  String get name => _name;
  String type;
  String aperture;
  String megaPixels;
  String sensorType;

  Camera(String name, String type, String aperture, String megaPixels, String sensorType) {
    this._name = name;
    this.type = type;
    this.aperture = aperture;
    this.megaPixels = megaPixels;
    this.sensorType = sensorType;
  }

  @override
  String toString() {
    return name;
  }
}
