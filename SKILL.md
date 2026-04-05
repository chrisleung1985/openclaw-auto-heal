---
name: openclaw-auto-heal
description: OpenClaw 自動修復系統。備份/恢復 + 4-tier 修復 + 指數退避。專為交易系統等需要高可用性的 OpenClaw 部署設計。
---

# OpenClaw Auto-Heal System

自動修復系統，強調預防勝於治療。

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
auto_heal check   # 健康檢查
auto_heal backup  # 備份配置
auto_heal heal    # 自動修復
auto_heal status  # 查看狀態
auto_heal monitor # 持續監控
```

## 檔案位置

- 備份目錄: `/tmp/openclaw_backups/`
- 日誌: `/tmp/openclaw_heal.log`
- 崩潰計數: `/tmp/openclaw_crash_count`
