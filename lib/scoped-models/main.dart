import 'package:scoped_model/scoped_model.dart';

import './SigninModel.dart';
import 'BaljuModel.dart';
import 'sujuModel.dart';

class MainModel extends Model
    with AuthUserModel, SigninModel, UtilityModel, BaljuModel, SujuModel {}
