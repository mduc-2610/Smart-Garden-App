
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_garden_app/features/garden/models/Dht11.dart';
import 'package:smart_garden_app/features/garden/models/Light.dart';
import 'package:smart_garden_app/features/garden/models/Moisture.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';

Future<String> getLocalIpAddress() async {
  try {
    final interfaces = await NetworkInterface.list(
      includeLinkLocal: false,
      type: InternetAddressType.IPv4,
    );

    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.address.startsWith('192.168.')) {
          return addr.address;
        }
      }
    }
  } catch (e) {
    print('Error getting IP address: $e');
  }

  return '127.0.0.1';

}

class Constant {
  static const String ESP32_IP_KEY = 'esp32_ip';

}

class APIConstant {
  // static const String ip = "192.168.1.71";
  static const String ip = "192.168.0.104";
  static const String esp32Ip = "192.168.209.161";
  static const String tSecretAPIKey = "";
  // static const baseUrl = 'http://10.0.2.2:8000/api';
  // static const baseUrl = 'http://192.168.1.8:8000/api'; // VANSAU
  // static const baseUrl = 'http://192.168.1.5:8000/api'; // VANSAU
  // static const baseUrl = 'http://192.168.0.103:8000/api'; // Tenda
  static const baseUrl = 'http://$ip:8000/api'; // Minh Duc 5g
  static const String baseEsp32Url = "http://$esp32Ip/api/esp";
  static const String baseCSUrl = "https://8zdnvn-3000.csb.app/api";
  // static const String baseCSUrl = 'http://$ip:3000/api';
  static const baseSocketUrl = 'ws://${APIConstant.ip}:8000/ws';

  // static Future<String> get ip async => await getLocalIpAddress();
  // static const String tSecretAPIKey = "";
  //
  // static Future<String> get baseUrl async => 'http://${await ip}:8000/api';
  // static Future<String> get baseSocketUrl async => 'ws://${await ip}:8000/ws';

  static String? getSocketEndpointFor<T>() {
    switch(T) {
      default:
        return 'order';
    }
  }

  static Future<String> buildBaseEsp32Url() async {
    final prefs = await SharedPreferences.getInstance();
    return "http://${prefs.getString(Constant.ESP32_IP_KEY) ?? "192.168.209.161"}/api/esp";
  }

  static String? getEndpointFor<T>() {
    switch (T) {
      case Dht11:
        return 'dht11';
      case Light:
        return 'light';
      case Plant:
        return 'plant';
      case Moisture:
        return 'moisture';
      default:
        return 'valve';
      ///AUTHENTICATION
      // case LoginPassword:
      //   return 'account/user/login-password';
      // case SendOTP:
      //   return 'account/user/send-otp';
      // case SetPassword:
      //   return 'account/user/set-password';
      // case Token:
      //   return 'account/user/token';
      // case VerifyOTP:
      //   return 'account/user/verify-otp';
      //
      // ///USER
      // case User:
      //   return 'account/user';
      // case UserProfile:
      //   return 'account/profile';
      // case UserSetting:
      //   return 'account/setting';
      // case UserSecuritySetting:
      //   return 'account/security-setting';
      // case UserLocation:
      //   return 'account/user-location';
      // case Me:
      //   return 'account/user/me';
      //
      // ///RESTAURANT
      // case Restaurant:
      //   return 'restaurant/restaurant';
      // case RestaurantBasicInfo:
      //   return 'restaurant/basic-info';
      // case RestaurantDetailInfo:
      //   return 'restaurant/detail-info';
      // case RestaurantMenuDelivery:
      //   return 'restaurant/menu-delivery';
      // case RestaurantOperatingHour:
      //   return 'restaurant/operating-hour';
      // case RestaurantRepresentativeInfo:
      //   return 'restaurant/representative';
      // case RestaurantPaymentInfo:
      //   return 'restaurant/payment-info';
      // case RestaurantLike:
      //   return 'restaurant/restaurant-like';
      //
      // ///DELIVERER
      // case Deliverer:
      //   return 'deliverer/deliverer';
      // case DelivererAddress:
      //   return 'deliverer/address';
      // case DelivererBasicInfo:
      //   return 'deliverer/basic-info';
      // case DelivererDriverLicense:
      //   return 'deliverer/driver-license';
      // case DelivererEmergencyContact:
      //   return 'deliverer/emergency-contact';
      // case DelivererOperationInfo:
      //   return 'deliverer/operation-info';
      // case DelivererOtherInfo:
      //   return 'deliverer/other-info';
      // case DelivererResidencyInfo:
      //   return 'deliverer/residency-info';
      //
      //   ///NOTIFICATION
      // case DirectMessage:
      //   return 'notification/direct-message';
      // case GroupMessage:
      //   return 'notification/group-message';
      // case DirectRoom:
      //   return 'notification/direct-room';
      // case GroupRoom:
      //   return 'notification/group-room';
      // case Notification:
      //   return 'notification/notification';
      // case UserNotification:
      //   return 'notification/user-notification';
      //
      // ///REVIEW
      // case DishReview:
      //   return 'review/dish-review';
      // case DelivererReview:
      //   return 'review/deliverer-review';
      // case RestaurantReview:
      //   return 'review/restaurant-review';
      // case DeliveryReview:
      //   return 'review/delivery-review';
      // case DishReviewReply:
      //   return 'review/dish-review-reply';
      // case DelivererReviewReply:
      //   return 'review/deliverer-review-reply';
      // case RestaurantReviewReply:
      //   return 'review/restaurant-review-reply';
      // case DeliveryReviewReply:
      //   return 'review/delivery-review-reply';
      // case DishReviewLike:
      //   return 'review/dish-review-like';
      // case DishReviewLike:
      //   return 'review/dish-review-like';
      // case RestaurantReviewLike:
      //   return 'review/restaurant-review-like';
      // case DelivererReviewLike:
      //   return 'review/deliverer-review-like';
      // case DeliveryReviewLike:
      //   return 'review/delivery-review-like';
      //
      // ///ORDER
      // case RestaurantCart:
      //   return 'order/restaurant-cart';
      // case RestaurantCartDish:
      //   return 'order/restaurant-cart-dish';
      // case Delivery:
      //   return 'order/delivery';
      // case Order:
      //   return 'order/order';
      // case OrderCancellation:
      //   return 'order/order-cancellation';
      // // case OrderPromotion:
      // //   return 'order/order-promotion';
      // case RestaurantPromotion:
      //   return 'order/restaurant-promotion';
      // // case UserPromotion:
      // //   return 'order/user-promotion';
      // // case Promotion:
      // //   return 'order/promotion';
      // // case ActivityPromotion:
      // //   return 'order/activity-promotion';
      //
      // ///SOCIAL
      // case Post:
      //   return 'social/post';
      // case PostLike:
      //   return 'social/post-like';
      // case PostImage:
      //   return 'social/post-image';
      // case Comment:
      //   return 'social/comment';
      // case CommentLike:
      //   return 'social/comment-like';
      // case CommentImage:
      //   return 'social/comment-image';
      //
      // ///FOOD
      // case DishOption:
      //   return 'food/dish-option';
      // case DishOptionItem:
      //   return 'food/dish-option-item';
      // case DishCategory:
      //   return 'food/dish-category';
      // case DishLike:
      //   return 'food/dish-like';
      // case Dish:
      //   return 'food/dish';
      // case DishImage:
      //   return 'food/dish-image';
      // case Weather:
      //   return 'food/weather';
      // default:
      //   return null;
    }
  }
}
