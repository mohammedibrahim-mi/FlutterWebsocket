import 'dart:convert';
import 'package:Sample/widgets/darkcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      height: 200,
      width: 200,
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(height: 200.0,),
          Container(
            child: Text("Balance",
      style:GoogleFonts.comfortaa(
        fontSize: 14,
        color: DarkColor.white,
      ),),
          ),
          SizedBox(height: 20.0,),
          Text(livebalance.toString(),
            style:GoogleFonts.comfortaa(
            fontSize: 12,
            color: DarkColor.white,
          ),
          ),
          SizedBox(height: 50.0,),
          Text("Exchange",
            style:GoogleFonts.comfortaa(
              fontSize: 14,
              color: DarkColor.white,
            ),),
          SizedBox(height: 20.0,),
          Text(livexchange.toString(), style:GoogleFonts.comfortaa(
            fontSize: 12,
            color: DarkColor.white,
          ),),
        ],
      ),
    );
  }
}
