class PainWeap_Base extends EvilWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var() config bool FireModeSwitch;
var bool bIsOffsetStored;
var config bool bPurchasedWeaponDLC;
var repnotify int AmmoAltCount;
var() config int MaxAmmoAltCount;
var() config int LowAmmoCountWarningThreshold;
var() config int LowAmmoAltCountWarningThreshold;
var(FirstPerson) config Vector SplitScreenPlayerViewOffset;
var Vector StoredViewOffset;
var array<TCrosshair> AvailableCrosshairs;

replication
{
    // Pos:0x000
    if(bNetOwner)
        AmmoAltCount;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x97
    if((PainGRI_SP(WorldInfo.GRI) != none) && PainGRI_SP(WorldInfo.GRI).b666AmmoCardEnabled)
    {
        MaxAmmoCount = 666;
        MaxAmmoAltCount = 666;
    }
    //return;    
}

function CreateCheckpointRecord(out InventoryRecord Record)
{
    super.CreateCheckpointRecord(Record);
    Record.AmmoAltCount = AmmoAltCount;
    //return;    
}

function ApplyCheckpointRecord(const out InventoryRecord Record)
{
    super.ApplyCheckpointRecord(Record);
    AmmoAltCount = Record.AmmoAltCount;
    //return;    
}

function ConsumeAmmo(byte FireModeNum)
{
    local GameReplicationInfo GRI;

    GRI = WorldInfo.GRI;
    AddAmmoForFireMode(FireModeNum, -ShotCost[int(FireModeNum)]);
    // End:0xAD
    if((GRI == none) || !GRI.IsCoopMultiplayerGame() && GRI.IsMultiplayerGame())
    {
        return;
    }
    // End:0x100
    if(int(FireModeNum) == int(0))
    {
        // End:0xFD
        if((AmmoCount < LowAmmoCountWarningThreshold) && !IsTimerActive('ShowLowAmmoWarning'))
        {
            ShowLowAmmoWarning();
        }        
    }
    else
    {
        // End:0x13C
        if((AmmoAltCount < LowAmmoAltCountWarningThreshold) && !IsTimerActive('ShowLowAmmoWarning'))
        {
            ShowLowAmmoWarning();
        }
    }
    //return;    
}

function int AddAmmoForFireMode(byte FireModeNum, int Amount)
{
    // End:0x123
    if((int(FireModeNum) < ShotCost.Length) && ShotCost[int(FireModeNum)] > 0)
    {
        // End:0x78
        if(int(FireModeNum) > int(0))
        {
            AmmoAltCount = Clamp(AmmoAltCount + Amount, 0, MaxAmmoAltCount);            
        }
        else
        {
            AmmoCount = Clamp(AmmoCount + Amount, 0, MaxAmmoCount);
        }
        // End:0xFB
        if((EvilInvManager == none) || EvilInvManager.bInfiniteAmmo)
        {
            AmmoCount = MaxAmmoCount;
            AmmoAltCount = MaxAmmoAltCount;
        }
        // End:0x119
        if(int(FireModeNum) > int(0))
        {
            return AmmoAltCount;
        }
        return AmmoCount;
    }
    return -1;
    //return ReturnValue;    
}

simulated function int GetAmmoCount(byte FireModeNum)
{
    // End:0x5F
    if((int(FireModeNum) < ShotCost.Length) && ShotCost[int(FireModeNum)] > 0)
    {
        // End:0x55
        if(int(FireModeNum) > int(0))
        {
            return AmmoAltCount;
        }
        return AmmoCount;
    }
    return -1;
    //return ReturnValue;    
}

simulated function int GetMaxAmmoCount(byte FireModeNum)
{
    // End:0x5F
    if((int(FireModeNum) < ShotCost.Length) && ShotCost[int(FireModeNum)] > 0)
    {
        // End:0x55
        if(int(FireModeNum) > int(0))
        {
            return MaxAmmoAltCount;
        }
        return MaxAmmoCount;
    }
    return -1;
    //return ReturnValue;    
}

