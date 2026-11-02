local _, Marginmate = ...

MarginmateRecipeRowMixin = {}

function MarginmateRecipeRowMixin:OnClick()
    self:GetParent():GetParent():GetParent():SelectRecipe(self.recipe)
end

function MarginmateRecipeRowMixin:SetRecipe(recipe)
    self.recipe = recipe
    self.Icon:SetTexture(recipe.icon)
    self.Name:SetText(recipe.name)
    self.Cost:SetText(Marginmate.FormatCompactMoney(recipe.cost))
    self.DailyProfit:SetText(Marginmate.FormatCompactMoney(recipe.dailyProfit, "—"))
end
