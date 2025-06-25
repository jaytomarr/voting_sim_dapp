import 'package:flutter/material.dart';
import 'package:voting_sim_dapp/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  const ElectionInfo({
    super.key,
    required this.ethClient,
    required this.electionName,
  });

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Info - ${widget.electionName}")),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getNumCandidates(widget.ethClient),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Text(
                          snapshot.data![0].toString(),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    Text('Total Candidates'),
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getTotalVotes(widget.ethClient),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Text(
                          snapshot.data![0].toString(),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    Text('Total Votes'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addCandidateController,
                    decoration: InputDecoration(
                      hintText: "Enter Candidate Name",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (addCandidateController.text.isNotEmpty) {
                      await addCandidate(
                        addCandidateController.text,
                        widget.ethClient,
                      );
                    }
                  },
                  child: Text("Add Candidate"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: authorizeVoterController,
                    decoration: InputDecoration(
                      hintText: "Enter Voter Address",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (authorizeVoterController.text.isNotEmpty) {
                      await authoriseVoter(
                        authorizeVoterController.text,
                        widget.ethClient,
                      );
                    }
                  },
                  child: Text("Add Voter"),
                ),
              ],
            ),
            Divider(),
            FutureBuilder<List>(
              future: getNumCandidates(widget.ethClient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      for (int i = 0; i < snapshot.data![0].toInt(); i++)
                        FutureBuilder<List>(
                          future: candidateInfo(i, widget.ethClient),
                          builder: (context, candidateSnapshot) {
                            if (candidateSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return ListTile(
                                title: Text(
                                  "Name:${candidateSnapshot.data![0][0].toString()}",
                                ),
                                subtitle: Text(
                                  "Votes: ${candidateSnapshot.data![0][1].toString()}",
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    vote(i, widget.ethClient);
                                  },
                                  child: Text("Vote"),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
