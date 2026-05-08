import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CirclePost {
  final String author;
  final String seed;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final String time;

  const CirclePost({
    required this.author,
    required this.seed,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.time,
  });
}

class CircleModel {
  final String id;
  final String name;
  final String memberCount;
  final String todayPosts;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String description;
  final String coverImageUrl;
  final List<CirclePost> posts;
  bool isJoined;

  CircleModel({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.todayPosts,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.description,
    required this.coverImageUrl,
    required this.posts,
    this.isJoined = false,
  });
}

// ── 主机游民 ──────────────────────────────────────────────
const _gamingPosts = [
  CirclePost(
    author: 'Pixel_Hunter', seed: 'Pixel',
    content: '《血源诅咒》到底什么时候出 PC 版啊！急死了！索尼你听到了吗？',
    likes: 312, comments: 87, time: '5分钟前',
  ),
  CirclePost(
    author: '老二次元', seed: 'Old',
    content: '《装甲核心6》白金了，感觉人生圆满了一半。有人一起打PVP吗？我的机体配色是全黑+红色高光，帅到爆。',
    imageUrl: 'https://picsum.photos/id/354/600/400',
    likes: 189, comments: 45, time: '30分钟前',
  ),
  CirclePost(
    author: 'Cyber_Punk', seed: 'Cyber',
    content: '赛博朋克2077 2.0更新之后真的脱胎换骨，当年退款的朋友们可以回来了。义体系统重做得太爽了。',
    likes: 456, comments: 102, time: '1小时前',
  ),
  CirclePost(
    author: '提瓦特向导', seed: 'Genshin',
    content: '有没有人推荐一些类似《极乐迪斯科》那种文学性很强的游戏？最近在找能让我哭出来的剧情向作品。',
    likes: 78, comments: 34, time: '2小时前',
  ),
  CirclePost(
    author: '白金猎人', seed: 'Trophy',
    content: '《艾尔登法环》DLC 影之地真的把我打哭了，米科拉那关卡设计是什么神仙水平，跪了。',
    imageUrl: 'https://picsum.photos/id/1015/600/400',
    likes: 892, comments: 213, time: '3小时前',
  ),
  CirclePost(
    author: 'SteamDeck党', seed: 'Steam',
    content: 'Steam Deck OLED 入手一个月体验：续航确实强了，屏幕素质没话说。就是重量还是有点压手腕。',
    likes: 234, comments: 67, time: '4小时前',
  ),
  CirclePost(
    author: '独立游戏探险家', seed: 'Indie',
    content: '《动物井》通关了，这游戏的隐藏内容密度真的离谱，感觉玩了个假通关。有没有人一起研究彩蛋？',
    likes: 145, comments: 89, time: '5小时前',
  ),
  CirclePost(
    author: 'NS玩家', seed: 'Nintendo',
    content: '《塞尔达：王国之泪》马里奥工厂玩法真的太上头了，我已经在里面造了一台能飞的坦克。',
    imageUrl: 'https://picsum.photos/id/100/600/400',
    likes: 567, comments: 134, time: '6小时前',
  ),
  CirclePost(
    author: '格斗游戏老炮', seed: 'Fighter',
    content: '《街霸6》世界巡回赛看完了，日本选手的操作真的是另一个维度。国内格斗圈什么时候能崛起啊。',
    likes: 89, comments: 23, time: '8小时前',
  ),
  CirclePost(
    author: 'RPG收藏家', seed: 'RPG',
    content: '《最终幻想16》剧情真的很成人向，克莱夫的故事线让我想起了《权力的游戏》早期的质感。',
    imageUrl: 'https://picsum.photos/id/122/600/400',
    likes: 334, comments: 78, time: '10小时前',
  ),
  CirclePost(
    author: '模拟经营控', seed: 'Sim',
    content: '《戴森球计划》又更新了，新的星系类型太好看了。工厂建设游戏的天花板就是它了。',
    likes: 201, comments: 45, time: '12小时前',
  ),
  CirclePost(
    author: 'FPS玩家', seed: 'FPS',
    content: '《幽灵行动：断点》虽然口碑不好，但我就是喜欢在里面开直升机乱飞。游戏不一定要好评才好玩。',
    likes: 67, comments: 19, time: '14小时前',
  ),
];

