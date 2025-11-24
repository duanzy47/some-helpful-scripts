# YouTube 播放列表转 MP3 工具

这是一个自动下载 YouTube 播放列表或单个视频，并将其转换为 MP3 音频文件的 Bash 脚本。

## 依赖项

使用前请确保已安装以下工具：

- **yt-dlp**: YouTube 视频下载工具
- **ffmpeg**: 音视频转换工具

安装方法：
```bash
# Ubuntu/Debian
sudo apt install ffmpeg
pip install yt-dlp

# macOS
brew install ffmpeg yt-dlp
```

## 使用方法

### 基本用法

```bash
./yt_playlist_to_mp3.sh --url <YOUTUBE_URL>
```

### 参数说明

| 参数 | 说明 | 是否必填 | 默认值 |
|------|------|----------|--------|
| `-u, --url` | YouTube 播放列表或单个视频的 URL | 必填 | - |
| `-f, --format` | 输出音频格式 | 可选 | mp3 |
| `-q, --quality` | 音质等级 (1-9，数字越小音质越好) | 可选 | 5 |
| `-h, --help` | 显示帮助信息 | - | - |

## 使用示例

### 下载单个视频

```bash
./yt_playlist_to_mp3.sh --url "https://youtu.be/XXXX"
```

### 下载整个播放列表

```bash
./yt_playlist_to_mp3.sh --url "https://www.youtube.com/playlist?list=YYY"
```

### 自定义音质

```bash
./yt_playlist_to_mp3.sh --url "https://youtu.be/XXXX" --quality 2
```

## 功能特点

- 自动识别播放列表和单个视频
- 支持播放列表批量下载（文件名自动编号）
- 下载最高质量的音频流
- 自动转换为 MP3 格式
- 可自定义音频质量
- 转换完成后自动清理原始文件
- 输出文件保存在脚本所在目录

## 工作原理

1. 使用 `yt-dlp` 下载视频的最佳音频流
2. 使用 `ffmpeg` 将下载的音频文件转换为 MP3 格式
3. 自动清理转换前的原始文件（webm、m4a、mp4、mkv）
4. 所有 MP3 文件保存在脚本运行的目录中

## 注意事项

- 确保有足够的磁盘空间
- 网络连接稳定
- 遵守 YouTube 服务条款
- 仅供个人学习使用
