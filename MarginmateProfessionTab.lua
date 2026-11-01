local addonName, Marginmate = ...

local initialized = false

local function Initialize()
    if initialized or not ProfessionsFrame then
        return
    end
    initialized = true

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
        Initialize()
    elseif loadedAddon == addonName and C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
        C_Timer.After(0, Initialize)
    end
end)
