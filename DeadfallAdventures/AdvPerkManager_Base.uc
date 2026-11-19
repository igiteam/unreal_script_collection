class AdvPerkManager_Base extends Actor
    abstract
    notplaceable
    hidecategories(Navigation);

var array< class<AdvPerk_Base> > Perks;
var const localized string KillStrikeMessage;
var const localized string SurvivalKillStrikeMessage;
var const localized string BonusScoreMessage;
var class<EvilFamilyInfoBase> MummyClassInfo;
var class<EvilFamilyInfoBase> DevastatorClassInfo;
var class<Weapon> MummyWeapon;
var SoundCue FailedPickupSound;

function PreparePerkNotification(PlayerController PC)
{
    local int Counter;
    local AdvPlayerControllerMP PCmp;

    PCmp = AdvPlayerControllerMP(PC);
    Counter = 0;
    J0x27:

    // End:0x7AC [Loop If]
    if(Counter < Perks.Length)
    {
        // End:0x8D
        if(PCmp.bAvaiblePerks.Length <= Counter)
        {
            PCmp.bAvaiblePerks.Add(1);            
        }
        switch(Perks[Counter].default.ActivationMethod.ActivationType)
        {
            // End:0x474
            case 0:
                // End:0x471
                if((AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[0] == Perks[Counter].default.ActivationMethod.Value) && int(PCmp.bAvaiblePerks[Counter]) == int(0))
                {
                    PCmp.bAvaiblePerks[Counter] = 1;
                    PCmp.ClientUpdateAvaiblePerks(Counter, 1);
                    // End:0x2C0
                    if(int(PCmp.bAvaiblePerks[Perks.Length - 1]) == int(1))
                    {
                        AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[0] = 0;
                        // End:0x2C0
                        if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                        {
                            AdvPlayerControllerMP(PC).ClientUnlockAchievement(42);
                        }
                    }
                    PCmp.SetNormalKillStrikeMessage(Counter, Class'ADVGame'.static.ConvertToLocalizedString("AdvPerks", Perks[Counter].default.PerkName, "AdvGame"), Perks[Counter].default.ActivationMethod.Value, Perks[Counter].default.ActivationAccentSound);
                    PCmp.ClientPlaySound(Perks[Counter].default.ActivationSound);
                    PCmp.SetSecondaryAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", Perks[Counter].default.ActivationStringKey, "AdvGame"));
                }
                // End:0x79E
                break;
            // End:0x79B
            case 1:
                // End:0x798
                if((AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[1] == Perks[Counter].default.ActivationMethod.Value) && int(PCmp.bAvaiblePerks[Counter]) == int(0))
                {
                    PCmp.bAvaiblePerks[Counter] = 1;
                    PCmp.ClientUpdateAvaiblePerks(Counter, 1);
                    // End:0x622
                    if(int(PCmp.bAvaiblePerks[Perks.Length - 1]) == int(1))
                    {
                        // End:0x622
                        if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                        {
                            AdvPlayerControllerMP(PC).ClientUnlockAchievement(42);
                        }
                    }
                    PCmp.SetSurvivalKillStrikeMessage(Counter, Class'ADVGame'.static.ConvertToLocalizedString("AdvPerks", Perks[Counter].default.PerkName, "AdvGame"), Perks[Counter].default.ActivationAccentSound);
                    PCmp.ClientPlaySound(Perks[Counter].default.ActivationSound);
                    PCmp.SetSecondaryAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", Perks[Counter].default.ActivationStringKey, "AdvGame"));
                }
                // End:0x79E
                break;
            // End:0xFFFF
            default:
                break;
        }
        Counter++;
        // [Loop Continue]
        goto J0x27;
    }
    //return;    
}

event PostBeginPlay()
{
    local class<AdvPerk_Base> Perk;
    local int PerkIndex, dots, I;

    super.PostBeginPlay();
    // End:0x290
    foreach Perks(Perk, PerkIndex)
    {
        AdvGRI(WorldInfo.GRI).KillStrikeIconIndexes[PerkIndex] = Perk.default.IconIndex;
        AdvGRI(WorldInfo.GRI).KillStrikeIcons[PerkIndex] = 1;
        // End:0x163
        if(PerkIndex > 0)
        {
            dots = Perk.default.ActivationMethod.Value - Perks[PerkIndex - 1].default.ActivationMethod.Value;            
        }
        else
        {
            dots = Perk.default.ActivationMethod.Value;
        }
        I = 0;
        J0x1A9:

        // End:0x28F [Loop If]
        if(I < 3)
        {
            // End:0x22A
            if(I < dots)
            {
                AdvGRI(WorldInfo.GRI).KillStrikeDots[I + (PerkIndex * 3)] = 1;                
            }
            else
            {
                AdvGRI(WorldInfo.GRI).KillStrikeDots[I + (PerkIndex * 3)] = 0;
            }
            I++;
            // [Loop Continue]
            goto J0x1A9;
        }        
    }    
    WorldInfo.GRI.bForceNetUpdate = true;
    //return;    
}

