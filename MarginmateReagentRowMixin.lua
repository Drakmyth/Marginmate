local _, Marginmate = ...

MarginmateReagentRowMixin = {}

function MarginmateReagentRowMixin:SetReagent(reagent)
    self:SetShown(reagent ~= nil)
    if not reagent then
        return
    end

    self.Icon:SetTexture(reagent.icon)
    self.Name:SetText(string.format("%d × %s", reagent.quantity, reagent.name))
    self.Cost:SetText(Marginmate.FormatDetailedMoney(-reagent.cost))
end