simulated function bool AmmoMaxed(int Mode)
{
    // End:0x24
    if(Mode > 0)
    {
        return AmmoAltCount >= MaxAmmoAltCount;
    }
    return AmmoCount >= MaxAmmoCount;
    //return ReturnValue;    
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    // End:0x69
    if(Amount == 0)
    {
        // End:0x45
        if(int(FireModeNum) > int(0))
        {
            return AmmoAltCount >= ShotCost[int(FireModeNum)];
        }
        return AmmoCount >= ShotCost[int(FireModeNum)];        
    }
    else
    {
        // End:0x92
        if(int(FireModeNum) > int(0))
        {
            return AmmoAltCount >= Amount;
        }
        return AmmoCount >= Amount;
    }
    //return ReturnValue;    
}

simulated function bool HasAnyAmmo()
{
    return ((AmmoCount > 0) || AmmoAltCount > 0) || (ShotCost[0] == 0) && ShotCost[1] == 0;
    //return ReturnValue;    
}

simulated function bool NeedAmmo()
{
    return (AmmoCount < MaxAmmoCount) || AmmoAltCount < MaxAmmoAltCount;
    //return ReturnValue;    
}

simulated function bool NeedAmmoForFireMode(int FireModeNum)
{
    // End:0x24
    if(FireModeNum > 0)
    {
        return AmmoAltCount < MaxAmmoAltCount;
    }
    return AmmoCount < MaxAmmoCount;
    //return ReturnValue;    
}

simulated function float GetFireInterval(byte FireModeNum)
{
    return (FireInterval[int(FireModeNum)] * ((PKGame(WorldInfo.Game) != none) ? PKGame(WorldInfo.Game).ReloadSpeedFactor : 1.0000000)) * ((EvilPawn(Owner) != none) ? EvilPawn(Owner).FireRateMultiplier : 1.0000000);
    //return ReturnValue;    
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
    local Vector2D CrosshairSize;
    local int CrosshairIndex;
    local float X, Y, PickupScale, ScreenX, ScreenY;

    local UTHUDBase H;
    local float TargetDist;
    local PKPawn P;
    local PKPlayerController PC;
    local Vector ScreenPos;

    P = PKPawn(Owner);
    // End:0x2D
    if(P == none)
    {
        return;
    }
    PC = PKPlayerController(P.Controller);
    // End:0x6F
    if(PC == none)
    {
        return;
    }
    CrosshairIndex = PC.CrosshairIndex;
    // End:0xBA
    if(AvailableCrosshairs.Length <= CrosshairIndex)
    {
        CrosshairIndex = 0;
    }
    H = UTHUDBase(HUD);
    // End:0x142
    if(((H == none) || !bDisplayCrosshair) || PC.bCinematicMode && !PC.bFiringOnZipLine)
    {
        return;
    }
    TargetDist = GetTargetDistance();
    // End:0x29D
    if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.3000000))
    {
        // End:0x23E
        if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.1500000))
        {
            PickupScale = 1.0000000 + (float(5) * (WorldInfo.TimeSeconds - H.LastPickupTime));            
        }
        else
        {
            PickupScale = 1.0000000 + (float(5) * ((H.LastPickupTime + 0.3000000) - WorldInfo.TimeSeconds));
        }        
    }
    else
    {
        PickupScale = 1.0000000;
    }
    CrosshairColor = ((H.bGreenCrosshair) ? H.default.LightGreenColor : default.CrosshairColor);
    // End:0x416
    if(WorldInfo.GRI.GameClass == Class'PKGameDualStick')
    {
        ScreenPos = H.Canvas.Project(P.Location + PKDualStickPlayerController(PC).VirtualCursor);
        X = ScreenPos.X;
        Y = ScreenPos.Y;        
    }
    else
    {
        X = H.Canvas.ClipX * 0.5000000;
        Y = H.Canvas.ClipY * 0.5000000;
    }
    // End:0xBC6
    if(AvailableCrosshairs[CrosshairIndex].DotTex != none)
    {
        CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * AvailableCrosshairs[CrosshairIndex].DotCord.VL) * PickupScale) * H.Canvas.ClipY) / float(1440);
        CrosshairSize.X = CrosshairSize.Y * (AvailableCrosshairs[CrosshairIndex].DotCord.UL / AvailableCrosshairs[CrosshairIndex].DotCord.VL);
        ScreenX = X - (CrosshairSize.X * 0.5000000);
        ScreenY = Y - (CrosshairSize.Y * 0.5000000);
        H.Canvas.DrawColor = H.BlackColor;
        H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
        H.Canvas.DrawTile(AvailableCrosshairs[CrosshairIndex].DotTex, CrosshairSize.X, CrosshairSize.Y, AvailableCrosshairs[CrosshairIndex].DotCord.U, AvailableCrosshairs[CrosshairIndex].DotCord.V, AvailableCrosshairs[CrosshairIndex].DotCord.UL, AvailableCrosshairs[CrosshairIndex].DotCord.VL);
        H.Canvas.DrawColor = ((((WorldInfo.TimeSeconds - LastHitEnemyTime) < 0.3000000) || (EvilWeap_Base(P.WeaponLeft) != none) && (WorldInfo.TimeSeconds - EvilWeap_Base(P.WeaponLeft).LastHitEnemyTime) < 0.3000000) ? H.RedColor : CrosshairColor);
        H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
        H.Canvas.DrawTile(AvailableCrosshairs[CrosshairIndex].DotTex, CrosshairSize.X, CrosshairSize.Y, AvailableCrosshairs[CrosshairIndex].DotCord.U, AvailableCrosshairs[CrosshairIndex].DotCord.V, AvailableCrosshairs[CrosshairIndex].DotCord.UL, AvailableCrosshairs[CrosshairIndex].DotCord.VL);
    }
    //return;    
}

