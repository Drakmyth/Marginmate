local _, Marginmate = ...

local GOLD = "|cffffd700g|r"
local SILVER = "|cffc7c7cfs|r"
local COPPER = "|cffeda55fc|r"

local function GetMoneyColor(value)
    return value < 0 and RED_FONT_COLOR or GREEN_FONT_COLOR
end

function Marginmate.FormatCompactMoney(value, unknownText)
    if value == nil then
        return DISABLED_FONT_COLOR:WrapTextInColorCode(unknownText or "Unknown")
    end

    local color = GetMoneyColor(value)
    local amount = math.abs(value)
    local gold = math.floor(amount / 10000)
    local silver = math.floor((amount % 10000) / 100)
    local copper = amount % 100
    local parts = {}

    if gold > 0 then
        table.insert(parts, color:WrapTextInColorCode(gold) .. GOLD)
    end
    if silver > 0 then
        table.insert(parts, color:WrapTextInColorCode(silver) .. SILVER)
    end
    if copper > 0 or #parts == 0 then
        table.insert(parts, color:WrapTextInColorCode(copper) .. COPPER)
    end

    local sign = value < 0 and RED_FONT_COLOR:WrapTextInColorCode("-") or ""
    return sign .. table.concat(parts, " ")
end

function Marginmate.FormatDetailedMoney(value, unknownText)
    if value == nil then
        return DISABLED_FONT_COLOR:WrapTextInColorCode(unknownText or "Unknown")
    end

    local sign = value < 0 and "-" or ""
    local text = sign .. C_CurrencyInfo.GetCoinTextureString(math.abs(value), 12)
    return GetMoneyColor(value):WrapTextInColorCode(text)
end
