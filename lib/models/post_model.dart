class PostModel {
  final String id;
  final String author;
  final String avatarSeed;
  final String? level;
  final String time;
  final String tag;
  final String content;
  final String? imageUrl;
  final dynamic likes;
  final int comments;
  final String type; // 'normal' or 'text'
  bool isLiked;
  bool isBookmarked;

  PostModel({
    required this.id,
    required this.author,
    required this.avatarSeed,
    this.level,
    required this.time,
    required this.tag,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.type,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  String get likesDisplay {
    if (likes is String) return likes as String;
    final n = likes as int;
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  int get likesCount {
    if (likes is String) {
      final s = (likes as String).replaceAll('k', '');
      return (double.tryParse(s) ?? 0 * 1000).toInt();
    }
    return likes as int;
  }
}

final List<PostModel> kFeedData = [
  PostModel(
    id: 'p_4829173',
    author: '猫耳控2046',
    avatarSeed: 'NekoMimi',
    level: 'Lv.4',
    time: '7分钟前',
    tag: '胶片日常',
    content: '周末去看了宫崎骏展，买到了想要的周边。天气不错 🍃 就是人有点多，排队排了快一小时',
    imageUrl: 'https://picsum.photos/id/250/600/400',
    likes: 187,
    comments: 29,
    type: 'normal',
  ),
  PostModel(
    id: 'p_7731042',
    author: '星野kiraa',
    avatarSeed: 'Kira',
    level: 'Lv.6',
    time: '43分钟前',
    tag: 'OOTD分享',
    content: 'CP漫展穿搭，地雷系。人超多累死了但还是很开心！谷子也收到了 🎀 下次还去',
    imageUrl: 'https://picsum.photos/id/1059/600/400',
    likes: '1.1k',
    comments: 76,
    type: 'normal',
  ),
  PostModel(
    id: 'p_2938401',
    author: '匿名树洞',
    avatarSeed: 'Tree',
    time: '1小时23分钟前',
    tag: '树洞',
    content: '二次元真的是我的避难所。白天工作太累了，只有晚上玩游戏才能活过来。有没有人懂这种感觉',
    likes: '2.8k',
    comments: 387,
    type: 'text',
  ),
  PostModel(
    id: 'p_5510293',
    author: '像素猎手',
    avatarSeed: 'Pixel',
    level: 'Lv.5',
    time: '2小时17分钟前',
    tag: '主机游民',
    content: '装甲核心6终于打通了！！有人一起打PVP吗，我的机体配色是全黑+红色高光',
    imageUrl: 'https://picsum.photos/id/354/600/400',
    likes: 463,
    comments: 91,
    type: 'normal',
  ),
  PostModel(
    id: 'p_8820174',
    author: '抚子酱',
    avatarSeed: 'Nadeko',
    time: '2小时51分钟前',
    tag: '圣地巡礼',
    content: '终于来下北泽了！感觉随时能遇到波奇酱哈哈，晚上去LIVE HOUSE喝一杯🍺',
    imageUrl: 'https://picsum.photos/id/453/600/400',
    likes: 934,
    comments: 58,
    type: 'normal',
  ),
  PostModel(
    id: 'p_3341829',
    author: 'GR3摄影党',
    avatarSeed: 'Cyber',
    level: 'Lv.3',
    time: '3小时44分钟前',
    tag: '街头摄影',
    content: '雨后随手拍的，理光GR3直出。霓虹灯倒影感觉还不错，就是对焦有点慢',
    imageUrl: 'https://picsum.photos/id/765/600/400',
    likes: 521,
    comments: 19,
    type: 'normal',
  ),
  PostModel(
    id: 'p_9912038',
    author: '凌晨三点',
    avatarSeed: 'Night',
    time: '4小时09分钟前',
    tag: '碎碎念',
    content: '凌晨3点全家便利店，买了关东煮。耳机里放着Secret Base，一个人在城市里也还好',
    likes: 743,
    comments: 98,
    type: 'text',
  ),
  PostModel(
    id: 'p_6628401',
    author: '谷子收纳控',
    avatarSeed: 'Bag',
    level: 'Lv.8',
    time: '5小时33分钟前',
    tag: '痛包展示',
    content: '新扎的痛包！排了两天阵，带去见推了。大家觉得这个配色怎么样？感觉有点乱',
    imageUrl: 'https://picsum.photos/id/1060/600/400',
    likes: 389,
    comments: 41,
    type: 'normal',
  ),
  PostModel(
    id: 'p_1147293',
    author: '富士胶片控',
    avatarSeed: 'Camera',
    time: '6小时22分钟前',
    tag: '器材党',
    content: '入了二手富士，直出色彩确实有点毒。就是溢价太严重了，心疼',
    imageUrl: 'https://picsum.photos/id/435/600/400',
    likes: 312,
    comments: 54,
    type: 'normal',
  ),
  PostModel(
    id: 'p_4403817',
    author: '老宅一枚',
    avatarSeed: 'Old',
    time: '7小时48分钟前',
    tag: '随想',
    content: '现在看番越来越没耐心了，是不是老了？以前能一口气补完几十集，现在看十分钟就想快进',
    likes: '1.1k',
    comments: 231,
    type: 'text',
  ),
  PostModel(
    id: 'p_7729034',
    author: '动森岛主',
    avatarSeed: 'Island',
    level: 'Lv.2',
    time: '9小时15分钟前',
    tag: '动森日记',
    content: '重新打开了吃灰两年的动森，小动物们还在等我，还给我留了信。有点感动',
    imageUrl: 'https://picsum.photos/id/100/600/400',
    likes: '2.9k',
    comments: 198,
    type: 'normal',
  ),
  PostModel(
    id: 'p_3318204',
    author: '追星星的人',
    avatarSeed: 'Star',
    time: '11小时03分钟前',
    tag: '摄影',
    content: '川西拍的星空，流星划过那一刻真的很震撼。新海诚的画面大概就是这样吧',
    imageUrl: 'https://picsum.photos/id/532/600/400',
    likes: '1.6k',
    comments: 87,
    type: 'normal',
  ),
  PostModel(
    id: 'p_8841029',
    author: '芙莉莲粉',
    avatarSeed: 'Elf',
    level: 'Lv.7',
    time: '14小时37分钟前',
    tag: '绘图分享',
    content: '摸鱼画了辛美尔和芙莉莲，意难平。"只是相处了短短十年"这句话真的太难受了',
    imageUrl: 'https://picsum.photos/id/104/600/400',
    likes: '4.8k',
    comments: 376,
    type: 'normal',
  ),
  PostModel(
    id: 'p_2209183',
    author: 'V家老粉',
    avatarSeed: 'Miku',
    time: '17小时22分钟前',
    tag: '音乐',
    content: '睡不着，单曲循环深海少女。V家的老歌真的百听不厌，承载了太多回忆了',
    likes: '2.1k',
    comments: 163,
    type: 'text',
  ),
  PostModel(
    id: 'p_5530847',
    author: '电锯人出没',
    avatarSeed: 'Dog',
    level: 'Lv.9',
    time: '21小时14分钟前',
    tag: 'Cosplay',
    content: '漫展出了电锯人，累但开心。认识了好多同好，下次还去',
    imageUrl: 'https://picsum.photos/id/1012/600/400',
    likes: '7.3k',
    comments: 812,
    type: 'normal',
  ),
];
