import 'package:calculator/SignIn.dart';
import 'package:calculator/main.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              // Logo or Heading (Optional)
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Email TextField
              _buildTextField(
                controller: emailController,
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email,
              ),

              // Password TextField
              _buildTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                keyboardType: TextInputType.text,
                icon: Icons.lock,
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // SignUp Button
              _buildElevatedButton(
                onPressed: () {
                  createUser(emailController.text, passwordController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                label: 'SignUp',
                icon: Icons.mail,
                color: Colors.white,
              ),

              // SignIn Button
              _buildElevatedButton(
                onPressed: () async {
                  bool loginSuccessful = await signIn(
                      context, emailController.text, passwordController.text);
                  if (loginSuccessful) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalculatorApp()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Invalid email or password. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                label: 'SignIn',
                icon: Icons.login,
                color: Colors.white,
              ),

              const SizedBox(height: 20),

              // Login via Email Button
              _buildElevatedButton(
                onPressed: () async {
                  bool loginSuccessful = await signIn(
                      context, emailController.text, passwordController.text);
                  if (loginSuccessful) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalculatorApp()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Invalid email or password. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                label: 'Sign-in with Google',
                icon: Icons.mail_outline,
                color: Colors.white,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Custom text field widget for better reusability
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  // Custom ElevatedButton with icon and color for better reusability
  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          textStyle: const TextStyle(fontSize: 19),
        ),
      ),
    );
  }
}
