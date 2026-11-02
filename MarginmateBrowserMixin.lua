local _, Marginmate = ...

MarginmateBrowserMixin = {}

function MarginmateBrowserMixin:OnLoad()
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
    details.Content.ProductValue:SetText(Marginmate.FormatDetailedMoney(recipe.productValue))
    details.Content.ReagentCost:SetText(Marginmate.FormatDetailedMoney(recipe.cost and -recipe.cost or nil))
    details.Content.UnitProfit:SetText(Marginmate.FormatDetailedMoney(recipe.unitProfit))
    details.Content.SoldPerDay:SetText(recipe.soldPerDay or "Unknown")
    details.Content.MarketShare:SetText(recipe.marketShare or "5%")
    details.Content.DailySales:SetText(recipe.dailySales or "Unknown")
    details.Content.DailyProfit:SetText(Marginmate.FormatDetailedMoney(recipe.dailyProfit, "—"))
    details.Content.SuggestedStock:SetText(recipe.suggestedStock or "Unknown")

    local reagentRows = {
        details.Content.ReagentRow1,
        details.Content.ReagentRow2,
        details.Content.ReagentRow3,
    }
    for index, row in ipairs(reagentRows) do
        row:SetReagent(recipe.reagents and recipe.reagents[index])
    end
    details.Content.NoReagents:SetShown(not recipe.reagents)
end
