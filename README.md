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

## 安裝

```bash
./scripts/auto_heal.sh check
```

## 使用方式

```bash
./scripts/auto_heal.sh check   # 健康檢查
./scripts/auto_heal.sh backup  # 備份
./scripts/auto_heal.sh heal    # 自動修復
./scripts/auto_heal.sh status  # 狀態
./scripts/auto_heal.sh monitor # 持續監控
```