// ── 深夜放映室 ────────────────────────────────────────────
const _animePosts = [
  CirclePost(
    author: '夜猫子_甲', seed: 'NightOwl',
    content: '《葬送的芙莉莲》真的是近年来最好的奇幻番，对"时间"和"告别"的处理方式太成熟了，不像是给年轻人看的。',
    imageUrl: 'https://picsum.photos/id/104/600/400',
    likes: 1203, comments: 345, time: '15分钟前',
  ),
  CirclePost(
    author: '深夜追番人', seed: 'Anime',
    content: '《链锯人》第二季什么时候来啊！藤本树的分镜真的是漫画界的天花板，期待MAPPA能还原出来。',
    likes: 678, comments: 189, time: '1小时前',
  ),
  CirclePost(
    author: '老番鉴赏家', seed: 'Classic',
    content: '重温《攻壳机动队》，每次看都有新感悟。素子对"自我"的追问放到今天AI时代更有共鸣了。',
    imageUrl: 'https://picsum.photos/id/180/600/400',
    likes: 892, comments: 234, time: '2小时前',
  ),
  CirclePost(
    author: '新番追踪者', seed: 'Season',
    content: '本季最惊喜的黑马是《败犬女主太多了》，恋爱喜剧能写出这种层次真的不容易，编剧懂人性。',
    likes: 445, comments: 112, time: '3小时前',
  ),
  CirclePost(
    author: '剧情分析师', seed: 'Analysis',
    content: '《进击的巨人》结局争议到现在还没停，我觉得谏山创的选择是对的——没有完美的结局，只有真实的人性。',
    likes: 2341, comments: 567, time: '4小时前',
  ),
  CirclePost(
    author: '声优粉', seed: 'Seiyuu',
    content: '花泽香菜在《物语系列》里的表演真的是教科书级别，战场原黛伽的每一句台词都是享受。',
    likes: 567, comments: 89, time: '5小时前',
  ),
  CirclePost(
    author: '作画厨', seed: 'Sakuga',
    content: '《鬼灭之刃》无限城篇的作画真的把ufotable的极限拉到了新高度，那个宇髄天元的镜头我截了100张图。',
    imageUrl: 'https://picsum.photos/id/225/600/400',
    likes: 1567, comments: 423, time: '6小时前',
  ),
  CirclePost(
    author: '轻小说读者', seed: 'LN',
    content: '《Re:Zero》原著比动画黑暗太多了，推荐所有只看过动画的人去补一下，会对斯巴鲁有完全不同的理解。',
    likes: 334, comments: 78, time: '8小时前',
  ),
  CirclePost(
    author: '恐怖番爱好者', seed: 'Horror',
    content: '《异兽魔都》的世界观构建真的很扎实，那种"人类才是怪物"的主题在恐怖番里算是做得最有深度的。',
    imageUrl: 'https://picsum.photos/id/200/600/400',
    likes: 234, comments: 56, time: '10小时前',
  ),
  CirclePost(
    author: '机器人番老粉', seed: 'Mecha',
    content: '《天元突破》重看了一遍，螺旋力的设定到现在还是最燃的热血设定之一。中岛かずき的剧本永远的神。',
    likes: 445, comments: 123, time: '12小时前',
  ),
  CirclePost(
    author: '日常番治愈系', seed: 'Slice',
    content: '《孤独摇滚》的成功在于它真的懂内向者的心理，波奇不是"可爱的社恐"，她是真实的焦虑症患者。',
    imageUrl: 'https://picsum.photos/id/453/600/400',
    likes: 1890, comments: 456, time: '14小时前',
  ),
  CirclePost(
    author: '电影番鉴赏', seed: 'Movie',
    content: '新海诚《铃芽之旅》的音乐和画面依然是顶级，但剧情逻辑确实比《你的名字》弱一些。不过瑕不掩瑜。',
    likes: 678, comments: 167, time: '16小时前',
  ),
];

