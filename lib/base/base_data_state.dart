import 'package:stockbuddy_flutter_app/base/base_response_data.dart';
import 'package:stockbuddy_flutter_app/base/base_ui_state.dart';

class BaseDataState extends BaseUiState<BaseResponseData> {
  BaseDataState.loading() : super.loading();

  BaseDataState.completed(BaseResponseData data) : super.completed(data: data);

  BaseDataState.error(super.error) : super.error();
}
