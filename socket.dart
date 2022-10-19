import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Socketdata extends StatefulWidget {
  const Socketdata({Key key}) : super(key: key);
  @override
  State<Socketdata> createState() => _SocketdataState();
}

class _SocketdataState extends State<Socketdata> {

  WebSocketChannel chatSocket;
  String livebalance = "";
  String livexchange= "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chat();
  }

  //USE web_socket_channel PACKAGE
  //VERSION :
  // web_socket_channel: ^1.2.0

  //Connecting Binance Socket Function
  void chat() async {
    if (chatSocket != null) chatSocket.sink.close();
    //Socket URL
    chatSocket = WebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws'));
    //Socket Request Param
    var params = '{"method": "SUBSCRIBE","params": ["btcusdt@ticker"],"id":1}';
    print("params--"+params);
    //Send Socket Param
    chatSocket.sink.add(params);
    //Receive(listen) Socket Response
    chatSocket.stream.listen((chatevent) {
      print("event--"+chatevent);
      if (chatevent != null) {
        //Convert socket response json to map
        final data = jsonDecode(chatevent as String) as Map<String, dynamic>;
        //set socket response to string
        livebalance = data['c'].toString();
        livexchange = data['p'].toString();
        print( "liveval"+data['c'].toString());
        print( "liveval"+data['p'].toString());
      } else {
        if (chatSocket != null) chatSocket.sink.close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(livebalance.toString(),style: TextStyle(color: Colors.white),),
          Text(livexchange.toString(),style: TextStyle(color: Colors.white),),
        ],
      ),
    );
  }
}
