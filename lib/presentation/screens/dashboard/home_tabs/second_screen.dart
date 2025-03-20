import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../gen/colors.gen.dart';
import '../../../../injector.dart';
import '../../../providers/second_screen_provider.dart';
import '../../../util/duration_formatter_mixin.dart';
import '../../../util/extensions/datetime_extensions.dart';
import '../../../util/theme.dart';

class SecondScreen extends StatelessWidget with DurationFormatterMixin {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<SecondScreenProvider>()..getDailySummaries(),
      builder: (context, child) {
        final provider = Provider.of<SecondScreenProvider>(context);

        final groupedData = groupByDate(provider.dailySummaries);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'History',
              style: theme.textTheme.titleMedium,
            ),
            centerTitle: true,
            elevation: 2,
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: groupedData.length,
            itemBuilder: (context, index) {
              final key = groupedData.keys.elementAt(index);
              final items = groupedData[key]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...items.map(
                    (data) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          spacing: 16,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Clock In: ${DateTime.parse(data.clockInTime).time}',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Clock Out: ${DateTime.parse(data.clockOutTime).time}',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Home: ${formatToHourMinute(data.homeSeconds)}',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Office: ${formatToHourMinute(data.officeSeconds)}',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Traveling: ${formatToHourMinute(data.travelingSeconds)}',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
          ),
        );
      },
    );
  }
}