function SelectPerk(int PerkNumber, PlayerController PC)
{
    local AdvPerk_Base PB;
    local bool Success;
    local int BonusScore, PerkIndex, NewKillStreakValue;
    local AdvPlayerControllerMP PCmp;
    local AdvGameSurvivalBase SurvGame;

    PCmp = AdvPlayerControllerMP(PC);
    // End:0x12E
    if((((((PCmp.Pawn.Health <= 0) || PCmp.IsInState('Dead')) || PCmp.IsInState('PlayerWaiting')) || PCmp.IsInState('Wounded')) || PCmp.IsInState('SurvivalWounded')) || !PCmp.MyAdvPlayerPawnMP.IsAliveAndWell())
    {
        return;
    }
    // End:0x941
    if((PerkNumber < Perks.Length) && Perks[PerkNumber] != none)
    {
        switch(Perks[PerkNumber].default.ActivationMethod.ActivationType)
        {
            // End:0x367
            case 0:
                // End:0x364
                if((int(PCmp.bAvaiblePerks[PerkNumber]) == int(1)) && !PCmp.MyAdvPlayerPawnMP.bIsMummy)
                {
                    PB = Spawn(Perks[PerkNumber]);
                    Success = PB.ActivatePerk(PC);
                    // End:0x328
                    if(Success)
                    {
                        PCmp.bAvaiblePerks[PerkNumber] = 0;
                        PCmp.ClientUpdateAvaiblePerks(PerkNumber, 0);
                        // End:0x325
                        if(AdvPlayerControllerMP(PC) != none)
                        {
                            AdvPlayerControllerMP(PC).SetKillStrikeUseMessage(PerkNumber, "");
                        }                        
                    }
                    else
                    {
                        return;
                    }
                    // End:0x364
                    if(PB.bDestroyAfterUse)
                    {
                        PB.Destroy();
                    }
                }
                // End:0x93E
                break;
            // End:0x93B
            case 1:
                // End:0x938
                if((int(PCmp.bAvaiblePerks[PerkNumber]) == int(1)) && !PCmp.MyAdvPlayerPawnMP.bIsMummy)
                {
                    PB = Spawn(Perks[PerkNumber]);
                    Success = PB.ActivatePerk(PC);
                    // End:0x8FC
                    if(Success)
                    {
                        SurvGame = AdvGameSurvivalBase(WorldInfo.Game);
                        // End:0x5A4
                        if(SurvGame != none)
                        {
                            // End:0x4C1
                            if(PerkNumber == 0)
                            {
                                BonusScore = SurvGame.BonusScoreForLeuchpistol;                                
                            }
                            else
                            {
                                // End:0x4FB
                                if(PerkNumber == 1)
                                {
                                    BonusScore = SurvGame.BonusScoreForDevastator;                                    
                                }
                                else
                                {
                                    // End:0x533
                                    if(PerkNumber == 2)
                                    {
                                        BonusScore = SurvGame.BonusScoreForMummy;
                                    }
                                }
                            }
                            PC.PlayerReplicationInfo.Score += float(BonusScore);
                            AdvPlayerControllerMP(PC).SetPerkBonusScoreMessage(BonusScore);
                        }
                        NewKillStreakValue = AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[1] - Perks[PerkNumber].default.ActivationMethod.Value;
                        AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[1] = NewKillStreakValue;
                        PerkIndex = 0;
                        J0x67C:

                        // End:0x7C2 [Loop If]
                        if(PerkIndex < Perks.Length)
                        {
                            // End:0x7B4
                            if((NewKillStreakValue < Perks[PerkIndex].default.ActivationMethod.Value) && int(AdvPlayerControllerMP(PC).bAvaiblePerks[PerkIndex]) == int(1))
                            {
                                AdvPlayerControllerMP(PC).bAvaiblePerks[PerkIndex] = 0;
                                AdvPlayerControllerMP(PC).ClientUpdateAvaiblePerks(PerkIndex, 0);
                                AdvPlayerControllerMP(PC).SetKillStrikeUseMessage(PerkIndex, "");
                            }
                            PerkIndex++;
                            // [Loop Continue]
                            goto J0x67C;
                        }
                        // End:0x83C
                        if(NewKillStreakValue >= Perks[PerkNumber].default.ActivationMethod.Value)
                        {
                            AdvPlayerControllerMP(PC).PlayKillStreakActiveAnim(PerkNumber);
                        }
                        // End:0x8F9
                        if((AdvPlayerController(PC) != none) && AdvGFxHudWrapper(AdvPlayerController(PC).myHUD) != none)
                        {
                            AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(PC).myHUD).HudMovie).SetKillStreakKillCount(NewKillStreakValue);
                        }                        
                    }
                    else
                    {
                        return;
                    }
                    // End:0x938
                    if(PB.bDestroyAfterUse)
                    {
                        PB.Destroy();
                    }
                }
                // End:0x93E
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    //return;    
}

