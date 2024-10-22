import 'package:flutter/material.dart';
import 'package:urlshortner/API.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = TextEditingController();
  var Analyticscontroller = TextEditingController();
  String? id;
  bool isFind = false;
  bool isAnalytic=false;
  bool isLoaded=false;
  //late Map data={};
  var data;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        isLoaded=true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body:!isLoaded?
              Center(child: CircularProgressIndicator())
     : Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: controller,
                decoration: InputDecoration(
                    hintText: "Enter Url",
                    contentPadding: EdgeInsets.only(left: 10),
                    hintFadeDuration: Duration(seconds: 1),
                    hintStyle:
                        TextStyle(color: Colors.grey[500]?.withOpacity(1))),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  Map data = {
                    "RedirectURL": controller.text.toString(),
                  };
                  id = await API.getNanoId(data);
                  if (id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Not Created"),
                      backgroundColor: Colors.red,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Created"),
                      backgroundColor: Colors.green,
                    ));
                    print(id);
                    setState(() {
                      isFind = true;
                      controller.text = '';
                    });
                    //isFind=false;
                  }
                },
                child: Text("Convert"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              Visibility(
                  visible: isFind,
                  child: SelectableText(
                    "New ShortID is: $id",
                  )),
              TextField(
                keyboardType: TextInputType.text,
                controller: Analyticscontroller,
                decoration: InputDecoration(
                    hintText: "Enter Url for Analytic",
                    contentPadding: EdgeInsets.only(left: 10),
                    hintFadeDuration: Duration(seconds: 1),
                    hintStyle:
                        TextStyle(color: Colors.grey[500]?.withOpacity(1))),
              ),
              ElevatedButton(
                onPressed: () async {
                 data= await API
                      .getAnalytics(Analyticscontroller.text.toString());

                  if (data == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Not found any of this id"),
                      backgroundColor: Colors.red,

                    ));
                    print(data);
                  }
                  else
                    {
                      print(data);
                     setState(() {
                       isAnalytic=true;
                       Analyticscontroller.text='';
                     });
                    }
                },
                child: Text("get"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              Visibility(
                  visible: isAnalytic,
                  child: Text(data.toString()) )//Text("Total clicks are:${data!['totalClicks']} \nAnd analytics are:${data!["anlytics"]}"))
            ],
          ),
        ),
      ),
    );
  }
}
