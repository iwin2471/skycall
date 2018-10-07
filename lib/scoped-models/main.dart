import 'package:scoped_model/scoped_model.dart';

import './SigninModel.dart';
import 'BaljuModel.dart';

class MainModel extends Model
    with AuthUserModel, SigninModel, SignupModel, UtilityModel, BaljuModel {}
