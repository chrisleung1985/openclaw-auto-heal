# 🛡️ OpenClaw Auto-Heal System

> 當系統出現問題時，自動修復而不是等待崩潰

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-v2026.4+-green.svg)](https://github.com/openclaw/openclaw)

---

## 🎯 這個系統解決什麼問題？

運維 OpenClaw 時，你是否遇到過：

- ❌ 半夜系統崩潰，只能等到早上才發現
- ❌ 修改配置後忘記備份，出問題無法恢復
- ❌ 崩潰後進入無限重啟循環
- ❌ 系統崩潰卻不知道原因

**Auto-Heal 讓系統「自己修復自己」**。

---

## ✨ 核心功能

| 功能 | 說明 |
|------|------|
| 🛡️ **自動備份** | 每次操作前自動備份配置 |
| 🔍 **健康檢查** | HTTP + 進程雙重監控 |
| 🔄 **4-tier 修復** | 從即時重啟到 AI 診斷 |
| ⏱️ **指數退避** | 防止崩潰循環 |
| 📊 **崩潰追蹤** | 6小時冷卻自動衰減 |
| 🔔 **多渠道通知** | Discord / Telegram / Slack |

---

## 🏗️ 架構原理

```
🚀 系統啟動
    ↓
┌─────────────────────┐
│ Level 0: Preflight  │ ← 預檢配置，預防勝於治療
└──────────┬──────────┘
           ↓ 通過
┌─────────────────────┐
│ Level 1: KeepAlive  │ ← 崩潰後即時重啟 (0-30秒)
└──────────┬──────────┘
           ↓ 連續失敗
┌─────────────────────┐
│ Level 2: Watchdog    │ ← 每分鐘監控，指數退避
└──────────┬──────────┘
           ↓ 30分鐘失敗
┌─────────────────────┐
│ Level 3: AI 修復     │ ← 可選：調用 AI 分析日誌
└──────────┬──────────┘
           ↓ 所有失敗
┌─────────────────────┐
│ Level 4: 人類通知    │ ← 通知管理員
└─────────────────────┘
```

**特點**：每個級別只處理它能處理的問題，解決不了才升級。

---

## 🚀 快速開始

### 1. 下載腳本

```bash
git clone https://github.com/chrisleung1985/openclaw-auto-heal.git
cd openclaw-auto-heal
chmod +x scripts/auto_heal.sh
```

### 2. 基本命令

```bash
./scripts/auto_heal.sh check    # 健康檢查
./scripts/auto_heal.sh backup   # 立即備份
./scripts/auto_heal.sh heal     # 自動修復
./scripts/auto_heal.sh status   # 查看狀態
```

### 3. 設置守護進程 (可選)

```bash
# 加入 crontab，每分鐘檢查
* * * * * /path/to/scripts/auto_heal.sh check || /path/to/scripts/auto_heal.sh heal
```

---

## 📁 文件結構

```
.
├── README.md            # 本文件
├── SKILL.md             # OpenClaw Skill 配置
└── scripts/
    └── auto_heal.sh    # 主腳本
```

---

## ⚙️ 自定義配置

編輯 `scripts/auto_heal.sh` 頂部的變量：

```bash
BACKUP_DIR="/tmp/openclaw_backups"      # 備份目錄
CONFIG_FILE="$HOME/.openclaw/openclaw.json"  # 配置檔案
LOG_FILE="/tmp/openclaw_heal.log"       # 日誌檔案
CRASH_COOLDOWN=21600                    # 崩潰計數冷卻 (秒)
```

---

## 🔧 與其他方案比較

| 功能 | 基礎 Watchdog | Supervisord | 本系統 |
|------|:------------:|:-----------:|:------:|
| 自動備份 | ❌ | ❌ | ✅ |
| HTTP 健康檢查 | ❌ | ❌ | ✅ |
| 崩潰循環保護 | ❌ | ⚠️ 部分 | ✅ |
| 配置預檢 | ❌ | ❌ | ✅ |
| 指數退避 | ❌ | ❌ | ✅ |
| 純 Shell 實現 | ✅ | ❌ | ✅ |
| 即裝即用 | ⚠️ | ⚠️ | ✅ |

---

## 💡 使用場景

- 🏠 **家庭服務器** - 24/7 運行的個人服務
- 📈 **量化交易系統** - 不能崩潰的交易機器
- 🤖 **OpenClaw 生產環境** - 需要高可用性的 AI 助手
- 🖥️ **開發環境** - 不想半夜被叫醒

---

## 📝 工作日誌格式

日誌位於 `/tmp/openclaw_heal.log`，格式：

```
[Sun Apr 05 10:30:00 HKT 2026] 🔍 Level 0: Preflight 驗證...
[Sun Apr 05 10:30:00 HKT 2026] ✅ Level 0: Preflight 通過
[Sun Apr 05 10:30:00 HKT 2026] ✅ OpenClaw 健康
```

---

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request！

1. Fork 本項目
2. 創建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 創建 Pull Request

---

## 📜 授權

MIT License - 詳見 [LICENSE](LICENSE) 文件

---

## 👤 聯繫

- GitHub: [@chrisleung1985](https://github.com/chrisleung1985)
- OpenClaw: [官方文檔](https://docs.openclaw.ai)

---

## 🙏 致謝

- [OpenClaw](https://github.com/openclaw/openclaw) - AI Gateway 框架
- 靈感來自 [ramsbaby/openclaw-self-healing](https://github.com/ramsbaby/openclaw-self-healing)

---

⭐ **如果這個項目對你有幫助，請給個 Star！**
