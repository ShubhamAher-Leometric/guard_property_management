import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_bloc/bloc/notification_list_bloc/notification_list_bloc.dart';
import '../api_bloc/bloc/read_delete_notification_bloc/read_delete_notification_bloc.dart';


class NotificationList extends StatefulWidget {

  const NotificationList({super.key,

  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  NotificationListBloc _notificationListBloc = NotificationListBloc();
  ReadDeleteNotificationBloc _readDeleteNotificationBloc = ReadDeleteNotificationBloc();

  late SharedPreferences prefs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _selectedDateFilter = 'All';
  bool isFourthContainerVisible = false;
  List<int> notificationIds = [];


  @override
  void initState() {
    super.initState();
    _initNotificationBoard();
    _initPrefs();
  }

  Future<void> _initNotificationBoard() async {
    _notificationListBloc.add(GetNotificationListEvent());
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
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
                  SetNotificationdatefilter('Today');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Yesterday'),
                onTap: () {
                  setState(() {
                    _selectedDateFilter = 'Yesterday';
                  });
                  SetNotificationdatefilter('Yesterday');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('This Week'),
                onTap: () {
                  setState(() {
                    _selectedDateFilter = 'This Week';
                  });
                  SetNotificationdatefilter('This Week');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('This Month'),
                onTap: () {
                  setState(() {
                    _selectedDateFilter = 'This Month';
                  });
                  SetNotificationdatefilter('This Month');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'Notification',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _showDateFilterPopup,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedDateFilter,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.sort_outlined, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocProvider(
                create: (context) => _notificationListBloc,
                child: BlocBuilder<NotificationListBloc, NotificationListState>(
                  builder: (context, state) {
                    if (state is NotificationListLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is NotificationListLoaded) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          _initNotificationBoard();
                          _initPrefs();
                          },
                        child: ListView.builder(
                          itemCount: state.notificationListModel.data!.length,
                          itemBuilder: (context, index) {
                            if (state.notificationListModel.data![index].status == "unread") {
                              notificationIds.add(state.notificationListModel.data![index].id as int);
                              print(notificationIds);
                              var sendreadData = {
                                "notification_ids": notificationIds,
                                "status": 'read',
                              };
                              var readNotificationData = jsonEncode(sendreadData);
                              _readDeleteNotificationBloc.add(SubmitReadDeleteNotificationData(readNotificationData));
                            }

                            return Dismissible(
                              key: Key(state.notificationListModel.data![index].id.toString()),
                              direction: DismissDirection.endToStart, // Only allow right swipe for delete
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                // Confirm delete action
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Delete"),
                                      content: Text("Are you sure you want to delete this notification?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text("DELETE"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text("CANCEL"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              // onDismissed: (direction) {
                              //   var sendreadData = {
                              //         "notification_ids": [state.notificationListModel.data![index].id as int],
                              //         "status": 'delete',
                              //   };
                              //   var readNotificationData = jsonEncode(sendreadData);
                              //   _readDeleteNotificationBloc.add(SubmitReadDeleteNotificationData(readNotificationData));
                              //   },
                              child: GestureDetector(
                                // onTap: () {
                                //   if(state.notificationListModel.data![index].notificationType=='noticeboard')
                                //     {
                                //       SetNoticeboardPropertyID(state.notificationListModel.data![index].additionalData!.propertyId.toString());
                                //       SetNoticeboarddatefilter('this_month');
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(builder: (context) => Notice_Board()),
                                //       );
                                //     }else if(state.notificationListModel.data![index].notificationType=='bill_generation'){
                                //     SetPropertyIds(
                                //       state.notificationListModel.data![index].additionalData!.propertyId as int,
                                //       state.notificationListModel.data![index].additionalData!.unitId as int,
                                //     );
                                //     SetBillingStatus('all');
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(builder: (context) => BillingPage()),
                                //     );
                                //   }else if(state.notificationListModel.data![index].notificationType=='defect_reply'){
                                //     SetDefectID(state.notificationListModel.data![index].additionalData!.defectId as int);
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(builder: (context) => DefectSecondPage()),
                                //     );
                                //   }else if(state.notificationListModel.data![index].notificationType=='visitor'){
                                //     SetVisitortype('upcoming');
                                //     SetvisitorPropertyIds(    state
                                //         .notificationListModel
                                //         .data![index]
                                //         .additionalData!.blockId as int,state
                                //         .notificationListModel
                                //         .data![index]
                                //         .additionalData!.floorId as int,
                                //         state
                                //             .notificationListModel
                                //             .data![index]
                                //             .additionalData!.unitId as int);
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(builder: (context) => MyHomePage()),
                                //     );
                                //   }
                                // },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                state.notificationListModel.data![index].notificationText.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                // overflow: TextOverflow.visible,
                                                // maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(children: [
                                          Text(
                                            state.notificationListModel.data![index].date.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                          ),
                                        ],),
                                        SizedBox(height: 20,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is NotificationListError) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          _initNotificationBoard();
                          _initPrefs();
                        },
                        child: Center(
                          child: Container(
                            height: 100,
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                        onRefresh: () async {
                          _initNotificationBoard();
                          _initPrefs();
                        },
                    child: Container(
                    height: 100,
                    ),);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> SetDefectID(int defctID, ) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('Defect_Id', defctID.toString());
      print('Defect_Id :-----' + defctID.toString());
    });
  }
  Future<void> SetBillingStatus(String billingstatus) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('Billing_status', billingstatus);
      print('Billing_status :' + billingstatus);
    });
  }
  Future<void> SetVisitortype(String request_type) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('request_type', request_type);
      print('request_type :' + request_type);
    });
  }
  Future<void> SetNotificationdatefilter(String notification_filter) async {
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
      prefs.setString('notification_filter', filterValue);
      print('notification_filter :' + filterValue);
      _initNotificationBoard();
    });
  }
}
