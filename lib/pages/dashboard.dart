import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuttritionapp/service/historyService.dart';
import '../widgets/login_widgets.dart';
import '../widgets/menudrawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final HistoryService _historyS = HistoryService();

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('d MMMM yyyy, h:mm:ss a').format(dateTime);
  }

  String selectedItem = 'today';

  // Future for fetching data
  Future<List<Map<String, dynamic>>>? dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _historyS.gethistorybydate(selectedItem);
  }

  // Function to update data when dropdown changes
  void onDropdownChanged(String? value) {
    if (value == null) return;
    setState(() {
      selectedItem = value;
      dataFuture = _historyS.gethistorybydate(selectedItem);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History',style: TextStyle(
            color: Colors.white
        ),),
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (BuildContext context) {
            return Customtopbtn(
              context,
              () {
                Scaffold.of(context).openDrawer();
              },
              Icons.menu,
            );
          },
        ),
      ),
      drawer: customDrawer(context),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      onDropdownChanged('today');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('today', style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      onDropdownChanged('week');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('week', style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      onDropdownChanged('month');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('month', style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    final data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: screenHeight / 7,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(style:TextStyle(color: Colors.white),'Food: ${item['food']},'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(style:TextStyle(color: Colors.white),'Calories: ${item['calories']}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(style:TextStyle(color: Colors.white),'Date: ${formatTimestamp(item['timestamp'])}'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
