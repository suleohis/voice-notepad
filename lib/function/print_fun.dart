import 'package:logger/logger.dart';

var logger = Logger();

printError(dynamic data) {
    logger.e(data);
}

printInfo(dynamic data) {
    logger.i(data);
}

printWarning(dynamic data) {
    logger.w(data);
}