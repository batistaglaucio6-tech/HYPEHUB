--[[
    HYPEHUB Premium UI - Script Completo
    Design Moderno com Glassmorphism e Animações
    Versão: 1.0.0
]]

-- Módulo de Configurações
local Config = {
    Theme = "Dark Purple",
    AccentColor = Color3.fromRGB(150, 0, 255),
    UIScale = 1,
    RainbowAccent = false,
    AutoSave = true,
    Keybinds = {
        ToggleUI = Enum.KeyCode.RightControl,
        Minimize = Enum.KeyCode.RightShift
    }
}

-- Módulo de Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Módulo de Utilitários
local Utils = {
    -- Criar Toggle com animação
    CreateToggle = function(parent, text, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 200, 0, 30)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local toggle = Instance.new("ImageButton")
        toggle.Size = UDim2.new(0, 30, 0, 20)
        toggle.Position = UDim2.new(0.85, 0, 0.5, -10)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        toggle.BackgroundTransparency = 0.3
        toggle.BorderSizePixel = 0
        toggle.Parent = frame
        
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(0, 16, 0, 16)
        circle.Position = UDim2.new(0.05, 0, 0.1, 0)
        circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        circle.BackgroundTransparency = 0.5
        circle.BorderSizePixel = 0
        circle.Parent = toggle
        
        local state = default or false
        
        local function updateToggle()
            if state then
                TweenService:Create(toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Config.AccentColor,
                    BackgroundTransparency = 0.1
                }):Play()
                TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(0.55, 0, 0.1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0
                }):Play()
            else
                TweenService:Create(toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    BackgroundTransparency = 0.3
                }):Play()
                TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(0.05, 0, 0.1, 0),
                    BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                    BackgroundTransparency = 0.5
                }):Play()
            end
        end
        
        toggle.MouseButton1Click:Connect(function()
            state = not state
            updateToggle()
            if callback then callback(state) end
        end)
        
        updateToggle()
        return { Set = function(s) state = s updateToggle() end, Get = function() return state end }
    end,
    
    -- Criar Slider com animação
    CreateSlider = function(parent, text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 200, 0, 35)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 0.5, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
        valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = Config.AccentColor
        valueLabel.TextSize = 13
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.Parent = frame
        
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 4)
        bar.Position = UDim2.new(0, 0, 0.8, 0)
        bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        bar.BackgroundTransparency = 0.3
        bar.BorderSizePixel = 0
        bar.Parent = frame
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Config.AccentColor
        fill.BackgroundTransparency = 0.2
        fill.BorderSizePixel = 0
        fill.Parent = bar
        
        local value = default
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * pos)
            valueLabel.Text = tostring(value)
            TweenService:Create(fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(pos, 0, 1, 0)
            }):Play()
            if callback then callback(value) end
        end
        
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateSlider(input)
                local con
                con = UserInputService.InputChanged:Connect(function(input2)
                    if input2.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input2)
                    end
                end)
                local con2
                con2 = UserInputService.InputEnded:Connect(function(input2)
                    if input2.UserInputType == Enum.UserInputType.MouseButton1 then
                        con:Disconnect()
                        con2:Disconnect()
                    end
                end)
            end
        end)
        
        return { Set = function(v) value = v updateSlider({Position = UDim2.new((v - min) / (max - min), 0, 0, 0)}) end, Get = function() return value end }
    end,
    
    -- Criar Dropdown
    CreateDropdown = function(parent, text, options, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 200, 0, 30)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local dropdown = Instance.new("ImageButton")
        dropdown.Size = UDim2.new(0.4, 0, 1, 0)
        dropdown.Position = UDim2.new(0.6, 0, 0, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        dropdown.BackgroundTransparency = 0.3
        dropdown.BorderSizePixel = 0
        dropdown.Parent = frame
        
        local currentText = Instance.new("TextLabel")
        currentText.Size = UDim2.new(0.8, 0, 1, 0)
        currentText.Position = UDim2.new(0.05, 0, 0, 0)
        currentText.BackgroundTransparency = 1
        currentText.Text = default or options[1]
        currentText.TextColor3 = Color3.fromRGB(200, 200, 200)
        currentText.TextSize = 12
        currentText.TextXAlignment = Enum.TextXAlignment.Left
        currentText.Font = Enum.Font.Gotham
        currentText.Parent = dropdown
        
        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0.15, 0, 1, 0)
        arrow.Position = UDim2.new(0.85, 0, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
        arrow.TextSize = 10
        arrow.Font = Enum.Font.Gotham
        arrow.Parent = dropdown
        
        local expanded = false
        local listFrame
        
        local function createList()
            if listFrame then listFrame:Destroy() end
            listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(0.4, 0, 0, 0)
            listFrame.Position = UDim2.new(0.6, 0, 1, 5)
            listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            listFrame.BackgroundTransparency = 0.1
            listFrame.BorderSizePixel = 0
            listFrame.ClipsDescendants = true
            listFrame.Parent = frame
            
            local uiList = Instance.new("UIListLayout")
            uiList.Padding = UDim.new(0, 2)
            uiList.SortOrder = Enum.SortOrder.LayoutOrder
            uiList.Parent = listFrame
            
            for i, option in ipairs(options) do
                local btn = Instance.new("ImageButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                btn.BackgroundTransparency = 0.5
                btn.BorderSizePixel = 0
                btn.Parent = listFrame
                
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = option
                lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
                lbl.TextSize = 12
                lbl.Font = Enum.Font.Gotham
                lbl.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    currentText.Text = option
                    expanded = false
                    TweenService:Create(listFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Size = UDim2.new(0.4, 0, 0, 0)
                    }):Play()
                    if callback then callback(option) end
                end)
            end
            
            local height = #options * 27 + 2
            TweenService:Create(listFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0.4, 0, 0, height)
            }):Play()
        end
        
        dropdown.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                createList()
            else
                if listFrame then
                    TweenService:Create(listFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Size = UDim2.new(0.4, 0, 0, 0)
                    }):Play()
                    wait(0.3)
                    if listFrame then listFrame:Destroy() end
                end
            end
        end)
        
        return { Set = function(v) currentText.Text = v end, Get = function() return currentText.Text end }
    end
}

