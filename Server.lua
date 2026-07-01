-- =======================================================
-- 🥓 培根腳本中心 V3 - Server 端 (測試版)
-- =======================================================

-- 為了防止被反作弊追蹤，全套使用 pcall 隱密執行
pcall(function()
    local COMMUNICATION_KEY = "Bacon_V3_Bridge"
    
    -- 1. 初始化安全的通訊橋樑
    _G[COMMUNICATION_KEY] = _G[COMMUNICATION_KEY] or {
        Command = nil,
        Value = nil,
        Trigger = false
    }

    -- 2. 獲取系統服務
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    -- 3. 持久化背景狀態表 (這個表是匿名的，依附在 RunService 的閉包中，不會隨著腳本關閉而消失)
    local SpeedState = {
        Enabled = false,
        Value = 50
    }

    -- 4. 核心技術：將加速邏輯牢牢綁定到系統底層 (Heartbeat 匿名函數)
    -- 即使本腳本本體死掉了，這段程式碼也會一直由遊戲引擎代為執行！
    RunService.Heartbeat:Connect(function(deltaTime)
        pcall(function()
            -- 檢查 Client 端有沒有發送新指令
            if _G[COMMUNICATION_KEY] and _G[COMMUNICATION_KEY].Trigger then
                local data = _G[COMMUNICATION_KEY]
                data.Trigger = false -- 重設觸發器
                
                if data.Command == "ToggleSpeed" then
                    SpeedState.Enabled = data.Value
                elseif data.Command == "UpdateSpeedValue" then
                    SpeedState.Value = data.Value
                end
            end

            -- 執行持久化的加速功能 (CFrame 繞過法)
            if SpeedState.Enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                    -- 透過 CFrame 補償位移，避開傳統 WalkSpeed 的反作弊檢測
                    hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * (SpeedState.Value - humanoid.WalkSpeed) * deltaTime)
                end
            end
        end)
    end)

    -- =======================================================
    -- 5. 高階隱形技術：抹除痕跡，自我銷毀！
    -- =======================================================
    print("【Server 核心提示】持久化功能已寫入底層，現在開始抹除腳本特徵並隱形...")
    
    -- 清空所有本地變數指引，斷開 GC（垃圾回收）鏈條
    Players = nil
    RunService = nil
    player = nil
    COMMUNICATION_KEY = nil
    
    -- 讓這個暫存的 Server 執行環境徹底在記憶體中蒸發
    setfenv(1, {}) 
end)
