# OpenClaw Auto-Heal System

OpenClaw 自動修復系統 - 基於備份/恢復 + 4-tier 修復架構

## 🎯 設計理念

當系統涉及高風險操作時，自動備份最新狀態，出現異常時直接自動修復。

不同於傳統 watchdog，本系統強調：
- **預防勝於治療** - 操作前自動備份
- **交易系統友好** - 專為需要 24/7 運行的系統設計
- **簡單可靠** - 不依賴外部 AI，純 shell 實現

## ✨ 功能

- ✅ 自動備份配置 (每次操作前)
- ✅ 健康檢查 (HTTP + 進程監控)
- ✅ 4-tier 修復流程 (預檢 → 即時 → 監控 → 通知)
- ✅ 指數退避 (防止崩潰循環)
- ✅ 崩潰計數 (6小時冷卻自動衰減)
- ✅ 多渠道通知支持

## 🏗️ 架構

```
Level 0: Preflight 驗證 (每次冷啟動)
Level 1: KeepAlive 即時重啟 (0-30秒)
Level 2: Watchdog 監控 (每3分鐘)
Level 3: AI 緊急修復 (可選)
Level 4: 人類通知 (Discord/Telegram)
```

## 📁 文件結構

```
.
├── SKILL.md           # OpenClaw Skill 配置
├── scripts/
│   └── auto_heal.sh  # 主腳本
└── README.md
```

## 🚀 安裝

```bash
# 下載腳本
git clone https://github.com/chrisleung1985/openclaw-auto-heal.git
cd openclaw-auto-heal
chmod +x scripts/auto_heal.sh
```

## 💡 使用方式

```bash
# 健康檢查
./scripts/auto_heal.sh check

# 備份配置
./scripts/auto_heal.sh backup

# 自動修復
./scripts/auto_heal.sh heal

# 查看狀態
./scripts/auto_heal.sh status

# 持續監控 (守護進程)
./scripts/auto_heal.sh monitor
```

## ⚙️ 自定義

修改腳本頂部的變量：

```bash
BACKUP_DIR="/tmp/openclaw_backups"  # 備份目錄
CONFIG_FILE="$HOME/.openclaw/openclaw.json"  # 配置檔案
LOG_FILE="/tmp/openclaw_heal.log"  # 日誌檔案
```

## 📊 與其他方案比較

| 功能 | 基礎 Watchdog | Supervisord | 本系統 |
|------|--------------|-------------|--------|
| 自動備份 | ❌ | ❌ | ✅ |
| HTTP 健康檢查 | ❌ | ❌ | ✅ |
| 崩潰保護 | ❌ | 部分 | ✅ 指數退避 |
| 配置驗證 | ❌ | ❌ | ✅ Preflight |
| 交易系統友好 | ❌ | ❌ | ✅ |

## 📝 授權

MIT License

## 👤 作者

Chris Leung - [GitHub](https://github.com/chrisleung1985)
