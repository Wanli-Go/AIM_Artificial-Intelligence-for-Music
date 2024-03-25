- # AIM - 音乐疗愈助手

  完整项目源码（前端+后端+模型）链接： https://pan.baidu.com/s/1vYBSMVo51jTS34uyi5d4Dw 提取码: abdc

  ## **程序目的**

  <img src="pics\Screenshot_2024-03-25-10-19-04-81_fad5737028f0e9f96b181e705f042238.jpg" alt="Screenshot_2024-03-25-10-19-04-81_fad5737028f0e9f96b181e705f042238" style="zoom: 50%;" />

  "AIM" （Artificial Intelligence for Music, 音乐疗愈助手）能够利用音乐的治疗潜力促进其使用者的身心健康。经过精心设计、结合现代人工智能（Artificial Intelligence），我们旨在为通过音乐获得慰藉和疗愈的个人提供最好的服务。以下是 AIM 的深入介绍：

  - **包含病例的个性化用户档案**

  AIM 的核心强调了个性化。用户可以创建不仅包含基本人口统计信息、还包含详细医疗状况和特定健康目标的综合档案。这一特性让 AIM 能在更深的层面上了解它的用户，从而根据每个人的健康需求和喜好调整音乐推荐。

  - **直观的主页**

  主页是一个欢迎界面，展示了最近播放的曲目和个性化播放列表推荐的混合。这个功能由一个先进的算法驱动，该算法从用户的聆听习惯和健康档案中学习，确保每一段音乐都符合他们的治疗需求。

  - **针对用户需求进行音乐推荐**

  AIM 的推荐页面是一个音乐瑰宝的宝库。在这里，会根据个人独特的档案、用户的需求推荐一份精心策划的歌曲列表。这个页面会不断更新，反映用户不断变化的品味和健康要求。

  - **具有 AI 聊天机器人的会话式音乐生成**

  AIM 最具创新性的功能也许是它能够根据与 AI 聊天机器人的互动生成定制音乐。这个配备了同理心倾听技巧的聊天机器人，与用户进行有意义的对话。基于在对谈中表达的情绪、主题和偏好，AIM 能够创作出30秒的原创音乐作品。这一功能不仅提供了高度个性化的音乐体验，还增加了一个惊喜和创意的元素，因为用户见证了直接反映他们思想和情感的音乐的诞生。

  ## **项目结构**

  这个应用程序是用 Dart 语言和 Flutter 框架编写的。 Flutter 官方网站: https://flutter.dev/。

  **根目录 (lib)**: 这是包含所有 Dart 文件和文件夹的主要库目录。它包括 main.dart，即 AIM Flutter 应用程序的入口点。

  - **component 目录**: 这个文件夹包含在整个应用程序代码中使用的可重用/次级 UI 组件。示例包括 BottomMusicBar.dart（首页底部播放组件）和 Disc.dart（用于旋转的唱片播放器）。
  - **model 目录**: 是 AIM 应用程序所需数据模型的定义。这包括 Music.dart, User.dart 和 MusicSheet.dart 等类，它们分别代表音乐轨道、用户档案和乐谱的数据结构。
  - **service 目录**: 这个文件夹专用于 AIM 应用程序的服务层，处理与后端通信的逻辑。像 MusicService.dart 和 ChatService.dart 这样的文件为管理音乐和与音乐疗愈助手对话提供了服务。
  - **view 目录**: 这个目录包含 AIM Flutter 应用程序的 UI 层。其中包含的各种 Dart 文件用于实现不同的页面，如 HomePage.dart，MusicDetailPage.dart 和 GeneratePage.dart，每个文件负责特定页面的布局和功能。

  **重要：前端源的/service/base_url.dart 中，可以指定与后端服务交互的地址。如果您想将后端服务运行在本地，请将其修改为“http://127.0.0.1”。后端配置需求配置中需要将application中的与python脚本相关的配置路径修改为本地路径，python指向算法中audiocraft\.audiocraft\python，generate、resample2npy、predict指向对应的python文件，musicPath与target指向后端中的对应文件夹即可，并修改其余的mysql，rabbitmq等相关配置**

  ## 使用手册

  ### 登陆

  <img src="pics\Screenshot_2024-03-25-10-40-51-47_fad5737028f0e9f96b181e705f042238.jpg" alt="Screenshot_2024-03-25-10-40-51-47_fad5737028f0e9f96b181e705f042238" style="zoom:25%;" />

  - **程序的切入点，**输入手机号和密码便能登陆App。
  - 除非用户制定“退出登陆”，会保存用户的账号和密码。
  - 可以在注册页面注册新的账户。

  ### 首页

  <img src="pics\Screenshot_2024-03-25-10-42-03-50_fad5737028f0e9f96b181e705f042238.jpg" alt="Screenshot_2024-03-25-10-42-03-50_fad5737028f0e9f96b181e705f042238" style="zoom:25%;" />

  - **登陆成功后**，用户会进入首页。
  - 在首页，用户可以看到他们常听的疗愈音乐和收藏的疗愈音乐。
  - 首页下方的“底部音乐栏”组件可以实时显示正在播放的音乐。
  - 点击想听的歌曲，音乐播放器便会在后台进行播放，此时“底部音乐栏”也会更新。

  ### 音乐播放页

  <img src="pics\2.jpg" alt="2" style="zoom:25%;" />

  - **登陆成功后**，不管是在首页或是“疗愈·推荐”，“疗愈·生成”，“设置”页面的任意一个，App的右上角会显示一个曲碟。点击后可以进入音乐播放页。

  <img src="pics\Screenshot_2024-03-25-10-47-03-97_fad5737028f0e9f96b181e705f042238.jpg" alt="Screenshot_2024-03-25-10-47-03-97_fad5737028f0e9f96b181e705f042238" style="zoom:25%;" />

  - 音乐播放页是一个精心设置的音乐播放界面，其中它的背景颜色会随乐曲专辑图片的色调动态实时变化。
  - 可以进行时间调整、切换下一首、上一首，等等。

  ### 音乐推荐

  <img src="C:\D\Git\music_therapy-master\pics\Screenshot_2024-03-25-10-55-01-95_fad5737028f0e9f96b181e705f042238.jpg" alt="Screenshot_2024-03-25-10-55-01-95_fad5737028f0e9f96b181e705f042238" style="zoom:25%;" />

  - 用户可以在音乐推荐界面查看AIM为其推荐的音乐。这个推荐系统考虑了用户的个人信息、病例（VIP）、最近常听的音乐，能够给出十分个性化的推送。
  - 与音乐疗愈助手对话，可以让AIM知道你现在想听的音乐，并且进行个性化推送。

  ### 音乐生成（VIP）

  <img src="pics\Screenshot_2024-03-25-10-56-38-07_fad5737028f0e9f96b181e705f042238.jpg" alt="Screenshot_2024-03-25-10-56-38-07_fad5737028f0e9f96b181e705f042238" style="zoom:25%;" />

  - 输入你想听的音乐的描述，AIM根据这段描述和个人信息制定全新的生成的音乐。
  - 与疗愈助手对话，可以辅助用户获取提示词。

  ### 疗愈助手大模型对话

  <img src="pics\Screenshot_2024-03-25-11-26-30-38_fad5737028f0e9f96b181e705f042238.jpg" alt="Screenshot_2024-03-25-11-26-30-38_fad5737028f0e9f96b181e705f042238" style="zoom:25%;" />

  - AIM提供了一个与用户进行动态交互的界面。这这个界面里，AIM会尝试了解用户的内心，并且为他制定它想要的音乐。
  - 在进行多轮提问后，AIM会给出一段音乐描述。用户可以选择用这段音乐描述推荐，或者生成（VIP）。

### 个人设置

<img src="pics\Screenshot_2024-03-25-11-28-27-39_fad5737028f0e9f96b181e705f042238.jpg" alt="Screenshot_2024-03-25-11-28-27-39_fad5737028f0e9f96b181e705f042238" style="zoom:25%;" />

- 可以设置自己的个人信息，查看历史记录，查看收藏，等等。
- 选择退出登陆后，AIM会忘记用户的个人信息。