// ── 胶片与光影 ────────────────────────────────────────────
const _photoPosts = [
  CirclePost(
    author: '复古胶片', seed: 'Camera',
    content: '刚入手的二手富士X100VI，直出色彩确实有点毒。就是溢价太严重了，心疼钱包。',
    imageUrl: 'https://picsum.photos/id/435/600/400',
    likes: 455, comments: 67, time: '20分钟前',
  ),
  CirclePost(
    author: '追逐星空', seed: 'Star',
    content: '去川西拍到了《你的名字》同款的璀璨星空。流星划过的那一刻，许了个关于新海诚的愿望。',
    imageUrl: 'https://picsum.photos/id/532/600/400',
    likes: 1823, comments: 95, time: '1小时前',
  ),
  CirclePost(
    author: '街头纪实', seed: 'Street',
    content: '雨后的赛博朋克感，用理光GR3拍的。霓虹灯的倒影有一种迷幻的数字感，这就是我爱下雨天的原因。',
    imageUrl: 'https://picsum.photos/id/765/600/400',
    likes: 678, comments: 23, time: '2小时前',
  ),
  CirclePost(
    author: '人像摄影师', seed: 'Portrait',
    content: '用禄来双反拍的人像，120胶片的颗粒感和层次是数码永远模拟不出来的。这卷柯达Portra 400真的绝了。',
    imageUrl: 'https://picsum.photos/id/1059/600/400',
    likes: 892, comments: 134, time: '3小时前',
  ),
  CirclePost(
    author: '风光摄影控', seed: 'Landscape',
    content: '凌晨四点爬上山顶等日出，冻得瑟瑟发抖，但看到云海的那一刻觉得一切都值了。',
    imageUrl: 'https://picsum.photos/id/250/600/400',
    likes: 2341, comments: 189, time: '4小时前',
  ),
  CirclePost(
    author: '暗房玩家', seed: 'Darkroom',
    content: '第一次自己冲洗黑白胶卷，看着影像在显影液里慢慢浮现的感觉真的很神奇。这才是摄影最原始的魔法。',
    likes: 567, comments: 112, time: '5小时前',
  ),
  CirclePost(
    author: '扫街老炮', seed: 'Scan',
    content: '徕卡M6+35mm Summicron，扫街一下午。老镜头的焦外真的是现代镜头学不来的，有一种油润感。',
    imageUrl: 'https://picsum.photos/id/366/600/400',
    likes: 445, comments: 78, time: '6小时前',
  ),
  CirclePost(
    author: '即拍玩家', seed: 'Instax',
    content: '富士instax mini 99的色调调节功能真的很好玩，暖色调拍出来的照片有一种老电影的质感。',
    imageUrl: 'https://picsum.photos/id/119/600/400',
    likes: 234, comments: 45, time: '8小时前',
  ),
  CirclePost(
    author: '微距摄影师', seed: 'Macro',
    content: '用微距镜头拍了一组露珠里的世界，每一滴水珠里都有一个完整的倒影，大自然真的是最好的摄影师。',
    imageUrl: 'https://picsum.photos/id/1068/600/400',
    likes: 1234, comments: 234, time: '10小时前',
  ),
  CirclePost(
    author: '电影感追求者', seed: 'Cinematic',
    content: '最近迷上了用变形镜头拍视频，那个椭圆形的焦外光斑和镜头光晕真的太有电影感了。',
    imageUrl: 'https://picsum.photos/id/160/600/400',
    likes: 678, comments: 89, time: '12小时前',
  ),
  CirclePost(
    author: '胶片扫描党', seed: 'Scan2',
    content: '入手了爱普生V850扫描仪，终于可以自己扫中画幅了。扫出来的细节量真的把我震惊了。',
    likes: 189, comments: 34, time: '14小时前',
  ),
  CirclePost(
    author: '纪实摄影人', seed: 'Doc',
    content: '在老城区拍了一组即将消失的手艺人，修鞋匠、磨刀师傅、弹棉花的老人。记录本身就是意义。',
    imageUrl: 'https://picsum.photos/id/1012/600/400',
    likes: 3456, comments: 456, time: '16小时前',
  ),
];

