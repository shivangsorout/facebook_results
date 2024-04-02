import 'package:facebook_results/constants/routes.dart';
import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:flutter/material.dart';

class ResultReadyView extends StatefulWidget {
  const ResultReadyView({super.key});

  @override
  State<ResultReadyView> createState() => _ResultReadyViewState();
}

class _ResultReadyViewState extends State<ResultReadyView> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Result'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.mqSize.height * 0.019,
            horizontal: context.mqSize.width * 0.04,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your is result is ready!',
                      style: TextStyle(
                        fontSize: context.mqSize.height * 0.044,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.mqSize.height * 0.0168,
                      ),
                      child: TextField(
                        controller: _textController,
                        maxLines: 16,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.mqSize.width * 0.04,
                            vertical: context.mqSize.height * 0.014,
                          ),
                          filled: true,
                          fillColor: const Color(0xffEDEFF5),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.mqSize.height * 0.017),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.mqSize.width * 0.08,
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  homeRoute,
                                  (route) => false,
                                );
                              },
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: context.mqSize.height * 0.014,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'COPY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: context.mqSize.height * 0.02,
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.mqSize.width * 0.008,
                                  ),
                                  Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                    size: context.mqSize.height * 0.02,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
