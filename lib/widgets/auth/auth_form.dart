import 'dart:io';

import 'package:chat_app/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
  ) submitForm;
  const AuthForm(this.submitForm, this.isLoading, {Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscurePassword = true; // hidden password
  bool _showLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  final _picker = ImagePicker();
  File? _pickedImage;

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus(); //close the soft keyboard after submit
    if (_pickedImage == null && !_showLogin) {
      ///Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(imageValidationText),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid == false || isValid == null) {
      return; //returning if validation fails
    }

    _formKey.currentState?.save();

    ///using values to send auth request
    widget.submitForm(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _showLogin,
    );
  }

  void _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    setState(() {
      _pickedImage = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_showLogin)
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      backgroundImage: _pickedImage == null
                          ? null
                          : FileImage(_pickedImage!),
                    ),
                  if (!_showLogin)
                    TextButton.icon(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.image_rounded),
                      label: const Text(addImageButtonText),
                    ),
                  TextFormField(
                    key: const ValueKey(emailKey),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: emailLabel,
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      //checking for empty field and it must contain @ symbol
                      if (value!.isEmpty || !value.contains('@')) {
                        return emailValidationText;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _userEmail = value!;
                      });
                    },
                  ),

                  if (!_showLogin) // show username if in signup mode
                    TextFormField(
                      key: const ValueKey(usernameKey),
                      decoration: const InputDecoration(
                        labelText: userNameLabel,
                        prefixIcon: Icon(Icons.person_outline_outlined),
                      ),
                      validator: (value) {
                        //checking for empty field and setting min length required
                        if (value!.isEmpty || value.length < 4) {
                          return userNameValidationText;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _userName = value!;
                        });
                      },
                    ),

                  TextFormField(
                    key: const ValueKey(passwordKey),
                    obscureText: _isObscurePassword,
                    decoration: InputDecoration(
                      labelText: passwordLabel,
                      prefixIcon:
                          const Icon(Icons.private_connectivity_outlined),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            //switching password visibility
                            _isObscurePassword = !_isObscurePassword;
                          });
                        },
                        icon: _isObscurePassword
                            ? const Icon(Icons.visibility_rounded)
                            : const Icon(Icons.visibility_off_rounded),
                      ),
                    ),
                    validator: (value) {
                      //checking for empty field and setting min length required
                      if (value!.isEmpty || value.length < 5) {
                        return passwordValidationText;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _userPassword = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  //showing progress indicator if loading
                  if (widget.isLoading) const CircularProgressIndicator(),

                  if (!widget.isLoading) //showing button if not loading
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                            _showLogin ? loginButtonText : signupButtonText),
                      ),
                    ),

                  if (!widget.isLoading) //showing button if not loading
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showLogin = !_showLogin;
                        });
                      },
                      child: Text(
                        _showLogin ? newAccountText : accountExistsText,
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
