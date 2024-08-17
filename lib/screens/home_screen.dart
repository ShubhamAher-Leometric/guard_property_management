import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guard_property_management/api_bloc/bloc/visitor_list_bloc/visitor_listing_bloc.dart';
import 'package:guard_property_management/screens/history_page.dart';
import 'package:guard_property_management/screens/new_visitor.dart';
import 'package:guard_property_management/screens/settings_screen.dart';
import 'package:guard_property_management/screens/visitor_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_bloc/bloc/get_profile_bloc/get_profile_bloc.dart';
import '../api_bloc/bloc/notification_count_bloc/notification_count_bloc.dart';
import 'notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _searchController = TextEditingController();
  VisitorListingBloc _visitorListingBloc = VisitorListingBloc();
  late NotificationCountBloc _notificationCountBloc = NotificationCountBloc();
  late GetProfileBloc _getProfileBloc = GetProfileBloc();

  late SharedPreferences prefs;
  int _selectedIndex = 0;
  bool isLoading = false;
  String _selectedDateFilter = 'This Month';
  String selected = 'Owner';
  String? _profilePic;
  String? _userName;


  @override
  void initState() {
    super.initState();
    Setdatefilter('this_month');
    setSelectedTab('owner');
    SetFacilityStrSearch('');
    _loadProfilePic();
    _initVisitorList();
    _notificationCountBloc.add(GetNotificationCountEvent());
    _getProfileBloc.add(GetProfileDataEvent());
  }
  void _Searchfaclitystate() async {
    _initVisitorList();
  }

  void _navigateToSearch(String query) {
    SetFacilityStrSearch(query).then((_) {
      _Searchfaclitystate();
    });
  }
  Future<void> _initVisitorList() async {
    _visitorListingBloc.add(VisitorListEventData());
  }

  Future<void> _loadProfilePic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profilePic = prefs.getString('user_pic');
      _userName = prefs.getString('user_name');
    });
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
                      BlocProvider(
                        create: (context) => _getProfileBloc,
                        child: BlocBuilder<GetProfileBloc, GetProfileState>(
                          builder: (context, state) {
                            if (state is GetProfileLoading) {
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage('assets/images/dummy_user.jpeg'),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    'Hi,',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            } else if (state is GetProfileLoaded) {
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(state
                                        .getProfileModel.data!.profileImage
                                        .toString()),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    'Hi, ' +
                                        state.getProfileModel.data!.name
                                            .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage('assets/images/dummy_user.jpeg'),
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
                              ],
                            );
                          },
                        ),
                      ),
                      Spacer(),
                      BlocProvider(
                        create: (context) => _notificationCountBloc,
                        child: BlocBuilder<NotificationCountBloc,
                            NotificationCountState>(
                          builder: (context, state) {
                            if (state is NotificationCountLoading) {
                              return GestureDetector(
                                onTap: () {
                                  SetNotificationfilter('all');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotificationList()),
                                  );
                                },
                                child: Badge(
                                  label: Text(" "),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: width * 0.07,
                                  ),
                                ),
                              );
                            } else if (state is NotificationCountLoaded) {
                              return GestureDetector(
                                onTap: () {
                                  SetNotificationfilter('all');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotificationList()),
                                  ).then((_) {
                                    _notificationCountBloc
                                        .add(GetNotificationCountEvent());
                                  });
                                },
                                child: Badge(
                                  label: Text(
                                      state.notificationCountModel.data.toString()),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: width * 0.07,
                                  ),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                SetNotificationfilter('all');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotificationList()),
                                );
                              },
                              child: Badge(
                                label: Text(" "),
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: width * 0.07,
                                ),
                              ),
                            );
                          },
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
                    child: RefreshIndicator(
                      onRefresh: () async{
                        _initVisitorList();
                        _notificationCountBloc.add(GetNotificationCountEvent());
                        _getProfileBloc.add(GetProfileDataEvent());
                        _searchController.clear();
                        SetFacilityStrSearch('');
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Text(
                                  'Visitor Request',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HistoryPage()),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFEBE9FF),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.history_outlined,
                                            color: Color(0xFFFF3629B7),
                                          ),
                                          Text(
                                            'History',
                                            style: TextStyle(fontSize: 18,
                                              color: Color(0xFFFF3629B7),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFFF4F4F4),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color:Colors.grey ,
                                    ),
                                    SizedBox(width: 8), // add spacing between icon and text
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText: 'Type hear to search...',
                                          border: InputBorder.none,
                                        ),
                                        onSubmitted: (text) {
                                          _navigateToSearch(text);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = 'Owner';
                                      });
                                      setSelectedTab('owner');
                                      _initVisitorList();
                                    },
                                    child: Text(
                                      'Invite by owner',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: selected == 'Owner'
                                            ? Color(0xFF3629B7)
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width / 2 -
                                        20,
                                    color: selected == 'Owner'
                                        ? Color(0xFF3629B7)
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = 'Me';
                                      });
                                      setSelectedTab('guard');
                                      _initVisitorList();
                                    },
                                    child: Text(
                                      'Walk in',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: selected == 'Me'
                                            ? Color(0xFF3629B7)
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width / 2 -
                                        20,
                                    color: selected == 'Me'
                                        ? Color(0xFF3629B7)
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                            Spacer(),
                            ],
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 10.0, horizontal: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: [
                          //       GestureDetector(
                          //         onTap: _showDateFilterPopup,
                          //         child: Container(
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal: 10, vertical: 5),
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey[200],
                          //             borderRadius: BorderRadius.circular(20),
                          //           ),
                          //           child: Row(
                          //             children: [
                          //               Text(
                          //                 _selectedDateFilter,
                          //                 style: TextStyle(
                          //                     fontSize: 16, color: Colors.grey),
                          //               ),
                          //               SizedBox(
                          //                 width: 5,
                          //               ),
                          //               Icon(Icons.keyboard_arrow_down,
                          //                   color: Colors.grey),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 10,),
                          BlocProvider(
                            create: (context) => _visitorListingBloc,
                            child: BlocBuilder<VisitorListingBloc,
                                VisitorListingState>(
                              builder: (context, state) {
                                if (state is VisitorListingLoading) {
                                  return Expanded(
                                      child: Center(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ));
                                } else if (state is VisitorListingLoaded) {
                                  return Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          state.vistorListingModel.data!.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            SetVisitordetials(state
                                                .vistorListingModel
                                                .data![index]
                                                .visitId
                                                .toString());
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VisitorDetailsScreen()),
                                            );
                                          },
                                          child: Container(
                                            height: 86,
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, bottom: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              state.vistorListingModel
                                                                  .data![index].name
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.black,
                                                              ),
                                                              overflow: TextOverflow
                                                                  .visible,
                                                              maxLines: 2,
                                                            ),
                                                            Text(
                                                              state
                                                                  .vistorListingModel
                                                                  .data![index]
                                                                  .unitInfo
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.black,
                                                              ),
                                                              overflow: TextOverflow
                                                                  .visible,
                                                              maxLines: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.calendar_month,
                                                                size: 16,
                                                                color:
                                                                    Color(0xFF3629B7),
                                                              ),
                                                              Container(
                                                                width: 100,
                                                                child: Text(
                                                                  state
                                                                      .vistorListingModel
                                                                      .data![index]
                                                                      .visitDate
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color:
                                                                        Colors.black,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.call,
                                                                size: 16,
                                                                color:
                                                                    Color(0xFF3629B7),
                                                              ),
                                                              Text(
                                                                state
                                                                    .vistorListingModel
                                                                    .data![index]
                                                                    .mobileNumber
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors.black,
                                                                ),
                                                                overflow: TextOverflow
                                                                    .visible,
                                                                maxLines: 2,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  if(selected == 'Other')
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Created by : ',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 2,
                                                        ),
                                                        Text(
                                                          state
                                                              .vistorListingModel
                                                              .data![index]
                                                              .createdBy
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 2,
                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else if (state is VisitorListingError) {
                                  return RefreshIndicator(
                                    onRefresh: () async {
                                      _initVisitorList();
                                      _notificationCountBloc.add(GetNotificationCountEvent());
                                      _searchController.clear();
                                      SetFacilityStrSearch('');
                                    },
                                    child: SingleChildScrollView(
                                      physics: const AlwaysScrollableScrollPhysics(), // Makes sure the widget is scrollable
                                      child: Container(
                                        height: 200,
                                      ),
                                    ),
                                  );
                                }
                                return RefreshIndicator(
                                  onRefresh: () async {
                                    _initVisitorList();
                                    _notificationCountBloc.add(GetNotificationCountEvent());
                                    _searchController.clear();
                                    SetFacilityStrSearch('');
                                  },
                                  child: SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(), // Makes sure the widget is scrollable
                                    child: Container(
                                      height: 200,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (selected == 'Me')
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddNewVisitor()),
                                );
                              },
                              icon: Icon(Icons.add),
                              label: Text('Add Visitor'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFF3629B7),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
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
          MaterialPageRoute(builder: (context) => Settings()),
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

  Future<void> SetVisitordetials(String visitor_id) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('visitor_id', visitor_id);
      print('visitor_id :' + visitor_id);
    });
  }

  Future<void> setSelectedTab(String tabName) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('selected_tab', tabName);
    print('Selected Tab: $tabName');
  }

  Future<void> SetVisitorListfilter(String date_filter) async {
    final SharedPreferences prefs = await _prefs;
    String filterValue;

    switch (date_filter) {
      case 'All':
        filterValue = 'all';
        break;
      case 'Today':
        filterValue = 'today';
        break;
      case 'Yesterday':
        filterValue = 'yesterday';
        break;
      case 'This Week':
        filterValue = 'this_week';
        break;
      case 'This Month':
        filterValue = 'this_month';
        break;
      default:
        filterValue = 'all'; // Default case
    }
    setState(() {
      prefs.setString('visitor_filter', filterValue);
      print('visitor_filter :' + filterValue);
      _initVisitorList();
    });
  }

  Future<void> Setdatefilter(String date_filter) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('visitor_filter', date_filter);
      print('visitor_filter :' + date_filter);
    });
  }

  Future<void> SetFacilityStrSearch(String str_Search) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('Str_Search', str_Search);
      print('Searching..... :' + str_Search.toString());
    });
  }
  void _showDateFilterPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Today'),
                onTap: () {
                  setState(() {
                    _selectedDateFilter = 'Today';
                  });
                  SetVisitorListfilter('Today');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Yesterday'),
                onTap: () {
                  setState(() {
                    _selectedDateFilter = 'Yesterday';
                  });
                  SetVisitorListfilter('Yesterday');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('This Week'),
                onTap: () {
                  setState(() {
                    _selectedDateFilter = 'This Week';
                  });
                  SetVisitorListfilter('This Week');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('This Month'),
                onTap: () {
                  setState(() {
                    _selectedDateFilter = 'This Month';
                  });
                  SetVisitorListfilter('This Month');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
