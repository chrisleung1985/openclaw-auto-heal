---
name: openclaw-self-healing-v2
description: 增強版自我修復系統。備份/恢復 + 4-tier 修復 + 指數退避。適用於交易系統等需要高可用性的 OpenClaw 部署。
---

# OpenClaw Self-Healing System v2

增強版自我修復系統，整合備份/恢復功能。

## 功能

- ✅ 自動備份配置
- ✅ 健康檢查
- ✅ 4-tier 修復流程
- ✅ 指數退避 (崩潰保護)
- ✅ 交易系統友好

## 架構

```
Level 0: Preflight 驗證
Level 1: KeepAlive 即時重啟
Level 2: Watchdog 監控
Level 3: AI 緊急修復
Level 4: 人類通知
```

## 使用方式

```bash
# 健康檢查
self-heal check

# 備份配置
self-heal backup

# 自動修復
self-heal heal

# 查看狀態
self-heal status

# 持續監控
self-heal monitor
```

## 檔案位置

- 備份目錄: `/tmp/openclaw_backups/`
- 日誌: `/tmp/openclaw_heal.log`
- 崩潰計數: `/tmp/openclaw_crash_count`
