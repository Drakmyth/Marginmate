local addonName, Marginmate = ...

Marginmate.mockRecipes = {
    {
        icon = 134808,
        name = "Algari Mana Potion",
        cost = "72g 80s",
        dailyProfit = "100g 44s",
        productValue = "105g 20s",
        unitProfit = "32g 40s",
        soldPerDay = "62.4",
        marketShare = "5%",
        dailySales = "3.1",
        suggestedStock = "3",
        reagents = "4 × Mycobloom    20g 00s\n2 × Luredrop      52g 80s",
    },
    {
        icon = 134828,
        name = "Flask of Alchemical Chaos",
        cost = "85g 10s",
        dailyProfit = "840g 00s",
    },
    {
        icon = 4548875,
        name = "Tempered Framework",
        cost = "Unknown",
        dailyProfit = "—",
    },
    {
        icon = 134937,
        name = "Vendor-only Example",
        cost = "Unknown",
        dailyProfit = "Unknown",
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
    self.Cost:SetText(recipe.cost)
    self.DailyProfit:SetText(recipe.dailyProfit)
end

MarginmateBrowserMixin = {}

function MarginmateBrowserMixin:OnLoad()
    self.CharacterFilter:SetText("Character: All")
    self.ProfessionFilter:SetText("Profession: All")
    self.SearchBox:SetInstructions("Search recipes")

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

function MarginmateBrowserMixin:SelectRecipe(recipe)
    local details = self.RightPane
    details.EmptyState:SetShown(not recipe)
    details.Content:SetShown(recipe ~= nil)
    if not recipe then
        return
    end

    details.Content.Icon:SetTexture(recipe.icon)
    details.Content.Name:SetText(recipe.name)
    details.Content.ProductValue:SetText(recipe.productValue or "Unknown")
    details.Content.ReagentCost:SetText(recipe.cost)
    details.Content.UnitProfit:SetText(recipe.unitProfit or "Unknown")
    details.Content.SoldPerDay:SetText(recipe.soldPerDay or "Unknown")
    details.Content.MarketShare:SetText(recipe.marketShare or "5%")
    details.Content.DailySales:SetText(recipe.dailySales or "Unknown")
    details.Content.DailyProfit:SetText(recipe.dailyProfit)
    details.Content.SuggestedStock:SetText(recipe.suggestedStock or "Unknown")
    details.Content.Reagents:SetText(recipe.reagents or "Pricing data is unavailable.")
end

MarginmateMainFrameMixin = {}

function MarginmateMainFrameMixin:OnLoad()
    self:SetTitle("Marginmate")
    self:SetPortraitToAsset("Interface/Icons/inv_misc_coin_02")
end

function Marginmate.Toggle()
    MarginmateMainFrame:SetShown(not MarginmateMainFrame:IsShown())
end

SLASH_MARGINMATE1 = "/marginmate"
SlashCmdList.MARGINMATE = Marginmate.Toggle

function Marginmate_OnAddonCompartmentClick()
    Marginmate.Toggle()
end
