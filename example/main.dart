import 'dart:async';

import 'package:resultex/lib/error_handler.dart';

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  @override
  String toString() => 'User(id: $id, name: "$name")';
}

// =========================================================================
// ۲.ResultExecutor در Clean Architecture)
// =========================================================================
class UserRepository {
  // استفاده از گتر استاتیک و شیک پکیج بدون نیاز به فراخوانی مستقیم GetIt
  final _executor = ErrorHandler.executor;

  Future<Result<User>> getUserProfile(int id) async {
    return _executor.executeAsync(
      () async {
        await Future.delayed(const Duration(milliseconds: 200));
        return User(id: id, name: "Hassan Ghasemzadeh");
      },
      context: 'UserRepository.getUserProfile($id)',
    );
  }

  Future<Result<User>> getRequiredConfiguration() async {
    return _executor.executeAsync(
      () async {
        await Future.delayed(const Duration(milliseconds: 200));
        throw TimeoutException('Remote database failed to respond in time.');
      },
      context: 'UserRepository.getRequiredConfiguration',
    );
  }
}

// =========================================================================
// ۳.(Main Execution)
// =========================================================================
void main() async {
  print('=== [مرحله ۱]: راه‌اندازی و کانفیگ وابستگی‌ها ===\n');

  await ErrorHandler().init();

  print('\n=== [مرحله ۲]: اجرای سناریوهای لایه دیتا (Result Pattern) ===\n');

  final repository = UserRepository();

  // -------------------------------------------------------------
  // سناریو اول: دریافت داده موفق و استفاده از متد فولد (Fold)
  // -------------------------------------------------------------
  final Result<User> successResult = await repository.getUserProfile(10);

  successResult.fold(
    onSuccess: (user) => print('➔ نتیجه مثبت در UI: خوش‌آمدی ${user.name}'),
    onFailure: (failure) => print('➔ نتیجه منفی در UI: ${failure.message}'),
  );

  print('\n-------------------------------------------------------------');

  // -------------------------------------------------------------
  //(map و getOrElse)
  // -------------------------------------------------------------

  final Result<User> result = await repository.getRequiredConfiguration();
  print('--- درخواست سوم (تبدیل داده و مکانیزم Fallback): ---');

  final upperCaseNameResult =
      successResult.map((user) => user.name.toUpperCase());
  print('➔ تبدیل نام با متد map: ${upperCaseNameResult.valueOrNull}');

  final fallbackUser = result.getOrElse(User(id: 0, name: "کاربر مهمان"));
  print('➔ استفاده از مقدار پیش‌فرض با getOrElse: $fallbackUser');

  print('\n=== اجرای مثال پکیج با موفقیت به پایان رسید ===');
}
