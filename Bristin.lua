
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Bristin HUB beta v2",
   LoadingTitle = "Загрузка Bristin HUB...",
   LoadingSubtitle = "by SWILL",
   ConfigurationSaving = { Enabled = false }
})


local isAutoOpen = false
local isAutoBank = false
local isAutoSell = false
local openDelay = 1
local amountToOpen = 1
local selectedCase = "Free Case"


local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local isFlying = false
local isNoclip = false
local flySpeed = 50
local walkSpeed = 16
local flyConnection = nil
local noclipConnection = nil


local function GetRemote()
    return game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent", true)
end


local MainTab = Window:CreateTab("Авто-Кейсы", 4483362458)
local MainSection = MainTab:CreateSection("Настройки крутки")

MainTab:CreateSlider({
   Name = "Задержка между открытиями (сек)",
   Range = {0.1, 10},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 1,
   Callback = function(Value) 
       openDelay = Value 

       if Value < 0.3 then
           Rayfield:Notify({
               Title = "⚠️ ВНИМАНИЕ",
               Content = "Задержка меньше 0.3 сек! Сервер может вас кикнуть за спам.",
               Duration = 5,
               Image = 4483362458,
           })
       end
   end,
})

MainTab:CreateSlider({
   Name = "Кол-во кейсов за раз (до 20)",
   Range = {1, 20},
   Increment = 1,
   Suffix = " шт",
   CurrentValue = 1,
   Callback = function(Value) amountToOpen = Value end,
})

MainTab:CreateToggle({
   Name = "ВКЛ/ВЫКЛ АВТО-ОТКРЫТИЕ",
   CurrentValue = false,
   Callback = function(State)
       isAutoOpen = State
       if isAutoOpen then
           task.spawn(function()
               local Remote = GetRemote()
               if not Remote then return end
               while isAutoOpen do
                   Remote:FireServer("OpenCase", selectedCase, amountToOpen)
                   task.wait(openDelay)
               end
           end)
       end
   end,
})


local CaseTab = Window:CreateTab("Выбор Кейса", 4483362458)
CaseTab:CreateSection("Выбери кейс из списка:")

local AllCases = {
    "Free Case", "Sealed Genesis Terminal", "Recoil Case", "Fracture Case", "Kilowatt Case", 
    "Sealed Dead Hand Terminal", "Clutch Case", "Gallery Case", "Danger Zone Case", "Fever Case", 
    "Shadow Case", "Prisma 2 Case", "Dreams & Nightmares Case", "Falchion Case", "Chroma 2 Case", 
    "Operation Phoenix Weapon Case", "Revolver Case", "Gamma 2 Case", "Shattered Web Case", 
    "Chroma Case", "Operation Broken Fang Case", "Weapon Case 3", "Winter Offensive Weapon Case", 
    "Operation Vanguard Weapon Case", "Huntsman Weapon Case", "Operation Breakout Case", 
    "2013 Winter Case", "2014 Summer Case", "Glove Case", "Operation Hydra Case", "Operation Bravo Case",
    "2013 Case", "Dust Collection", "Weapon Case", "The Rising Sun Collection", 
    "The Assault Collection", "St. Marc Collection", "The Canals Collection", 
    "2015 Cobblestone Collection", "The Norse Collection", "Enfu Sticker Capsule", 
    "Community Sticker Capsule 1", "Sticker Capsule 2", "Katowice 2015 Legends", 
    "MLG Columbus 2016 Challengers", "Atlanta 2017 Challengers", "Katowice 2015 Challengers", 
    "DreamHack 2014 Legends", "Katowice 2014 Challengers", "Katowice 2014 Legends", 
    "Doodle Capsule", "Lore Case", "Medusa Case", "Fade Case", "Howl Case", "Prince Case",
    "Haven Case", "AWP Case", "Space Case", "Jungle Case", "Hot or Cold", "Ocean Case", 
    "Doodle Case", "Aussie Case", "Cherry Blossom Case", "Mustard Case",
    "Alien Case", "Diamond Case", "Gold Case", "Pirate Case", "Emerald Case", "Verity Case",
    "Lightning Case", "Dragon Case", "Eclipse Case", "Tempest Case", "Obsidian Case",
    "Seraph Case", "Chronos Case", "Singularity Case", "Rainbow Case",
    "Pumpkin Case", "Haunted Pumpkin Case", "Blood Moon Case",
    "Stock: 20x Verdant Relic Case", "Stock: 15x Prism Circuit Case", 
    "Stock: 5x Royal Vault Case", "Stock: 20x Witchlight Case",
    "Level 5 Case", "Level 10 Case", "Level 15 Case", "Level 20 Case", "Level 25 Case",
    "Level 30 Case", "Level 40 Case", "Level 50 Case", "Level 60 Case", "Level 70 Case",
    "Level 80 Case", "Level 90 Case", "Level 100 Case", "Level 110 Case", "Level 120 Case",
    "Nerf Case", "Ketchup Case", "Cars Case", "Roblox Case"
}

