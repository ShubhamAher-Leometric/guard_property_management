import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guard_property_management/screens/visitor_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_bloc/bloc/visitor_history_bloc/visitor_history_bloc.dart';
import '../api_bloc/bloc/visitor_list_bloc/visitor_listing_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  VisitorHistoryBloc _visitorListingBloc = VisitorHistoryBloc();
  String _selectedDateFilter = 'This Month';
  String selected = 'Owner';

  @override
  void initState() {
    super.initState();
    Setdatefilter('this_month');
    setSelectedTab('owner');
    _initVisitorList();
  }

  Future<void> _initVisitorList() async {
    _visitorListingBloc.add(VisitorHistoryEventData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visitor Request',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        'Owner',
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
                      width: MediaQuery.of(context).size.width / 3 -
                          20,
                      color: selected == 'Owner'
                          ? Color(0xFF3629B7)
                          : Colors.grey,
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
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
                        'Me',
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
                      width: MediaQuery.of(context).size.width / 3 -
                          20,
                      color: selected == 'Me'
                          ? Color(0xFF3629B7)
                          : Colors.grey,
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'Other';
                        });
                        setSelectedTab('other');
                        _initVisitorList();
                      },
                      child: Text(
                        'Other',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: selected == 'Other'
                              ? Color(0xFF3629B7)
                              : Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width / 3 -
                          20,
                      color: selected == 'Other'
                          ? Color(0xFF3629B7)
                          : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _showDateFilterPopup,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedDateFilter,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.keyboard_arrow_down,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocProvider(
              create: (context) => _visitorListingBloc,
              child: BlocBuilder<VisitorHistoryBloc,
                  VisitorHistoryState>(
                builder: (context, state) {
                  if (state is VisitorHistoryLoading) {
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
                  } else if (state is VisitorHistoryLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount:
                        state.visitorHistoryModel.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              SetVisitordetials(state
                                  .visitorHistoryModel
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
                                                state.visitorHistoryModel
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
                                                    .visitorHistoryModel
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
                                                        .visitorHistoryModel
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
                                                      .visitorHistoryModel
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
                                              .visitorHistoryModel
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
                    return Expanded(child: Container());
                  }
                  return Expanded(child: Container());
                },
              ),
            ),
          ],
        ),
      ),
    );
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
