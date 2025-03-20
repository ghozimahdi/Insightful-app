import 'package:injectable/injectable.dart';

import '../../domain/models/daily_summary_model.dart';
import '../../domain/models/geo_fence_summary.dart';
import '../../domain/repository/repository.dart';
import '../data_sources/local_data_source.dart';
import '../mappers/daily_summary_model_mapper.dart';
import '../mappers/daily_summary_object_mapper.dart';
import '../mappers/geo_fence_summary_data_mapper.dart';

@LazySingleton(as: Repository)
class RepositoryImpl extends Repository {
  final LocalDataSource localDataSource;
  final GeoFenceSummaryDataMapper geoFenceSummaryDataMapper;
  final DailySummaryObjectMapper dailySummaryObjectMapper;
  final DailySummaryModelMapper dailySummaryModelMapper;

  RepositoryImpl(
    this.localDataSource,
    this.geoFenceSummaryDataMapper,
    this.dailySummaryObjectMapper,
    this.dailySummaryModelMapper,
  );

  @override
  void clearData() {
    localDataSource.clearData();
  }

  @override
  Future<void> addDailySummary(GeoFenceSummary model) {
    final data = geoFenceSummaryDataMapper.mapFromDomain(model);
    final dataObject = dailySummaryObjectMapper.mapFromDomain(data);
    return localDataSource.addDailySummary(dataObject);
  }

  @override
  Future<List<DailySummaryModel>> getDailySummaries() async {
    final dailySummaries = await localDataSource.getDailySummaries();
    return dailySummaries
        .map((e) => dailySummaryModelMapper.mapFromObject(e))
        .toList();
  }
}
