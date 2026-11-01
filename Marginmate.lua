local addonName, Marginmate = ...

local function FormatMoney(value, unknownText)
    if value == nil then
        return DISABLED_FONT_COLOR:WrapTextInColorCode(unknownText or "Unknown")
    end

    local sign = value < 0 and "-" or ""
    local text = sign .. C_CurrencyInfo.GetCoinTextureString(math.abs(value), 12)
    local color = value < 0 and RED_FONT_COLOR or GREEN_FONT_COLOR
    return color:WrapTextInColorCode(text)
end

local function FormatReagents(reagents)
    if not reagents then
        return "Pricing data is unavailable."
    end

    local lines = {}
    for _, reagent in ipairs(reagents) do
        table.insert(lines, string.format("%d × %s    %s", reagent.quantity, reagent.name, FormatMoney(reagent.cost)))
    end
    return table.concat(lines, "\n")
end

Marginmate.mockRecipes = {
    {
        icon = 134808,
        name = "Algari Mana Potion",
        cost = 728000,
        dailyProfit = 1004400,
        productValue = 1052000,
        unitProfit = 324000,
        soldPerDay = "62.4",
        marketShare = "5%",
        dailySales = "3.1",
        suggestedStock = "3",
        reagents = {
            { quantity = 4, name = "Mycobloom", cost = 200000 },
            { quantity = 2, name = "Luredrop", cost = 528000 },
        },
    },
    {
        icon = 134828,
        name = "Flask of Alchemical Chaos",
        cost = 851000,
        dailyProfit = 8400000,
    },
    {
        icon = 4548875,
        name = "Tempered Framework",
    },
    {
        icon = 134937,
        name = "Unprofitable Example",
        cost = 140000,
        dailyProfit = -425000,
        productValue = 125000,
        unitProfit = -15000,
    },
}

MarginmateRecipeRowMixin = {}

function MarginmateRecipeRowMixin:OnClick()
    self:GetParent():GetParent():GetParent():SelectRecipe(self.recipe)
end

function MarginmateRecipeRowMixin:SetRecipe(recipe)
    self.recipe = recipe
    self.Icon:SetTexture(recipe.icon)
    self.Name:SetText(recipe.name)
    self.Cost:SetText(FormatMoney(recipe.cost))
    self.DailyProfit:SetText(FormatMoney(recipe.dailyProfit, "—"))
end

MarginmateBrowserMixin = {}

function MarginmateBrowserMixin:OnLoad()
    self.LeftPane.SearchBox.Instructions:SetText("Search recipes")
    self.LeftPane.FilterDropdown:SetupMenu(function(_, rootDescription)
        rootDescription:CreateTitle("Character")
        rootDescription:CreateButton(self.contextCharacter or "All", function() end)
        rootDescription:CreateTitle("Profession")
        rootDescription:CreateButton(self.contextProfession or "All", function() end)
        rootDescription:CreateTitle("Additional filters are not implemented yet")
    end)

    local rows = {
        self.LeftPane.Rows.Row1,
        self.LeftPane.Rows.Row2,
        self.LeftPane.Rows.Row3,
        self.LeftPane.Rows.Row4,
    }
    for index, recipe in ipairs(Marginmate.mockRecipes) do
        rows[index]:SetRecipe(recipe)
    end

    self:SelectRecipe(Marginmate.mockRecipes[1])
end

function MarginmateBrowserMixin:SetContext(character, profession)
    self.contextCharacter = character
    self.contextProfession = profession
end

function MarginmateBrowserMixin:SelectRecipe(recipe)
    local details = self.RightPane
    details.EmptyState:SetShown(not recipe)
    details.Content:SetShown(recipe ~= nil)
    if not recipe then
        return
    end

    details.Content.Icon:SetTexture(recipe.icon)
    details.Content.Name:SetText(recipe.name)
    details.Content.ProductValue:SetText(FormatMoney(recipe.productValue))
    details.Content.ReagentCost:SetText(FormatMoney(recipe.cost and -recipe.cost or nil))
    details.Content.UnitProfit:SetText(FormatMoney(recipe.unitProfit))
    details.Content.SoldPerDay:SetText(recipe.soldPerDay or "Unknown")
    details.Content.MarketShare:SetText(recipe.marketShare or "5%")
    details.Content.DailySales:SetText(recipe.dailySales or "Unknown")
    details.Content.DailyProfit:SetText(FormatMoney(recipe.dailyProfit, "—"))
    details.Content.SuggestedStock:SetText(recipe.suggestedStock or "Unknown")
    details.Content.Reagents:SetText(FormatReagents(recipe.reagents))
end

MarginmateMainFrameMixin = {}

function MarginmateMainFrameMixin:OnLoad()
    self:SetTitle("Marginmate")
    self:SetPortraitToAsset("Interface/Icons/inv_misc_coin_02")
    self:RegisterForDrag("LeftButton")
end

function Marginmate.Toggle()
    if ProfessionsFrame and ProfessionsFrame:IsShown() and Marginmate.professionTabID then
        ProfessionsFrame:SetTab(Marginmate.professionTabID)
        return
    end
    MarginmateMainFrame:SetShown(not MarginmateMainFrame:IsShown())
end

SLASH_MARGINMATE1 = "/marginmate"
SlashCmdList.MARGINMATE = Marginmate.Toggle

function Marginmate_OnAddonCompartmentClick()
    Marginmate.Toggle()
end

local professionTabInitialized = false

local function InitializeProfessionTab()
    if professionTabInitialized or not ProfessionsFrame then
        return
    end
    professionTabInitialized = true

    local page = CreateFrame("Frame", "MarginmateProfessionPage", ProfessionsFrame, "MarginmateBrowserTemplate")
    page:SetPoint("TOPLEFT", ProfessionsFrame, "TOPLEFT", 4, -58)
    page:SetPoint("BOTTOMRIGHT", ProfessionsFrame, "BOTTOMRIGHT", -4, 4)
    page.GetDesiredPageWidth = function()
        return ProfessionsFrame.CraftingPage:GetDesiredPageWidth()
    end
    page:SetScript("OnShow", function(self)
        MarginmateMainFrame:Hide()
        local info = ProfessionsFrame:GetProfessionInfo()
        self:SetContext(UnitName("player"), info and (info.professionName or info.parentProfessionName))
    end)

    Marginmate.professionTabID = ProfessionsFrame:AddNamedTab("Marginmate", page)
    ProfessionsFrame:HookScript("OnShow", function()
        MarginmateMainFrame:Hide()
    end)
    ProfessionsFrame.TabSystem:Layout()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, _, loadedAddon)
    if loadedAddon == "Blizzard_Professions" then
        InitializeProfessionTab()
    elseif loadedAddon == addonName and C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
        C_Timer.After(0, InitializeProfessionTab)
    end
end)
