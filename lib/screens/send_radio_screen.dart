import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/toast_widget.dart';

class SendRadioScreen extends StatefulWidget {
  final Function(String)? onSent;
  final String? replyTo;

  const SendRadioScreen({super.key, this.onSent, this.replyTo});

  @override
  State<SendRadioScreen> createState() => _SendRadioScreenState();
}

class _SendRadioScreenState extends State<SendRadioScreen> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;
  static const int _maxChars = 500;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _charCount = _controller.text.length);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      showAppToast(context, '请先写点什么吧~');
      return;
    }
    if (text.length > _maxChars) {
      showAppToast(context, '内容不能超过 $_maxChars 字');
      return;
    }
    widget.onSent?.call(text);
    showAppToast(context, widget.replyTo != null ? '回信已发出！' : '发射成功！');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isReply = widget.replyTo != null;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16, right: 16, bottom: 12,
            ),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('取消',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                ),
                Text(
                  isReply ? '回信给 ${widget.replyTo}' : '发射电波',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textColor),
                ),
                GestureDetector(
                  onTap: _send,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _charCount > 0 && _charCount <= _maxChars
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isReply ? '发送' : '发射',
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold,
                        color: _charCount > 0 && _charCount <= _maxChars
                            ? Colors.white
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Reply hint
          if (isReply)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.reply, size: 14, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text('正在回复 ${widget.replyTo} 的电波',
                      style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
                ],
              ),
            ),
          // Text area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                autofocus: true,
                textAlignVertical: TextAlignVertical.top,
                maxLength: _maxChars,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                    const SizedBox.shrink(),
                decoration: InputDecoration.collapsed(
                  hintText: isReply
                      ? '写下你的回信...'
                      : '说出你的深夜感悟，寻找同频共振的灵魂...',
                  hintStyle: const TextStyle(
                      color: AppColors.subtext, fontSize: 15, height: 1.6),
                ),
                style: const TextStyle(
                    fontSize: 15, color: AppColors.textColor, height: 1.7),
              ),
            ),
          ),
          // Bottom bar — 只显示字数
          Container(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$_charCount / $_maxChars',
                  style: TextStyle(
                    fontSize: 12,
                    color: _charCount > _maxChars ? Colors.red : AppColors.subtext,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
