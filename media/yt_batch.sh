#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<EOF
用法:
  $0 --url <YOUTUBE_URL> [--format mp3] [--quality 5]

说明:
  -u, --url       必填，YouTube 播放列表 或 单个视频 URL
  -f, --format    输出音频格式（默认 mp3）
  -q, --quality   音质 1-9 (默认 5，越小越好)
  -h, --help      显示帮助

示例:
  ./yt_batch.sh --url "https://youtu.be/XXXX"
  ./yt_batch.sh --url "https://www.youtube.com/playlist?list=YYY"
EOF
}

PLAYLIST_URL=""
AUDIO_FORMAT="mp3"
AUDIO_QUALITY="5"

# 当前脚本所在目录 = 输出目录
OUT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 参数解析
while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--url)
      PLAYLIST_URL="$2"; shift 2;;
    -f|--format)
      AUDIO_FORMAT="$2"; shift 2;;
    -q|--quality)
      AUDIO_QUALITY="$2"; shift 2;;
    -h|--help)
      print_help; exit 0;;
    *)
      echo "未知参数: $1"; print_help; exit 1;;
  esac
done

if [[ -z "$PLAYLIST_URL" ]]; then
  echo "错误: 必须指定 --url"
  print_help
  exit 1
fi

mkdir -p "$OUT_DIR"

# 自动识别 playlist vs 单视频
if [[ "$PLAYLIST_URL" == *"list="* ]]; then
  MODE="playlist"
  TEMPLATE="%(playlist_index)03d_%(title)s.%(ext)s"
else
  MODE="single"
  TEMPLATE="%(title)s.%(ext)s"
fi

echo "===> URL 类型: $MODE"
echo "===> 输出目录: $OUT_DIR"

# 下载音频
yt-dlp \
  -f "bestaudio/best" \
  -o "$OUT_DIR/$TEMPLATE" \
  "$PLAYLIST_URL"

echo "===> 下载完成，开始转换为 $AUDIO_FORMAT ..."

cd "$OUT_DIR"
shopt -s nullglob

for f in *.webm *.m4a *.mp4 *.mkv; do
  base="${f%.*}"
  out="${base}.${AUDIO_FORMAT}"
  echo "转换: $f -> $out"

  if [[ "$AUDIO_FORMAT" == "mp3" ]]; then
    ffmpeg -y -i "$f" -vn -acodec libmp3lame -qscale:a "$AUDIO_QUALITY" "$out"
  else
    ffmpeg -y -i "$f" -vn -qscale:a "$AUDIO_QUALITY" "$out"
  fi
done

echo "===> 转换完成，清理原始文件..."

for f in *.webm *.m4a *.mp4 *.mkv; do
  rm -f "$f"
done

echo "===> 全部完成！MP3 在: $OUT_DIR"
