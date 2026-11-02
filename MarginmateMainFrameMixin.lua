MarginmateMainFrameMixin = {}

function MarginmateMainFrameMixin:OnLoad()
    self:SetTitle(self.title)
    self:SetPortraitToAsset(self.portraitIcon)
    self:RegisterForDrag("LeftButton")
end
