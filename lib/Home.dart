import 'dart:convert';
import 'package:api_rest/Post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String urlBase = "https://jsonplaceholder.typicode.com";

Future<List<Post>> recuperarPostagens(http.Client client) async {
  http.Response response = await client.get(Uri.parse(urlBase + '/posts'));
  return compute(parsePostagens, response.body);
}

List<Post> parsePostagens(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

post() async {
  var corpo = json.encode({
    "userId": 120,
    "id": null,
    "title": "",
    "body": "",
  });
  http.Response response = await http.post(
    Uri.parse(urlBase + '/posts'),
    headers: {"Content-type": 'aplication/json; charset=UTF-8'},
    body: corpo,
  );

  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");
}

put() async {
  var corpo = json.encode({
    "userId": 120,
    "id": null,
    "title": "Título Alterado",
    "body": "Corpo da postagem alterada",
  });
  http.Response response = await http.put(
    Uri.parse(urlBase + '/posts/2'),
    headers: {"Content-type": 'aplication/json; charset=UTF-8'},
    body: corpo,
  );

  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");
}

patch() async {
  var corpo = json.encode({
    "userId": 120,
    "id": null,
    "title": null,
    "body": "Corpo da postagem alterada",
  });
  http.Response response = await http.patch(
    Uri.parse(urlBase + '/posts/2'),
    headers: {"Content-type": 'aplication/json; charset=UTF-8'},
    body: corpo,
  );

  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");
}

delete() async {
  http.Response response = await http.delete(
    Uri.parse(urlBase + '/posts'),
  );

  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: post,
                  child: Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: put,
                  child: Text('Atualizar'),
                ),
                ElevatedButton(
                  onPressed: patch,
                  child: Text('Remover'),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
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
                              List<Post>? lista =
                                  snapshot.data; //!Erro snapshot
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
            ),
          ],
        ),
      ),
    );
  }
}
