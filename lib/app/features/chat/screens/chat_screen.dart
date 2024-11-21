import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/features/chat/widgets/message_item.dart';
import 'package:talkie/app/shared/widgets/back_button.dart';
import 'package:talkie/app/shared/widgets/user_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.chatId != widget.chatId) {
      getData();
    }
  }

  final EmojiTextEditingController _controller = EmojiTextEditingController(
    emojiTextStyle: DefaultEmojiTextStyle.copyWith(
      fontFamily: 'NotoColorEmoji',
      fontSize: 20,
      height: 24 / 20,
    ),
  );

  bool _emojiShowing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getData();
  }

  getData() {
    chatController.markChatAsRead(widget.chatId);

    chatController.getMessages(widget.chatId);
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      chatController.getMessages(widget.chatId);
    }
  }

  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return PopScope(
      canPop: !_emojiShowing,
      onPopInvokedWithResult: (didPop, result) {
        if (_emojiShowing) {
          setState(() {
            _emojiShowing = false;
          });
        } else {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: context.isDarkMode
            ? AppColors.neutralDark
            : AppColors.neutralOffWhite,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 64,
          flexibleSpace: Obx(
            () {
              final Chat? chat = chatController.chats
                  .firstWhereOrNull((chat) => chat.id == widget.chatId);

              if (chat == null) {
                return Container();
              }

              final unreadMessagesCount = chat.unreadMessagesCount;

              // Detectar cuando unreadMessagesCount aumenta
              if (unreadMessagesCount > 0) {
                chatController.markChatAsRead(widget.chatId);
              }

              return SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 16,
                  ),
                  height: 64,
                  child: Row(
                    children: [
                      if (Breakpoints.isMdDown(context))
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: CustomBackButton(),
                        ),
                      UserImage(
                        name: chat.receiver.name,
                        surname: chat.receiver.surname,
                        photo: chat.receiver.photo,
                        size: 40,
                        isConnected: chat.receiver.isConnected,
                      ),
                      const Width(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${chat.receiver.name} ${chat.receiver.surname}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: context.isDarkMode
                                    ? AppColors.white
                                    : AppColors.neutralActive,
                                height: 24 / 16,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              chat.receiver.isConnected
                                  ? 'Online'
                                  : 'Last seen ${timeago.format(chat.receiver.lastConnection)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.neutralDisabled,
                                height: 20 / 13,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  final existingMessages =
                      chatController.messages.value[widget.chatId] ?? [];

                  return CustomScrollView(
                    controller: _scrollController,
                    reverse: true,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 16,
                          right: 16,
                          bottom: 12,
                        ),
                        sliver: SliverList.builder(
                          itemBuilder: (context, index) {
                            final message = existingMessages[index];
                            return MessageItem(
                              key: ValueKey(message.id),
                              message: message,
                            );
                          },
                          itemCount: existingMessages.length,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            TapRegion(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
                setState(() {
                  _emojiShowing = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? AppColors.neutralActive
                      : AppColors.white,
                  border: Border(
                    top: BorderSide(
                      color: context.isDarkMode
                          ? AppColors.neutralDark
                          : AppColors.neutralLine,
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 8,
                    right: 8,
                    bottom: kIsWeb ? 16 : 8 + screen.padding.bottom,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _emojiShowing = !_emojiShowing;
                                  if (!_emojiShowing) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _focusNode.requestFocus();
                                    });
                                  }
                                  _focusNode.unfocus();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _focusNode.requestFocus();
                                  });
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: SvgPicture.asset(
                                _emojiShowing
                                    ? 'assets/icons/keyboard.svg'
                                    : 'assets/icons/emoji.svg',
                                width: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.neutralWeak,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.isDarkMode
                                    ? AppColors.neutralDark
                                    : AppColors.neutralOffWhite,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              // height: 44,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _controller,
                                      style: TextStyle(
                                        color: context.isDarkMode
                                            ? AppColors.neutralOffWhite
                                            : AppColors.neutralActive,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height: 24 / 14,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        hintText: 'Message',
                                        hintStyle: const TextStyle(
                                          fontSize: 14,
                                          height: 24 / 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.neutralDisabled,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                          top: 10,
                                          left: 12,
                                          right: 12,
                                          bottom: 10,
                                        ),
                                      ),
                                      maxLines: 3,
                                      minLines: 1,
                                      keyboardType: _emojiShowing
                                          ? TextInputType.none
                                          : TextInputType.multiline,
                                      onTap: () {
                                        //** Cuando los emojies estan activos y es mobile desaparece los emojies y aparece el teclado */
                                        if (_emojiShowing && !kIsWeb) {
                                          setState(() {
                                            _emojiShowing = false;
                                            _focusNode.unfocus();

                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              _focusNode.requestFocus();
                                            });
                                          });
                                        }
                                      },
                                      onFieldSubmitted: (value) {
                                        if (_controller.text
                                            .trim()
                                            .isNotEmpty) {
                                          chatController.sendMessage(
                                            _controller.text.trim(),
                                            widget.chatId,
                                          );

                                          setState(() {
                                            _controller.clear();
                                          });
                                          _focusNode.requestFocus();
                                        }
                                      },
                                      textInputAction: TextInputAction.send,
                                      focusNode: _focusNode,
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: _controller,
                                    builder: (context, value, child) {
                                      if (_controller.text.isNotEmpty) {
                                        return Container();
                                      }

                                      return SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: TextButton(
                                          onPressed: () {
                                            chatController
                                                .sendImage(widget.chatId);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/camera.svg',
                                            width: 24,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.neutralWeak,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (context, value, child) {
                              return SizedBox(
                                width: 44,
                                height: 44,
                                child: TextButton(
                                  onPressed: _controller.text.trim().isEmpty
                                      ? null
                                      : () {
                                          chatController.sendMessage(
                                            _controller.text.trim(),
                                            widget.chatId,
                                          );

                                          setState(() {
                                            _controller.text = '';
                                          });
                                        },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: SvgPicture.asset(
                                    _controller.text.trim().isEmpty
                                        ? 'assets/icons/send_outlined.svg'
                                        : 'assets/icons/send_solid.svg',
                                    colorFilter: ColorFilter.mode(
                                      _controller.text.trim().isEmpty
                                          ? AppColors.neutralWeak
                                          : context.isDarkMode
                                              ? AppColors.brandColorDarkMode
                                              : AppColors.brandColorDefault,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: _emojiShowing ? 256 : 0,
                            curve: Curves.easeInOut,
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: EmojiPicker(
                              textEditingController: _controller,
                              onEmojiSelected: (category, emoji) {
                                _focusNode.requestFocus();
                              },
                              config: Config(
                                height: 256,
                                checkPlatformCompatibility: true,
                                viewOrderConfig: const ViewOrderConfig(
                                  top: EmojiPickerItem.searchBar,
                                  middle: EmojiPickerItem.emojiView,
                                  bottom: EmojiPickerItem.categoryBar,
                                ),
                                customSearchIcon: const Icon(
                                  Icons.search,
                                  size: 24,
                                  color: AppColors.neutralWeak,
                                ),
                                customBackspaceIcon: const Icon(
                                  Icons.backspace_outlined,
                                  size: 24,
                                  color: AppColors.neutralWeak,
                                ),
                                emojiTextStyle: DefaultEmojiTextStyle.copyWith(
                                  fontFamily: 'NotoColorEmoji',
                                  fontSize: 24,
                                ),
                                emojiViewConfig: const EmojiViewConfig(
                                  backgroundColor: Colors.transparent,
                                ),
                                skinToneConfig: const SkinToneConfig(),
                                categoryViewConfig: CategoryViewConfig(
                                  backgroundColor: Colors.transparent,
                                  iconColorSelected: context.isDarkMode
                                      ? AppColors.brandColorDarkMode
                                      : AppColors.brandColorDefault,
                                  dividerColor: Colors.transparent,
                                  customCategoryView: (
                                    config,
                                    state,
                                    tabController,
                                    pageController,
                                  ) {
                                    return CustomCategoryView(
                                      config,
                                      state,
                                      tabController,
                                      pageController,
                                    );
                                  },
                                  categoryIcons: const CategoryIcons(
                                    recentIcon: Icons.access_time_outlined,
                                    smileyIcon: Icons.emoji_emotions_outlined,
                                    animalIcon: Icons.cruelty_free_outlined,
                                    foodIcon: Icons.coffee_outlined,
                                    activityIcon: Icons.sports_soccer_outlined,
                                    travelIcon:
                                        Icons.directions_car_filled_outlined,
                                    objectIcon: Icons.lightbulb_outline,
                                    symbolIcon: Icons.emoji_symbols_outlined,
                                    flagIcon: Icons.flag_outlined,
                                  ),
                                ),
                                bottomActionBarConfig:
                                    const BottomActionBarConfig(
                                  backgroundColor: Colors.transparent,
                                  buttonColor: Colors.transparent,
                                  buttonIconColor: AppColors.neutralDisabled,
                                ),
                                searchViewConfig: SearchViewConfig(
                                  backgroundColor: Colors.transparent,
                                  customSearchView: (
                                    config,
                                    state,
                                    showEmojiView,
                                  ) {
                                    return CustomSearchView(
                                      config,
                                      state,
                                      showEmojiView,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Whatsapp Search view implementation
class CustomSearchView extends SearchView {
  const CustomSearchView(
    super.config,
    super.state,
    super.showEmojiView, {
    super.key,
  });

  @override
  CustomSearchViewState createState() => CustomSearchViewState();
}

class CustomSearchViewState extends SearchViewState {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final emojiSize =
          widget.config.emojiViewConfig.getEmojiSize(constraints.maxWidth);
      final emojiBoxSize =
          widget.config.emojiViewConfig.getEmojiBoxSize(constraints.maxWidth);
      return Container(
        color: widget.config.searchViewConfig.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: emojiBoxSize + 8.0,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                scrollDirection: Axis.horizontal,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return buildEmoji(
                    results[index],
                    emojiSize,
                    emojiBoxSize,
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: widget.showEmojiView,
                  color: widget.config.searchViewConfig.buttonIconColor,
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 20.0,
                    color: AppColors.neutralWeak,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: onTextInputChanged,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.config.searchViewConfig.hintText,
                      hintStyle: const TextStyle(
                        color: AppColors.neutralDisabled,
                        fontWeight: FontWeight.normal,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

/// Customized Whatsapp category view
class CustomCategoryView extends CategoryView {
  const CustomCategoryView(
    super.config,
    super.state,
    super.tabController,
    super.pageController, {
    super.key,
  });

  @override
  CustomCategoryViewState createState() => CustomCategoryViewState();
}

class CustomCategoryViewState extends State<CustomCategoryView>
    with SkinToneOverlayStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.config.categoryViewConfig.backgroundColor,
      child: SizedBox(
        height: widget.config.categoryViewConfig.tabBarHeight,
        child: TabBar(
          labelColor: widget.config.categoryViewConfig.iconColorSelected,
          indicatorColor: widget.config.categoryViewConfig.indicatorColor,
          unselectedLabelColor: widget.config.categoryViewConfig.iconColor,
          dividerColor: widget.config.categoryViewConfig.dividerColor,
          controller: widget.tabController,
          labelPadding: const EdgeInsets.only(top: 1.0),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
          ),
          onTap: (index) {
            closeSkinToneOverlay();
            widget.pageController.jumpToPage(index);
          },
          tabs: widget.state.categoryEmoji
              .asMap()
              .entries
              .map<Widget>(
                  (item) => _buildCategory(item.key, item.value.category))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCategory(int index, category) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          getIconForCategory(
            widget.config.categoryViewConfig.categoryIcons,
            category,
          ),
          size: 20,
        ),
      ),
    );
  }
}
