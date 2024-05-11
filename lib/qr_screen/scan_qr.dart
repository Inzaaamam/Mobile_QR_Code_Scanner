import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qrcode/databse/database_helper.dart';

class OutputQr extends StatefulWidget {
  const OutputQr({super.key});

  @override
  State<OutputQr> createState() => _OutputQrState();
}

class _OutputQrState extends State<OutputQr> {
  @override
  void initState() {
    super.initState();
    // We can also use FutureBuilder to load the data
    getAllItems();
  }

  Future<void> getAllItems() async {
    final data = await SQLHelper.getItems();
    setState(() {
      dbItems = data;
    });
  }

  Map<String, dynamic> qrResult = {};
  List<Map<String, dynamic>> dbItems = [];

  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      log(qrCode);
      qrResult = extractKeyValuePairs(qrCode);
      // qrResult = jsonDecode(qrCode);

      if (qrResult.isNotEmpty) {
        try {
          await SQLHelper.createItems(
            qrResult['name'].toString(),
            int.parse(qrResult['age']),
            qrResult['address'].toString(),
            qrResult['profession'].toString(),
          );

          await getAllItems();
          log('Successfully saved it');
        } catch (e) {
          log('couldn\'t save it');
        }
      }

      setState(() {});
    } on PlatformException {
      qrResult = {};
    } finally {

      if (!mounted) return;
    }
  }
  // final comment = '''Name: Inzamam
  // Age: 20
  // Address: Islamabad
  // Profession: Student''';

  // Ist Iteration -> ['Name:Inzamam', 'Age: 2' ...]

  // Second Interation -> ['Name', 'Inzamam']  -> first index is key AND second index is value

  Map<String, dynamic> extractKeyValuePairs(String data) {
    final Map<String, dynamic> map = {};
    final List<String> keyValuePairs = data.split('\n');

    for (final pair in keyValuePairs) {
      final keyValue = pair.split(': ');
      final key = keyValue[0].trim();
      final value = keyValue[1].trim();
      map[key] = value;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    log("Show QR result: $qrResult");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: (dbItems.isNotEmpty)
              ? ListView.builder(
                  itemCount: dbItems.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await SQLHelper.deleteItem(
                            dbItems[index]['name'],
                            dbItems[index]['age'],
                          );
                          dbItems = [];
                          await getAllItems();
                          setState(() {});
                        },
                      ),
                      title:
                         Text('Name : ${dbItems[index]['name'].toString()}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    
                          Text(
                            'Age: ${dbItems[index]['age'].toString()}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Profession: ${dbItems[index]['profession'].toString()}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        
                          Text('Adress: ${
                            dbItems[index]['address'].toString()}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Text('No Results Found!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanQR,
        child: const Icon(Icons.qr_code_scanner_outlined),
      ),
    );
  }
  
}

extension PaddWideget on Widget{
  // ignore: non_constant_identifier_names
  Widget Padd(double padding){
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }
}
extension CustomSize on Widget{
  // ignore: non_constant_identifier_names
  Widget Custombox( double height){
    return SizedBox(
      height: height,
      child: this,
    );
  }
}
extension TxtStyle on Widget{
  // ignore: non_constant_identifier_names
  Widget Txt(String text, double fontsize, Color color){
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontsize,
      ),
    );
  }
}