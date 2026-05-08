import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 点赞的帖子ID列表
  static List<String> getLikedPosts() {
    return _prefs.getStringList('liked_posts') ?? [];
  }

  static Future<void> toggleLikePost(String postId) async {
    final liked = getLikedPosts();
    if (liked.contains(postId)) {
      liked.remove(postId);
    } else {
      liked.add(postId);
    }
    await _prefs.setStringList('liked_posts', liked);
  }

  static bool isPostLiked(String postId) {
    return getLikedPosts().contains(postId);
  }

  // 收藏的帖子ID列表
  static List<String> getBookmarkedPosts() {
    return _prefs.getStringList('bookmarked_posts') ?? [];
  }

  static Future<void> toggleBookmarkPost(String postId) async {
    final bookmarked = getBookmarkedPosts();
    if (bookmarked.contains(postId)) {
      bookmarked.remove(postId);
    } else {
      bookmarked.add(postId);
    }
    await _prefs.setStringList('bookmarked_posts', bookmarked);
  }

  static bool isPostBookmarked(String postId) {
    return getBookmarkedPosts().contains(postId);
  }

  // 加入的圈子ID列表
  static List<String> getJoinedCircles() {
    return _prefs.getStringList('joined_circles') ?? [];
  }

  static Future<void> toggleJoinCircle(String circleId) async {
    final joined = getJoinedCircles();
    if (joined.contains(circleId)) {
      joined.remove(circleId);
    } else {
      joined.add(circleId);
    }
    await _prefs.setStringList('joined_circles', joined);
  }

  static bool isCircleJoined(String circleId) {
    return getJoinedCircles().contains(circleId);
  }

  // 发送的电波消息
  static List<Map<String, String>> getSentRadios() {
    final jsonList = _prefs.getStringList('sent_radios') ?? [];
    return jsonList.map((json) => Map<String, String>.from(jsonDecode(json))).toList();
  }

  static Future<void> addSentRadio(String content, String time) async {
    final radios = getSentRadios();
    radios.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'sender': 'Anonymous_我',
      'content': content,
      'time': time,
      'isReplied': 'false',
    });
    final jsonList = radios.map((r) => jsonEncode(r)).toList();
    await _prefs.setStringList('sent_radios', jsonList);
  }

  // 通知设置
  static bool getNotificationEnabled() {
    return _prefs.getBool('notification_enabled') ?? true;
  }

  static Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs.setBool('notification_enabled', enabled);
  }

  // 黑名单
  static List<Map<String, String>> getBlacklist() {
    final jsonList = _prefs.getStringList('blacklist') ?? [];
    return jsonList.map((s) => Map<String, String>.from(jsonDecode(s))).toList();
  }

  static Future<void> addToBlacklist(String userId, String userName, String seed) async {
    final list = getBlacklist();
    if (list.any((u) => u['id'] == userId)) return;
    final now = DateTime.now();
    list.add({
      'id': userId,
      'name': userName,
      'seed': seed,
      'time': '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}',
    });
    await _prefs.setStringList('blacklist', list.map((u) => jsonEncode(u)).toList());
  }

  static Future<void> removeFromBlacklist(String userId) async {
    final list = getBlacklist()..removeWhere((u) => u['id'] == userId);
    await _prefs.setStringList('blacklist', list.map((u) => jsonEncode(u)).toList());
  }

  static bool isBlacklisted(String userId) {
    return getBlacklist().any((u) => u['id'] == userId);
  }

  // 用户资料
  static String getNickname() => _prefs.getString('nickname') ?? '友约用户';
  static Future<void> setNickname(String name) => _prefs.setString('nickname', name);

  static String getAvatarSeed() => _prefs.getString('avatar_seed') ?? 'YouYue';
  static Future<void> setAvatarSeed(String seed) => _prefs.setString('avatar_seed', seed);

  static String getBio() => _prefs.getString('bio') ?? '坐标: 银河系';
  static Future<void> setBio(String bio) => _prefs.setString('bio', bio);

  // 登录状态
  static bool isLoggedIn() => _prefs.getBool('is_logged_in') ?? false;
  static Future<void> setLoggedIn(bool v) => _prefs.setBool('is_logged_in', v);

  // 注销账号（清除所有用户数据，保留协议同意记录）
  static Future<void> clearUserData() async {
    await _prefs.remove('nickname');
    await _prefs.remove('avatar_seed');
    await _prefs.remove('bio');
    await _prefs.remove('liked_posts');
    await _prefs.remove('bookmarked_posts');
    await _prefs.remove('joined_circles');
    await _prefs.remove('sent_radios');
    await _prefs.remove('blacklist');
    await _prefs.remove('is_logged_in');
  }
}
