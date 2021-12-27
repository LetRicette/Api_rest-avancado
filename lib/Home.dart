import 'dart:convert';
import 'package:api_rest/Post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> recuperarPostagens(http.Client client) async {
  http.Response response =
      await client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  return compute(parsePostagens, response.body);
}

List<Post> parsePostagens(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: FutureBuilder<List<Post>>(
        future: recuperarPostagens(http.Client()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Erro ao carregar os dados.');
              else
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      List<Post>? lista = snapshot.data; //!Erro snapshot
                      Post post = lista![index];

                      return ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Text(post.title),
                        subtitle: Text(post.body),
                      );
                    });
          }
        },
      ),
    );
  }
}