// ── OOTD研究所 ────────────────────────────────────────────
const _ootdPosts = [
  CirclePost(
    author: 'Kira_星', seed: 'Kira',
    content: '今天去 CP 漫展的穿搭，尝试了地雷系风格。人太多了，好累但收到了喜欢的谷子！🎀',
    imageUrl: 'https://picsum.photos/id/1059/600/400',
    likes: 1203, comments: 84, time: '10分钟前',
  ),
  CirclePost(
    author: '极简生活', seed: 'Simple',
    content: '今天的极简风穿搭。虽然平时喜欢二次元，但出门还是偏向于日系City Boy风格，比较清爽。',
    imageUrl: 'https://picsum.photos/id/119/600/400',
    likes: 320, comments: 18, time: '1小时前',
  ),
  CirclePost(
    author: '汉服爱好者', seed: 'Hanfu',
    content: '新入的宋制汉服，去了趟博物馆拍了一组。古典美学和现代审美真的可以完美融合。',
    imageUrl: 'https://picsum.photos/id/453/600/400',
    likes: 2341, comments: 234, time: '2小时前',
  ),
  CirclePost(
    author: 'JK制服党', seed: 'JK',
    content: '这套JK是在小众品牌定制的，格纹是自己选的配色，领结也是手工打的。细节控的快乐你们懂吗。',
    imageUrl: 'https://picsum.photos/id/1060/600/400',
    likes: 1567, comments: 312, time: '3小时前',
  ),
  CirclePost(
    author: '街头潮流控', seed: 'Street2',
    content: 'Supreme x BAPE联名这季真的太炸了，排了三个小时队终于抢到了。穿出去被问了十几次在哪买的。',
    imageUrl: 'https://picsum.photos/id/366/600/400',
    likes: 892, comments: 167, time: '4小时前',
  ),
  CirclePost(
    author: '洛丽塔爱好者', seed: 'Lolita',
    content: 'AP新款的草莓印花真的太可爱了，配上白色蕾丝袜和玛丽珍鞋，整个人都甜了。',
    imageUrl: 'https://picsum.photos/id/250/600/400',
    likes: 1234, comments: 189, time: '5小时前',
  ),
  CirclePost(
    author: '暗黑系穿搭', seed: 'Dark',
    content: '全黑穿搭不是没有层次，关键在于面料和剪裁的混搭。今天这套是棉麻+皮革+针织的组合。',
    imageUrl: 'https://picsum.photos/id/160/600/400',
    likes: 678, comments: 89, time: '6小时前',
  ),
  CirclePost(
    author: '痛包展示台', seed: 'Bag',
    content: '新扎的痛包！花了两天时间排阵，带着它去见推啦！大家觉得这个配色怎么样？',
    imageUrl: 'https://picsum.photos/id/1060/600/400',
    likes: 456, comments: 45, time: '8小时前',
  ),
  CirclePost(
    author: '古着收藏家', seed: 'Vintage',
    content: '在二手店淘到了一件80年代的vintage夹克，洗了三遍还是有点旧旧的感觉，但这就是古着的魅力。',
    imageUrl: 'https://picsum.photos/id/435/600/400',
    likes: 345, comments: 56, time: '10小时前',
  ),
  CirclePost(
    author: '运动风混搭', seed: 'Sport',
    content: 'Gorpcore风格真的越来越流行了，今天这套是始祖鸟+New Balance+工装裤，户外感十足。',
    imageUrl: 'https://picsum.photos/id/354/600/400',
    likes: 567, comments: 78, time: '12小时前',
  ),
  CirclePost(
    author: '配饰研究员', seed: 'Acc',
    content: '最近迷上了收集各种二次元周边改造成配饰，把喜欢的角色徽章别在包上，走哪都是移动的爱意。',
    likes: 789, comments: 123, time: '14小时前',
  ),
  CirclePost(
    author: '制服改造师', seed: 'Uniform',
    content: '把普通的白衬衫改造成了地雷系风格，加了蕾丝边和蝴蝶结，成本不到50块，效果拉满。',
    imageUrl: 'https://picsum.photos/id/1015/600/400',
    likes: 1023, comments: 234, time: '16小时前',
  ),
];

