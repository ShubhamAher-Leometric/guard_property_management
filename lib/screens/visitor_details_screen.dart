import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guard_property_management/api_bloc/bloc/visitor_list_bloc/visitor_listing_bloc.dart';
import 'package:guard_property_management/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_bloc/bloc/visitor_details_bloc/visitor_details_bloc.dart';

class VisitorDetailsScreen extends StatefulWidget {
  const VisitorDetailsScreen({Key? key}) : super(key: key);

  @override
  State<VisitorDetailsScreen> createState() => _VisitorDetailsScreenState();
}

class _VisitorDetailsScreenState extends State<VisitorDetailsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  VisitorDetailsBloc _visitorDetailsBloc = VisitorDetailsBloc();


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
    _loadProfilePic();
    _initVisitorList();
  }

  Future<void> _initVisitorList() async {
    _visitorDetailsBloc.add(VisitorDetailsData());
  }

  Future<void> _loadProfilePic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profilePic = prefs.getString('user_pic');
      _userName = prefs.getString('user_name');
    });
  }

  void _launchCaller(String mobileNumber) async {
    final url = "tel:$mobileNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                        backgroundImage: _profilePic != null
                            ? NetworkImage(_profilePic!)
                            : AssetImage('assets/Home.png'),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Hi, '+_userName!,
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
                        // child: Badge(
                        //   label: Text("1"),
                        //   child: Icon(
                        //     Icons.notifications,
                        //     color: Colors.white,
                        //     size: width * 0.07,
                        //   ),
                        // ),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: width * 0.07,
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 9.0, right: 9.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // Center aligns children horizontally
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 29,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    'Visitors Facility',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 29,
                                  )
                                ],
                              ),
                            ),
                            BlocProvider(
                              create: (context) => _visitorDetailsBloc,
                              child: BlocBuilder<VisitorDetailsBloc, VisitorDetailsState>(
                                builder: (context, state) {
                                  if (state is VisitorDetailsLoading){
                                    return Center(
                                      child: Container(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(color: Colors.grey,)),
                                    );
                                  }else if(state is VisitorDetailsLoaded){
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _launchCaller(state.visitorDetailsModel.data!.mobileNumber.toString());
                                            },
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Icon(Icons.call,  color: Color(0xFF3629B7),),
                                                    ],
                                                  ),
                                                  SizedBox(width: 20,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Owner Phone Number',
                                                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                                                      Text(state.visitorDetailsModel.data!.mobileNumber.toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          child: Padding(
                                            padding:  EdgeInsets.all(22.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Center(
                                                //   child: Text(
                                                //     'Entry No #'+state.visitorDetailsModel.data!.visitId.toString(),
                                                //     style: TextStyle(
                                                //       fontWeight: FontWeight.bold,
                                                //       fontSize: 15.0,
                                                //     ),
                                                //   ),
                                                // ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Purpose Of Entry :  '+state.visitorDetailsModel.data!.purposeOfVisit.toString(),style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                                Divider(),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        'Full Name',style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Phone Number',style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        state.visitorDetailsModel.data!.name.toString(),
                                                      ),
                                                    ),
                                                    Text(
                                                      state.visitorDetailsModel.data!.mobileNumber.toString(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        'Visit Date',style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Visit Time',style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        state.visitorDetailsModel.data!.date.toString(),
                                                      ),
                                                    ),
                                                    Text(
                                                      state.visitorDetailsModel.data!.visitTime.toString(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        'Expired Date',style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Expired Time',style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        state.visitorDetailsModel.data!.expiredDate.toString(),
                                                      ),
                                                    ),
                                                    Text(
                                                      state.visitorDetailsModel.data!.expiredTime.toString(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        'NIRC/Passport No:',style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Image Of ID',style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        state.visitorDetailsModel.data!.nricPassportNo.toString(),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context:
                                                          context,
                                                          builder:
                                                              (BuildContext
                                                          context) {
                                                            return Dialog(
                                                              child:
                                                              Container(
                                                                child:
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  child: Image.network(
                                                                    state.visitorDetailsModel.data!.idImage.toString(),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },

                                                      child: Container(
                                                          height:30,
                                                          width:30,
                                                          child: Image.network(state.visitorDetailsModel.data!.idImage.toString())),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        'Visit Type',style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Entry Type',style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2.3,
                                                      child: Text(
                                                        state.visitorDetailsModel.data!.visitType.toString(),
                                                      ),
                                                    ),
                                                    Text(
                                                      state.visitorDetailsModel.data!.entryType.toString(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Vehicle Number',style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      state.visitorDetailsModel.data!.vehicleNumber.toString(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Remark',style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      state.visitorDetailsModel.data!.remark.toString(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                        // Card(
                        //   color: Colors.white,
                        //   child: Padding(
                        //     padding:  EdgeInsets.all(22.0),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Center(
                        //           child: Text(
                        //             'Entry No #',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 15.0,
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 10.0),
                        //         Row(
                        //           children: [
                        //             Text(
                        //               'Purpose Of Entry :  ',style: TextStyle(fontWeight: FontWeight.bold),
                        //             ),
                        //             Spacer(),
                        //           ],
                        //         ),
                        //         Divider(),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               width: MediaQuery.of(context).size.width/2.3,
                        //               child: Text(
                        //                 'Full Name',style: TextStyle(fontWeight: FontWeight.bold),
                        //               ),
                        //             ),
                        //             Text(
                        //               'Phone Number',style: TextStyle(fontWeight: FontWeight.bold),
                        //             ),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               width: MediaQuery.of(context).size.width/2.3,
                        //               child: Text(
                        //                 'Name',
                        //               ),
                        //             ),
                        //             Text(
                        //               'no',
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 10,),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               width: MediaQuery.of(context).size.width/2.3,
                        //               child: Text(
                        //                 'Visit Date',style: TextStyle(fontWeight: FontWeight.bold),
                        //               ),
                        //             ),
                        //             Text(
                        //               'Time',style: TextStyle(fontWeight: FontWeight.bold),
                        //             ),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               width: MediaQuery.of(context).size.width/2.3,
                        //               child: Text(
                        //                 'date',
                        //               ),
                        //             ),
                        //             Text(
                        //              'time',
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 10,),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               width: MediaQuery.of(context).size.width/2.3,
                        //               child: Text(
                        //                 'Expired Date',style: TextStyle(fontWeight: FontWeight.bold),
                        //               ),
                        //             ),
                        //             Text(
                        //               'Expired Time',style: TextStyle(fontWeight: FontWeight.bold),
                        //             ),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               width: MediaQuery.of(context).size.width/2.3,
                        //               child: Text(
                        //                 'test',
                        //               ),
                        //             ),
                        //             Text(
                        //               '--',
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 10,),
                        //         Row(
                        //           children: [
                        //             Text(
                        //               'Address',style: TextStyle(fontWeight: FontWeight.bold),
                        //             ),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             Expanded(
                        //               child: Text(
                        //                 'address',
                        //              overflow: TextOverflow.ellipsis,
                        //                 maxLines: 2,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 10,),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                          ],
                        ),
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

  Future<void> setSelectedTab(String tabName) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('selected_tab', tabName);
    print('Selected Tab: $tabName');
  }

  Future<void> SetVisitorListfilter(String notification_filter) async {
    final SharedPreferences prefs = await _prefs;
    String filterValue;

    switch (notification_filter) {
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
