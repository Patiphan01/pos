import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestFetchPage extends StatefulWidget {
  const TestFetchPage({Key? key}) : super(key: key);

  @override
  State<TestFetchPage> createState() => _TestFetchPageState();
}

class _TestFetchPageState extends State<TestFetchPage> {
  bool _isLoading = false;
  String _data = '';

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _data = '';
    });

    // URL ที่คุณให้มา
    final url =
        'https://sounddev.triggersplus.com/dining/get_restaurant_mode/F236C2691F953686A95A8ACB7EEF782D/';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // สมมุติว่า API ส่งข้อมูลในรูปแบบ JSON
        final decoded = jsonDecode(response.body);
        // แปลง JSON ให้อ่านง่ายด้วยการจัด indent
        final prettyJson = const JsonEncoder.withIndent('  ').convert(decoded);
        setState(() {
          _data = prettyJson;
        });
      } else {
        setState(() {
          _data = 'Error: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _data = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Optionally fetch data automatically when page loads:
    // _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Fetch Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchData,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Fetch Data"),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _data.isEmpty ? "No data fetched yet." : _data,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