// ── Galgame品鉴室 ─────────────────────────────────────────
const _galPosts = [
  CirclePost(
    author: 'Gal老玩家', seed: 'Gal',
    content: '《白色相簿2》是我心中Galgame的天花板，冬马和雪菜的三角关系写得太真实了，每次重读都会哭。',
    likes: 2341, comments: 567, time: '10分钟前',
  ),
  CirclePost(
    author: '泪目收集者', seed: 'Cry',
    content: '《Clannad》After Story的岁月篇是我玩过最催泪的剧情，朋也和渚的故事让我哭了整整一个晚上。',
    imageUrl: 'https://picsum.photos/id/200/600/400',
    likes: 3456, comments: 789, time: '1小时前',
  ),
  CirclePost(
    author: '文字游戏鉴赏家', seed: 'VN',
    content: '《命运石之门》的时间线设计到现在还是视觉小说的标杆，冈部伦太郎的角色弧线写得太好了。',
    likes: 1892, comments: 345, time: '2小时前',
  ),
  CirclePost(
    author: '新作追踪者', seed: 'NewGal',
    content: '最近在玩《枯れない世界と終わる花》，剧情密度很高，推荐给喜欢哲学向Gal的朋友。',
    likes: 234, comments: 89, time: '3小时前',
  ),
  CirclePost(
    author: '攻略达人', seed: 'Guide',
    content: '《月姬Remake》终于把远野志贵的线全通了，TYPE-MOON的世界观真的越挖越深，期待下一部。',
    imageUrl: 'https://picsum.photos/id/104/600/400',
    likes: 1234, comments: 234, time: '4小时前',
  ),
  CirclePost(
    author: '音乐鉴赏家', seed: 'Music',
    content: 'Key社的音乐真的是Galgame界的天花板，折戸伸治和麻枝准的组合出了多少神曲，数都数不清。',
    likes: 892, comments: 167, time: '5小时前',
  ),
  CirclePost(
    author: '画师粉丝', seed: 'Artist',
    content: 'Na-Ga的人设画风真的太美了，《Little Busters!》里每个角色的立绘都是艺术品。',
    imageUrl: 'https://picsum.photos/id/225/600/400',
    likes: 678, comments: 123, time: '6小时前',
  ),
  CirclePost(
    author: '硬核推理玩家', seed: 'Mystery',
    content: '《极限脱出》系列的剧情密度和反转质量在视觉小说里是独一档的，打越钢太郎真的是天才编剧。',
    likes: 567, comments: 89, time: '8小时前',
  ),
  CirclePost(
    author: '恋爱模拟达人', seed: 'Dating',
    content: '《心跳文学部》的元叙事设计放到今天还是让人背脊发凉，这才是真正意义上的"打破第四面墙"。',
    likes: 1567, comments: 345, time: '10小时前',
  ),
  CirclePost(
    author: '同人创作者', seed: 'Doujin',
    content: '最近在写《白色相簿2》的同人，冬马线的结局太意难平了，我要给她一个happy ending。',
    likes: 345, comments: 78, time: '12小时前',
  ),
  CirclePost(
    author: '翻译组成员', seed: 'Trans',
    content: '我们组的《素晴日》汉化终于完成了，花了两年时间，希望大家能感受到这部作品的深度。',
    likes: 2890, comments: 456, time: '14小时前',
  ),
  CirclePost(
    author: '老Gal玩家', seed: 'OldGal',
    content: '《Ever17》的真相揭露那一刻，我坐在椅子上发了十分钟的呆。这辈子都忘不了那种震撼感。',
    imageUrl: 'https://picsum.photos/id/180/600/400',
    likes: 1234, comments: 234, time: '16小时前',
  ),
];

// ── Vtuber切片站 ──────────────────────────────────────────
const _vtuberPosts = [
  CirclePost(
    author: 'Holo粉', seed: 'Holo',
    content: '今天看了Marine的3D直播，她的舞台表现力真的太强了，完全不像是虚拟主播，更像是真正的偶像。',
    imageUrl: 'https://picsum.photos/id/225/600/400',
    likes: 2341, comments: 456, time: '5分钟前',
  ),
  CirclePost(
    author: '切片大师', seed: 'Clip',
    content: '剪了一个Pekora的名场面合集，她的反应速度和梗感真的是天生的，笑死我了。',
    likes: 1567, comments: 234, time: '30分钟前',
  ),
  CirclePost(
    author: 'Niji粉', seed: 'Niji',
    content: '彩虹社EN的Luxiem组合真的打开了男性Vtuber的市场，Vox的ASMR直播每次都能上热搜。',
    likes: 892, comments: 167, time: '1小时前',
  ),
  CirclePost(
    author: '独立Vtuber支持者', seed: 'Indie',
    content: '推荐一个独立Vtuber：小鸟游六花，她的歌声真的太治愈了，而且每次直播都很用心。',
    imageUrl: 'https://picsum.photos/id/104/600/400',
    likes: 678, comments: 123, time: '2小时前',
  ),
  CirclePost(
    author: '歌回鉴赏家', seed: 'Song',
    content: 'AZKi的歌回真的是Hololive里最高水准的，她对音乐的认真程度让人肃然起敬。',
    likes: 1234, comments: 189, time: '3小时前',
  ),
  CirclePost(
    author: '3D直播狂热粉', seed: '3D',
    content: 'Hololive的3D技术越来越成熟了，最新的3D直播里的物理效果和表情捕捉真的达到了新高度。',
    imageUrl: 'https://picsum.photos/id/160/600/400',
    likes: 2890, comments: 567, time: '4小时前',
  ),
  CirclePost(
    author: '企划追踪者', seed: 'Project',
    content: 'Hololive Sports Festival每年都是最期待的企划，今年的团队分配太有意思了，期待看到意外的组合。',
    likes: 1892, comments: 345, time: '5小时前',
  ),
  CirclePost(
    author: '翻译志愿者', seed: 'TL',
    content: '翻译了一期Korone的老游戏直播，她对FC游戏的热情真的感染了我，决定去买一台复刻版FC。',
    likes: 567, comments: 89, time: '6小时前',
  ),
  CirclePost(
    author: 'ASMR爱好者', seed: 'ASMR',
    content: 'Noel的ASMR直播是我失眠时的救星，她的声音真的有一种特别的治愈感，每次都能睡着。',
    likes: 3456, comments: 678, time: '8小时前',
  ),
  CirclePost(
    author: '游戏直播粉', seed: 'Gaming',
    content: '看Aqua打《只狼》真的是一种享受，她的操作水平在Vtuber里绝对是第一梯队，而且反应超级可爱。',
    imageUrl: 'https://picsum.photos/id/1015/600/400',
    likes: 2341, comments: 456, time: '10小时前',
  ),
  CirclePost(
    author: '周边收藏家', seed: 'Merch',
    content: '这次Fubuki的生日周边真的太好看了，手办的细节度比上一次提升了很多，值得入手。',
    likes: 892, comments: 134, time: '12小时前',
  ),
  CirclePost(
    author: '新人观察员', seed: 'Debut',
    content: '最近出道的几个新人里，有一个歌声真的让我惊艳了，期待她以后的发展。Vtuber圈子真的越来越卷了。',
    likes: 456, comments: 78, time: '14小时前',
  ),
];

