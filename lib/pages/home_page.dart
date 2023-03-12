import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/monthly_summary.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/components/monthly_summary.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _newHabitNameController = TextEditingController();
  bool habitCompleted = false;
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_Database');

  @override
  void initState(){

    if(_myBox.get('CURRENT_HABIT_LIST')== null){
      db.createDefaultData();
    }
    else{
     db.loadData();
    }
    db.updateDatabase();
    super.initState();
  }

  void checkTapped(bool? value,int index) {
    setState(() {
      db.todaysHabitList[index][1] = value!;
    });
    db.updateDatabase();
  }

  void createNewHabit(){
    showDialog(context: context, builder: (context){
      return MyAlertBox(
        _newHabitNameController,
        saveNewHabit,
        cancelDialogBox
      );
    });
    db.updateDatabase();
  }

  void saveNewHabit(){
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text,false]);
    });
    _newHabitNameController.clear();
    db.updateDatabase();
    Navigator.of(context).pop();
  }
  void cancelDialogBox(){
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    db.updateDatabase();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
           _newHabitNameController,
            ()=>saveExistingHabit(index),
           cancelDialogBox,
        );
      },
    );
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
        backgroundColor: Colors.grey[300],
        body: ListView(
          children: [
            MonthlySummary(datasets: db.heatMapDataSet,startDate:_myBox.get("START_DATE") ,),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: db.todaysHabitList.length,
          itemBuilder: (context, index) {
            return HabitTile(
              habitName: db.todaysHabitList[index][0],
              habitCompleted: db.todaysHabitList[index][1],
              onChanged: (value) => checkTapped(value,index),
              settingsTapped: (context)=>openHabitSettings(index),
              deleteTapped: (context)=>deleteHabit(index),
            );
          },
        )
          ],
        )
    );
  }
}
