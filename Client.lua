-- =======================================================
-- 🥓 培根腳本中心 V3 - Client 端 (給使用者運行)
-- =======================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 你的 GitHub Server 端 Raw 連結
local SERVER_URL = "https://raw.githubusercontent.com/QAQ0722/-V3.0/refs/heads/main/Server.lua"

-- 初始化全域安全通訊橋樑
local BRIDGE_KEY = "Bacon_V3_Bridge"
_G[BRIDGE_KEY] = _G[BRIDGE_KEY] or {
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpEnabled = false,
    JumpValue = 50,
    Trigger = false
}

local Window = Rayfield:CreateWindow({
   Name = "🥓 培根 V3 雲端主控台",
   LoadingTitle = "培根 V3 載入中...",
   LoadingSubtitle = "by QAQ0722",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local Tab = Window:CreateTab("玩家修改", 4483362458)

-- --- 速度控制組 ---
Tab:CreateToggle({
   Name = "開啟安全 CFrame 加速",
   CurrentValue = false,
   Callback = function(Value)
      _G[BRIDGE_KEY].SpeedEnabled = Value
      _G[BRIDGE_KEY].Trigger = true
      pcall(function() loadstring(game:HttpGet(SERVER_URL))() end)
   end,
})

Tab:CreateSlider({
   Name = "自訂速度值",
   Min = 16,
   Max = 200,
   CurrentValue = 50,
   Callback = function(Value)
      _G[BRIDGE_KEY].SpeedValue = Value
      _G[BRIDGE_KEY].Trigger = true
      pcall(function() loadstring(game:HttpGet(SERVER_URL))() end)
   end,
})

-- --- 跳躍控制組 ---
Tab:CreateToggle({
   Name = "開啟安全跳躍修改",
   CurrentValue = false,
   Callback = function(Value)
      _G[BRIDGE_KEY].JumpEnabled = Value
      _G[BRIDGE_KEY].Trigger = true
      pcall(function() loadstring(game:HttpGet(SERVER_URL))() end)
   end,
})

Tab:CreateSlider({
   Name = "自訂跳躍值",
   Min = 50,
   Max = 300,
   CurrentValue = 50,
   Callback = function(Value)
      _G[BRIDGE_KEY].JumpValue = Value
      _G[BRIDGE_KEY].Trigger = true
      pcall(function() loadstring(game:HttpGet(SERVER_URL))() end)
   end,
})
