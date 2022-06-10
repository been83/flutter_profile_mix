import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_profile_mix/components/drawer.dart';
import 'package:firebase_core/firebase_core.dart';

// 할 일 클래스
class Todo {
  bool isDone;
  String title;

  Todo(this.title, {this.isDone = false});
}

// 시작 클래스
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '할 일 관리',
      theme: ThemeData(
        //primarySwatch: Colors.indigo,
        appBarTheme: AppBarTheme(
          color: Color(0xff192a70),
        ),
      ),
      home: TodoListPage(),
    );
  }
}

// TodoListPage 클래스
class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

// TodoListPage의 State 클래스
class _TodoListPageState extends State<TodoListPage> {
  var _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('todo').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final documents = snapshot.data.docs;
              return Expanded(
                child: ListView(
                  children:
                  documents.map((doc) => _buildItemWidget(doc)).toList(),
                ),
              );
            },
          ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff192a70),
        child: Icon(Icons.add),

        onPressed: () => _addTodo(Todo(_todoController.text)),

      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
        centerTitle: true,
        leading : IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DrawerMenu()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Color(0xff192a70),
                  child: Icon(Icons.add),
                  onPressed: () => _addTodo(Todo(_todoController.text)),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('todo').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final documents = snapshot.data?.docs;
                return Expanded(
                  child: ListView(
                    children:
                    documents!.map((doc) => _buildItemWidget(doc)).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 할 일 객체를 ListTile 형태로 변경하는 메서드
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final todo = Todo(doc['title'], isDone: doc['isDone']);
    return ListTile(
      onTap: () => _toggleTodo(doc),
      title: Text(
        todo.title,
        style: todo.isDone
            ? TextStyle(
          decoration: TextDecoration.lineThrough,
          fontStyle: FontStyle.italic,
        )
            : null,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () => _deleteTodo(doc),
      ),
    );
  }

  // 할 일 추가 메서드
  void _addTodo(Todo todo) {
    FirebaseFirestore.instance
        .collection('todo')
        .add({'title': todo.title, 'isDone': todo.isDone});
    _todoController.text = '';
  }

  // 할 일 삭제 메서드
  void _deleteTodo(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('todo').doc(doc.id).delete();
  }

  // 할 일 완료/미완료 메서드
  void _toggleTodo(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('todo').doc(doc.id).update({
      'isDone': !doc['isDone'],
    });
  }
}