-- Módulo Principal da Interface
local Interface = {
    ScreenGui = nil,
    MainFrame = nil,
    Dragging = false,
    DragInput = nil,
    DragStart = nil,
    StartPos = nil,
    Minimized = false,
    CurrentTab = "Main"
}

function Interface:Initialize()
    -- Criar ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HYPEHUB"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = LocalPlayer.PlayerGui
    
    -- Criar Toggle UI Keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Config.Keybinds.ToggleUI then
            if self.MainFrame then
                self.MainFrame.Visible = not self.MainFrame.Visible
            end
        end
        if input.KeyCode == Config.Keybinds.Minimize then
            self:ToggleMinimize()
        end
    end)
    
    self:CreateMainFrame()
    self:CreateTabs()
    self:CreateCategories()
    self:SetupDragging()
end

function Interface:CreateMainFrame()
    -- Main Frame com Glassmorphism
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 900, 0, 600)
    self.MainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    self.MainFrame.BackgroundTransparency = 0.15
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Efeito Glassmorphism
    local glass = Instance.new("Frame")
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glass.BackgroundTransparency = 0.03
    glass.BorderSizePixel = 0
    glass.Parent = self.MainFrame
    
    -- Cantos arredondados
    local corners = Instance.new("UICorner")
    corners.CornerRadius = UDim.new(0, 12)
    corners.Parent = self.MainFrame
    
    -- Sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1.1, 0, 1.1, 0)
    shadow.Position = UDim2.new(-0.05, 0, -0.05, 0)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13160456027"
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = -1
    shadow.Parent = self.MainFrame
    
    -- Título e Barra Superior
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Position = UDim2.new(0.02, 0, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "✦ HYPEHUB v1.0"
    titleText.TextColor3 = Color3.fromRGB(220, 220, 255)
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamSemibold
    titleText.Parent = titleBar
    
    -- Botões de Controle
    local btnMinimize = self:CreateControlButton(titleBar, "─", 0.92)
    btnMinimize.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    local btnClose = self:CreateControlButton(titleBar, "✕", 0.97)
    btnClose.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
    end)
    
    -- Container Principal
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, -45)
    container.Position = UDim2.new(0, 0, 0, 45)
    container.BackgroundTransparency = 1
    container.Parent = self.MainFrame
    
    -- Barra Lateral
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 180, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    sidebar.BackgroundTransparency = 0.2
    sidebar.BorderSizePixel = 0
    sidebar.Parent = container
    
    -- Conteúdo Principal
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -180, 1, 0)
    content.Position = UDim2.new(0, 180, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = container
    
    -- Container de Abas (Content)
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, -20, 1, -10)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 5)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = content
    
    -- Logo HYPEHUB na sidebar
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(1, 0, 0, 45)
    logoFrame.BackgroundTransparency = 1
    logoFrame.Parent = sidebar
    
    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "HYPEHUB"
    logoText.TextColor3 = Config.AccentColor
    logoText.TextSize = 16
    logoText.Font = Enum.Font.GothamBold
    logoText.Parent = logoFrame
    
    local logoSub = Instance.new("TextLabel")
    logoSub.Size = UDim2.new(1, 0, 0, 15)
    logoSub.Position = UDim2.new(0, 0, 1, -15)
    logoSub.BackgroundTransparency = 1
    logoSub.Text = "PREMIUM"
    logoSub.TextColor3 = Color3.fromRGB(150, 150, 180)
    logoSub.TextSize = 9
    logoSub.Font = Enum.Font.Gotham
    logoSub.Parent = logoFrame
    
    -- Barra de Pesquisa
    local searchBox = Instance.new("ImageButton")
    searchBox.Size = UDim2.new(0, 160, 0, 30)
    searchBox.Position = UDim2.new(1, -170, 0, 10)
    searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    searchBox.BackgroundTransparency = 0.3
    searchBox.BorderSizePixel = 0
    searchBox.Parent = container
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchBox
    
    local searchIcon = Instance.new("TextLabel")
    searchIcon.Size = UDim2.new(0, 20, 1, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "🔍"
    searchIcon.TextSize = 14
    searchIcon.Font = Enum.Font.Gotham
    searchIcon.Parent = searchBox
    
    local searchInput = Instance.new("TextBox")
    searchInput.Size = UDim2.new(1, -25, 1, 0)
    searchInput.Position = UDim2.new(0, 25, 0, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.PlaceholderText = "Buscar funções..."
    searchInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
    searchInput.Text = ""
    searchInput.TextColor3 = Color3.fromRGB(200, 200, 220)
    searchInput.TextSize = 13
    searchInput.Font = Enum.Font.Gotham
    searchInput.Parent = searchBox
    
    -- Criar botões da sidebar
    local tabs = {
        {name = "Main", icon = "📌"},
        {name = "Combat", icon = "⚔"},
        {name = "Sea Events", icon = "🌊"},
        {name = "Teleports", icon = "🏝"},
        {name = "Devil Fruits", icon = "🍎"},
        {name = "Race", icon = "🏁"},
        {name = "ESP", icon = "🔎"},
        {name = "Player", icon = "⚙"},
        {name = "Misc", icon = "🎯"},
        {name = "Config", icon = "📊"}
    }
    
    self.SidebarButtons = {}
    local yPos = 65
    
    for i, tab in ipairs(tabs) do
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        btn.BackgroundTransparency = i == 1 and 0.3 or 0.8
        btn.BorderSizePixel = 0
        btn.Parent = sidebar
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 25, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Text = tab.icon
        icon.TextSize = 16
        icon.Font = Enum.Font.Gotham
        icon.Parent = btn
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -30, 1, 0)
        lbl.Position = UDim2.new(0, 30, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = tab.name
        lbl.TextColor3 = Color3.fromRGB(i == 1 and 220 or 180, i == 1 and 220 or 180, i == 1 and 255 or 200)
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            self:SwitchTab(tab.name)
        end)
        
        self.SidebarButtons[tab.name] = btn
        yPos = yPos + 42
    end
    
    -- Salvar referências
    self.Sidebar = sidebar
    self.Content = content
    self.SearchBox = searchInput
end

function Interface:CreateControlButton(parent, text, xPos)
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 30, 1, 0)
    btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    lbl.TextSize = 16
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)
    
    return btn
