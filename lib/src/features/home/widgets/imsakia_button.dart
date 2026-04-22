import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ImsakiaButton extends StatelessWidget {
  const ImsakiaButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () => showAdaptiveDialog(
          context: context,
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('إمساكية شهر رمضان 2024'),
              centerTitle: true,
            ),
            body: SfPdfViewer.network(
              'https://firebasestorage.googleapis.com/v0/b/esjod-25748.appspot.com/o/calendar.pdf?alt=media&token=89c627c9-8187-470c-9c43-b77d99493c23',
              onDocumentLoadFailed: (details) {
                debugPrint(details.error);
              },
            ),
          ),
        ),
        child: Material(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(8),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "🌙 إمساكية شهر رمضان",
                  style:
                      theme.textTheme.titleLarge!.copyWith(color: whiteColor),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: whiteColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
