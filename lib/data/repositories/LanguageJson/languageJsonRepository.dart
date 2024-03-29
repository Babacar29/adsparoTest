// ignore_for_file: file_names
import '../../../utils/api.dart';
import 'languageJsonRemoteDataRepo.dart';

class LanguageJsonRepository {
  static final LanguageJsonRepository _languageRepository = LanguageJsonRepository._internal();

  late LanguageJsonRemoteDataSource _languageRemoteDataSource;

  factory LanguageJsonRepository() {
    _languageRepository._languageRemoteDataSource = LanguageJsonRemoteDataSource();
    return _languageRepository;
  }

  LanguageJsonRepository._internal();

  Future<dynamic> getLanguageJson({required String lanCode}) async {
    try {
      //final result = await _languageRemoteDataSource.getLanguageJson(lanCode: lanCode);
      return {};
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<Map<dynamic, dynamic>> fetchLanguageLabels(String langCode) async {
      Map<dynamic, dynamic> languageLabelsJson = {};
      /*await getLanguageJson(lanCode: langCode).then((value) async {
        languageLabelsJson = value as Map<dynamic, dynamic>; //result;
      });*/
      return languageLabelsJson;

  }
}
