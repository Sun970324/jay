import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/features/postings/models/filter_model.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostingRepository {
  final SupabaseClient postingsClient = Supabase.instance.client;

  Future<List<PostingModel>> getPostings({
    FilterModel? filter,
    String? queryText,
    int offset = 0,
  }) async {
    final params = <String, dynamic>{
      'p_query_text': (queryText?.isNotEmpty == true) ? queryText : null,
      'p_disease': (filter != null && filter.disease.isNotEmpty)
          ? filter.disease.map(int.parse).toList()
          : null,
      'p_province': (filter != null && filter.location.provinceName.isNotEmpty)
          ? filter.location.provinceName
          : null,
      'p_city': (filter != null && filter.location.cityName.isNotEmpty)
          ? filter.location.cityName
          : null,
      'p_birth_year': filter?.birth?.year,
      // 'p_is_disability': (filter?.isDisability == true) ? true : null,
      // 'p_is_rare_disease': (filter?.isRareDisease == true) ? true : null,
      // 'p_is_life_prevention': (filter?.isLifePrevention == true) ? true : null,
      'p_income_rate': filter?.incomeRate ?? 0,
      'p_offset': offset,
      'p_limit': 10,
    };

    final response =
        await postingsClient.rpc('search_postings', params: params);

    final result = (response as List).map(
        (posting) => PostingModel.fromMap(posting as Map<String, dynamic>));
    return result.toList();
  }

  Future<PostingModel?> getPostingById(int id) async {
    final response = await postingsClient
        .from('postings')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return PostingModel.fromMap(response);
  }
}

final postingRepo = Provider<PostingRepository>((ref) => PostingRepository());
