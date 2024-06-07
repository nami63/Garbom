import 'package:flutter/material.dart';
import 'package:login/user/main1.dart';
import 'package:login/user/successfully_registerd.dart';

// ignore: camel_case_types
class userreg extends StatefulWidget {
  const userreg({super.key, Key? key3});

  @override
  State<userreg> createState() => _UserRegState();
}

class _UserRegState extends State<userreg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      width: 180,
                      height: 200,
                      top: 40,
                      left: 10,
                      child: Container(
                        width: 220,
                        height: 300,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/welcome2.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Name"),
              const SizedBox(height: 20), // Increased spacing
              _buildTextField("Phone Number"),
              const SizedBox(height: 20), // Increased spacing
              _buildTextField("Email"),
              const SizedBox(height: 20), // Increased spacing
              _buildTextField("Address"),
              const SizedBox(height: 20), // Increased spacing
              _buildTextField("State"),
              const SizedBox(height: 20), // Increased spacing
              _buildTextField("Pin Code"),
              const SizedBox(height: 20), // Increased spacing
              _buildTextField("Password", obscureText: true),
              const SizedBox(height: 20), // Increased spacing
              _buildTextField("Confirm Password", obscureText: true),
              const SizedBox(height: 20), // Increased spacing

              const SizedBox(height: 20),
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(255, 107, 100, 237),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Succreg()),
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(255, 107, 100, 237),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Already Registered?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Positioned(
                width: 180, // Set a specific width for the container
                height: 200,
                bottom: 40,
                right: 10,
                child: Container(
                  width: 220, // Set a specific width for the container
                  height: 300, // Set a specific height for the container
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/register.gif'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), // Rounded edges
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 142, 137, 239).withOpacity(0.7),
        ),
        style: const TextStyle(color: Color.fromARGB(255, 13, 0, 0)),
        obscureText: obscureText,
      ),
    );
  }
}
