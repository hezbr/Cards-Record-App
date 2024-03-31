import 'package:get/get.dart';
import '../../controllers/batches_controller.dart';
import '../../controllers/categories_controller.dart';

import '../../controllers/add_batch_controller.dart';
import '../../controllers/distributors_controller.dart';
import '../../controllers/installment_controller.dart';
import '../../controllers/operations_controller.dart';

class BindingAll extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AddBatchController(), fenix: true);
    Get.lazyPut(() => CategoriesController(), fenix: true);
    Get.lazyPut(() => OperationsController(), fenix: true);
    Get.lazyPut(() => DistributorsController(), fenix: true);
    Get.lazyPut(() => InstallmentController(), fenix: true);
     Get.lazyPut(() => BatchesController(), fenix: true);
  }

}