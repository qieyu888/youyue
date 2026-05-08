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
    id: '1',
    author: 'Neko_Mimi',
    avatarSeed: 'NekoMimi',
    level: 'Lv.4',
    time: '10分钟前',
    tag: '胶片日常',
    content: '周末去看了宫崎骏的原画展，买到了心仪的周边。天气真好，光影都很温柔 🍃',
    imageUrl: 'https://picsum.photos/id/250/600/400',
    likes: 245,
    comments: 32,
    type: 'normal',
  ),
  PostModel(
    id: '2',
    author: 'Kira_星',
    avatarSeed: 'Kira',
    level: 'Lv.6',
    time: '1小时前',
    tag: 'OOTD分享',
    content: '今天去 CP 漫展的穿搭，尝试了地雷系风格。人太多了，好累但收到了喜欢的谷子！🎀',
    imageUrl: 'https://picsum.photos/id/1059/600/400',
    likes: '12k',
    comments: 84,
    type: 'normal',
  ),
  PostModel(
    id: '3',
    author: 'Anonymous_树',
    avatarSeed: 'Tree',
    time: '2小时前',
    tag: '树洞',
    content: '有时候觉得，二次元就像一个巨大的逃生舱。白天在公司面对无止境的表格和会议，只有晚上回家打开主机，看到熟悉的登录界面，才会觉得自己短暂地活了过来。',
    likes: '3.4k',
    comments: 420,
    type: 'text',
  ),
  PostModel(
    id: '4',
    author: 'Pixel_Hunter',
    avatarSeed: 'Pixel',
    level: 'Lv.5',
    time: '3小时前',
    tag: '主机游民',
    content: '《装甲核心6》这周目终于打通了！卢比孔的星火真的太浪漫了，附上我的机体配色方案，有人一起交流PVP吗？',
    imageUrl: 'https://picsum.photos/id/354/600/400',
    likes: 512,
    comments: 98,
    type: 'normal',
  ),
  PostModel(
    id: '5',
    author: '千石抚子',
    avatarSeed: 'Nadeko',
    time: '3小时前',
    tag: '圣地巡礼',
    content: '终于来到了下北泽！感觉转角就能遇到波奇酱，晚上去LIVE HOUSE喝一杯🍺。',
    imageUrl: 'https://picsum.photos/id/453/600/400',
    likes: 1024,
    comments: 66,
    type: 'normal',
  ),
  PostModel(
    id: '6',
    author: 'Cyber_Punk',
    avatarSeed: 'Cyber',
    level: 'Lv.3',
    time: '4小时前',
    tag: '街头摄影',
    content: '雨后的赛博朋克感，用理光GR3拍的。霓虹灯的倒影有一种迷幻的数字感。',
    imageUrl: 'https://picsum.photos/id/765/600/400',
    likes: 678,
    comments: 23,
    type: 'normal',
  ),
  PostModel(
    id: '7',
    author: '熬夜冠军',
    avatarSeed: 'Night',
    time: '5小时前',
    tag: '碎碎念',
    content: '凌晨3点的全家便利店，买了一份关东煮。耳机里放着《Secret Base》，突然觉得就算一个人生活在城市里，也能找到属于自己的平静。',
    likes: 890,
    comments: 112,
    type: 'text',
  ),
  PostModel(
    id: '8',
    author: '谷子收纳大师',
    avatarSeed: 'Bag',
    level: 'Lv.8',
    time: '5小时前',
    tag: '痛包展示',
    content: '新扎的痛包！花了两天时间排阵，带着它去见推啦！大家觉得这个配色怎么样？',
    imageUrl: 'https://picsum.photos/id/1060/600/400',
    likes: 456,
    comments: 45,
    type: 'normal',
  ),
  PostModel(
    id: '9',
    author: '复古胶片',
    avatarSeed: 'Camera',
    time: '6小时前',
    tag: '器材党',
    content: '刚入手的二手富士，直出色彩确实有点毒。就是溢价太严重了，心疼钱包。',
    imageUrl: 'https://picsum.photos/id/435/600/400',
    likes: 455,
    comments: 67,
    type: 'normal',
  ),
  PostModel(
    id: '10',
    author: '老二次元',
    avatarSeed: 'Old',
    time: '7小时前',
    tag: '随想',
    content: '发现自己现在看番越来越没耐心了，是不是老了？以前能一口气补完几十集，现在看十分钟就想快进。只剩下玩黄游的耐心了（笑）。',
    likes: '1.2k',
    comments: 256,
    type: 'text',
  ),
  PostModel(
    id: '11',
    author: '岛主A',
    avatarSeed: 'Island',
    level: 'Lv.2',
    time: '8小时前',
    tag: '动森日记',
    content: '重新打开了吃灰两年的动森，发现小动物们还在等我，甚至还给我留了信。眼眶有点热。',
    imageUrl: 'https://picsum.photos/id/100/600/400',
    likes: '3.3k',
    comments: 210,
    type: 'normal',
  ),
  PostModel(
    id: '12',
    author: '追逐星空',
    avatarSeed: 'Star',
    time: '9小时前',
    tag: '摄影',
    content: '去川西拍到了《你的名字》同款的璀璨星空。流星划过的那一刻，许了个关于新海诚的愿望。',
    imageUrl: 'https://picsum.photos/id/532/600/400',
    likes: '1.8k',
    comments: 95,
    type: 'normal',
  ),
  PostModel(
    id: '13',
    author: '葬送的芙莉莲',
    avatarSeed: 'Elf',
    level: 'Lv.7',
    time: '14小时前',
    tag: '绘图分享',
    content: '"只是相处了短短十年的时间而已"。摸鱼一张辛美尔和芙莉莲，太意难平了。',
    imageUrl: 'https://picsum.photos/id/104/600/400',
    likes: '5.5k',
    comments: 402,
    type: 'normal',
  ),
  PostModel(
    id: '14',
    author: '初音未来',
    avatarSeed: 'Miku',
    time: '16小时前',
    tag: '音乐',
    content: '晚上睡不着，单曲循环《深海少女》。那些V家的老歌，承载了整个中二时期的回忆，永远听不腻。',
    likes: '2.5k',
    comments: 180,
    type: 'text',
  ),
  PostModel(
    id: '15',
    author: '玛奇玛的狗',
    avatarSeed: 'Dog',
    level: 'Lv.9',
    time: '20小时前',
    tag: 'Cosplay',
    content: '周末去漫展出了电锯人，太累了但是很开心！认识了很多同好。',
    imageUrl: 'https://picsum.photos/id/1012/600/400',
    likes: '8.9k',
    comments: 890,
    type: 'normal',
  ),
];
