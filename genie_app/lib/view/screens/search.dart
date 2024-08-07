import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/found_member.dart';
import 'package:genie_app/viewModel/controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool firstTime = true;
  bool nameButtonPressed = true;
  bool careerButtonPressed = false;
  bool univButtonPressed = false;
  bool isLoading = false;
  late List<Widget> foundUsers = [];
  final TextEditingController _controller = TextEditingController();

  void findUsers(String attribute) async {
    String txt = _controller.text.trim();
    if (txt.isNotEmpty) {
      setState(() {
        firstTime = false;
        isLoading = true;
      });
      List<Widget> found = await Controller.getFoundUsers(txt, attribute);
      List<Widget> correctUsers = processUsers(found, txt, attribute);

      setState(() {
        foundUsers = correctUsers;
        isLoading = false;
      });
    }
  }

  List<Widget> processUsers(
      List<Widget> foundUsers, String searchValue, String attribute) {
    List<FoundMember> endList = [];
    if (attribute == "username") {
      for (Widget user in foundUsers) {
        if ((user as FoundMember)
            .username
            .toLowerCase()
            .startsWith(searchValue.toLowerCase())) {
          endList.add(user);
        }
      }
    } else if (attribute == "career") {
      for (Widget user in foundUsers) {
        if ((user as FoundMember)
            .career
            .toLowerCase()
            .startsWith(searchValue.toLowerCase())) {
          endList.add(user);
        }
      }
    } else if (attribute == "university") {
      for (Widget user in foundUsers) {
        if ((user as FoundMember)
            .university
            .toLowerCase()
            .startsWith(searchValue.toLowerCase())) {
          endList.add(user);
        }
      }
    }
    return endList as List<Widget>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(12.0),
                color: genieThemeDataDemo.colorScheme.secondary,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: TextField(
                            controller: _controller,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    genieThemeDataDemo.colorScheme.onSecondary,
                                hintText: "Buscar...",
                                hintStyle:
                                    genieThemeDataDemo.textTheme.titleMedium,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: genieThemeDataDemo
                                            .colorScheme.secondary),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)))),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (nameButtonPressed) {
                              findUsers("username");
                            } else if (univButtonPressed) {
                              findUsers("university");
                            } else if (careerButtonPressed) {
                              findUsers("career");
                            }
                          },
                          icon: Icon(Icons.search_outlined,
                              color: genieThemeDataDemo.colorScheme.onPrimary)),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Filtrar por:",
                            style: TextStyle(
                                color: genieThemeDataDemo.colorScheme.onPrimary,
                                fontSize: 14),
                          ),
                        ),
                        FilledButton(
                            onPressed: () {
                              setState(() {
                                univButtonPressed = false;
                                careerButtonPressed = false;
                                nameButtonPressed = true;
                              });
                            },
                            style: nameButtonPressed
                                ? mainButtonStyle
                                : outlinedButtonStyle,
                            child: const Text(
                              "Usuario",
                              style: TextStyle(fontSize: 14),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(
                              onPressed: () {
                                setState(() {
                                  nameButtonPressed = false;
                                  univButtonPressed = false;
                                  careerButtonPressed = true;
                                });
                              },
                              style: careerButtonPressed
                                  ? mainButtonStyle
                                  : outlinedButtonStyle,
                              child: const Text("Carrera",
                                  style: TextStyle(fontSize: 14))),
                        ),
                        FilledButton(
                            onPressed: () {
                              setState(() {
                                careerButtonPressed = false;
                                nameButtonPressed = false;
                                univButtonPressed = true;
                              });
                            },
                            style: univButtonPressed
                                ? mainButtonStyle
                                : outlinedButtonStyle,
                            child: const Text("Universidad",
                                style: TextStyle(fontSize: 14))),
                      ],
                    ),
                  ),
                ])),
            isLoading
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(child: const CircularProgressIndicator()),
                      ),
                    ],
                  )
                : foundUsers.isEmpty
                    ? !firstTime
                        ? const Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "No se ha encontrado ningún usuario",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xffB4B6BF)),
                              ),
                            ],
                          )
                        : const SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "¡Realiza una búsqueda!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xffB4B6BF)),
                                  ),
                                ),
                              ],
                            ))
                    : Expanded(child: ListView(children: [...foundUsers]))
          ],
        ),
        bottomNavigationBar: BottomNavBar());
  }
}
