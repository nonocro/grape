import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/components/homepage/big_wine_card.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/providers/wine_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Wine> _filteredWines = [];
  AppColorsExtension? _theme;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context).extension<AppColorsExtension>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterWines(String query, List<Wine> allWines) {
    setState(() {
      if (query.isEmpty) {
        _filteredWines = allWines;
      } else {
        _filteredWines = allWines.where((wine) {
          final nameLower = wine.name.toLowerCase();
          final wineryLower = wine.winery.toLowerCase();
          final locationLower = wine.location.toLowerCase();
          final searchLower = query.toLowerCase();
          
          return nameLower.contains(searchLower) ||
                 wineryLower.contains(searchLower) ||
                 locationLower.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _theme?.backgroundColor ?? Colors.white;
    final winesAsync = ref.watch(wineListProvider);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: _theme?.accentColor ?? Colors.black26,
        elevation: 0,
        title: const Text(
          'Rechercher',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: winesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (allWines) {
          if (_filteredWines.isEmpty && _searchController.text.isEmpty) {
            _filteredWines = allWines.length > 14 
              ? allWines.sublist(0, 14) 
              : allWines;
          } else if (_filteredWines.length > 14) {
            _filteredWines = _filteredWines.length > 14 
              ? _filteredWines.sublist(0, 14) 
              : allWines;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) => _filterWines(query, allWines),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un vin...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterWines('', allWines);
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              Expanded(
                child: _filteredWines.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wine_bar_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            Text(
                              'Aucun vin trouvé',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                      child: SizedBox(
                        height: 650,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _filteredWines.length,
                          itemBuilder: (context, index) {
                            final wine = _filteredWines[index];
                            final cardColor = index % 2 == 0
                              ? _theme?.accentColor ?? Colors.amber
                              : _theme?.cardColor ?? Colors.white;
                          final textColor = index % 2 == 0
                              ? Colors.black
                              : Colors.white;
                            return BigWineCard(wine: wine, cardColor: cardColor, textColor: textColor);
                          },
                        ),
                      ),
                    )
              ),
            ],
          );
        },
      ),
    );
  }
}
