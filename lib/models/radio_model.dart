class RadioMessage {
  final String id;
  final String sender;
  final String content;
  final String time;
  final bool isReplied;

  RadioMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.time,
    this.isReplied = false,
  });
}

final List<RadioMessage> kRadioMessages = [
  RadioMessage(
    id: 'r_3829104',
    sender: '匿名_茶',
    content: '下班后泡茶听番，有人一样吗？今天喝的是茉莉，配夏目友人帐刚好',
    time: '8分钟前',
    isReplied: false,
  ),
  RadioMessage(
    id: 'r_7741029',
    sender: '匿名_月',
    content: '凌晨2点便利店，一个人喝啤酒。感觉有点孤独，但也还好',
    time: '1小时17分钟前',
    isReplied: true,
  ),
  RadioMessage(
    id: 'r_2209384',
    sender: '匿名_星',
    content: '《ロストワンの号哭》这首歌真的绝了，每次听都很有感触',
    time: '2小时44分钟前',
    isReplied: false,
  ),
  RadioMessage(
    id: 'r_5530182',
    sender: '匿名_风',
    content: '极乐迪斯科好玩吗？一直想买，有人推荐吗',
    time: '4小时03分钟前',
    isReplied: false,
  ),
];
