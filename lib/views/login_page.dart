// lib/views/login_page.dart
import 'package:flutter/material.dart';
import 'home_page.dart'; // Import the HomePage

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create controllers for the text fields
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> _formKey =
        GlobalKey<FormState>(); // Key for form validation

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to match the image
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blueAccent, // Change app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Center the content vertically
          child: SingleChildScrollView(
            // Allow scrolling if the keyboard appears
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Add the image at the top of the login form
                Image.asset(
                  'assets/images/login_image.png', // Path to your image
                  height: 300, // Adjust height as needed
                ),
                // SizedBox(height: 5), // Space between image and title
                // Text(
                //   'Login',
                //   style: TextStyle(
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //     color:
                //         Colors.black87, // Darker text color for better contrast
                //   ),
                //   textAlign: TextAlign.center, // Center the text
                // ),
                SizedBox(height: 20), // Space between title and fields
                Form(
                  // Wrap the Column in a Form widget
                  key: _formKey, // Assign the form key
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        // Use TextFormField for validation
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          // Validation logic for email
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Add more email validation if needed
                          return null; // Return null if validation passes
                        },
                      ),
                      SizedBox(height: 16.0), // Space between fields
                      TextFormField(
                        // Use TextFormField for validation
                        controller: passwordController,
                        obscureText: true, // Hides the password
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          // Validation logic for password
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null; // Return null if validation passes
                        },
                      ),
                      SizedBox(height: 24.0), // Space between fields and button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Validate the form
                            // Navigate to HomePage when the button is pressed
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          } else {
                            // Show error message if validation fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please fix the errors in red',
                                  style: TextStyle(color: Colors.red),
                                ),
                                backgroundColor: Colors.white,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded button
                          ),
                          backgroundColor: Colors.blueAccent, // Button color
                        ),
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
