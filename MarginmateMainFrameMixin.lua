MarginmateMainFrameMixin = {}

function MarginmateMainFrameMixin:OnLoad()
    self:SetTitle("Marginmate")
    self:SetPortraitToAsset("Interface/Icons/inv_misc_coin_02")
    self:RegisterForDrag("LeftButton")
end
