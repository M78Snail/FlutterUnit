import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unit/blocs/category/category_bloc.dart';
import 'package:flutter_unit/blocs/category/category_state.dart';
import 'package:flutter_unit/blocs/category_widget/category_widget_bloc.dart';
import 'package:flutter_unit/blocs/category_widget/category_widget_event.dart';
import 'package:flutter_unit/components/permanent/circle.dart';
import 'package:flutter_unit/components/permanent/panel.dart';
import 'package:flutter_unit/model/category_model.dart';
import 'package:flutter_unit/model/widget_model.dart';
import 'package:flutter_unit/repositories/itf/category_repository.dart';
import 'package:flutter_unit/views/common/unit_drawer_header.dart';


/// create by 张风捷特烈 on 2020-04-22
/// contact me by email 1981462002@qq.com
/// 说明:

class CategoryEndDrawer extends StatelessWidget {
  final WidgetModel widget;

  CategoryEndDrawer({this.widget});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) => Container(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        UnitDrawerHeader(color: Theme.of(context).primaryColor),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Circle(
                color: widget.color,
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.name)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Panel(
            child: Text(
              widget.info,
              style: TextStyle(color: Colors.grey, shadows: [
                Shadow(
                    color: Colors.white, offset: Offset(.5, .5), blurRadius: .5)
              ]),
            ),
          ),
        ),
        Divider(),
        _buildTitle(context),
        Divider(),
        CategoryInfo(widget.id)
      ]));

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Circle(
            color: Theme.of(context).primaryColor,
            radius: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '当前组件收藏情况',
              style: TextStyle(fontSize: 16, shadows: [
                Shadow(
                    color: Colors.white, offset: Offset(.5, .5), blurRadius: 1)
              ]),
            ),
          ),
          Circle(
            color: Theme.of(context).primaryColor,
            radius: 5,
          ),
        ],
      ),
    );
  }
}

class CategoryInfo extends StatefulWidget {
  final int id;

  CategoryInfo(this.id);

  @override
  _CategoryInfoState createState() => _CategoryInfoState();
}

class _CategoryInfoState extends State<CategoryInfo> {
  List<int> categoryIds = [];
  List<CategoryModel> _categories = [];

//  var

  @override
  void didChangeDependencies() {
    _loadCategoryIds();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCategory();
  }

  Widget _buildCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 5,
//        runSpacing: 10,
        children: categories.map((e) => _buildItem(e)).toList(),
      ),
    );
  }

  Widget _buildItem(CategoryModel category) {
    bool inHere = categoryIds.contains(category.id);
    return FilterChip(
      backgroundColor: Theme.of(context).primaryColor.withAlpha(33),
//        backgroundColor: category.color.withAlpha(88),
        selectedColor: Colors.orange.withAlpha(120),
        shadowColor: Theme.of(context).primaryColor,
        elevation: 1,
        avatar: Circle(
          radius: 13,
          color: category.color,
        ),
        selected: inHere,
        label: Text(category.name),
        onSelected: (v) async {
          await repository.toggleCategory(category.id, widget.id);
          _loadCategoryIds();
          BlocProvider.of<CategoryWidgetBloc>(context).add(EventLoadCategoryWidget(category.id));
        });
  }

  CategoryRepository get repository =>
      BlocProvider.of<CategoryBloc>(context).repository;

  List<CategoryModel> get categories {
    var state = BlocProvider.of<CategoryBloc>(context).state;
    if (state is CategoryLoadedState) {
      _categories = state.categories;
    }
    return _categories;
  }

  void _loadCategoryIds() async {
    categoryIds = await repository.getCategoryByWidget(widget.id);
    print(categoryIds);
    if(mounted)
    setState(() {

    });
  }
}
