#!/bin/bash
#==============================================================================
# OpenClaw Self-Healing System v2
# 整合 backup/restore + 4-tier 修復
#==============================================================================

BACKUP_DIR="/tmp/openclaw_backups"
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
LOG_FILE="/tmp/openclaw_heal.log"
CRASH_COUNT_FILE="/tmp/openclaw_crash_count"
CRASH_COOLDOWN=21600  # 6小時後衰減

#==============================================================================
# 備份當前配置
#==============================================================================
backup_config() {
    local backup_file="$BACKUP_DIR/config_$(date +%Y%m%d_%H%M%S).json"
    mkdir -p "$BACKUP_DIR"
    cp "$CONFIG_FILE" "$backup_file"
    echo "[$(date)] 📦 Backup: $backup_file" >> "$LOG_FILE"
    echo "$backup_file"
}

#==============================================================================
# 健康檢查
#==============================================================================
health_check() {
    local timeout=10
    local result=$(timeout $timeout openclaw status 2>&1)
    
    if [ $? -eq 0 ] && echo "$result" | grep -q "reachable"; then
        return 0
    else
        return 1
    fi
}

#==============================================================================
# 讀取崩潰次數
#==============================================================================
get_crash_count() {
    if [ -f "$CRASH_COUNT_FILE" ]; then
        local last_time=$(cat "$CRASH_COUNT_FILE" | cut -d: -f1)
        local count=$(cat "$CRASH_COUNT_FILE" | cut -d: -f2)
        
        # 檢查是否在冷卻期內
        local now=$(date +%s)
        local elapsed=$((now - last_time))
        
        if [ $elapsed -gt $CRASH_COOLDOWN ]; then
            # 冷卻期已過，重置
            echo "0" > "$CRASH_COUNT_FILE"
            echo "0"
        else
            echo "$count"
        fi
    else
        echo "0"
    fi
}

#==============================================================================
# 增加崩潰次數
#==============================================================================
increment_crash() {
    local count=$(get_crash_count)
    local new_count=$((count + 1))
    echo "$(date +%s):$new_count" > "$CRASH_COUNT_FILE"
    echo "$new_count"
}

#==============================================================================
# 計算指數退避時間
#==============================================================================
get_backoff_time() {
    local crash_count=$1
    case $crash_count in
        0) echo 10 ;;
        1) echo 30 ;;
        2) echo 90 ;;
        3) echo 180 ;;
        4) echo 600 ;;
        *) echo 600 ;;
    esac
}

#==============================================================================
# Level 0: Preflight 驗證
#==============================================================================
level0_preflight() {
    echo "[$(date)] 🔍 Level 0: Preflight 驗證..." >> "$LOG_FILE"
    
    # 檢查配置文件是否存在
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "[$(date)] ❌ 配置檔案不存在" >> "$LOG_FILE"
        return 1
    fi
    
    # 驗證 JSON 格式
    if ! python3 -c "import json; json.load(open('$CONFIG_FILE'))" 2>/dev/null; then
        echo "[$(date)] ❌ 配置 JSON 格式無效" >> "$LOG_FILE"
        return 1
    fi
    
    echo "[$(date)] ✅ Level 0: Preflight 通過" >> "$LOG_FILE"
    return 0
}

#==============================================================================
# Level 1: 即時重啟
#==============================================================================
level1_keepalive() {
    echo "[$(date)] ⚡ Level 1: 即時重啟..." >> "$LOG_FILE"
    
    # 備份配置
    backup_config
    
    # 重啟 Gateway
    openclaw gateway restart >> "$LOG_FILE" 2>&1
    
    # 等待重啟
    sleep 5
    
    # 驗證
    if health_check; then
        echo "[$(date)] ✅ Level 1: 重啟成功" >> "$LOG_FILE"
        return 0
    fi
    
    return 1
}

