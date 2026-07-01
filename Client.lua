-- =======================================================
-- 🥓 培根腳本中心 V3 - Client 端 (測試版)
-- =======================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. 隨機化全域通訊密鑰（防止反作弊直接掃描固定名稱）
local COMMUNICATION_KEY = "Bacon_V3_Bridge"
_G[COMMUNICATION_KEY] = _G[COMMUNICATION_KEY] or {
    Command = nil,
    Value = nil,
    Trigger = false
}

-- 2. 建立測試視窗
local Window = Rayfield:CreateWindow({
   Name = "🥓 培根 V3 測試核心",
   LoadingTitle = "培根 V3 加載中...",
   LoadingSubtitle = "by QAQ0722",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local Tab = Window:CreateTab("核心測試", 4483362458)

-- 3. 測試：加速開關 (Toggle)
Tab:CreateToggle({
   Name = "安全 CFrame 加速",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      -- 傳遞狀態給 Server 端
      _G[COMMUNICATION_KEY].Command = "ToggleSpeed"
      _G[COMMUNICATION_KEY].Value = Value
      _G[COMMUNICATION_KEY].Trigger = true -- 發射訊號
      
      Rayfield:Notify({Title = "Client 提示", Content = "已發送指令，觸發影子 Server 端...", Duration = 2})
   end,
})

-- 4. 測試：速度拉桿 (Slider)
Tab:CreateSlider({
   Name = "自訂速度值",
   Min = 16,
   Max = 150,
   CurrentValue = 50,
   Flag = "SpeedValue",
   Callback = function(Value)
      -- 傳遞數值給 Server 端
      _G[COMMUNICATION_KEY].Command = "UpdateSpeedValue"
      _G[COMMUNICATION_KEY].Value = Value
      _G[COMMUNICATION_KEY].Trigger = true -- 發射訊號
   end,
})
