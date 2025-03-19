import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create a Popup Manager class
class PopupManager {
  static const String LAST_SHOWN_KEY = 'last_popup_shown';
  static const int INTERVAL_HOURS = 24;

  static Future<bool> shouldShowPopup() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getInt(LAST_SHOWN_KEY);

    if (lastShown == null) return true;

    final now = DateTime.now();
    final lastShownDate = DateTime.fromMillisecondsSinceEpoch(lastShown);
    final hoursSinceLastShown = now.difference(lastShownDate).inHours;

    return hoursSinceLastShown >= INTERVAL_HOURS;
  }

  static Future<void> updateLastShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(LAST_SHOWN_KEY, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<Map<String, dynamic>?> getPopupConfig() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('popups')
          .doc('daily_popup_config')
          .get();

      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error fetching popup config: $e');
      return null;
    }
  }

  static Future<void> showPopupIfNeeded(BuildContext context) async {
    final config = await getPopupConfig();

    if (config == null || !config['isActive'] || !context.mounted) return;

    final shouldShow = await shouldShowPopup();
    if (!shouldShow) return;

    if (context.mounted) {
      _showPopupDialog(context, config['imageUrl']);
      await updateLastShown();
    }
  }

  static void _showPopupDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 200,
                    child: Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
