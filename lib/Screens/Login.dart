import 'package:flutter/material.dart';
import 'package:urlshortner/API.dart';
import 'package:urlshortner/Home.dart';

class Login extends StatefulWidget {
  void Function()? onPressed;

  Login({super.key, required this.onPressed});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // TextEditingControllers to manage the input in the text fields
  //TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Define a global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dispose of the controllers when they are no longer needed
  @override
  void dispose() {
    // nameController.dispose();
    passwordController.dispose();
    //confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey, // Use the form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login Screen",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Enter Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password Field
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Enter Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () async {
                      // Validate form on submit
                      if (_formKey.currentState!.validate()) {
                        Map data = {
                          "Email": emailController.text.toString(),
                          "Password": passwordController.text.toString()
                        };
                        String? sessionId = await API.Login(data);
                        if (sessionId !=null) {
                         /* emailController.clear();
                          passwordController.clear();*/
                          await API.setSession(sessionId);
                          //API.sessionId=sessionId;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("User Found "),
                            backgroundColor: Colors.green,
                          ));
                          bool isAuthtecated=await API.MakeUserAUthenticated();
                          if(!isAuthtecated){
                            print("error you are not authorized");

                          }
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("User Not Found "),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      CircleAvatar(
                        child: IconButton(
                            onPressed: widget.onPressed,
                            icon: Icon(Icons.arrow_forward)),
                      ),
                    ],
                  ),
                  // SizedBox(height: 8,),
                  // TextButton(onPressed: (){}, child: Text("Forgot Password?"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
