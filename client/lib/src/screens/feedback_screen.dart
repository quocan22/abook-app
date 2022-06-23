import 'package:client/src/blocs/feedback/feedback_bloc.dart';
import 'package:client/src/blocs/feedback/feedback_state.dart';
import 'package:client/src/blocs/feedback/feedback_event.dart';
import 'package:client/src/constants/constants.dart';
import 'package:client/src/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/constants.dart' as constants;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackTextController = TextEditingController();

  final _emailTextController = TextEditingController();

  final _feedbackFormKey = GlobalKey<FormState>();

  String? emailValidate(String? value) {
    if (!Validators.isValidEmail(value!)) {
      return constants.FailureProcess.invalidEmail;
    }
    return null;
  }

  String? feedbackValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Your feedback is empty';
    }
    return null;
  }

  @override
  void dispose() {
    _feedbackTextController.dispose();
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _textFieldContentPadding = EdgeInsets.only(top: 15.0, bottom: 5.0);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(
          'Feedback',
          style: Theme.of(context).textTheme.headline4?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsConstant.primaryColor,
              ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSendSuccess) {
            _feedbackTextController.clear();
            _emailTextController.clear();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Your feedback is sent')));
          } else if (state is FeedbackSendFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('There are some errors occurred')));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _feedbackFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset('assets/images/abook_feedback_logo.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Email",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: constants.ColorsConstant.textFieldTitle,
                          fontSize: 19,
                          fontWeight: FontWeight.w300)),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => emailValidate(value),
                    controller: _emailTextController,
                    textInputAction: TextInputAction.next,
                    cursorColor: constants.ColorsConstant.primaryColor,
                    decoration: InputDecoration(
                      contentPadding: _textFieldContentPadding,
                      errorStyle:
                          Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Colors.red,
                              ),
                    ),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: constants.ColorsConstant.textField,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text('Feedback',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: constants.ColorsConstant.textFieldTitle,
                          fontSize: 19,
                          fontWeight: FontWeight.w300)),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null,
                    controller: _feedbackTextController,
                    textInputAction: TextInputAction.newline,
                    validator: (value) => feedbackValidate(value),
                    cursorColor: constants.ColorsConstant.primaryColor,
                    decoration: InputDecoration(
                      contentPadding: _textFieldContentPadding,
                      errorStyle:
                          Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Colors.red,
                              ),
                    ),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: constants.ColorsConstant.textField,
                        fontSize: 19),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            constants.ColorsConstant.primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                      ),
                      onPressed: () {
                        if (_feedbackFormKey.currentState!.validate()) {
                          context.read<FeedbackBloc>().add(FeedbackSent(
                              email: _emailTextController.text,
                              feedback: _feedbackTextController.text));
                        }
                      },
                      child: Text(
                        'Send Your Feedback',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