function bool IncreaseKillStrikeScore(AdvPerk_Base.EActivationType ActivationType, Controller Winner, optional Controller Loser)
{
    switch(ActivationType)
    {
        // End:0x2F9
        case 0:
            // End:0xA5
            if(!AdvPlayerPawnMP(Winner.Pawn).bIsMummy)
            {
                AdvPRI(Winner.PlayerReplicationInfo).KillStrikePoints[int(ActivationType)]++;
            }
            // End:0xFE
            if(Loser != none)
            {
                AdvPRI(Loser.PlayerReplicationInfo).KillStrikePoints[int(ActivationType)] = 0;
            }
            // End:0x1FA
            if((AdvPlayerController(Winner) != none) && AdvGFxHudWrapper(AdvPlayerController(Winner).myHUD) != none)
            {
                AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Winner).myHUD).HudMovie).SetKillStreakKillCount(AdvPRI(Winner.PlayerReplicationInfo).KillStrikePoints[int(ActivationType)]);
            }
            // End:0x2F6
            if((AdvPlayerController(Loser) != none) && AdvGFxHudWrapper(AdvPlayerController(Loser).myHUD) != none)
            {
                AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Loser).myHUD).HudMovie).SetKillStreakKillCount(AdvPRI(Loser.PlayerReplicationInfo).KillStrikePoints[int(ActivationType)]);
            }
            // End:0x65C
            break;
        // End:0x659
        case 1:
            // End:0x379
            if(AdvPRI(Winner.PlayerReplicationInfo).KillStrikePoints[1] >= 8)
            {
                PlayerController(Winner).ClientPlaySound(FailedPickupSound);
                return false;                
            }
            else
            {
                // End:0x405
                if(!AdvPlayerPawnMP(Winner.Pawn).bIsMummy)
                {
                    AdvPRI(Winner.PlayerReplicationInfo).KillStrikePoints[int(ActivationType)]++;
                }
                // End:0x45E
                if(Loser != none)
                {
                    AdvPRI(Loser.PlayerReplicationInfo).KillStrikePoints[int(ActivationType)] = 0;
                }
                // End:0x55A
                if((AdvPlayerController(Winner) != none) && AdvGFxHudWrapper(AdvPlayerController(Winner).myHUD) != none)
                {
                    AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Winner).myHUD).HudMovie).SetKillStreakKillCount(AdvPRI(Winner.PlayerReplicationInfo).KillStrikePoints[int(ActivationType)]);
                }
                // End:0x656
                if((AdvPlayerController(Loser) != none) && AdvGFxHudWrapper(AdvPlayerController(Loser).myHUD) != none)
                {
                    AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Loser).myHUD).HudMovie).SetKillStreakKillCount(AdvPRI(Loser.PlayerReplicationInfo).KillStrikePoints[int(ActivationType)]);
                }
                // End:0x65C
                break;
            }
        // End:0xFFFF
        default:
            break;
    }
    // End:0x68B
    if(Perks.Length > 0)
    {
        PreparePerkNotification(PlayerController(Winner));        
    }
    return true;
    //return ReturnValue;    
}

function ResetKillStrike(AdvPlayerControllerMP PC)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x71 [Loop If]
    if(I < PC.bAvaiblePerks.Length)
    {
        PC.bAvaiblePerks[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[0] = 0;
    AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[1] = 0;
    PC.ResetKillStrikesOnHud(Perks.Length);
    //return;    
}

defaultproperties
{
    KillStrikeMessage="`n kills award enabled: `w"
    SurvivalKillStrikeMessage="Award enabled: `w"
    BonusScoreMessage="Perk used"
    FailedPickupSound=SoundCue'a_Accents.Cue.a_MPSignal_02'
}