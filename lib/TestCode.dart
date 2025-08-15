import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class TestCode extends StatefulWidget {
  const TestCode({super.key});

  @override
  State<TestCode> createState() => _TestCodeState();
}

class _TestCodeState extends State<TestCode>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final double _expandedHeight = 200;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: ExtendedNestedScrollView(
          onlyOneScrollInBody: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: _expandedHeight,
                floating: false,
                pinned: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Collapsing Header'),
                  background: ColoredBox(color: Colors.blue),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Tab 1"),
                    Tab(text: "Tab 2"),
                    Tab(text: "Tab 3"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [
              _BuildTabContent(tabKey: PageStorageKey("tab1")),
              _BuildTabContent(tabKey: PageStorageKey("tab2")),
              _BuildTabContent(tabKey: PageStorageKey("tab3")),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildTabContent extends StatefulWidget {
  final PageStorageKey tabKey;
  const _BuildTabContent({required this.tabKey});

  @override
  State<_BuildTabContent> createState() => _BuildTabContentState();
}

class _BuildTabContentState extends State<_BuildTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // Important for keep-alive
    return ListView.builder(
      key: widget.tabKey,
      padding: const EdgeInsets.all(8),
      itemCount: 200,
      itemBuilder: (context, index) {
        return ListTile(title: Text('Item $index'));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
