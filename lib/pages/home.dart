import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voting_sim_dapp/pages/electionInfo.dart';
import 'package:voting_sim_dapp/services/functions.dart';
import 'package:voting_sim_dapp/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infuraUrl, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Start Election")),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter Election Name",
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (textController.text.isNotEmpty) {
                    await startElection(textController.text, ethClient!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionInfo(
                          ethClient: ethClient!,
                          electionName: textController.text,
                        ),
                      ),
                    );
                  }
                },
                child: Text("Start Election"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