#==============================================================================
# Level 2: Watchdog 監控
#==============================================================================
level2_watchdog() {
    local crash_count=$(get_crash_count)
    local backoff_time=$(get_backoff_time $crash_count)
    
    echo "[$(date)] 🔍 Level 2: Watchdog (崩潰 #$crash_count, 退避 ${backoff_time}s)..." >> "$LOG_FILE"
    
    # 增加崩潰次數
    increment_crash
    
    # 等待退避時間
    echo "[$(date)] ⏳ 等待退避時間 ${backoff_time}s..." >> "$LOG_FILE"
    sleep "$backoff_time"
    
    # 重啟
    openclaw gateway restart >> "$LOG_FILE" 2>&1
    
    # 等待
    sleep 10
    
    # 驗證
    if health_check; then
        echo "[$(date)] ✅ Level 2: Watchdog 恢復成功" >> "$LOG_FILE"
        return 0
    fi
    
    return 1
}

#==============================================================================
# Level 3: AI 緊急修復
#==============================================================================
level3_ai_recovery() {
    echo "[$(date)] 🤖 Level 3: AI 緊急修復..." >> "$LOG_FILE"
    
    # 嘗試使用 DeepSeek 分析日誌
    local logs=$(tail -100 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log 2>/dev/null)
    
    if [ -n "$logs" ]; then
        echo "[$(date)] 📋 分析日誌..." >> "$LOG_FILE"
        # 這裡可以調用 DeepSeek API 分析
    fi
    
    # 嘗試 restore 最新備份
    local latest_backup=$(ls -t "$BACKUP_DIR"/config_*.json 2>/dev/null | head -1)
    
    if [ -n "$latest_backup" ]; then
        echo "[$(date)] 📁 恢復備份: $latest_backup" >> "$LOG_FILE"
        cp "$latest_backup" "$CONFIG_FILE"
    fi
    
    # 重啟
    openclaw gateway restart >> "$LOG_FILE" 2>&1
    sleep 10
    
    if health_check; then
        echo "[$(date)] ✅ Level 3: AI 修復成功" >> "$LOG_FILE"
        return 0
    fi
    
    return 1
}

#==============================================================================
# Level 4: 人類通知
#==============================================================================
level4_human_alert() {
    echo "[$(date)] 🚨 Level 4: 通知人類..." >> "$LOG_FILE"
    
    # 這裡可以添加 Telegram/Discord 通知
    # 但目前我們通過 this chat 通知
    
    return 1
}

#==============================================================================
# 自動修復流程
#==============================================================================
auto_heal() {
    echo "[$(date)] 🚨 ===== 開始自我修復 =====" >> "$LOG_FILE"
    
    # Level 0: Preflight
    if ! level0_preflight; then
        # 配置有問題，嘗試恢復
        local latest=$(ls -t "$BACKUP_DIR"/config_*.json 2>/dev/null | head -1)
        if [ -n "$latest" ]; then
            cp "$latest" "$CONFIG_FILE"
            echo "[$(date)] 📁 已恢復備份" >> "$LOG_FILE"
        fi
    fi
    
    # Level 1: 即時重啟
    if health_check; then
        echo "[$(date)] ✅ 系統健康，無需修復" >> "$LOG_FILE"
        return 0
    fi
    
    if level1_keepalive; then
        return 0
    fi
    
    # Level 2: Watchdog
    if level2_watchdog; then
        return 0
    fi
    
    # Level 3: AI 修復
    if level3_ai_recovery; then
        return 0
    fi
    
    # Level 4: 人類通知
    level4_human_alert
    
    echo "[$(date)] ❌ 所有修復方法失敗" >> "$LOG_FILE"
    return 1
}

#==============================================================================
# 主程序
#==============================================================================
case "$1" in
    backup)
        backup_config
        ;;
    check)
        if health_check; then
            echo "✅ OpenClaw 健康"
            exit 0
        else
            echo "❌ OpenClaw 有問題"
            exit 1
        fi
        ;;
    heal)
        auto_heal
        ;;
    status)
        count=$(get_crash_count)
        backoff=$(get_backoff_time $count)
        echo "崩潰次數: $count"
        echo "下次退避: ${backoff}s"
        if health_check; then
            echo "狀態: ✅ 健康"
        else
            echo "狀態: ❌ 離線"
        fi
        ;;
    monitor)
        echo "開始監控 (Ctrl+C 退出)..."
        while true; do
            if ! health_check; then
                echo "[$(date)] 🚨 檢測到問題，開始修復..." | tee -a "$LOG_FILE"
                auto_heal
            fi
            sleep 60
        done
        ;;
    *)
        echo "用法: $0 {backup|check|heal|status|monitor}"
        ;;
esac
