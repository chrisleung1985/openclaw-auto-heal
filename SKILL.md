---
name: openclaw-auto-heal
description: OpenClaw 自動修復系統。備份/恢復 + 4-tier 修復 + 指數退避。專為交易系統等需要高可用性的 OpenClaw 部署設計。
version: 1.0.0
author: Chris Leung
license: MIT
homepage: https://github.com/chrisleung1985/openclaw-auto-heal
---

# 🛡️ OpenClaw Auto-Heal System

自動修復系統，強調「預防勝於治療」。

## 功能

- ✅ 自動備份配置 (每次操作前)
- ✅ 健康檢查 (HTTP + 進程)
- ✅ 4-tier 修復流程
- ✅ 指數退避 (防止崩潰循環)
- ✅ 崩潰計數 (6小時冷卻)
- ✅ 多渠道通知支持

## 架構

| 等級 | 名稱 | 觸發 | 響應 |
|------|------|------|------|
| 0 | Preflight | 冷啟動 | 預檢配置 |
| 1 | KeepAlive | 崩潰 | 即時重啟 |
| 2 | Watchdog | 連續失敗 | 監控 + 退避 |
| 3 | AI 修復 | 30分鐘失敗 | 日誌分析 |
| 4 | 人類通知 | 所有失敗 | 通知管理員 |

## 使用方式

```bash
auto_heal check    # 健康檢查
auto_heal backup   # 備份配置
auto_heal heal     # 自動修復
auto_heal status   # 查看狀態
auto_heal monitor  # 持續監控
```

## 安裝

```bash
git clone https://github.com/chrisleung1985/openclaw-auto-heal.git
cd openclaw-auto-heal
chmod +x scripts/auto_heal.sh
```

## 配置

修改 `scripts/auto_heal.sh` 頂部變量：

```bash
BACKUP_DIR="/tmp/openclaw_backups"
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
LOG_FILE="/tmp/openclaw_heal.log"
CRASH_COOLDOWN=21600
```
