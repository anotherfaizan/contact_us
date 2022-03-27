import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  late String name;
  late String userEmail;
  late String message;
  late String number;

  final _formKey = GlobalKey<FormState>();

  final nameFieldText = TextEditingController();
  final emailFieldText = TextEditingController();
  final numberFieldText = TextEditingController();
  final messageFieldText = TextEditingController();

  void clearText() {
    nameFieldText.clear();
    emailFieldText.clear();
    numberFieldText.clear();
    messageFieldText.clear();
  }

  Future<void> _sendMail() async{
    final Email email = Email(
      body: 'Name: $name\n'
          'Email id: $userEmail\n'
          'Mobile Number: $number\n\n'
          '$message',
      subject: 'Data from Contact us',
      recipients: ['info@redpositive.in'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contact Us'),
          backgroundColor: const Color(0xff272833),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('images/background.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            )
          ),
          constraints: const BoxConstraints.expand(),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameFieldText,
                      textAlign: TextAlign.center,
                      maxLength: 25,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      style: kInputTextStyle,
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name.';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: emailFieldText,
                      textAlign: TextAlign.center,
                      style: kInputTextStyle,
                      keyboardType: TextInputType.emailAddress,
                      decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Email'),
                      onChanged: (value){
                        userEmail = value;
                      },
                      validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: numberFieldText,
                      textAlign: TextAlign.center,
                      maxLength: 10,
                      style: kInputTextStyle,
                      keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Mobile Number'),
                      onChanged: (value){
                        number = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This is a required Field';
                        }
                        if( value.length != 10){
                          return 'Mobile number must be 10 digits.';
                        }
                        return null;
                      }
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.blueGrey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        controller: messageFieldText,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        style: kInputTextStyle,
                        decoration: kMessageBoxDecoration,
                        onChanged: (value){
                          message = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }
                      ),

                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    MaterialButton(
                      elevation: 5.0,
                      height: 40.0,
                        minWidth: 154.0,
                        color: Colors.teal.shade600,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.tealAccent.shade100,
                          ),
                        ),

                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                              setState(() {
                                _sendMail();
                                FocusManager.instance.primaryFocus?.unfocus();
                                clearText();
                              });
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
