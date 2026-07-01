-- =======================================================
-- 🥓 培根腳本中心 V3 - Server 端 (放置在 GitHub 雲端)
-- =======================================================

pcall(function()
    local BRIDGE_KEY = "Bacon_V3_Bridge"
    if not _G[BRIDGE_KEY] then return end

    -- 1. 取得系統服務與本機玩家
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    -- 2. 建立匿名的持久化背景狀態表（存在於底層閉包中，不隨腳本死亡而消失）
    -- 這裡使用 _G.Bacon_V3_CoreState 來做跨次載入的狀態留存，避免重複綁定監聽器
    _G.Bacon_V3_CoreState = _G.Bacon_V3_CoreState or {
        SpeedEnabled = false,
        SpeedValue = 16,
        JumpEnabled = false,
        JumpValue = 50,
        Initialized = false
    }
    
    local State = _G.Bacon_V3_CoreState

    -- 3. 讀取此次 Client 端傳過來的最新設定
    if _G[BRIDGE_KEY].Trigger then
        State.SpeedEnabled = _G[BRIDGE_KEY].SpeedEnabled
        State.SpeedValue = _G[BRIDGE_KEY].SpeedValue
        State.JumpEnabled = _G[BRIDGE_KEY].JumpEnabled
        State.JumpValue = _G[BRIDGE_KEY].JumpValue
        _G[BRIDGE_KEY].Trigger = false -- 重設觸發旗標
    end

    -- 4. 如果是第一次啟動，將匿名循環牢牢綁定到系統底層
    if not State.Initialized then
        State.Initialized = true

        -- 【持久化功能一：安全 CFrame 加速（繞過傳統 WalkSpeed 檢測）】
        RunService.Heartbeat:Connect(function(deltaTime)
            pcall(function()
                if State.SpeedEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                        -- 透過 CFrame 補償位移，反作弊眼裡你的 WalkSpeed 依然是 16，但你移動極快
                        hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * (State.SpeedValue - humanoid.WalkSpeed) * deltaTime)
                    end
                end
            end)
        end)

        -- 【持久化功能二：安全跳躍力維持】
        -- 許多反作弊會在玩家落地時把 JumpPower 強制重設為 50。
        -- 我們使用底層 Heartbeat 匿名每幀覆寫，配合 CharacterAdded 確保死後復活依然有效。
        RunService.Heartbeat:Connect(function()
            pcall(function()
                if State.JumpEnabled and player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        -- 啟用 CharacterUseJumpPower 確保新版 Roblox 引擎相容性
                        humanoid.UseJumpPower = true 
                        if humanoid.JumpPower ~= State.JumpValue then
                            humanoid.JumpPower = State.JumpValue
                        end
                    end
                end
            end)
        end)
    end

    -- =======================================================
    -- 5. 高階隱形技術：斷開所有變數引指，自我銷毀！
    -- =======================================================
    -- 將本地局部變數全部指向 nil，解除記憶體指引，讓垃圾回收(GC)自然釋放這個短暫的執行環境
    Players = nil
    RunService = nil
    player = nil
    BRIDGE_KEY = nil
    
    -- 抹除當前代碼執行緒的虛擬環境表
    setfenv(1, {}) 
end)