end

function Interface:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 400, 0, 45)
        }):Play()
    else
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 900, 0, 600)
        }):Play()
    end
end

function Interface:SwitchTab(tabName)
    self.CurrentTab = tabName
    
    -- Atualizar sidebar
    for name, btn in pairs(self.SidebarButtons) do
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = name == tabName and 0.3 or 0.8
        }):Play()
        local lbl = btn:FindFirstChildOfClass("TextLabel")
        if lbl then
            TweenService:Create(lbl, TweenInfo.new(0.2), {
                TextColor3 = name == tabName and Color3.fromRGB(220, 220, 255) or Color3.fromRGB(180, 180, 200)
            }):Play()
        end
    end
    
    -- Limpar e recriar conteúdo da aba
    for _, child in pairs(self.TabContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    -- Criar conteúdo da aba
    self:CreateTabContent(tabName)
end

function Interface:CreateTabs()
    -- As abas são criadas dinamicamente via SwitchTab
    self:SwitchTab("Main")
end

function Interface:CreateTabContent(tabName)
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = self.TabContainer
    
    -- Layout em grid para os toggles
    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0, 220, 0, 40)
    layout.CellPadding = UDim2.new(0, 15, 0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tabFrame
    
    -- Funções por categoria
    local functions = {
        Main = {
            "Auto Farm Level", "Auto Quest", "Auto Farm Mastery", "Auto Farm Bones",
            "Auto Farm Fragments", "Auto Chest", "Auto Elite Hunter", "Auto Cake Prince",
            "Auto Rip Indra", "Auto Dough King", "Auto Factory", "Auto Pirate Raid",
            "Auto Boss", "Auto Boss Select", "Auto Stats", "Auto Haki"
        },
        Combat = {
            "Kill Aura", "Fast Attack", "Auto Click", "Auto Skill",
            "Auto Equip Weapon", "Select Weapon", "Bring Mob", "Magnet Mob",
            "No Stun", "No Dash Cooldown"
        },
        ["Sea Events"] = {
            "Auto Sea Beast", "Auto Leviathan", "Auto Terror Shark", "Auto Shark Anchor",
            "Auto Ship Raid", "Auto Tiki Event", "Auto Piranha", "Auto Frozen Dimension",
            "Auto Mirage Island", "Auto Kitsune Shrine"
        },
        Teleports = {
            "Teleport First Sea", "Teleport Second Sea", "Teleport Third Sea",
            "Teleport Islands", "Teleport NPCs", "Teleport Bosses", "Teleport Fruits"
        },
        ["Devil Fruits"] = {
            "Fruit Sniper", "Auto Store Fruit", "Fruit ESP", "Fruit Notifier",
            "Auto Collect Fruit", "Random Fruit Finder"
        },
        Race = {
            "Auto Race V2", "Auto Race V3", "Auto Race V4", "Auto Trials",
            "Auto Temple", "Auto Gear", "Auto Mirage", "Auto Blue Gear"
        },
        ESP = {
            "Player ESP", "Fruit ESP", "Boss ESP", "Chest ESP", "Flower ESP", "Island ESP"
        },
        Player = {
            "WalkSpeed Slider", "JumpPower Slider", "Fly", "Infinite Jump",
            "No Clip", "Anti AFK", "Full Bright"
        },
        Misc = {
            "Redeem Codes", "FPS Boost", "Rejoin Server", "Server Hop",
            "Auto Rejoin", "Remove Fog", "Remove Effects", "White Screen Mode"
        },
        Config = {
            "Save Config", "Load Config", "Auto Save", "Theme Selector",
            "UI Scale", "Rainbow Accent Color"
        }
    }
    
    local funcs = functions[tabName] or {}
    for _, func in ipairs(funcs) do
        if func:find("Slider") then
            -- Criar slider
            local val = func:match("(.*) Slider")
            local slider = Utils.CreateSlider(tabFrame, val, 1, 50, 16, function(v)
                print(val .. " set to " .. v)
            end)
        elseif func:find("Select") or func:find("Selector") then
            -- Criar dropdown
            local options = {"Opção 1", "Opção 2", "Opção 3"}
            if func == "Select Weapon" then
                options = {"Sword", "Gun", "Fruit", "Melee"}
            elseif func == "Theme Selector" then
                options = {"Dark Purple", "Dark Blue", "Dark Red", "Dark Green"}
            end
            local dropdown = Utils.CreateDropdown(tabFrame, func, options, options[1], function(v)
                print(func .. " selected: " .. v)
            end)
        else
            -- Criar toggle
            local toggle = Utils.CreateToggle(tabFrame, func, false, function(state)
                print(func .. " toggled: " .. tostring(state))
            end)
        end
    end
    
    -- Animar entrada
    tabFrame.BackgroundTransparency = 1
    TweenService:Create(tabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0
    }):Play()
