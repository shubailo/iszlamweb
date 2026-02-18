import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/bento_item.dart';

class BentoTile extends StatefulWidget {
  final BentoItem item;
  final bool isLarge;

  const BentoTile({
    super.key, 
    required this.item,
    this.isLarge = false,
  });

  @override
  State<BentoTile> createState() => _BentoTileState();
}

class _BentoTileState extends State<BentoTile> {
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          height: _isExpanded ? 300 : (widget.isLarge ? 240 : 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered 
                  ? GardenPalette.leafyGreen.withAlpha(100) 
                  : GardenPalette.white.withAlpha(20),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: GardenPalette.white.withAlpha(_isHovered ? 20 : 5),
                blurRadius: _isHovered ? 20 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // Geometric Background Pattern (Triangle)
                Positioned(
                  right: -40,
                  top: -40,
                  child: Transform.rotate(
                    angle: 0.5,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: (widget.item.category == 'event' 
                            ? GardenPalette.leafyGreen 
                            : GardenPalette.leafyGreen).withAlpha(15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header: Icon + Category
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (widget.item.category == 'event' 
                                  ? GardenPalette.leafyGreen 
                                  : GardenPalette.leafyGreen).withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.item.category == 'event' 
                                  ? Icons.event 
                                  : Icons.newspaper, 
                              size: 16,
                              color: widget.item.category == 'event' 
                                  ? GardenPalette.leafyGreen 
                                  : GardenPalette.leafyGreen,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.item.category.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: GardenPalette.white.withAlpha(150),
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),

                      // Title
                      Text(
                        widget.item.title,
                        maxLines: _isExpanded ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: widget.isLarge ? 22 : 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: GardenPalette.white,
                        ),
                      ),

                      // Animated Description Reveal
                      AnimatedCrossFade(
                        firstChild: const SizedBox(width: double.infinity), // Empty when collapsed
                        secondChild: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40, 
                                height: 2, 
                                color: GardenPalette.leafyGreen.withAlpha(50)
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.item.description,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: GardenPalette.white.withAlpha(200),
                                ),
                              ),
                              if (widget.item.date != null) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14, color: GardenPalette.darkGrey),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.item.date!.month}/${widget.item.date!.day}', // Simple date format
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: GardenPalette.darkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        crossFadeState: _isExpanded 
                            ? CrossFadeState.showSecond 
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                      ),

                      // "More" Indicator if not expanded
                      if (!_isExpanded) ...[
                        const SizedBox(height: 12),
                        const Icon(
                          Icons.keyboard_arrow_down, 
                          color: GardenPalette.darkGrey, 
                          size: 20
                        ).animate().fadeIn(delay: 200.ms),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
