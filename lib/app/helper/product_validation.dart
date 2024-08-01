class ProductValidation {
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama produk tidak boleh kosong';
    }
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga tidak boleh kosong';
    }
    return null;
  }
}
