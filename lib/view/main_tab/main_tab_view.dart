import 'package:cp_movies/common/color_extension.dart';
import 'package:cp_movies/view/download/download_view.dart';
import 'package:cp_movies/view/home/home_view.dart';
import 'package:cp_movies/view/profile/profile_view.dart';
import 'package:cp_movies/view/search/search_view.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with TickerProviderStateMixin {
  int selectTab = 0;

  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller?.addListener(() {
      selectTab = controller?.index ?? 0;
      if (mounted) {
        setState(() {});
      }
    });
    FBroadcast.instance().register("change_mode", (value, callback) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: const [
          HomeView(),
          SearchView(),
          DownloadView(),
          ProfileView(),
        ],
      ),
      backgroundColor: TColor.bg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColor.primary1,
        onPressed: () {
          TColor.tModeDark = !TColor.tModeDark;
          FBroadcast.instance().broadcast("change_mode");

          if (mounted) {
            setState(() {});
          }
        },
        child: Icon(
          TColor.tModeDark ? Icons.light_mode : Icons.dark_mode,
          color: TColor.text,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: TColor.tabBG,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: TabBar(
            labelStyle: TextStyle(
                color: TColor.primary2,
                fontSize: 8,
                fontWeight: FontWeight.w700),
            controller: controller,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            overlayColor: const MaterialStatePropertyAll(
              Colors.transparent,
            ),
            labelColor: TColor.primary2,
            indicatorWeight: 0.01,
            unselectedLabelColor: TColor.subtext,
            unselectedLabelStyle: TextStyle(
              color: TColor.subtext,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
            tabs: [
              Tab(
                text: "HOME",
                icon: Image.asset(
                  "assets/img/tab_home.png",
                  width: 30,
                  height: 30,
                  color: selectTab == 0 ? TColor.primary2 : TColor.subtext,
                ),
              ),
              Tab(
                text: "SEARCH",
                icon: Image.asset(
                  "assets/img/tab_search-2.png",
                  width: 30,
                  height: 30,
                  color: selectTab == 1 ? TColor.primary2 : TColor.subtext,
                ),
              ),
              Tab(
                text: "DOWNLOAD",
                icon: Image.asset(
                  "assets/img/tab_download.png",
                  width: 30,
                  height: 30,
                  color: selectTab == 2 ? TColor.primary2 : TColor.subtext,
                ),
              ),
              Tab(
                text: "PROFILE",
                icon: Image.asset(
                  "assets/img/tab_user.png",
                  width: 30,
                  height: 30,
                  color: selectTab == 3 ? TColor.primary2 : TColor.subtext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
