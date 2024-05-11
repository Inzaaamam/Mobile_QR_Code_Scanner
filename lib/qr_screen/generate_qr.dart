// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/qr_screen/scan_qr.dart';

class MultiFieldQRCode extends StatefulWidget {
  const MultiFieldQRCode({super.key});

  @override
  _MultiFieldQRCodeState createState() => _MultiFieldQRCodeState();
}

class _MultiFieldQRCodeState extends State<MultiFieldQRCode> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Field QR Code'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'age',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Address';
                  }
                  return null;
                },
              ),
            
                 TextFormField(
                controller: _professionController,
                decoration: const InputDecoration(
                  labelText: 'profession',
                ),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your profession';
                  }
                  return null;
                },
              ),
             const  SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodeScreen(
                            name: _nameController.text,
                            age: int.parse(_ageController.text),
                            address: _addressController.text,
                            profession: _professionController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Generate QR Code'),
                ), 
              ),
              const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(child: const Text('Scan Code'), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OutputQr()),
                );
              },),
            )
            ],
          ),
        ),
      ),
    );
  }
}

class QRCodeScreen extends StatelessWidget {
  final String name;
  final int age;
  final String address;
  final String profession;
QRCodeScreen({required this.name, required this.age, required this.address, required this.profession});
 

  @override
  Widget build(BuildContext context) {
    String data = 'name: $name\nage: $age\naddress: $address\nprofession: $profession';

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: QrImageView(data: data, version: QrVersions.auto,
        size:300 ,),
       
  
      ),
    );
  }
}