double calculateSubtotal(List<Map<String, dynamic>> orders) {
  return orders.fold(
    0.0,
    (sum, item) {
      final price = item['price'] ?? 0.0;
      final quantity = item['quantity'] ?? 0;
      return sum + (price * quantity);
    },
  );
}

/// คำนวณ Service Charge
double calculateServiceCharge(double subtotal) {
  return subtotal * 0.1; // 10%
}

/// คำนวณ VAT
double calculateVAT(double subtotal) {
  return subtotal * 0.07; // 7%
}

/// คำนวณ Grand Total
double calculateGrandTotal(double subtotal, double serviceCharge, double vat) {
  return subtotal + serviceCharge + vat;
}