// ── 圈子列表 ──────────────────────────────────────────────
final List<CircleModel> kCircleData = [
  CircleModel(
    id: '1',
    name: '主机游民',
    memberCount: '12.4k',
    todayPosts: '342',
    icon: Icons.sports_esports,
    iconColor: AppColors.primary,
    iconBg: const Color(0xFFEBF4FA),
    description: '这里是热爱单机、主机游戏的硬核玩家聚集地。探讨剧情、分享白金攻略。',
    coverImageUrl: 'https://picsum.photos/id/160/600/400',
    posts: _gamingPosts,
    isJoined: false,
  ),
  CircleModel(
    id: '2',
    name: '深夜放映室',
    memberCount: '8.1k',
    todayPosts: '218',
    icon: Icons.movie,
    iconColor: AppColors.secondary,
    iconBg: const Color(0xFFFFF0F0),
    description: '深夜番剧、电影、OVA 的讨论圣地。只有真正的夜猫子才懂的感动。',
    coverImageUrl: 'https://picsum.photos/id/180/600/400',
    posts: _animePosts,
    isJoined: false,
  ),
  CircleModel(
    id: '3',
    name: '胶片与光影',
    memberCount: '4.5k',
    todayPosts: '96',
    icon: Icons.camera_alt,
    iconColor: AppColors.accent,
    iconBg: const Color(0xFFEEFAF5),
    description: '用胶片记录生活的温度，分享你的摄影作品与器材心得。',
    coverImageUrl: 'https://picsum.photos/id/250/600/400',
    posts: _photoPosts,
    isJoined: true,
  ),
  CircleModel(
    id: '4',
    name: 'OOTD研究所',
    memberCount: '6.2k',
    todayPosts: '155',
    icon: Icons.checkroom,
    iconColor: const Color(0xFFA78BFA),
    iconBg: const Color(0xFFF3F0FF),
    description: '二次元与现实穿搭的碰撞，地雷系、JK、汉服、街头潮流都欢迎。',
    coverImageUrl: 'https://picsum.photos/id/119/600/400',
    posts: _ootdPosts,
    isJoined: false,
  ),
  CircleModel(
    id: '5',
    name: 'Galgame品鉴室',
    memberCount: '3.2k',
    todayPosts: '87',
    icon: Icons.favorite,
    iconColor: const Color(0xFFF472B6),
    iconBg: const Color(0xFFFFF0F7),
    description: '硬核 Gal 玩家的精神角落，攻略、推荐、泪目名场面都在这里。',
    coverImageUrl: 'https://picsum.photos/id/200/600/400',
    posts: _galPosts,
    isJoined: false,
  ),
  CircleModel(
    id: '6',
    name: 'Vtuber切片站',
    memberCount: '9.8k',
    todayPosts: '512',
    icon: Icons.live_tv,
    iconColor: const Color(0xFF34D399),
    iconBg: const Color(0xFFECFDF5),
    description: '虚拟主播的深度切片与讨论，名场面、梗图、应援都在这里。',
    coverImageUrl: 'https://picsum.photos/id/225/600/400',
    posts: _vtuberPosts,
    isJoined: false,
  ),
];
