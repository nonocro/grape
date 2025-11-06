import 'package:flutter/material.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/services/ai.dart';
import 'package:grape/models/wine_details.dart';


class WineDetailsPage extends StatefulWidget {
  final Wine wine;

  const WineDetailsPage({super.key, required this.wine});

  @override
  State<WineDetailsPage> createState() => _WineDetailsPageState();
}

class _WineDetailsPageState extends State<WineDetailsPage> {
  late Future<WineDetails> _wineDetails;

  @override
  void initState() {
    super.initState();
    _wineDetails = getWineDetails(widget.wine.name);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColorsExtension>();
    final bgColor = theme?.accentColor ?? const Color(0xFFFF8A80);

    final locationParts = widget.wine.location.split('\n·\n');
    final country = locationParts.isNotEmpty ? locationParts[0].trim() : '';
    final region = locationParts.length > 1 ? locationParts[1].trim() : '';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<WineDetails>(
        future: _wineDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                width: 180,
                child: const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.white24,
                ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<int>(
                stream: Stream.periodic(const Duration(milliseconds: 500), (i) => (i % 3) + 1),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 1;
                  final dots = List.generate(count, (_) => '.').join();
                  return Text(
                  'Nous récoltons les raisins$dots',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  );
                },
                ),
              ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur lors du chargement des détails',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Aucune donnée disponible',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final details = snapshot.data!;

          return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.wine.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Center(
                    child: Image.network(
                      widget.wine.image,
                      height: 280,
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Vol',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      details.servingTemperature,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Alc',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      details.alcoolPercentage,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Grape',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            details.grapeVariety,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Region',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            country.isNotEmpty && region.isNotEmpty
                                ? '$country, $region'
                                : widget.wine.location.replaceAll('\n·\n', ', '),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            details.description,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Accords mets-vins',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            details.foodPairings,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Potentiel de garde',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            details.agingPotential,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
        },
      ),
    );
  }
}