end

function Interface:SetupDragging()
    local dragStart, startPos
    
    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = self.MainFrame.Position
            self.Dragging = true
        end
    end)
    
    self.MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    self.MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
end

function Interface:CreateCategories()
    -- As categorias são criadas dinamicamente via SwitchTab
end

-- Inicializar Interface
local ui = Interface:Initialize()

-- Sistema de Notificações
local Notification = {
    Create = function(title, message, duration)
        duration = duration or 3
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 350, 0, 60)
        frame.Position = UDim2.new(1, -370, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 0
        frame.Parent = ui.ScreenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -20, 0, 25)
        titleLbl.Position = UDim2.new(0, 10, 0, 5)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = Color3.fromRGB(200, 200, 255)
        titleLbl.TextSize = 14
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Font = Enum.Font.GothamSemibold
        titleLbl.Parent = frame
        
        local msgLbl = Instance.new("TextLabel")
        msgLbl.Size = UDim2.new(1, -20, 0, 25)
        msgLbl.Position = UDim2.new(0, 10, 0, 30)
        msgLbl.BackgroundTransparency = 1
        msgLbl.Text = message
        msgLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
        msgLbl.TextSize = 12
        msgLbl.TextXAlignment = Enum.TextXAlignment.Left
        msgLbl.Font = Enum.Font.Gotham
        msgLbl.Parent = frame
        
        frame.Position = UDim2.new(1, 0, 0, 10)
        TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -370,