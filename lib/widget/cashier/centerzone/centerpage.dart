import 'package:flutter/material.dart';

class CenterSection extends StatefulWidget {
  final List<Map<String, String>> mockData;

  const CenterSection({required this.mockData, Key? key}) : super(key: key);

  @override
  State<CenterSection> createState() => _CenterSectionState();
}

class _CenterSectionState extends State<CenterSection> {
  // สร้าง ScrollController ส่วนตัว
  final ScrollController _itemsScrollController = ScrollController();
  final ScrollController _paymentScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          // Items Section
          _buildItemsSection(),

          const SizedBox(height: 8),

          // Summary Section
          _buildSummarySection(),

          const SizedBox(height: 8),

          // Total Section
          _buildTotalSection(),

          const SizedBox(height: 8),

          // Payment Section
          _buildPaymentSection(),
        ],
      ),
    );
  }

  // Items Section
  Widget _buildItemsSection() {
    return Container(
      width: 520,
      height: 180,
      padding: const EdgeInsets.all(14.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                  flex: 1,
                  child: Text('Item',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 1,
                  child: Text('Qty.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 1,
                  child: Text('Unit price',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 1,
                  child: Text('Discount',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 1,
                  child: Text('Price',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller:
                  _itemsScrollController, // ใช้ ScrollController ส่วนตัว
              primary: false, // ปิดการใช้งาน PrimaryScrollController
              itemCount: widget.mockData.length,
              itemBuilder: (context, index) {
                final item = widget.mockData[index];
                return _buildItemRow(
                  item["item"]!,
                  item["qty"]!,
                  item["unitPrice"]!,
                  item["discount"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Summary Section
  Widget _buildSummarySection() {
    return Container(
      width: 520,
      height: 135,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Amount', '700.00'),
          _buildSummaryRow('Discount', '90.00'),
          _buildSummaryRow('Service Charge 10%', '70.00'),
          _buildSummaryRow('VAT 7%', '53.90'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
          Text(value,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  // Total Section
  Widget _buildTotalSection() {
    return Container(
      width: 520,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Total',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          Text('748.90',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }

  // Payment Section
  Widget _buildPaymentSection() {
    return Container(
      width: 520,
      height: 150,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: Scrollbar(
                controller: _paymentScrollController,
                thickness: 7,
                radius: const Radius.circular(15),
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _paymentScrollController,
                  primary: false, // ปิด PrimaryScrollController
                  child: Column(
                    children: [
                      for (int i = 1; i <= 10; i++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment $i'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${500.00 + i * 10}'),
                                const Text(
                                  'Details',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(
      String item, String qty, String unitPrice, String discount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(item, textAlign: TextAlign.left)),
          Expanded(flex: 1, child: Text(qty, textAlign: TextAlign.center)),
          Expanded(
              flex: 1, child: Text(unitPrice, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text(discount, textAlign: TextAlign.center)),
          Expanded(
            flex: 1,
            child: Text(
              (double.parse(unitPrice) - double.parse(discount))
                  .toStringAsFixed(2),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
