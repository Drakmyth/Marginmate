local _, Marginmate = ...

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
            { icon = 134195, quantity = 4, name = "Mycobloom", cost = 200000 },
            { icon = 134197, quantity = 2, name = "Luredrop", cost = 528000 },
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
