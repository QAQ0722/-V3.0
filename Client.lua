-- =======================================================
-- 🥓 培根腳本中心 V3 - Client 端 (GitHub 聯動測試版)
-- =======================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 你的 GitHub Server 端連結
local SERVER_URL = "https://raw.githubusercontent.com/QAQ0722/-V3.0/refs/heads/main/Server.lua"

-- 通訊橋樑（讓 Server 下載下來時知道要執行什麼參數）
local COMMUNICATION_KEY = "Bacon_V3_Bridge"
_G[COMMUNICATION_KEY] = _G[COMMUNICATION_KEY] or { Command = nil, Value = nil }

local Window = Rayfield:CreateWindow({
   Name = "🥓 培根 V3 雲端主控台",
   LoadingTitle = "培根 V3 載入中...",
   LoadingSubtitle = "by QAQ0722",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local Tab = Window:CreateTab("雲端功能測試", 4483362458)

-- 測試按鈕：當玩家點擊時，才會去 GitHub 抓取 Server 程式碼
Tab:CreateToggle({
   Name = "安全 CFrame 加速",
   CurrentValue = false,
   Callback = function(Value)
      -- 1. 先打包參數
      _G[COMMUNICATION_KEY].Command = "ToggleSpeed"
      _G[COMMUNICATION_KEY].Value = Value
      
      -- 2. 動態從你的 GitHub 呼叫 Server 端執行
      -- 平常不佔用記憶體，點擊的瞬間才下載、執行、然後在 Server 內部自我銷毀
      pcall(function()
          loadstring(game:HttpGet(SERVER_URL))()
      end)
   end,
})