reliable server function ServerDoQuickAction(bool bAltFire)
{
    DoQuickAction(bAltFire);
    //return;    
}

simulated function DoQuickAction(bool bAltFire)
{
    // End:0x28
    if(int(Role) < int(ROLE_Authority))
    {
        ServerDoQuickAction(bAltFire);
    }
    ClearPendingFire(((bAltFire) ? 0 : 1));
    // End:0x73
    if(IsInState('Active'))
    {
        StartFire(((bAltFire) ? 1 : 0));        
    }
    else
    {
        SetPendingFire(((bAltFire) ? 1 : 0));
    }
    //return;    
}

reliable server function ServerEndQuickAction(bool bAltFire)
{
    EndQuickAction(bAltFire);
    //return;    
}

simulated function EndQuickAction(bool bAltFire)
{
    // End:0x28
    if(int(Role) < int(ROLE_Authority))
    {
        ServerEndQuickAction(bAltFire);
    }
    ClearPendingFire(((bAltFire) ? 1 : 0));
    // End:0x6D
    if(IsFiring())
    {
        StopFire(((bAltFire) ? 1 : 0));
    }
    //return;    
}

simulated function bool HasWeaponModifier()
{
    // End:0x5C
    if((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool CanCountShoots()
{
    return true;
    //return ReturnValue;    
}

static simulated function bool CanCountHitsByWeaponDamage(class<DamageType> DamageType)
{
    local bool bResult;

    bResult = true;
    // End:0x33
    if(ClassIsChildOf(DamageType, Class'PKDmgType_Painkiller'))
    {
        bResult = false;        
    }
    else
    {
        // End:0x5A
        if(ClassIsChildOf(DamageType, Class'PKDmgType_PainkillerBeam'))
        {
            bResult = false;            
        }
        else
        {
            // End:0x81
            if(ClassIsChildOf(DamageType, Class'PKDmgType_PainkillerBladesRotating'))
            {
                bResult = false;                
            }
            else
            {
                // End:0xA5
                if(ClassIsChildOf(DamageType, Class'PKDmgType_SoulReaper'))
                {
                    bResult = false;
                }
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

simulated function FireAmmunition()
{
    local PKPlayerController PKPC;
    local int ShootsAmount;

    super.FireAmmunition();
    // End:0x173
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(Owner), EvilPlayer_interface(none)) && CanCountShoots())
    {
        PKPC = PKPlayerController(EvilPlayer_interface(Owner).GetPC());
        // End:0x173
        if(PKPC != none)
        {
            ShootsAmount = 1;
            // End:0x103
            if(ClassIsChildOf(self.Class, Class'PKWeap_Boltgun_Base'))
            {
                // End:0xE0
                if(int(CurrentFireMode) == int(0))
                {
                    ShootsAmount = 5;                    
                }
                else
                {
                    // End:0x100
                    if(int(CurrentFireMode) == int(1))
                    {
                        ShootsAmount = 10;
                    }
                }                
            }
            else
            {
                // End:0x148
                if(ClassIsChildOf(self.Class, Class'PKWeap_Shotgun_Base'))
                {
                    // End:0x148
                    if(int(CurrentFireMode) == int(0))
                    {
                        ShootsAmount = 15;
                    }
                }
            }
            PKPC.IncrementGlobalIntStat(125, ShootsAmount);
        }
    }
    //return;    
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    super.AttachWeaponTo(MeshCpnt, SocketName);
    // End:0xAF
    if(Class'Engine.Engine'.static.IsSplitScreen() && Instigator.IsFirstPerson())
    {
        // End:0x91
        if(!bIsOffsetStored)
        {
            StoredViewOffset = PlayerViewOffset;
            bIsOffsetStored = true;
        }
        PlayerViewOffset = StoredViewOffset + SplitScreenPlayerViewOffset;
    }
    // End:0x133
    if((Instigator != none) && PKPlayerController(Instigator.Controller) != none)
    {
        BobDamping = PKPlayerController(Instigator.Controller).GlobalWeaponBobDamping;
    }
    //return;    
}

simulated function RefreshWeaponParamsFromPC(PKPlayerController PC)
{
    BobDamping = PC.GlobalWeaponBobDamping;
    //return;    
}

simulated function float GetCurrentSpread(byte FireModeNum)
{
    local float CurrentSpread, CalculatedShotSpread;

    CurrentSpread = Spread[int(FireModeNum)];
    CalculatedShotSpread = ShotSpreadHelper * ShotSpreadModifier;
    // End:0xC7
    if((CalculatedShotSpread > WeaponSpreadMax[int(FireModeNum)]) && ShotSpreadModifier != float(0))
    {
        ShotSpreadHelper -= ((CalculatedShotSpread - WeaponSpreadMax[int(FireModeNum)]) / ShotSpreadModifier);
        CalculatedShotSpread = ShotSpreadHelper * ShotSpreadModifier;
    }
    CurrentSpread += CalculatedShotSpread;
    // End:0x1E1
    if(((CurrentShotCount == 0) && NumberOfShots[int(FireModeNum)] == 1) && !MoveSpreadState || JumpSpreadState)
    {
        // End:0x18C
        if(bFastRepeater)
        {
            return (CurrentSpread * 0.9000000) * UpgradeInfo.GetBaseSpreadForLevel(((BaseSpreadUpgradeLevel > 0) ? BaseSpreadUpgradeLevel : UpgradeLevelGlobal));            
        }
        else
        {
            return (CurrentSpread * 0.2000000) * UpgradeInfo.GetBaseSpreadForLevel(((BaseSpreadUpgradeLevel > 0) ? BaseSpreadUpgradeLevel : UpgradeLevelGlobal));
        }
    }
    return CurrentSpread * UpgradeInfo.GetBaseSpreadForLevel(((BaseSpreadUpgradeLevel > 0) ? BaseSpreadUpgradeLevel : UpgradeLevelGlobal));
    //return ReturnValue;    
}

simulated function ShowLowAmmoWarning()
{
    // End:0x128
    if(((PKPawn(Owner) != none) && PKPlayerController(PKPawn(Owner).Controller) != none) && PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD) != none)
    {
        PainGFxHud(PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD).HudMovie).ShowLowAmmo();
    }
    super.ShowLowAmmoWarning();
    //return;    
}

simulated function HideLowAmmoWarning()
{
    // End:0x191
    if(((PKPawn(Owner) != none) && PKPlayerController(PKPawn(Owner).Controller) != none) && PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD) != none)
    {
        // End:0x191
        if(PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD).HudMovie != none)
        {
            PainGFxHud(PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD).HudMovie).HideLowAmmo();
        }
    }
    super.HideLowAmmoWarning();
    //return;    
}

