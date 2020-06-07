local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer
local Point = DMW.Classes.Point

function LocalPlayer:New(Pointer)
    self.Pointer = Pointer
    self.CombatReach = UnitCombatReach(Pointer)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(Pointer)
    self.Position = Point(self.PosX, self.PosY, self.PosZ)
    self.GUID = ObjectGUID(Pointer)
    self.Class = select(2, UnitClass(Pointer)):gsub("%s+", "")
    self.Distance = 0
    self.Combat = UnitAffectingCombat(self.Pointer) and DMW.Time or false
    self.CombatLeft = false
    self.EID = false
    self.NoControl = false
    self.Level = UnitLevel(Pointer)
    self:GetSpells()
    self:GetTalents()
    self.Equipment = {}
    self.Professions = {}
    self.Items = {}
    self.Looting = false
    self:UpdateEquipment()
    self:GetItems()
    self:UpdateProfessions()
    if self.Class == "WARRIOR" then
        self.OverpowerUnit = {}
        self.RevengeUnit = {}
    end
    self.SwingMH = 0
    self.SwingOH = false
    self.LastCastTime = DMW.Time
    DMW.Helpers.Queue.GetBindings()
end

function LocalPlayer:Update()
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Position = Point(self.PosX, self.PosY, self.PosZ)
    DMW.Functions.AuraCache.Refresh(self.Pointer)
    self.Health = UnitHealth(self.Pointer)
    self.HealthMax = UnitHealthMax(self.Pointer)
    self.HP = self.Health / self.HealthMax * 100
    self.Level = UnitLevel(self.Pointer)
    self.Casting = CastingInfo(self.Pointer) or ChannelInfo(self.Pointer)
    if self.Casting then
        self.LastCastTime = DMW.Time
    end
    self.Drinking = AuraUtil.FindAuraByName('Drink', 'player')
    self.Eating = AuraUtil.FindAuraByName('Food', 'player')
    self.Bandaging = AuraUtil.FindAuraByName('First Aid', 'player')
    self.Wanding = IsAutoRepeatSpell(self.Spells.Shoot.SpellName)
    self.Rooted = self:HasMovementFlag(DMW.Enums.MovementFlags.Root)
    self.Disabled = self:HasMovementFlag(bit.bor(DMW.Enums.UnitFlags.Stunned, DMW.Enums.UnitFlags.Confused, DMW.Enums.UnitFlags.Pacified, DMW.Enums.UnitFlags.Feared))
    self.Dazed = self.Debuffs.Daze:Exist(self, false)
    self.RecentlyBandaged = self.Debuffs.RecentlyBandaged:Exist(self, false)
    self.Power = UnitPower(self.Pointer)
    self.Power = self:PredictedPower()
    self.PowerMax = UnitPowerMax(self.Pointer)
    self.PowerDeficit = self.PowerMax - self.Power
    self.PowerPct = self.Power / self.PowerMax * 100
    self.PowerRegen = GetPowerRegen()
    if not self.Combat and UnitAffectingCombat("player") then
        self.Combat = DMW.Time
    end
    if self.Class == "ROGUE" or self.Class == "DRUID" then
        self.ComboPoints = GetComboPoints("player", "target")
        self.ComboMax = 5 --UnitPowerMax(self.Pointer, 4)
        self.ComboDeficit = self.ComboMax - self.ComboPoints
        if self.TickTime and DMW.Time >= self.TickTime then
            self.TickTime = self.TickTime + 2
        end
        if self.TickTime then
            self.NextTick = self.TickTime - DMW.Time
        end
    end
    self.Instance = select(2, IsInInstance())
    self.Moving = self:HasMovementFlag(DMW.Enums.MovementFlags.Moving)
    self.Swimming = self:HasMovementFlag(DMW.Enums.MovementFlags.Swimming)
    self.PetActive = UnitIsVisible("pet")
    if self.Class == "HUNTER" then
        self.PetFeeding = AuraUtil.FindAuraByName('Feed Pet Effect', 'pet')
        self.PetHappiness, _, _ = GetPetHappiness()
    end
    self.InGroup = IsInGroup()
    self.CombatTime = self.Combat and (DMW.Time - self.Combat) or 0
    self.CombatLeftTime = self.CombatLeft and (DMW.Time - self.CombatLeft) or 0
    self.Resting = IsResting()
    if self.DOTed then
        local count = 0
        for spell in pairs(self.DOTed) do
            count = count + 1
            if DMW.Time > self.DOTed[spell] then
                self.DOTed[spell] = nil
            end
        end
        if count == 0 then
            self.DOTed = nil
        end
    end
end

function LocalPlayer:PredictedPower()
    if self.Casting then
        local SpellID = select(9, CastingInfo("player"))
        if SpellID then
            local CostTable = GetSpellPowerCost(SpellID)
            if CostTable then
                for _, CostInfo in pairs(CostTable) do
                    if CostInfo.cost > 0 then
                        return (self.Power - CostInfo.cost)
                    end
                end
            end
        end
    end
    return self.Power
