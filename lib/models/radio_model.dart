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
    id: '1',
    sender: 'Anonymous_茶',
    content: '有人懂下班后泡一杯花茶，戴上耳机重温《夏目友人帐》那种被治愈的孤独感吗？...',
    time: '10分钟前',
    isReplied: false,
  ),
  RadioMessage(
    id: '2',
    sender: 'Anonymous_月',
    content: '凌晨两点，一个人在便利店买了一瓶啤酒。突然想起某部番剧里说的：孤独不是一个人，而是找不到同频的人。',
    time: '1小时前',
    isReplied: true,
  ),
  RadioMessage(
    id: '3',
    sender: 'Anonymous_星',
    content: '推荐一首歌：《ロストワンの号哭》。每次听都觉得被说中了什么。',
    time: '3小时前',
    isReplied: false,
  ),
  RadioMessage(
    id: '4',
    sender: 'Anonymous_风',
    content: '有没有人玩过《极乐迪斯科》？那种文学性和世界观让我觉得游戏也可以是艺术。',
    time: '5小时前',
    isReplied: false,
  ),
];
