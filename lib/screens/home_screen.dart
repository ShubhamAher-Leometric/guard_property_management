import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard_property_management/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  int _selectedIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = MediaQuery.of(context).size.width;
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF3629B7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/Home.png'),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Hi, user dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          SetNotificationfilter('all');
                        },
                        child: Badge(
                          label: Text(" "),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 11),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text('Visitor Request',style: TextStyle(fontSize: 18),),
                          TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 4.0,
                                color: Colors.blue,
                              ),
                              insets: EdgeInsets.symmetric(horizontal: 10.0),
                            ),
                            tabs: [
                              Tab(text: "Owner"),
                              Tab(text: "Me")
                            ],
                            onTap: (index) {
                              setSelectedTab(index == 0 ? 'Owner' : 'Me');
                            },
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Container(
                                        height: 86,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'User',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                      overflow: TextOverflow.visible,
                                                      maxLines: 2,
                                                    ),
                                                    Text(
                                                      'User',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      '(Pending)',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                      overflow: TextOverflow.visible,
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 80),
                                              Image.network(
                                                'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Worker_home_from_1911_in_Helsinki.jpg/220px-Worker_home_from_1911_in_Helsinki.jpg',
                                                width: 60,
                                                height: 60,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            child: Container(
                                              height: 86,
                                              margin: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'User',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black,
                                                            ),
                                                            overflow: TextOverflow.visible,
                                                            maxLines: 2,
                                                          ),
                                                          Text(
                                                            'User',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          Text(
                                                            '(Pending)',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black,
                                                            ),
                                                            overflow: TextOverflow.visible,
                                                            maxLines: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 80),
                                                    Image.network(
                                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Worker_home_from_1911_in_Helsinki.jpg/220px-Worker_home_from_1911_in_Helsinki.jpg',
                                                      width: 60,
                                                      height: 60,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(height: 10,color: Colors.red,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: 110,
              height: 38,
              decoration: BoxDecoration(
                color: Color(0xFF3629B7),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, color: Colors.white),
                  SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.grey),
            label: '',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        ).then((_) {
          // _getProfileBloc.add(GetProfileDataEvent());
        });
      }
    });
  }

  Future<void> SetNotificationfilter(String notification_filter) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('notification_filter', notification_filter);
      print('notification_filter : $notification_filter');
    });
  }

  Future<void> setSelectedTab(String tabName) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('selected_tab', tabName);
    print('Selected Tab: $tabName');
  }

  Future<void> SetPropertyIds(int FacilityPropertyId, int FacilityBlockId,
      int FacilityFloorId, int FacilityUnitId) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('Facility_Property_Id', FacilityPropertyId.toString());
      print('Facility_Property_Id : $FacilityPropertyId');

      prefs.setString('Facility_Block_Id', FacilityBlockId.toString());
      print('Facility_Block_Id : $FacilityBlockId');

      prefs.setString('Facility_Floor_Id', FacilityFloorId.toString());
      print('Facility_Floor_Id : $FacilityFloorId');

      prefs.setString('Facility_Unit_Id', FacilityUnitId.toString());
      print('Facility_Unit_Id : $FacilityUnitId');
    });
  }
}
