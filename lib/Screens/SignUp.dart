import 'package:flutter/material.dart';
import 'package:urlshortner/API.dart';
import 'package:urlshortner/Home.dart';

class SignUp extends StatefulWidget {
  void Function()? onPressed;

  SignUp({super.key, required this.onPressed});

  @override
  State<SignUp> createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  // TextEditingControllers to manage the input in the text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Define a global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dispose of the controllers when they are no longer needed
  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp Page"),
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
                    "Signup Screen",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Name Field
                  TextFormField(
                    controller: nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: "Enter Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

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
                  const SizedBox(height: 10),

                  // Confirm Password Field
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
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
                        if (passwordController.text.toString() !=
                            confirmPasswordController.text.toString()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Passwords do not match')));
                        } else {
                          Map data = {
                            "Name": nameController.text.toString().trim(),
                            "Email": emailController.text.toString().trim(),
                            "Password": passwordController.text.toString()
                          };
                          bool isCreated = await API.RegisterUser(data);
                          if (isCreated) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("User Created"),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("User not Created"),
                              backgroundColor: Colors.red,
                            ));
                          }
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
                  SizedBox(
                    height: 8,
                  ),
                  TextButton(onPressed: () {}, child: Text("Forgot Password?"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
