#!/bin/bash
# 本地合成脚本：上游树 + .custom-overlay 定制 → 新 master 孤儿快照
# 用法: bash apply.sh [upstream_ref]
# 需要本地已有上游对象（GitHub Actions 里先 clone upstream/master 再调本脚本）
set -euo pipefail
REPO=$(git rev-parse --show-toplevel)
cd "$REPO"

UP="${1:-upstream/master}"
UP_HEAD=$(git rev-parse "$UP")
echo "== 上游: $UP_HEAD ($(git log -1 --format='%s' "$UP"))"

# 临时工作树（仅存放展开的文件）
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

echo "== 展开上游树 =="
git archive "$UP_HEAD" | tar -x -C "$WORK"

echo "== 叠加定制：真实路径 + 保留 .custom-overlay 目录 =="
cp -a .custom-overlay "$WORK/.custom-overlay"
for f in config.seed README.md \
         .github/workflows/build-firmware.yml \
         .github/workflows/sync-upstream.yml \
         package/emortal/default-settings/files/99-default-settings \
         package/custom \
         target/linux/airoha/an7581/base-files/etc/board.d/02_network \
         target/linux/airoha/an7581/base-files/etc/board.d/03_wifi_defaults; do
  mkdir -p "$WORK/$(dirname "$f")"
  cp -a ".custom-overlay/$f" "$WORK/$f"
done

echo "== 写入本次同步的上游版本 =="
echo "$UP_HEAD" > "$WORK/.upstream-linked"
echo "$UP_HEAD" > "$WORK/.custom-overlay/upstream.rev"

echo "== 用独立索引 + 外部 worktree 组装树（落进主仓库对象库） =="
IDX=$(mktemp)
trap 'rm -rf "$WORK" "$IDX"' EXIT
GIT_INDEX_FILE="$IDX" git read-tree --empty
GIT_INDEX_FILE="$IDX" git --work-tree="$WORK" add -A
TREE=$(GIT_INDEX_FILE="$IDX" git --work-tree="$WORK" write-tree)

CUR_TREE=$(git rev-parse master^{tree} 2>/dev/null || echo none)
echo "合成树: $TREE"
echo "现master树: $CUR_TREE"
if [ "$TREE" = "$CUR_TREE" ]; then
  echo "== 无变化，跳过 =="
  exit 0
fi

MSG="customize: 同步上游 $(echo "$UP_HEAD" | cut -c1-10) (naoki66), 重放 NetDoge 定制"
COMMIT=$(echo "$MSG" | git commit-tree "$TREE")
echo "== 新孤儿快照: $COMMIT =="
git update-ref refs/heads/master "$COMMIT"
echo "master -> $(git rev-parse --short master)"
echo "新快照已创建。需手动: git push --force origin master"