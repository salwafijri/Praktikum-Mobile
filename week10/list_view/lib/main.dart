import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Item',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B8FD4),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F4F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F4F2),
          foregroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFFFF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE8E8E4), width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8E8E4), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8E8E4), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF4B8FD4), width: 1.5),
          ),
          hintStyle:
              const TextStyle(color: Color(0xFFB8B8B4), fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
      home: const ItemListPage(),
    );
  }
}

// Kategori Bawaan

const List<String> kDefaultCategories = [
  'Semua',
  'Elektronik',
  'Alat Tulis',
  'Barang Random',
  'Pakaian',
  'Makanan & Minuman',
  'Lainnya',
];

// Palet warna random yang menarik untuk kategori kustom
const List<Color> kRandomColorPalette = [
  Color(0xFF6C5CE7), // ungu
  Color(0xFF00B894), // hijau mint
  Color(0xFFE17055), // oranye salmon
  Color(0xFF0984E3), // biru cerah
  Color(0xFFD63031), // merah
  Color(0xFFE84393), // pink
  Color(0xFF00CEC9), // teal
  Color(0xFFFDAB33), // kuning emas
  Color(0xFF55EFC4), // hijau neon
  Color(0xFFAB8FFF), // ungu muda
  Color(0xFFFF6B6B), // merah muda
  Color(0xFF2D9CDB), // biru langit
];

Color _randomColor() {
  final rng = Random();
  return kRandomColorPalette[rng.nextInt(kRandomColorPalette.length)];
}

Color _lightenColor(Color color, [double amount = 0.88]) {
  return Color.lerp(color, Colors.white, amount)!;
}

// Model Kategori Kustom

class CustomCategory {
  final String name;
  final int colorValue; // simpan sebagai int agar bisa di-encode JSON

  CustomCategory({required this.name, required this.colorValue});

  Color get color => Color(colorValue);
  Color get bgColor => _lightenColor(Color(colorValue));

  Map<String, dynamic> toMap() => {'name': name, 'colorValue': colorValue};

  factory CustomCategory.fromMap(Map<String, dynamic> map) =>
      CustomCategory(name: map['name'], colorValue: map['colorValue']);
}

//  Helper Warna & Ikon Kategori

Color categoryColor(String category,
    {List<CustomCategory> customCategories = const []}) {
  switch (category) {
    case 'Elektronik':
      return const Color(0xFF4B8FD4);
    case 'Alat Tulis':
      return const Color(0xFFF5C518);
    case 'Barang Random':
      return const Color(0xFFE85F9E);
    case 'Pakaian':
      return const Color(0xFF8FA8C8);
    case 'Makanan & Minuman':
      return const Color(0xFF72B13A);
    default:
      // Cari di kategori kustom
      try {
        final custom =
            customCategories.firstWhere((c) => c.name == category);
        return custom.color;
      } catch (_) {
        return const Color(0xFF888884);
      }
  }
}

Color categoryBg(String category,
    {List<CustomCategory> customCategories = const []}) {
  switch (category) {
    case 'Elektronik':
      return const Color(0xFFE8F1FB);
    case 'Alat Tulis':
      return const Color(0xFFFDF7E0);
    case 'Barang Random':
      return const Color(0xFFFDE8F3);
    case 'Pakaian':
      return const Color(0xFFEDF1F7);
    case 'Makanan & Minuman':
      return const Color(0xFFEDF7E4);
    default:
      try {
        final custom =
            customCategories.firstWhere((c) => c.name == category);
        return custom.bgColor;
      } catch (_) {
        return const Color(0xFFF0F0EC);
      }
  }
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Elektronik':
      return Icons.laptop_rounded;
    case 'Alat Tulis':
      return Icons.edit_rounded;
    case 'Barang Random':
      return Icons.auto_awesome_rounded;
    case 'Pakaian':
      return Icons.dry_cleaning_rounded;
    case 'Makanan & Minuman':
      return Icons.fastfood_rounded;
    default:
      return Icons.label_rounded;
  }
}

