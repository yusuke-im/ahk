; ================================
; Mouse Control AutoHotKey
; ================================

; --- 初期設定 ---
moveAmount := 20  ; 初期カーソル移動速度

; --- カーソル移動 ---
; カーソルキーは、HHKB US配列準拠

RAlt & [::MouseMove, 0, -moveAmount, 0, R     ; ↑
RAlt & /::MouseMove, 0, moveAmount, 0, R      ; ↓
RAlt & ;::MouseMove, -moveAmount, 0, 0, R     ; ←
RAlt & '::MouseMove, moveAmount, 0, 0, R      ; →

; --- クリック操作 ---
; 左クリック : d
; 右クリック : f

RAlt & d::Click
RAlt & f::Click, Right

; --- 前提設定 ---
RAlt::Return  ; RAlt 単独押しでは何もしない（誤動作防止）

; --- スクロール操作（RAlt + Left Shift + 特定キー） ---
; カーソルキーは、HHKB US配列準拠
<+>RAlt & [::Send {WheelUp}       ; ↑ スクロール
<+>RAlt & /::Send {WheelDown}     ; ↓ スクロール
<+>RAlt & ;::Send {WheelLeft}     ; ← 横スクロール
<+>RAlt & '::Send {WheelRight}    ; → 横スクロール

; --- 移動速度切り替え ---
RAlt & 1::moveAmount := 50   ; 高速
RAlt & 2::moveAmount := 20   ; 通常

; --- 左右ディスプレイ間移動 ---
; カーソルキーは、HHKB US配列準拠(; / ')
; <^>：Left Ctrl
; <+>：Left Shift
; RAlt : RAlt

MoveToAdjacentMonitor(direction) {
    MouseGetPos, curX, curY
    SysGet, MonitorCount, MonitorCount

    monitors := []
    Loop %MonitorCount% {
        SysGet, mon, Monitor, %A_Index%
        monitors.Push({ 
            num: A_Index,
            left: monLeft,
            right: monRight,
            top: monTop,
            bottom: monBottom
        })
    }

    currentIndex := -1
    Loop % monitors.Length() {
        m := monitors[A_Index]
        if (curX >= m.left && curX < m.right && curY >= m.top && curY < m.bottom) {
            currentIndex := A_Index
            break
        }
    }

    if (currentIndex = -1)
        return

    if (direction = "left")
        targetIndex := currentIndex - 1
    else if (direction = "right")
        targetIndex := currentIndex + 1
    else
        return

    if (targetIndex < 1 || targetIndex > monitors.Length())
        return

    target := monitors[targetIndex]
    centerX := (target.left + target.right) // 2
    centerY := (target.top + target.bottom) // 2
    MouseMove, centerX, centerY, 0
}