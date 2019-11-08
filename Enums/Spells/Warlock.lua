local Spells = DMW.Enums.Spells

Spells.WARLOCK = {
    Abilities = {
        AmplifyCurse = {Ranks = {18288}},
        Banish = {Ranks = {710, 18647}},
        Conflagrate = {Ranks = {17962}},
        Corruption = {Ranks = {172, 6222, 6223, 7648, 11671, 11672, 25311}},
        CreateHealthstone = {Ranks = {5699}},
        CreateHealthstoneGreater = {Ranks = {11729}},
        CreateHealthstoneLesser = {Ranks = {6202}},
        CreateHealthstoneMajor = {Ranks = {11730}},
        CreateHealthstoneMinor = {Ranks = {6201}},
        CreateSoulstone = {Ranks = {20767}},
        CreateSoulstoneGreater = {Ranks = {20768}},
        CreateSoulstoneLesser = {Ranks = {20766}},
        CreateSoulstoneMajor = {Ranks = {20769}},
        CreateSoulstoneMinor = {Ranks = {1377}},
        CurseOfAgony = {Ranks = {980, 6217, 11711, 11712, 11713}},
        CurseOfDoom = {Ranks = {603}},
        CurseOfIdiocy = {Ranks = {1010}},
        CurseOfRecklessness = {Ranks = {704, 7658, 7659,11717}},
        CurseOfShadow = {Ranks = {17862, 17937}},
        CurseOfTongues = {Ranks = {1714, 11719}},
        CurseOfWeakness = {Ranks = {702, 1108, 6205, 7646, 11707, 11708}},
        CurseOfTheElements = {Ranks = {1490, 11721, 11722}},
        DarkPact = {Ranks = {18220, 18937, 18938}},
        DeathCoil = {Ranks = {6789, 17925, 17926}},
        DemonArmor = {Ranks = {706, 1086, 11733, 11734, 11735}},
        DemonSkin = {Ranks = {687, 696}},
        DetectLesserInvisibility = {Ranks = {132}},
        DrainLife = {Ranks = {689, 699, 709, 7651, 11699, 11700}},
        DrainMana = {Ranks = {5138}},
        DrainSoul = {Ranks = {1120, 8288, 8289, 11675}},
        EnslaveDemon = {Ranks = {1098, 11725, 11726}},
        Fear = {Ranks = {5782, 6213, 6215}},
        HealthFunnel = {Ranks = {755, 3698, 3699, 3700, 11693, 11694, 11695}},
        Hellfire = {Ranks = {1949, 11683, 11684}},
        HowlOfTerror = {Ranks = {5484, 17928}},
        Immolate = {Ranks = {348, 707, 1094, 2941, 11665, 11667, 11668, 25309}},
        Inferno = {Ranks = {1122}},
        LifeTap = {Ranks = {1454, 1455, 1456, 11687, 11688, 11689}},
        RainOfFire = {Ranks = {5740, 6219, 11677, 11678}, CastType = "Ground"},
        RitualOfDoom = {Ranks = {18540}},
        SearingPain = {Ranks = {5676, 17919, 17920, 17921, 17922, 17923}},
        Sacrifice = {Ranks = {7812,19438,19440,19441,19442,19443}},
		ShadowBolt = {Ranks = {686, 695, 705, 1088, 1106, 7641, 11659, 11660, 11661, 25307}},
        ShadowWard = {Ranks = {6229, 11739, 11740, 28610}},
        Shadowburn = {Ranks = {17877, 18867, 18868, 18869, 18870, 18871}},
        SiphonLife = {Ranks = {18265, 18879, 18880, 18881, 18927, 18928, 18929}},
        SoulFire = {Ranks = {6353, 17924}},
        SummonImp = {Ranks = {688}},
        SummonFelhunter = {Ranks = {691}},
        SummonSuccubus = {Ranks = {712}},
        SummonVoidwalker = {Ranks = {697}},
        UnendingBreath = {Ranks = {5697}},
		SummonMount = {Ranks = {5784,  23161}}
    },
    Buffs = {
        DemonArmor = {Ranks = {706, 1086, 11733, 11734, 11735}},
        DemonSkin = {Ranks = {687, 696}},
        Nightfall = {Ranks = {18094, 18095}},
        ShadowTrance = {Ranks = {17941}},
        ShadowWard = {Ranks = {6229, 11739, 11740, 28610}}
    },
    Debuffs = {
        Banish = {Ranks = {710, 18647}},
        Corruption = {Ranks = {172, 6222, 6223, 7648, 11671, 11672, 25311}},
        CurseOfAgony = {Ranks = {980, 6217, 11711, 11712, 11713}},
        CurseOfDoom = {Ranks = {603}},
        CurseOfIdiocy = {Ranks = {1010}},
        CurseOfRecklessness = {Ranks = {704, 7658, 7659,11717}},
        CurseOfShadow = {Ranks = {17862, 17937}},
        CurseOfTongues = {Ranks = {1714, 11719}},
        CurseOfWeakness = {Ranks = {702, 1108, 6205, 7646, 11707, 11708}},
        CurseOfTheElements = {Ranks = {1490, 11721, 11722}},
        DeathCoil = {Ranks = {6789, 17925, 17926}},
        EnslaveDemon = {Ranks = {1098, 11725, 11726}},
        Fear = {Ranks = {5782, 6213, 6215}},
        Immolate = {Ranks = {348, 707, 1094, 2941, 11665, 11667, 11668, 25309}},
        Shadowburn = {Ranks = {17877, 18867, 18868, 18869, 18870, 18871}},
        SiphonLife = {Ranks = {18265, 18879, 18880, 18881, 18927, 18928, 18929}},
    },
    Talents = {
        --Affliction
        Supression = {1, 1},
        ImprovedCorruption = {1, 2},
        ImprovedCurseOfWeakness = {1, 3},
        ImprovedDrainSoul = {1, 4},
        ImprovedLifeTap = {1, 5},
        ImprovedDrainLife = {1, 6},
        ImprovedCurseOfAgony = {1, 7},
        FelConcentration = {1, 8},
        AmplifyCurse = {1, 9},
        GrimReach = {1, 10},
        Nightfall = {1, 11},
        ImprovedDrainMana = {1, 12},
        ShadowMastery = {1, 13},
        DarkPact = {1, 14},
        --Demonology
        ImprovedHealthstone = {2, 1},
        ImprovedImp = {2, 2},
        DemonicEmbrace = {2, 3},
        ImprovedHealthFunnel = {2, 4},
        ImprovedVoidwalker = {2, 5},
        FelIntellect = {2, 6},
        ImprovedSuccubus = {2, 7},
        FelDomination = {2, 8},
        FelStamina = {2, 9},
        MasterSummoner = {2, 10},
        UnholyPower = {2, 11},
        ImprovedEnslaveDemon = {2, 12},
        DemonicSacrifice = {2, 13},
        ImprovedFirestone = {2, 14},
        MasterDemonologist = {2, 15},
        SoulLink = {2, 16},
        ImprovedSpellstone = {2, 17},
        --Destruction
        ImprovedShadowBolt = {3, 1},
        Cataclysm = {3, 2},
        Bane = {3, 3},
        Aftermath = {3, 4},
        ImprovedFirebolt = {3, 5},
        ImprovedLashOfPain = {3, 6},
        Devastation = {3, 7},
        Shadowburn = {3, 8},
        Intensity = {3, 9},
        DestructiveReach = {3, 10},
        ImprovedSearingPain = {3, 11},
        Pyroclasm = {3, 12},
        ImprovedImmolate = {3, 13},
        Ruin = {3, 14},
        Emberstorm = {3, 15},
        Conflagrate = {3, 16}
    }
}
