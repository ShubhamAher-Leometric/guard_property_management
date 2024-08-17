import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../api_bloc/bloc/terms_and_conditions_bloc/terms_and_conditions_bloc.dart';

class TermCondition extends StatefulWidget {
  const TermCondition({super.key});

  @override
  State<TermCondition> createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {
  TermsAndConditionsBloc _termsAndConditionsBloc = TermsAndConditionsBloc();

  @override
  void initState() {
    super.initState();
    _termsAndConditionsBloc.add(TermsAndConditionsData());
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => _termsAndConditionsBloc,
          child: BlocBuilder<TermsAndConditionsBloc, TermsAndConditionsState>(
            builder: (context, state) {
              if(state is TermsAndConditionsLoading){
                return Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(color: Colors.grey,)
                );
              }else if(state is TermsAndConditionsLoaded){
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:  Html(
                    data:  state.termsandconditionsModel.data!.content,
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
                  //      state.termsandconditionsModel.data!.content.toString(),
                  //       style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
                  //     ),
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
                      'Lorem Arc nib et ci diam porttitor nunc condimentum quis pretium porta.',
                      style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}