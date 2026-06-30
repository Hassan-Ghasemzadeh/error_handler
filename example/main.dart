import 'dart:async';

import 'package:resultex/lib/error_handler.dart';

/// مدل داده برای نمایش در مثال
class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  @override
  String toString() => 'User(id: $id, name: "$name")';
}

// =========================================================================
// ۲. لایه ریپازیتوری (نحوه استفاده از ResultExecutor در Clean Architecture)
// =========================================================================
class UserRepository {
  // استفاده از گتر استاتیک و شیک پکیج بدون نیاز به فراخوانی مستقیم GetIt
  final _executor = ErrorHandler.executor;

  /// متدی که داده‌ها را با موفقیت شبیه‌سازی می‌کند
  Future<Result<User>> getUserProfile(int id) async {
    return _executor.executeAsync(
      () async {
        await Future.delayed(const Duration(milliseconds: 200));
        return User(id: id, name: "Hassan Ghasemzadeh");
      },
      context: 'UserRepository.getUserProfile($id)',
    );
  }

  /// متدی که عمداً با اکسپشن مواجه می‌شود تا هندلینگ پکیج را نشان دهد
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
// ۳. نقطه شروع برنامه (Main Execution)
// =========================================================================
void main() async {
  print('=== [مرحله ۱]: راه‌اندازی و کانفیگ وابستگی‌ها ===\n');

  ErrorHandler().init();

  print('\n=== [مرحله ۲]: اجرای سناریوهای لایه دیتا (Result Pattern) ===\n');

  final repository = UserRepository();

  // -------------------------------------------------------------
  // سناریو اول: دریافت داده موفق و استفاده از متد فولد (Fold)
  // -------------------------------------------------------------
  print('--- درخواست اول (سناریوی موفقیت‌آمیز): ---');
  final Result<User> successResult = await repository.getUserProfile(10);

  successResult.fold(
    onSuccess: (user) => print('➔ نتیجه مثبت در UI: خوش‌آمدی ${user.name}'),
    onFailure: (failure) => print('➔ نتیجه منفی در UI: ${failure.message}'),
  );

  print('\n-------------------------------------------------------------');

  // -------------------------------------------------------------
  // سناریو دوم: بروز خطا و استفاده از Dart 3 Pattern Matching
  // -------------------------------------------------------------
  print('--- درخواست دوم (سناریوی شکست و مپ خودکار خطا): ---');
  final Result<User> failureResult =
      await repository.getRequiredConfiguration();

  // استفاده از قابلیت فوق‌العاده Sealed Class پکیج شما با ساختار سوئیچ دارت ۳
  switch (failureResult) {
    case SuccessResult<User>(value: final user):
      print('➔ موفقیت غیرمنتظره: $user');
    case FailureResult<User>(failure: final failure):
      print('➔ مدیریت ایمن خطا در بلاک کنترلر:');
      print('   🔹 پیام خطا: ${failure.message}');
      print('   🔹 نوع آبجکت خطا: ${failure.error.runtimeType}');
  }

  print('\n-------------------------------------------------------------');

  // -------------------------------------------------------------
  // سناریو سوم: استفاده از ابزارهای مونیادیک (map و getOrElse)
  // -------------------------------------------------------------
  print('--- درخواست سوم (تبدیل داده و مکانیزم Fallback): ---');

  // ۱. مپ کردن داده درون باکس بدون باز کردن آن
  final upperCaseNameResult =
      successResult.map((user) => user.name.toUpperCase());
  print('➔ تبدیل نام با متد map: ${upperCaseNameResult.valueOrNull}');

  // ۲. استفاده از داده پیش‌فرض در صورت رخ دادن خطا
  final fallbackUser =
      failureResult.getOrElse(User(id: 0, name: "کاربر مهمان"));
  print('➔ استفاده از مقدار پیش‌فرض با getOrElse: $fallbackUser');

  print('\n=== اجرای مثال پکیج با موفقیت به پایان رسید ===');
}