CaseTab:CreateDropdown({
    Name = "Список всех кейсов",
    Options = AllCases,
    CurrentOption = {"Free Case"},
    MultipleOptions = false,
    Flag = "AllCasesDropdown",
    Callback = function(Option)
        if Option[1] then
            selectedCase = Option[1]
            Rayfield:Notify({
                Title = "Кейс выбран",
                Content = "Теперь крутится: " .. selectedCase,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})


local FarmTab = Window:CreateTab("Авто-Фарм", 4483362458)
FarmTab:CreateSection("Автоматизация")

FarmTab:CreateToggle({
   Name = "Авто-сбор банка (каждую минуту)",
   CurrentValue = false,
   Callback = function(State)
       isAutoBank = State
       if isAutoBank then
           task.spawn(function()
               local Remote = GetRemote()
               if not Remote then return end
               while isAutoBank do
                   Remote:FireServer("CollectBank")
                   for i = 1, 60 do
                       if not isAutoBank then break end
                       task.wait(1)
                   end
               end
           end)
       end
   end,
})

FarmTab:CreateToggle({
   Name = "Авто-продажа (каждую секунду)",
   CurrentValue = false,
   Callback = function(State)
       isAutoSell = State
       if isAutoSell then
           task.spawn(function()
               local Remote = GetRemote()
               if not Remote then return end
               while isAutoSell do
                   Remote:FireServer("SellItem", {}, nil)
                   task.wait(1)
               end
           end)
       end
   end,
})


local MoveTab = Window:CreateTab("Читы Движения", 4483362458)
MoveTab:CreateSection("⚠️ Осторожно! Если игра обновится и добавят АК, могут забанить.")

-- Speed Hack
MoveTab:CreateSlider({
   Name = "Скорость ходьбы (Speed Hack)",
   Range = {16, 300},
   Increment = 1,
   Suffix = " ws",
   CurrentValue = 16,
   Callback = function(Value)
       walkSpeed = Value
       if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
           player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed
       end
   end,
})

-- Fly (Полет)
MoveTab:CreateToggle({
   Name = "Fly (Полет)",
   CurrentValue = false,
   Callback = function(State)
       isFlying = State
       local char = player.Character
       if not char then return end
       local hrp = char:FindFirstChild("HumanoidRootPart")
       local humanoid = char:FindFirstChildOfClass("Humanoid")
       
       if isFlying then
           if hrp and humanoid then
               
               humanoid.PlatformStand = true
               local bodyVelocity = Instance.new("BodyVelocity")
               bodyVelocity.Name = "FlyVelocity"
               bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
               bodyVelocity.Velocity = Vector3.new(0,0,0)
               bodyVelocity.Parent = hrp

               flyConnection = RunService.RenderStepped:Connect(function()
                   local camera = workspace.CurrentCamera
                   local moveDirection = Vector3.new(0,0,0)
                   
                   if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += camera.CFrame.LookVector end
                   if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= camera.CFrame.LookVector end
                   if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= camera.CFrame.RightVector end
                   if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += camera.CFrame.RightVector end
                   if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0,1,0) end
                   if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection -= Vector3.new(0,1,0) end

                   bodyVelocity.Velocity = moveDirection * flySpeed
               end)
           end
       else
           if flyConnection then flyConnection:Disconnect() end
           if hrp then
               local bv = hrp:FindFirstChild("FlyVelocity")
               if bv then bv:Destroy() end
           end
           if humanoid then humanoid.PlatformStand = false end
       end
   end,
})

-- Noclip (Проход сквозь стены)
MoveTab:CreateToggle({
   Name = "Noclip (Проход сквозь стены)",
   CurrentValue = false,
   Callback = function(State)
       isNoclip = State
       if isNoclip then
           noclipConnection = RunService.Stepped:Connect(function()
               if player.Character then
                   for _, v in pairs(player.Character:GetDescendants()) do
                       if v:IsA("BasePart") then
                           v.CanCollide = false
                       end
                   end
               end
           end)
       else
           if noclipConnection then noclipConnection:Disconnect() end
           if player.Character then
               for _, v in pairs(player.Character:GetDescendants()) do
                   if v:IsA("BasePart") then
                       v.CanCollide = true
                   end
               end
           end
       end
   end,
})

-- ================= ВКЛАДКА 5: СЕРВЕР =================
local ServerTab = Window:CreateTab("Сервер", 4483362458)
ServerTab:CreateSection("Управление сервером")

ServerTab:CreateButton({
   Name = "Rejoin (Перезайти на этот сервер)",
   Callback = function()
       local TeleportService = game:GetService("TeleportService")
       if game.JobId ~= "" then
           TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
       else
           Rayfield:Notify({Title = "Ошибка", Content = "Не удалось получить ID сервера.", Duration = 3})
       end
   end,
})

Rayfield:Notify({
   Title = "Bristin HUB beta v2",
   Content = "Загружено! Вкладка 'Читы Движения' активна.",
   Duration = 5,
   Image = 4483362458,
})