import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelberaberolsun/data/post_json.dart';
import 'package:gelberaberolsun/services/Auth.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    String a = Provider.of<Auth>(context).getCurrentUserName();

    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(0, 1)),
          ],
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeTab = 0;
                    Navigator.pushNamed(context, '/Main');
                  });
                },
                child: const Icon(
                  Icons.home,
                  size: 35,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeTab = 1;
                    //Mesajlaşma Kısmına gidecek.
                    Navigator.pushNamed(context, '/Chat');
                  });
                },
                child: const Icon(
                  Icons.message,
                  size: 35,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeTab = 3;
                    //Favoriler kısmına gidecek(Eğer yapmaya karar verirsek)
                  });
                },
                child: const Icon(
                  Icons.favorite,
                  size: 35,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeTab = 3;
                    Navigator.pushNamed(context, '/Profile');
                  });
                },
                child: const Icon(
                  Icons.person,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/Request");
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 1),
              ),
            ],
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gel Beraber Olsun',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () {
                  //Bildirim ekranına gidecek.
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.login_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await Provider.of<Auth>(context, listen: false).singOut();
                  })
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Güncel İstekler",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(icon: Icon(Icons.sort), onPressed: () {}),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            StreamBuilder(
                stream: Provider.of<Auth>(context, listen: false)
                    .getRequestListFromApi("request"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Bir Hata Meydana Geldi"),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      QuerySnapshot data = snapshot.data;
                      List<DocumentSnapshot> dataList = data.docs;

                      return MyColumn2(list: dataList);
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class MyColumn extends StatelessWidget {
  const MyColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(postsList.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 175,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  image: DecorationImage(
                      image: NetworkImage(postsList[index]['postImg']),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: double.infinity,
                height: 175,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: double.infinity,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(postsList[index]['img']),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    postsList[index]['name'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    postsList[index]['time'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: const Offset(0, 1),
                              )
                            ]),
                        child: Text(
                          postsList[index]['request'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class MyColumn2 extends StatelessWidget {
  final String name, info, requestTime;
  final List<DocumentSnapshot> list;

  MyColumn2({this.name, this.info, this.requestTime, this.list});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            ///Olusturulma tarihine göre sıralama işlemi.En son oluşturulan en üstte çıkacak.
            list.sort((a, b) {
              Map<String, dynamic> map1 = a.data();
              Map<String, dynamic> map2 = b.data();

              if ((map1["olusturma tarihi"]
                      .compareTo(map2["olusturma tarihi"]) <
                  0)) {
                return 1;
              } else {
                return -1;
              }
            });

            Map<String, dynamic> map = list[index].data();
            User user =
                Provider.of<Auth>(context, listen: false).getCurrentUser();
            return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: (){
                  print(map["isim"]);
                },
                onDoubleTap: () async {
                  
                  //silme işlemi için
                  if (map["uid"] == user.uid) {
                    showAlertDialog(context, () async {
                      try {
                        await Provider.of<Auth>(context,listen: false)
                            .documentDelete(user.uid);

                        Navigator.pop(context);
                      } catch (e) {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                    "Bir Hata Meydana Geldi Lütfen Daha Sonra Tekrar Deneyin!"),
                                    actions: [ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("Anladım."))],
                              );
                            });
                        
                      }
                    });
                    // await Provider.of<Auth>(context,listen: false).documentDelete(user.uid);
                  }
                },
                child: Stack(
                  children: [
                    
                    Container(
                      //width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        border: map["uid"] == user.uid
                            ? Border.all(color: Colors.yellow, width: 5)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        image: DecorationImage(
                            image: NetworkImage(
                                postsList[Random().nextInt(6)]['postImg']),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      //width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      //width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          postsList[Random().nextInt(6)]
                                              ['img']),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          map["isim"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          postsList[index]['time'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                      children: [
                                        Text(
                                          map["sehir"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          map["ilce"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 15,
                                      offset: const Offset(0, 1),
                                    )
                                  ]),
                              child: Text(
                                map["bilgi"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void showAlertDialog(context, Function deleteFunction) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Silme İşlemi"),
            content: Text(
                "Eğer Bu İşlemi Onaylarsanız Geri Alamazsınız.Onaylıyor musunuz?"),
            actions: [
              SizedBox(
                  //width: MediaQuery.of(context).size.width / 2,
                  child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      deleteFunction();
                    },
                    child: Text("Evet"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(130, 30),
                        elevation: 10,
                        primary: Colors.black),
                  ),
                ],
              )),
              SizedBox(
                  // width: MediaQuery.of(context).size.width / 2,
                  child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Hayır"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(130, 30),
                        elevation: 10,
                        primary: Colors.black),
                  ),
                ],
              )),
            ],
          );
        });
  }
}