// Halaman Utama

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage>
    with SingleTickerProviderStateMixin {
  List<ItemModel> _items = [];
  List<CustomCategory> _customCategories = []; // Kategori tambahan user

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();

  String _selectedCategory = 'Barang Random';
  String _filterCategory = 'Semua';
  String _searchQuery = '';
  bool _showFavoritesOnly = false;
  late AnimationController _fabAnimController;

  // Semua kategori (bawaan + kustom)
  List<String> get _allCategories {
    final customs = _customCategories.map((c) => c.name).toList();
    return [...kDefaultCategories, ...customs];
  }

  final List<ItemModel> _dummyItems = [
    ItemModel(
        id: 1,
        name: 'Laptop',
        description: 'Laptop gaming 16"',
        category: 'Elektronik'),
    ItemModel(
        id: 2,
        name: 'Mouse',
        description: 'Mouse wireless ergonomis',
        category: 'Elektronik'),
    ItemModel(
        id: 3,
        name: 'Keyboard',
        description: 'Keyboard mechanical TKL',
        category: 'Elektronik'),
    ItemModel(
        id: 4,
        name: 'Pulpen',
        description: 'Pulpen hitam 0.5mm',
        category: 'Alat Tulis'),
    ItemModel(
        id: 5,
        name: 'Buku Catatan',
        description: 'Buku A5 100 lembar',
        category: 'Alat Tulis'),
    ItemModel(
        id: 6,
        name: 'Jaket',
        description: 'Jaket denim biru tua',
        category: 'Pakaian'),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _loadData();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _searchController.dispose();
    _newCategoryController.dispose();
    _fabAnimController.dispose();
    super.dispose();
  }

  List<ItemModel> get _filteredItems {
    return _items.where((item) {
      final matchCategory =
          _filterCategory == 'Semua' || item.category == _filterCategory;
      final matchFavorite = !_showFavoritesOnly || item.isFavorite;
      final matchSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery) ||
          item.description.toLowerCase().contains(_searchQuery) ||
          item.category.toLowerCase().contains(_searchQuery);
      return matchCategory && matchFavorite && matchSearch;
    }).toList();
  }

  // Load & Save

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load items
    final itemsString = prefs.getString('items_list');
    if (itemsString != null) {
      final List<dynamic> itemsMap = json.decode(itemsString);
      setState(() {
        _items = itemsMap.map((item) => ItemModel.fromMap(item)).toList();
      });
    } else {
      setState(() => _items = List.from(_dummyItems));
      await _saveData();
    }

    // Load custom categories
    final catString = prefs.getString('custom_categories');
    if (catString != null) {
      final List<dynamic> catList = json.decode(catString);
      setState(() {
        _customCategories =
            catList.map((c) => CustomCategory.fromMap(c)).toList();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsMap = _items.map((item) => item.toMap()).toList();
    await prefs.setString('items_list', json.encode(itemsMap));
  }

  Future<void> _saveCustomCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final catMap = _customCategories.map((c) => c.toMap()).toList();
    await prefs.setString('custom_categories', json.encode(catMap));
  }

  // CRUD Item
  Future<void> _addItem() async {
    if (_nameController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      _showSnack('Nama dan deskripsi tidak boleh kosong', isError: true);
      return;
    }
    final newId = _items.isNotEmpty
        ? _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1
        : 1;
    final newItem = ItemModel(
      id: newId,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      category: _selectedCategory,
    );
    setState(() => _items.add(newItem));
    await _saveData();
    _clearControllers();
    if (mounted) Navigator.pop(context);
    _showSnack('Barang berhasil ditambahkan');
  }

  Future<void> _editItem(ItemModel oldItem) async {
    if (_nameController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      _showSnack('Nama dan deskripsi tidak boleh kosong', isError: true);
      return;
    }
    setState(() {
      final idx = _items.indexWhere((item) => item.id == oldItem.id);
      if (idx != -1) {
        _items[idx] = ItemModel(
          id: oldItem.id,
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          category: _selectedCategory,
          isFavorite: oldItem.isFavorite,
        );
      }
    });
    await _saveData();
    _clearControllers();
    if (mounted) Navigator.pop(context);
    _showSnack('Barang berhasil diperbarui');
  }

  Future<void> _toggleFavorite(ItemModel item) async {
    setState(() => item.isFavorite = !item.isFavorite);
    await _saveData();
    _showSnack(
        item.isFavorite ? 'Ditambahkan ke Favorit' : 'Dihapus dari Favorit');
  }

  Future<void> _deleteItem(int id) async {
    setState(() => _items.removeWhere((item) => item.id == id));
    await _saveData();
    _showSnack('Barang dihapus');
  }

  // Tambah Kategori Kustom

  void _showAddCategoryDialog() {
    _newCategoryController.clear();
    Color previewColor = _randomColor();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFFFFFFFF),
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                              color: _lightenColor(previewColor),
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.add_circle_outline_rounded,
                              color: previewColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Text('Tambah Kategori',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A))),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Input nama kategori
                    const Text('Nama Kategori',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _newCategoryController,
                      autofocus: true,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1A1A1A)),
                      decoration: const InputDecoration(
                          hintText: 'Contoh: Hobi, Olahraga, dll...'),
                    ),
                    const SizedBox(height: 16),

                    // Preview warna + tombol acak
                    const Text('Warna Kategori',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Preview chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _lightenColor(previewColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.label_rounded,
                                  size: 13, color: previewColor),
                              const SizedBox(width: 6),
                              ValueListenableBuilder(
                                valueListenable: _newCategoryController,
                                builder: (_, val, __) => Text(
                                  val.text.isEmpty
                                      ? 'Preview'
                                      : val.text,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: previewColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Tombol acak warna
                        GestureDetector(
                          onTap: () => setDialogState(
                              () => previewColor = _randomColor()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0EC),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE8E8E4)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.shuffle_rounded,
                                    size: 14, color: Color(0xFF888884)),
                                SizedBox(width: 5),
                                Text('Acak Warna',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF888884),
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tombol aksi
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF888884),
                              side: const BorderSide(
                                  color: Color(0xFFE8E8E4)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Batal',
                                style: TextStyle(fontSize: 13)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                _submitNewCategory(ctx, previewColor),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A1A1A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Tambah',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitNewCategory(BuildContext ctx, Color color) async {
    final name = _newCategoryController.text.trim();
    if (name.isEmpty) {
      _showSnack('Nama kategori tidak boleh kosong', isError: true);
      return;
    }
    if (_allCategories.map((c) => c.toLowerCase()).contains(name.toLowerCase())) {
      _showSnack('Kategori "$name" sudah ada', isError: true);
      return;
    }
    final newCat =
        CustomCategory(name: name, colorValue: color.value);
    setState(() => _customCategories.add(newCat));
    await _saveCustomCategories();
    _newCategoryController.clear();
    if (mounted) Navigator.pop(ctx);
    _showSnack('Kategori "$name" berhasil ditambahkan');
  }

  //Hapus Kategori Kustom (long-press)

  void _confirmDeleteCategory(CustomCategory cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Kategori?',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A))),
        content: Text(
          'Yakin ingin menghapus kategori "${cat.name}"?\nBarang dengan kategori ini tidak akan terhapus.',
          style: const TextStyle(
              fontSize: 13, color: Color(0xFF888884), height: 1.6),
        ),
        actionsPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF888884),
                    side: const BorderSide(color: Color(0xFFE8E8E4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child:
                      const Text('Batal', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    setState(() {
                      _customCategories
                          .removeWhere((c) => c.name == cat.name);
                      if (_filterCategory == cat.name) {
                        _filterCategory = 'Semua';
                      }
                    });
                    await _saveCustomCategories();
                    _showSnack('Kategori "${cat.name}" dihapus');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE83A2C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.delete_rounded, size: 16),
                  label: const Text('Hapus',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helpers

  void _clearControllers() {
    _nameController.clear();
    _descController.clear();
    _selectedCategory = 'Barang Random';
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontSize: 13, color: Colors.white)),
        backgroundColor:
            isError ? const Color(0xFFE83A2C) : const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddDialog() {
    _clearControllers();
    showDialog(
      context: context,
      builder: (ctx) => _ItemDialog(
        title: 'Tambah Barang Baru',
        icon: Icons.add_box_outlined,
        nameController: _nameController,
        descController: _descController,
        selectedCategory: _selectedCategory,
        allCategories: _allCategories.where((c) => c != 'Semua').toList(),
        customCategories: _customCategories,
        onCategoryChanged: (val) => setState(() => _selectedCategory = val!),
        onConfirm: _addItem,
        confirmLabel: 'Tambah',
        onCancel: () {
          _clearControllers();
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showEditDialog(ItemModel item) {
      _nameController.text = item.name;
      _descController.text = item.description;

      // Cek apakah kategori item masih valid (ada di daftar kategori)
      final validCategories = _allCategories.where((c) => c != 'Semua').toList();
      _selectedCategory = validCategories.contains(item.category)
          ? item.category
          : 'Lainnya'; // fallback jika kategori sudah dihapus

      showDialog(
        context: context,
        builder: (ctx) => _ItemDialog(
          title: 'Edit Barang',
          icon: Icons.edit_note_rounded,
          nameController: _nameController,
          descController: _descController,
          selectedCategory: _selectedCategory,
          allCategories: validCategories,
          customCategories: _customCategories,
          onCategoryChanged: (val) => setState(() => _selectedCategory = val!),
          onConfirm: () => _editItem(item),
          confirmLabel: 'Simpan',
          onCancel: () {
            _clearControllers();
            Navigator.pop(ctx);
          },
        ),
      );
  }

  void _confirmDelete(ItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Barang?',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A)),
        ),
        content: Text(
          'Yakin ingin menghapus "${item.name}"?\nTindakan ini tidak bisa dibatalkan.',
          style: const TextStyle(
              fontSize: 13, color: Color(0xFF888884), height: 1.6),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF888884),
                    side: const BorderSide(color: Color(0xFFE8E8E4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child:
                      const Text('Batal', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _deleteItem(item.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE83A2C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.delete_rounded, size: 16),
                  label: const Text('Hapus',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F2),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 125,
            pinned: true,
            backgroundColor: const Color(0xFFF4F4F2),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 34),
              title: const Text(
                'Daftar Item',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                color: const Color(0xFFF4F4F2),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 52, right: 20),
                        child: GestureDetector(
                          onTap: () => setState(
                              () => _showFavoritesOnly = !_showFavoritesOnly),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _showFavoritesOnly
                                  ? const Color(0xFFF5C518)
                                  : const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0xFFE8E8E4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _showFavoritesOnly
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 16,
                                  color: _showFavoritesOnly
                                      ? Colors.white
                                      : const Color(0xFFF5C518),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Favorit',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _showFavoritesOnly
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 14),
                        child: Text(
                          'Kelola barang-mu dengan lebih baik',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF888884)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: const Color(0xFFE8E8E4)),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF1A1A1A)),
                decoration: InputDecoration(
                  hintText: 'Cari nama, deskripsi, atau kategori...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Color(0xFFB8B8B4), size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Color(0xFFB8B8B4), size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Filter Kategori (+ Tombol Tambah Kategori)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                // +1 untuk tombol tambah kategori di akhir
                itemCount: _allCategories.length + 1,
                itemBuilder: (ctx, i) {
                  // Tombol "+" tambah kategori di posisi paling kanan
                  if (i == _allCategories.length) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: _showAddCategoryDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Kategori',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final cat = _allCategories[i];
                  final isSelected = cat == _filterCategory;
                  final isCustom = _customCategories
                      .any((c) => c.name == cat);

                  final color = categoryColor(cat,
                      customCategories: _customCategories);
                  final bg = categoryBg(cat,
                      customCategories: _customCategories);
                  final baseColor = cat == 'Semua'
                      ? const Color(0xFF1A1A1A)
                      : color;
                  final baseBg = cat == 'Semua'
                      ? const Color(0xFFF0F0EC)
                      : bg;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _filterCategory = cat),
                      // Long-press untuk hapus kategori kustom
                      onLongPress: isCustom
                          ? () {
                              final custom = _customCategories
                                  .firstWhere((c) => c.name == cat);
                              _confirmDeleteCategory(custom);
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (cat == 'Semua'
                                  ? const Color(0xFF1A1A1A)
                                  : baseColor)
                              : baseBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : const Color(0xFFE8E8E4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (cat != 'Semua') ...[
                              Icon(categoryIcon(cat),
                                  size: 11,
                                  color: isSelected
                                      ? Colors.white
                                      : baseColor),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.white
                                    : (cat == 'Semua'
                                        ? const Color(0xFF888884)
                                        : baseColor),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Info Hasil
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Row(
                children: [
                  Text(
                    '${filtered.length} barang ${_showFavoritesOnly ? 'favorit' : ''}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFFB8B8B4)),
                  ),
                  if (_filterCategory != 'Semua') ...[
                    const Text('  ·  ',
                        style: TextStyle(
                            color: Color(0xFFD8D8D4), fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: categoryBg(_filterCategory,
                              customCategories: _customCategories),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(categoryIcon(_filterCategory),
                              size: 10,
                              color: categoryColor(_filterCategory,
                                  customCategories: _customCategories)),
                          const SizedBox(width: 4),
                          Text(_filterCategory,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: categoryColor(_filterCategory,
                                      customCategories:
                                          _customCategories),
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // List Barang
          filtered.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: const BoxDecoration(
                              color: Color(0xFFEEEEEA),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.inbox_rounded,
                              size: 32, color: Color(0xFFCCCCC8)),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showFavoritesOnly
                              ? 'Belum ada barang favorit.'
                              : 'Tidak ada barang ditemukan.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFB8B8B4),
                              height: 1.6),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _ItemCard(
                        item: filtered[i],
                        index: i,
                        customCategories: _customCategories,
                        onFavoriteToggle: () =>
                            _toggleFavorite(filtered[i]),
                        onEdit: () => _showEditDialog(filtered[i]),
                        onDelete: () => _confirmDelete(filtered[i]),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                ),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: const Color(0xFFF4F4F2),
        elevation: 2,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text('Tambah Barang',
            style:
                TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// Widget Kartu Item 

class _ItemCard extends StatefulWidget {
  final ItemModel item;
  final int index;
  final List<CustomCategory> customCategories;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ItemCard({
    required this.item,
    required this.index,
    required this.customCategories,
    required this.onFavoriteToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<_ItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260 + widget.index * 35),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final color =
        categoryColor(item.category, customCategories: widget.customCategories);
    final bg =
        categoryBg(item.category, customCategories: widget.customCategories);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(13)),
                        child: Icon(categoryIcon(item.category),
                            color: color, size: 22),
                      ),
                      Positioned(
                        top: -4,
                        left: -4,
                        child: GestureDetector(
                          onTap: widget.onFavoriteToggle,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle),
                            child: Icon(
                              item.isFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 18,
                              color: const Color(0xFFF5C518),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 3),
                        Text(item.description,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF888884)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius:
                                      BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  Icon(categoryIcon(item.category),
                                      size: 10, color: color),
                                  const SizedBox(width: 4),
                                  Text(item.category,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: color,
                                          fontWeight:
                                              FontWeight.w500)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('#${item.id}',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFD0D0CC))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: widget.onEdit,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F1FB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              size: 14, color: Color(0xFF4B8FD4)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: widget.onDelete,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE83A2C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.delete_rounded,
                                  size: 13, color: Colors.white),
                              SizedBox(width: 2),
                              Text('Hapus',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable Dialog (Untuk Tambah & Edit)

class _ItemDialog extends StatefulWidget {
  final String title;
  final IconData icon;
  final TextEditingController nameController;
  final TextEditingController descController;
  final String selectedCategory;
  final List<String> allCategories;
  final List<CustomCategory> customCategories;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onConfirm;
  final String confirmLabel;
  final VoidCallback onCancel;

  const _ItemDialog({
    required this.title,
    required this.icon,
    required this.nameController,
    required this.descController,
    required this.selectedCategory,
    required this.allCategories,
    required this.customCategories,
    required this.onCategoryChanged,
    required this.onConfirm,
    required this.confirmLabel,
    required this.onCancel,
  });

  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  late String _localCategory;

  @override
  void initState() {
    super.initState();
    _localCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF0F0EC),
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(widget.icon,
                        color: const Color(0xFF1A1A1A), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A))),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Nama Barang',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A))),
              const SizedBox(height: 6),
              TextField(
                controller: widget.nameController,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF1A1A1A)),
                decoration: const InputDecoration(
                    hintText: 'Masukkan nama barang...'),
              ),
              const SizedBox(height: 16),
              const Text('Deskripsi',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A))),
              const SizedBox(height: 6),
              TextField(
                controller: widget.descController,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF1A1A1A)),
                decoration: const InputDecoration(
                    hintText: 'Masukkan deskripsi barang...'),
              ),
              const SizedBox(height: 16),
              const Text('Kategori',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A))),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFFE8E8E4))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _localCategory,
                    isExpanded: true,
                    icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF888884)),
                    items: widget.allCategories.map((String value) {
                      final color = categoryColor(value,
                          customCategories: widget.customCategories);
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(categoryIcon(value),
                                size: 16, color: color),
                            const SizedBox(width: 8),
                            Text(value,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A))),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => _localCategory = newValue!);
                      widget.onCategoryChanged(newValue);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF888884),
                        side: const BorderSide(
                            color: Color(0xFFE8E8E4)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(widget.confirmLabel,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}