import 'package:ethern/auth/auth_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
          'Ethern',
          style: TextStyle(color: Colors.white, fontFamily: 'MedievalSharp'),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/736x/40/d7/ff/40d7ff0bf2c6cb35ee8242fb5cd2a9a0.jpg'),
                fit: BoxFit.cover),
            gradient: LinearGradient(colors: [
              Color(0xFFFF7308),
              Color(0xFFE05C04),
              Color(0xFFC13729),
              Color(0xFFA32530),
              Color(0xFF841436),
              Color(0xFF66023D)
            ], begin: Alignment.topRight, end: Alignment.bottomLeft),
          ),
          child:
              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              children: [
                Icon(
                  Icons.whatshot,
                  color: Colors.white,
                  size: 60.0,
                ),
                Container(
                  height: 230,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black.withOpacity(.7),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bem vindo",
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nCrie seu personagem, embarque em sua própria aventura, fique mais forte e alcance o topo.",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nSua história, 20 Lados",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.blue, width: 2),
                      minimumSize: Size(20, 50),
                      backgroundColor: Colors.black.withOpacity(.7),
                      padding: EdgeInsets.only(left: 30, right: 30),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const AuthPage(showLoginPage: false,)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Criar conta',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.assignment,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.blue, width: 2),
                      minimumSize: Size(20, 50),
                      backgroundColor: Colors.black.withOpacity(.7),
                      padding: EdgeInsets.only(left: 30, right: 30),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const AuthPage(showLoginPage: true,)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.login,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
