import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../api_bloc/bloc/privacy_policy_bloc/privacy_policy_bloc.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  PrivacyPolicyBloc _privacyPolicyBloc = PrivacyPolicyBloc();

  @override
  void initState() {
    super.initState();
    _privacyPolicyBloc.add(GetPrivacyPolicyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back(); // Navigate back to the previous screen
          },

        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: BlocProvider(
            create: (context) => _privacyPolicyBloc,
            child: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
              builder: (context, state) {
                if(state is PrivacyPolicyLoading){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(color: Colors.grey,)
                      ),
                    ],
                  );
                }else if (state is PrivacyPolicyLoaded){
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Html(
                      data: state.privacyPolicyModel.data!.content,
                      style: {
                        "html": Style(
                          textAlign: TextAlign.left,
                        ),
                        "br": Style(),
                        "span": Style(),
                        "p": Style(),
                        "tr": Style(),
                        "td": Style(),
                        "table": Style(),
                      },
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     Text(
                    //       state.privacyPolicyModel.data!.content.toString(),
                    //       style: TextStyle(fontSize: 13),
                    //     ),
                    //     SizedBox(height: 10),
                    //   ],
                    // ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Lore in consectondimentum quis pretium porta.',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
