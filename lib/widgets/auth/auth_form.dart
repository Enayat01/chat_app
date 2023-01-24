import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx, //context for snackBar
  ) submitForm;
  const AuthForm(this.submitForm, this.isLoading, {Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isObscurePassword = true; // hidden password
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (isValid == false) {
      return; //returning if validation fails
    }
    FocusScope.of(context).unfocus(); //close the soft keyboard after submit
    _formKey.currentState?.save();
    //using values to send auth request
    widget.submitForm(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _isLogin,
      context,
    );
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
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      //checking for empty field and it must contain @ symbol
                      if (value!.isEmpty || !value.contains("@")) {
                        return 'Please provide a valid email address!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _userEmail = value!;
                      });
                    },
                  ),

                  if (!_isLogin) // show username if in signup mode
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline_outlined),
                      ),
                      validator: (value) {
                        //checking for empty field and setting min length required
                        if (value!.isEmpty || value.length < 4) {
                          return 'Username must be at least 4 characters.';
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
                    key: const ValueKey('password'),
                    obscureText: _isObscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                        return 'Password is too short!';
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
                        child: Text(_isLogin ? 'LOGIN' : 'SIGNUP'),
                      ),
                    ),

                  if (!widget.isLoading) //showing button if not loading
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'Already have an account?'),
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