simulated function ShowNoAmmoWarning()
{
    // End:0x128
    if(((PKPawn(Owner) != none) && PKPlayerController(PKPawn(Owner).Controller) != none) && PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD) != none)
    {
        PainGFxHud(PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD).HudMovie).ShowNoAmmo();
    }
    super.ShowNoAmmoWarning();
    //return;    
}

simulated function HideNoAmmoWarning()
{
    // End:0x191
    if(((PKPawn(Owner) != none) && PKPlayerController(PKPawn(Owner).Controller) != none) && PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD) != none)
    {
        // End:0x191
        if(PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD).HudMovie != none)
        {
            PainGFxHud(PainGFxHudWrapper(PKPlayerController(PKPawn(Owner).Controller).myHUD).HudMovie).HideNoAmmo();
        }
    }
    super.HideNoAmmoWarning();
    //return;    
}

simulated state ComboFire extends WeaponFiring
{
    simulated function bool ShouldRefire()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function HandleFinishedFiring()
    {
        StopFire(CurrentFireMode);
        super(EvilWeap_Base).HandleFinishedFiring();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        StopFire(CurrentFireMode);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    LowAmmoCountWarningThreshold=10
    LowAmmoAltCountWarningThreshold=10
    SplitScreenPlayerViewOffset=(X=-10.0000000,Y=0.0000000,Z=-15.0000000)
    AvailableCrosshairs[0]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.crosshair_tex',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[1]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross1',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[2]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross2',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[3]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross3',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[4]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross4',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[5]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross5',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[6]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross6',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[7]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross7',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[8]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross8',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[9]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross9',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[10]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross91',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[11]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross92',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[12]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross93',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[13]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross94',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[14]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross95',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[15]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross96',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[16]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross97',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[17]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross98',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[18]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross99',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[19]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross991',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[20]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross992',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[21]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross993',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[22]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross994',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[23]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross995',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[24]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross996',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[25]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross997',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[26]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross998',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[27]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross999',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[28]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross9991',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[29]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross9992',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[30]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross9993',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    AvailableCrosshairs[31]=(UpTex=none,UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DownTex=none,DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),LeftTex=none,LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),RightTex=none,RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),DotTex=Texture2D'PKHD_HUD.cross9994',DotCord=(U=0.0000000,V=0.0000000,UL=64.0000000,VL=64.0000000))
    bSuppressAutoReload=true
    BothHandWeapon=true
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponCloseDamageMaxMultiplier=1.0000000
    WeaponCloseDamageDistance=0.0000000
    NumberOfShots=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponSpreadMax=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    FireCameraAnimScale=/* Array type was not detected. */
    ShotSpreadModifier=0.0001000
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    EffectSockets=/* Array type was not detected. */
    CrosshairScaling=2.2000000
    DroppedPickupOffsetZ=-30.0000000
    bZoomedFireMode=/* Array type was not detected. */
    WeaponFireAnim=/* Array type was not detected. */
    ArmFireAnim=/* Array type was not detected. */
    // Reference: AudioComponent'Default__PainWeap_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'EvilGame.Default__EvilWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    WeaponFireSnd=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    BackForceVector=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BackForceMax=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    ShotDistortionVector=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    ShotDistortionMax=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    RecoilDelta=0.0000000
    RecoilMax=0.0000000
    MuzzleFlashSocket=/* Array type was not detected. */
    SmokeTracePS=ParticleSystem'ps_wp_MuzzleBase.Effects.ps_Smokefromtrace'
    AimingHelpRadius=/* Array type was not detected. */
    FiringStatesArray=/* Array type was not detected. */
    WeaponFireTypes=/* Array type was not detected. */
    WeaponProjectiles=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'EvilGame.Default__EvilWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ShouldFireOnRelease=/* Array type was not detected. */
    DroppedPickupClass=Class'EvilGame.UTDroppedPickup'
    // Reference: SkeletalMeshComponent'Default__PainWeap_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}