end

local GCDList = {
    DRUID = {
        NONE = 5176,
        CAT = 5221,
    },
    HUNTER = 1978,
    MAGE = 133,
    PALADIN = 635,
    PRIEST = 2050,
    ROGUE = 1752,
    SHAMAN = 403,
    WARLOCK = 348,
    WARRIOR = 772,
}

function LocalPlayer:GCDRemain()
    local GCDSpell = 61304
    if self.Class == "DRUID" then
        if self:AuraByID(768,true) then GCDSpell = GCDList[self.Class].CAT else GCDSpell = GCDList[self.Class].NONE end
    else
        GCDSpell = GCDList[self.Class]
    end
    local Start, CD = GetSpellCooldown(GCDSpell)
    if Start == 0 then
        return 0
    end
    return math.max(0, (Start + CD) - DMW.Time)
end

function LocalPlayer:GCD()
    if self.Class == "ROGUE" or (self.Class == "DRUID" and self:AuraByID(768,true)) then
        return 1
    else
        return 1.5
    end
end

function LocalPlayer:CDs()
    if DMW.Settings.profile.HUD.CDs and DMW.Settings.profile.HUD.CDs == 3 then
        return false
    elseif DMW.Settings.profile.HUD.CDs and DMW.Settings.profile.HUD.CDs == 2 then
        return true
    elseif self.Target and self.Target:IsBoss() then
        return true
    end
    return false
end

function LocalPlayer:CritPct()
    return GetCritChance()
end

function LocalPlayer:TTM()
    local PowerMissing = self.PowerMax - self.Power
    if PowerMissing > 0 then
        return PowerMissing / self.PowerRegen
    else
        return 0
    end
end

function LocalPlayer:Standing()
    if ObjectDescriptor("player", GetOffset("CGUnitData__AnimTier"), Types.Byte) == 0 then
        return true
    end
    return false
end

function LocalPlayer:Dispel(Spell)
    local AuraCache = DMW.Tables.AuraCache[self.Pointer]
    if not AuraCache or not Spell then
        return false
    end
    local DispelTypes = {}
    for k, v in pairs(DMW.Enums.DispelSpells[Spell.SpellID]) do
        DispelTypes[v] = true
    end
    local Elapsed
    local Delay = DMW.Settings.profile.Friend.DispelDelay - 0.2 + (math.random(1, 4) / 10)
    local ReturnValue = false
    --name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId
    local AuraReturn
    for _, Aura in pairs(AuraCache) do
        if Aura.Type == "HARMFUL" then
            AuraReturn = Aura.AuraReturn
            Elapsed = AuraReturn[5] - (AuraReturn[6] - DMW.Time)
            if AuraReturn[4] and DispelTypes[AuraReturn[4]] and Elapsed > Delay then
                if DMW.Enums.NoDispel[AuraReturn[10]] then
                    ReturnValue = false
                    break
                elseif DMW.Enums.SpecialDispel[AuraReturn[10]] and DMW.Enums.SpecialDispel[AuraReturn[10]].Stacks then
                    if AuraReturn[3] >= DMW.Enums.SpecialDispel[AuraReturn[10]].Stacks then
                        ReturnValue = true
                    else
                        ReturnValue = false
                        break
                    end
                elseif DMW.Enums.SpecialDispel[AuraReturn[10]] and DMW.Enums.SpecialDispel[AuraReturn[10]].Range then
                    if select(2, self:GetFriends(DMW.Enums.SpecialDispel[AuraReturn[10]].Range)) < 2 then
                        ReturnValue = true
                    else
                        ReturnValue = false
                        break
                    end
                else
                    ReturnValue = true
                end
            end
        end
    end
    return ReturnValue
end

function LocalPlayer:HasFlag(Flag)
    return bit.band(ObjectDescriptor(self.Pointer, GetOffset("CGUnitData__Flags"), "int"), Flag) > 0
end

function LocalPlayer:AuraByID(SpellID, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or false
    local SpellName = GetSpellInfo(SpellID)
    local Pointer = self.Pointer
    if DMW.Tables.AuraCache[Pointer] ~= nil and DMW.Tables.AuraCache[Pointer][SpellName] ~= nil and (not OnlyPlayer or DMW.Tables.AuraCache[Pointer][SpellName]["player"] ~= nil) then
        local AuraReturn
        if OnlyPlayer then
            AuraReturn = DMW.Tables.AuraCache[Pointer][SpellName]["player"].AuraReturn
        else
            AuraReturn = DMW.Tables.AuraCache[Pointer][SpellName].AuraReturn
        end
        return unpack(AuraReturn)
    end
    return nil
end

function LocalPlayer:HasMovementFlag(Flag)
    local SelfFlag = UnitMovementFlags(self.Pointer)
    if SelfFlag then
        return bit.band(UnitMovementFlags(self.Pointer), Flag) > 0
    end
    return false
end
