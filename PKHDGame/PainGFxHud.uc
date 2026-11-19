class PainGFxHud extends EvilGFxHud
    config(UI);

struct TBossIconMap
{
    var string IconName;
    var Class BossClass;

    structdefaultproperties
    {
        IconName=""
        BossClass=none
    }
};

struct HeadshotInfo
{
    var GFxObject GFx;
    var float ElapsedTime;
    var float MinimalTime;
    var float PersistTime;

    structdefaultproperties
    {
        GFx=none
        ElapsedTime=0.0000000
        MinimalTime=0.0000000
        PersistTime=0.0000000
    }
};

struct THitLocIndicator
{
    var GFxObject GFx;
    var Vector ShotLoc;
    var float TimeOfHit;

    structdefaultproperties
    {
        GFx=none
        ShotLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        TimeOfHit=0.0000000
    }
};

struct GrenadeIndicator
{
    var GFxObject GFx;
    var Projectile Proj;

    structdefaultproperties
    {
        GFx=none
        Proj=none
    }
};

var GFxObject TopMC;
var GFxObject RightMC;
var GFxObject LeftMC;
var GFxObject BottomMC;
var GFxObject KillsMC;
var GFxObject KillsTF;
var GFxObject SoulsMC;
var GFxObject SoulsTF;
var GFxObject ArmorMC;
var GFxObject ArmorTF;
var GFxObject HealthMC;
var GFxObject HealthTF;
var GFxObject Ammo1MC;
var GFxObject Ammo1TF;
var GFxObject Ammo2MC;
var GFxObject Ammo2TF;
var GFxObject LeftTopMC;
var array<GFxObject> StatMC;
var array<GFxObject> StatVal;
var array<GFxObject> StatLabel;
var GFxObject AmmoIconsMC;
var GFxObject Ammo1IconMC;
var GFxObject Ammo2IconMC;
var GFxObject AmmoInfinityUpMC;
var GFxObject AmmoInfinityDownMC;
var GFxObject ArrowMC;
var GFxObject Arrow;
var GFxObject ArrowUp;
var GFxObject ArrowDown;
var Actor CurrentArrowTarget;
var() float SameFloorThreshold;
var GFxObject CenterTextMC;
var GFxObject CenterTextTF;
var GFxObject HintTextMC;
var GFxObject HintTextTF;
var GFxObject TutorialMessageMC;
var GFxObject TutorialMessageTF;
var GFxObject ObjectiveMessageMC;
var GFxObject ObjectiveMessageTF;
var GFxObject GhostTimeMC;
var GFxObject GhostTimeMask;
var GFxObject GhostTimeIconMC;
var GFxObject BossHealthMC;
var GFxObject BossHealthMask;
var GFxObject BossHealthIconMC;
var array<TBossIconMap> BossIconMap;
var array<GFxObject> CardsMC;
var array<GFxObject> Cards_g;
var array<GFxObject> CardsTF;
var GFxObject ReloadMC;
var GFxObject ReloadTextTF;
var transient bool bReloadVisible;
var transient bool bLowAmmoVisible;
var transient bool bNoAmmoVisible;
var HeadshotInfo CurrentHeadshot;
var int HeadshotCount;
var GFxObject HeadshotMC;
var GFxObject HitLocMC[8];
var GFxObject MultiKillN_TF;
var GFxObject MultiKillMsg_TF;
var GFxObject MultiKillMC;
var GFxObject ReticuleMC;
var GFxObject HitLocIndicator;
var array<THitLocIndicator> HitLocIndicators;
var int HitLocIndicatorsCount;
var array<GrenadeIndicator> GrenadeIndicators;
var int GrenadeIndicatorsCount;
var const localized string Reload;
var const localized string HeadshotString;
var const localized string CompassString;
var const localized string FlashlightString;
var const localized string MapString;
var const localized string POIString;
var const localized string TimeString;
var const localized string ScoreString;
var const localized string LivesString;
var const localized string LowAmmoString;
var const localized string NoAmmoString;
var float LastCompassRotation;
var float TimeElapsedForSin;
var float ArrowAlpha;
var transient float DefaultLogY;

function AddDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Killed, class<EvilDmgType_Base> Dmg)
{
    local string msg;
    local byte Index;

    // End:0x37
    if(Killer != none)
    {
        msg = Killer.PlayerName;
    }
    // End:0xA9
    if((Dmg != none) && Dmg.default.DamageWeaponClass != none)
    {
        Index = Dmg.default.DamageWeaponClass.default.InventoryGroup;
    }
    // End:0xFE
    if(int(Index) < int(12))
    {        
        msg @= (("<img src='ut3_weapon" $ string(Index)) $ "'>");        
    }
    else
    {        
        msg @= "<img src='skull'>";
    }    
    msg @= Killed.PlayerName;
    AddMessage("htmlText", msg);
    //return;    
}

function Init(optional LocalPlayer Player)
{
    local int I;

    super.Init(Player);
    bReloadVisible = false;
    bLowAmmoVisible = false;
    bNoAmmoVisible = false;
    CenterTextTF = GetVariableObject("_root.HUD.centerTextMC.centerText.textField");
    CenterTextMC = GetVariableObject("_root.HUD.centerTextMC");
    HintTextTF = GetVariableObject("_root.HUD.hinttextMC.hinttext.textField");
    HintTextMC = GetVariableObject("_root.HUD.hinttextMC");
    TutorialMessageTF = GetVariableObject("_root.HUD.TutorialMessageMC.textField");
    TutorialMessageMC = GetVariableObject("_root.HUD.TutorialMessageMC");
    ObjectiveMessageTF = GetVariableObject("_root.HUD.survivalSP.survivalSPMC.textField");
    ObjectiveMessageMC = GetVariableObject("_root.HUD.survivalSP");
    ReloadMC = GetVariableObject("_root.HUD.reload");
    ReloadTextTF = GetVariableObject("_root.HUD.reload.text.textField");
    HeadshotMC = GetVariableObject("_root.HUD.HeadshotMC");
    ReticuleMC = GetVariableObject("_root.HUD.reticule");
    HitLocMC[0] = GetVariableObject("_root.HUD.dirHit.t");
    HitLocMC[1] = GetVariableObject("_root.HUD.dirHit.tr");
    HitLocMC[2] = GetVariableObject("_root.HUD.dirHit.r");
    HitLocMC[3] = GetVariableObject("_root.HUD.dirHit.br");
    HitLocMC[4] = GetVariableObject("_root.HUD.dirHit.b");
    HitLocMC[5] = GetVariableObject("_root.HUD.dirHit.bl");
    HitLocMC[6] = GetVariableObject("_root.HUD.dirHit.l");
    HitLocMC[7] = GetVariableObject("_root.HUD.dirHit.tl");
    HitLocIndicator = GetVariableObject("_root.HUD.dirHit.indicator");
    RootMC = GetVariableObject("_root");
    HudMC = RootMC.GetObject("HUD");
    HUDOverlay = HudMC.GetObject("hudoverlay");
    TopMC = HudMC.GetObject("top");
    RightMC = HudMC.GetObject("right");
    LeftMC = HudMC.GetObject("left");
    BottomMC = HudMC.GetObject("bottom");
    LeftTopMC = HudMC.GetObject("lefttop");
    KillsMC = TopMC.GetObject("kills");
    SoulsMC = TopMC.GetObject("souls");
    KillsTF = KillsMC.GetObject("textField");
    SoulsTF = SoulsMC.GetObject("textField");
    HealthMC = LeftMC.GetObject("health");
    ArmorMC = LeftMC.GetObject("armor");
    HealthTF = HealthMC.GetObject("textField");
    ArmorTF = ArmorMC.GetObject("textField");
    Ammo1MC = RightMC.GetObject("ammo1");
    Ammo2MC = RightMC.GetObject("ammo2");
    Ammo1TF = Ammo1MC.GetObject("textField");
    Ammo2TF = Ammo2MC.GetObject("textField");
    AmmoIconsMC = RightMC.GetObject("icons");
    Ammo1IconMC = AmmoIconsMC.GetObject("ammo1");
    Ammo2IconMC = AmmoIconsMC.GetObject("ammo2");
    AmmoInfinityUpMC = RightMC.GetObject("infinity_up");
    AmmoInfinityDownMC = RightMC.GetObject("infinity_down");
    ArrowMC = TopMC.GetObject("arrowMC");
    Arrow = ArrowMC.GetObject("arrow");
    ArrowUp = ArrowMC.GetObject("arrowup");
    ArrowDown = ArrowMC.GetObject("arrowdown");
    GhostTimeMC = TopMC.GetObject("ghostmode");
    GhostTimeMask = GhostTimeMC.GetObject("mask");
    GhostTimeIconMC = GhostTimeMC.GetObject("ghostmodeicon");
    BossHealthMC = TopMC.GetObject("bosshealth");
    BossHealthMask = BossHealthMC.GetObject("mask");
    BossHealthIconMC = BossHealthMC.GetObject("icon");
    I = 0;
    J0xB18:

    // End:0xC10 [Loop If]
    if(I < 3)
    {
        StatMC[I] = LeftTopMC.GetObject(("stat" $ string(I + 1)) $ "MC");
        StatVal[I] = StatMC[I].GetObject("value");
        StatLabel[I] = StatMC[I].GetObject("label");
        I++;
        // [Loop Continue]
        goto J0xB18;
    }
    I = 0;
    J0xC1B:

    // End:0xD42 [Loop If]
    if(I < 3)
    {
        CardsMC[I] = GFxClikWidget(BottomMC.GetObject("card" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        CardsTF[I] = CardsMC[I].GetObject("CardTF").GetObject("textField");
        Cards_g[I] = CardsMC[I].GetObject("Card_g");
        I++;
        // [Loop Continue]
        goto J0xC1B;
    }
    UpdateChosenCards();
    HealthTF.SetBool("html", true);
    ArmorTF.SetBool("html", true);
    SetHUDElementsVisible(false);
    bVisibilityNeedsUpdate = true;
    DefaultLogY = LogMC.GetFloat("_y");
    SetHUDScale(PKPlayerController(GetPC()).HUDScale);
    //return;    
}

function UpdateChosenCards()
{
    local int I;
    local PainGRI PGRI;

    PGRI = PainGRI(GetPC().WorldInfo.GRI);
    I = 0;
    J0x52:

    // End:0x161 [Loop If]
    if(I < 3)
    {
        // End:0x129
        if((PGRI != none) && int(PGRI.SelectedGoldCards[I]) != int(0))
        {
            CardsTF[I].SetText(" ");
            Cards_g[I].GotoAndStopI(int(PGRI.SelectedGoldCards[I]));            
        }
        else
        {
            CardsMC[I].SetVisible(false);
        }
        I++;
        // [Loop Continue]
        goto J0x52;
    }
    //return;    
}

function SetHUDScale(float Scale)
{
    local ASDisplayInfo DI;

    DI.hasXScale = true;
    DI.hasYScale = true;
    DI.XScale = Scale * float(100);
    DI.YScale = Scale * float(100);
    TopMC.SetDisplayInfo(DI);
    LeftMC.SetDisplayInfo(DI);
    RightMC.SetDisplayInfo(DI);
    LeftTopMC.SetDisplayInfo(DI);
    DI.XScale = Scale * float(80);
    DI.YScale = Scale * float(80);
    BottomMC.SetDisplayInfo(DI);
    LogMC.SetFloat("_y", DefaultLogY - (float(80) * (Scale - 0.8000000)));
    //return;    
}

function SetHUDElementsVisible(bool Visible)
{
    local GameReplicationInfo PGRI;

    PGRI = GetPC().WorldInfo.GRI;
    super.SetHUDElementsVisible(Visible);
    // End:0xCE
    if((PGRI == none) || !PGRI.IsCoopMultiplayerGame() && PGRI.IsMultiplayerGame())
    {
        TopMC.SetVisible(false);        
    }
    else
    {
        TopMC.SetVisible(Visible);
    }
    LeftMC.SetVisible(Visible);
    RightMC.SetVisible(Visible);
    BottomMC.SetVisible(Visible);
    // End:0x1C9
    if(PainGRI(PGRI).IsSingleSurvivalGame())
    {
        LeftTopMC.SetVisible(Visible);        
    }
    else
    {
        LeftTopMC.SetVisible(false);
    }
    ArrowMC.SetVisible(false);
    BossHealthMC.SetVisible(false);
    GhostTimeMC.SetVisible(false);
    //return;    
}

function GFxObject CreateMessageRow()
{
    return LogMC.AttachMovie("LogMessage", "logMessage" $ string(NumMessages++));
    //return ReturnValue;    
}

function GFxObject InitMessageRow()
{
    local MessageRow mrow;

    mrow.Y = 0;
    mrow.MC = CreateMessageRow();
    mrow.TF = mrow.MC.GetObject("message").GetObject("textField");
    mrow.TF.SetBool("html", true);
    mrow.TF.SetString("htmlText", "");
    FreeMessages.AddItem(mrow);
    return mrow.MC;
    //return ReturnValue;    
}

function RemoveMessage()
{
    //return;    
}

function AddMessage(string Type, string msg)
{
    local MessageRow mrow;
    local ASDisplayInfo DI;
    local int J;

    // End:0x13
    if(Len(msg) == 0)
    {
        return;
    }
    // End:0x60
    if(FreeMessages.Length > 0)
    {
        mrow = FreeMessages[FreeMessages.Length - 1];
        FreeMessages.Remove(FreeMessages.Length - 1, 1);        
    }
    else
    {
        mrow = Messages[Messages.Length - 1];
        Messages.Remove(Messages.Length - 1, 1);
    }
    mrow.TF.SetString(Type, msg);
    mrow.Y = 0;
    DI.hasY = true;
    DI.Y = 0.0000000;
    mrow.MC.SetDisplayInfo(DI);
    mrow.MC.GotoAndPlay("show");
    J = 0;
    J0x1BC:

    // End:0x29F [Loop If]
    if(J < Messages.Length)
    {
        Messages[J].Y -= int(MessageHeight);
        DI.Y = float(Messages[J].Y);
        Messages[J].MC.SetDisplayInfo(DI);
        J++;
        // [Loop Continue]
        goto J0x1BC;
    }
    Messages.InsertItem(0, mrow);
    //return;    
}

function TickHud(float DeltaTime)
{
    local PKPlayerPawn UTP;
    local EvilVehicle_Base UTV;
    local UTWeaponPawn UWP;
    local PainWeap_Base Weapon;
    local PKPlayerController PC;
    local PainPRI PRI;
    local PainGRI PKGRI;
    local string HealthText, ArmorText;

    PC = PKPlayerController(GetPC());
    // End:0x2E
    if(PC == none)
    {
        return;
    }
    GRI = EvilGameReplicationInfo(PC.WorldInfo.GRI);
    PKGRI = PainGRI(PC.WorldInfo.GRI);
    PRI = PainPRI(PC.PlayerReplicationInfo);
    UTP = PKPlayerPawn(PC.Pawn);
    // End:0x269
    if(UTP == none)
    {
        UTV = EvilVehicle_Base(PC.Pawn);
        // End:0x210
        if(UTV == none)
        {
            UWP = UTWeaponPawn(PC.Pawn);
            // End:0x20D
            if(UWP != none)
            {
                UTV = EvilVehicle_Base(UWP.MyVehicle);
                UTP = PKPlayerPawn(UWP.Driver);
            }            
        }
        else
        {
            UTP = PKPlayerPawn(UTV.Driver);
        }
        // End:0x269
        if(UTV == none)
        {
            SetHUDElementsVisible(false);
            bVisibilityNeedsUpdate = true;
            return;
        }
    }
    Weapon = PainWeap_Base(UTP.Weapon);
    // End:0x53D
    if(Weapon != none)
    {
        // End:0x312
        if((float(Weapon.MagazineAmmoCount) / float(Weapon.MagazineMaxAmmoCount)) < 0.3000000)
        {
            // End:0x30F
            if(!bReloadVisible)
            {
                ShowReload(true);
            }            
        }
        else
        {
            // End:0x32A
            if(bReloadVisible)
            {
                ShowReload(false);
            }
        }
        // End:0x395
        if(Weapon.ShotCost[0] == 0)
        {
            Ammo1TF.SetText("");
            AmmoInfinityUpMC.SetVisible(true);            
        }
        else
        {
            Ammo1TF.SetText(string(Weapon.AmmoCount));
            AmmoInfinityUpMC.SetVisible(false);
        }
        // End:0x460
        if(Weapon.ShotCost[1] == 0)
        {
            Ammo2TF.SetText("");
            AmmoInfinityDownMC.SetVisible(true);            
        }
        else
        {
            Ammo2TF.SetText(string(Weapon.AmmoAltCount));
            AmmoInfinityDownMC.SetVisible(false);
        }
        Ammo1IconMC.GotoAndStop(Weapon.WeaponName);
        Ammo2IconMC.GotoAndStop(Weapon.WeaponName);        
    }
    else
    {
        Ammo1TF.SetText("");
        Ammo2TF.SetText("");
        AmmoInfinityUpMC.SetVisible(false);
        AmmoInfinityDownMC.SetVisible(false);
    }
    // End:0x7F1
    if((UTP != none) && PRI != none)
    {
        // End:0x682
        if((float(UTP.Health) / UTP.DefaultHealth) < 0.2600000)
        {
            HealthText = ("<Color:R=0.55,G=0.0,B=0.0>" $ string(UTP.Health)) $ "</Color>";            
        }
        else
        {
            HealthText = string(UTP.Health);
        }
        // End:0x6DE
        if(UTP.bFrozenArmour)
        {
            ArmorText = "0";            
        }
        else
        {
            ArmorText = string(UTP.Armour);
        }
        HealthTF.SetString("htmlText", HealthText);
        ArmorTF.SetString("htmlText", ArmorText);
        SoulsTF.SetText(string(PKGRI.TotalSoulsCollected));
        KillsTF.SetText(string(PKGRI.MonstersKilled));        
    }
    else
    {
        SoulsTF.SetText("");
        KillsTF.SetText("");
        HealthTF.SetString("htmlText", "");
        ArmorTF.SetString("htmlText", "");
    }
    // End:0x8A7
    if(HitLocIndicators.Length > 0)
    {
        UpdateHitLocIndicators();
    }
    UpdateSingleSurvivalStats();
    UpdateCompass(DeltaTime);
    super.TickHud(DeltaTime);
    //return;    
}

simulated function UpdateSingleSurvivalStats()
{
    local PKPlayerController PC;
    local PainGRI PKGRI;
    local int I, CurrentStatIndex;

    PC = PKPlayerController(GetPC());
    // End:0x2E
    if(PC == none)
    {
        return;
    }
    PKGRI = PainGRI(PC.WorldInfo.GRI);
    CurrentStatIndex = 0;
    // End:0x4BA
    if((PKGRI != none) && PKGRI.IsSingleSurvivalGame())
    {
        // End:0x1E9
        if(PKGRI.TimeLimit != 0)
        {
            StatMC[CurrentStatIndex].SetVisible(true);
            StatLabel[CurrentStatIndex].SetText(TimeString);
            StatVal[CurrentStatIndex].SetText(Class'PKGFxUI_Scoreboard'.static.FormatTime(((PKGRI.TimeLimit != 0) ? PKGRI.RemainingTime : PKGRI.ElapsedTime)));
            CurrentStatIndex++;
        }
        // End:0x300
        if(PC.WorldInfo.Game.GoalScore != 0)
        {
            StatMC[CurrentStatIndex].SetVisible(true);
            StatLabel[CurrentStatIndex].SetText(ScoreString);
            StatVal[CurrentStatIndex].SetText(string(int(PC.PlayerReplicationInfo.Score)));
            CurrentStatIndex++;
        }
        // End:0x45F
        if(PC.WorldInfo.Game.MaxLives > 1)
        {
            StatMC[CurrentStatIndex].SetVisible(true);
            StatLabel[CurrentStatIndex].SetText(LivesString);
            StatVal[CurrentStatIndex].SetText(string(PC.WorldInfo.Game.MaxLives - PC.PlayerReplicationInfo.NumLives));
            CurrentStatIndex++;
        }
        I = CurrentStatIndex;
        J0x472:

        // End:0x4BA [Loop If]
        if(I < 3)
        {
            StatMC[I].SetVisible(false);
            I++;
            // [Loop Continue]
            goto J0x472;
        }
    }
    //return;    
}

function FlashSoulCollectedInGhost()
{
    GhostTimeIconMC.GotoAndPlay("glow");
    //return;    
}

function UpdateCompass(float DeltaTime)
{
    local PKPawn P;
    local PKPawn_Boss_Base BossPawn;
    local PainItemBaseSkelMesh Obj;
    local PainCheckpoint Checkpoint;
    local float BestDistance, TargetDistance;
    local Vector BestLocation, Loc;
    local Rotator Rot;
    local bool bIsCheckpoint;

    // End:0x98
    if(PKPlayerController(GetPC()).IsGhost())
    {
        ArrowMC.SetVisible(false);
        BossHealthMC.SetVisible(false);
        GhostTimeMC.SetVisible(true);
        UpdateGhostTime();
        return;
    }
    BossPawn = none;
    bIsCheckpoint = false;
    BestDistance = 999999.0000000;
    BestLocation = vect(0.0000000, 0.0000000, 0.0000000);
    CurrentArrowTarget = none;
    GetPC().GetPlayerViewPoint(Loc, Rot);
    // End:0x2D9
    foreach GetPC().DynamicActors(Class'PKPawn', P)
    {
        // End:0x1A5
        if((PKPawn_Boss_Base(P) != none) && PKPawn_Boss_Base(P).bIsReallyBoss)
        {
            BossPawn = PKPawn_Boss_Base(P);
            // End:0x2D9
            break;
        }
        // End:0x2D8
        if(((EqualEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none)) && P.IsAliveAndWell()) && !P.bDeleteMe) && !P.bAmbientCreature)
        {
            TargetDistance = VSize(P.Location - Loc);
            // End:0x2D8
            if(BestDistance > TargetDistance)
            {
                BestDistance = TargetDistance;
                BestLocation = P.Location;
                CurrentArrowTarget = P;
            }
        }        
    }    
    // End:0x372
    if(BossPawn != none)
    {
        ArrowMC.SetVisible(false);
        BossHealthMC.SetVisible(true);
        GhostTimeMC.SetVisible(false);
        UpdateBossHealth(BossPawn);
        CurrentArrowTarget = BossPawn;        
    }
    else
    {
        // End:0x4D7
        foreach GetPC().DynamicActors(Class'PainItemBaseSkelMesh', Obj)
        {
            Checkpoint = PainCheckpoint(Obj);
            // End:0x427
            if((Checkpoint != none) && Checkpoint.IsCheckpointEnabled())
            {
                BestLocation = Checkpoint.Location;
                bIsCheckpoint = true;                
            }
            else
            {
                // End:0x4B3
                if(((PainEndOfLevel(Obj) != none) || PainEndOfGame(Obj) != none) && !Obj.bHidden)
                {
                    BestLocation = Obj.Location;
                    bIsCheckpoint = true;
                }
            }
            // End:0x4D6
            if(bIsCheckpoint)
            {
                CurrentArrowTarget = Obj;
                // End:0x4D7
                break;
            }            
        }        
        ArrowMC.SetVisible(true);
        BossHealthMC.SetVisible(false);
        GhostTimeMC.SetVisible(false);
        UpdateCompassArrow(BestLocation, bIsCheckpoint, DeltaTime);
    }
    //return;    
}

function UpdateGhostTime()
{
    local int TimePerc, TimeScale;

    TimePerc = int((PKPlayerController(GetPC()).TimeRemainingInGhost / PainGRI_SP(GetPC().WorldInfo.GRI).TimeToRespawnInCOOP) * float(100));
    TimeScale = Clamp(TimePerc, 0, 99);
    GhostTimeMask.GotoAndStopI(100 - TimeScale);
    //return;    
}

function UpdateBossHealth(PKPawn_Boss_Base BossPawn)
{
    local int HealthScale;
    local TBossIconMap BossIconIt;

    HealthScale = Clamp(BossPawn.HealthPercentage, 0, 99);
    BossHealthMask.GotoAndStopI(100 - HealthScale);
    // End:0xEF
    foreach BossIconMap(BossIconIt)
    {
        // End:0xEE
        if(ClassIsChildOf(BossPawn.Class, BossIconIt.BossClass))
        {
            BossHealthIconMC.GotoAndStop(BossIconIt.IconName);            
        }
        else
        {            
        }
    }    
    //return;    
}

function UpdateCompassArrow(Vector Location, bool bIsCheckpoint, float DeltaTime)
{
    local Vector Loc;
    local Rotator Rot;
    local float DirOfTarget;
    local Vector AxisX, AxisY, AxisZ, TargetDirection;
    local bool bIsInFront;
    local Vector2D AngularDist;
    local ASDisplayInfo DI;

    GetPC().GetPlayerViewPoint(Loc, Rot);
    GetAxes(Rot, AxisX, AxisY, AxisZ);
    DI.hasRotation = true;
    DI.hasAlpha = true;
    ArrowDown.SetVisible(false);
    ArrowUp.SetVisible(false);
    // End:0x10B
    if(bIsCheckpoint)
    {
        Arrow.GotoAndStop("glow");        
    }
    else
    {
        Arrow.GotoAndStop("normal");
    }
    // End:0x44E
    if(Location != vect(0.0000000, 0.0000000, 0.0000000))
    {
        TargetDirection = Normal(Location - Loc);
        bIsInFront = GetAngularDistance(AngularDist, TargetDirection, AxisX, AxisY, AxisZ);
        GetAngularDegreesFromRadians(AngularDist);
        // End:0x1F8
        if(bIsInFront)
        {
            DirOfTarget = AngularDist.X;            
        }
        else
        {
            DirOfTarget = 180.0000000 - AngularDist.X;
            // End:0x248
            if(DirOfTarget < float(0))
            {
                DirOfTarget += float(360);
            }
        }
        DI.Rotation = FInterpTo(LastCompassRotation, DirOfTarget, DeltaTime, 10.0000000);
        // End:0x2D4
        if(ArrowAlpha < float(100))
        {
            ArrowAlpha = FClamp(ArrowAlpha + (DeltaTime * float(300)), 0.0000000, 100.0000000);
        }
        DI.Alpha = ArrowAlpha;
        Arrow.SetDisplayInfo(DI);
        // End:0x3B8
        if((Location.Z - GetPC().Pawn.Location.Z) > SameFloorThreshold)
        {
            ArrowUp.SetVisible(true);            
        }
        else
        {
            // End:0x44B
            if((GetPC().Pawn.Location.Z - Location.Z) > SameFloorThreshold)
            {
                ArrowDown.SetVisible(true);
            }
        }        
    }
    else
    {
        DI.Rotation = LastCompassRotation;
        // End:0x4B8
        if(ArrowAlpha > float(0))
        {
            ArrowAlpha = FClamp(ArrowAlpha - (DeltaTime * float(300)), 0.0000000, 100.0000000);
        }
        DI.Alpha = ArrowAlpha;
        Arrow.SetDisplayInfo(DI);
    }
    LastCompassRotation = DI.Rotation;
    //return;    
}

function UpdateHitLocIndicators()
{
    local Vector Loc;
    local Rotator Rot;
    local float DirOfShot;
    local Vector AxisX, AxisY, AxisZ, HitDirection;
    local bool bIsInFront;
    local Vector2D AngularDist;
    local THitLocIndicator HI;
    local ASDisplayInfo DI;

    GetPC().GetPlayerViewPoint(Loc, Rot);
    GetAxes(Rot, AxisX, AxisY, AxisZ);
    // End:0x2A7
    foreach HitLocIndicators(HI)
    {
        // End:0x25D
        if((GetPC().WorldInfo.TimeSeconds - HI.TimeOfHit) < float(3))
        {
            HitDirection = Normal(HI.ShotLoc - Loc);
            bIsInFront = GetAngularDistance(AngularDist, HitDirection, AxisX, AxisY, AxisZ);
            GetAngularDegreesFromRadians(AngularDist);
            // End:0x18F
            if(bIsInFront)
            {
                DirOfShot = 180.0000000 + AngularDist.X;                
            }
            else
            {
                DirOfShot = -AngularDist.X;
                // End:0x1DA
                if(DirOfShot < float(0))
                {
                    DirOfShot += float(360);
                }
            }
            DI.hasRotation = true;
            DI.Rotation = DirOfShot;
            HI.GFx.SetDisplayInfo(DI);            
        }
        else
        {
            HI.GFx.SetVisible(false);
            HitLocIndicators.RemoveItem(HI);
        }        
    }    
    //return;    
}

function ToggleCrosshair(bool bToggle)
{
    bToggle = ((!bDrawWeaponCrosshairs && bToggle) && !UTPlayerController(GetPC()).bNoCrosshair) && UTHUDBase(GetPC().myHUD).bCrosshairShow;
    ReticuleMC.SetVisible(bToggle);
    //return;    
}

function DisplayHit(Vector HitDir, int Damage, class<DamageType> DamageType)
{
    local THitLocIndicator HI;

    // End:0x16B
    if((class<EvilDmgType_Base>(DamageType) != none) && class<EvilDmgType_Base>(DamageType).default.bLocationalHit)
    {
        HI.GFx = HitLocIndicator.AttachMovie("dirHitArc", "dirHitArc" $ string(HitLocIndicatorsCount++));
        HI.TimeOfHit = GetPC().WorldInfo.TimeSeconds;
        HI.ShotLoc = HitDir;
        HI.GFx.GotoAndPlay("on");
        HitLocIndicators.AddItem(HI);
    }
    //return;    
}

function SetCenterText(string Text)
{
    CenterTextTF.SetText(Text);
    CenterTextMC.GotoAndPlay("on");
    //return;    
}

function ShowReload(bool Show)
{
    // End:0x5E
    if(Show)
    {
        ReloadMC.GotoAndPlay("show");
        ReloadTextTF.SetText(Reload);        
    }
    else
    {
        ReloadMC.GotoAndStop("hide");
    }
    bReloadVisible = Show;
    //return;    
}

function ShowLowAmmo()
{
    // End:0x0F
    if(bLowAmmoVisible)
    {
        return;
    }
    ReloadMC.GotoAndPlay("show");
    ReloadTextTF.SetText(LowAmmoString);
    bLowAmmoVisible = true;
    //return;    
}

function HideLowAmmo()
{
    ReloadMC.GotoAndStop("hide");
    bLowAmmoVisible = false;
    //return;    
}

function ShowNoAmmo()
{
    // End:0x0F
    if(bNoAmmoVisible)
    {
        return;
    }
    ReloadMC.GotoAndPlay("show");
    ReloadTextTF.SetText(NoAmmoString);
    bNoAmmoVisible = true;
    //return;    
}

function HideNoAmmo()
{
    ReloadMC.GotoAndStop("hide");
    bNoAmmoVisible = false;
    //return;    
}

function HideCards(optional bool Instant)
{
    // End:0x36
    if(Instant)
    {
        BottomMC.GotoAndStop("hide");        
    }
    else
    {
        BottomMC.GotoAndPlay("fadeout");
    }
    //return;    
}

function ShowCardsInactive()
{
    UpdateChosenCards();
    BottomMC.GotoAndPlay("inactive");
    //return;    
}

function ShowCardsActive()
{
    UpdateChosenCards();
    BottomMC.GotoAndPlay("active");
    //return;    
}

protected function string GetLocalizedBindingForCommand(out array<BindingInfo> ActiveBindings, string Command)
{
    local int Index;
    local name Key;

    Index = ActiveBindings.Find('Command', Command);
    // End:0x6C
    if(Index != -1)
    {
        Key = ActiveBindings[Index].PrimaryBind;
    }
    return ("<Color:R=1.0,G=0.0,B=0.0>[" $ Class'PKGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(Key)) $ "]</Color>";
    //return ReturnValue;    
}

function string ParseString(string Text)
{
    local string Result, Path;
    local array<BindingInfo> ActiveBindings;
    local int DummyHash;
    local PainProfileSettings.EStickConfigOpts StickConfig;
    local bool bInvertSticks;

    Result = Text;
    Path = "Strings:PKHDGame.ControllerFont";
    // End:0x96
    if(GetPC().WorldInfo.IsConsoleBuild(2))
    {        
        Path $= "_PS3";        
    }
    else
    {
        // End:0x129
        if(GetPC().WorldInfo.IsConsoleBuild(1) || GetPC().PlayerInput.bUsingGamepad)
        {            
            Path $= "_XBOX";            
        }
        else
        {            
            Path $= "_PC";
            PKPlayerController(GetPC()).ProfileSettings.GetKeyBindings(76, ActiveBindings, DummyHash);
            // End:0x1EC
            if(ActiveBindings.Length == 0)
            {
                PKPlayerInput(GetPC().PlayerInput).GetDefaultBindingsForPC(ActiveBindings);
            }
            Result = Repl(Result, "{RT}", GetLocalizedBindingForCommand(ActiveBindings, "GBA_Fire"), false);
            Result = Repl(Result, "{LT}", GetLocalizedBindingForCommand(ActiveBindings, "GBA_AltFire"), false);
            Result = Repl(Result, "{BK}", GetLocalizedBindingForCommand(ActiveBindings, "GBA_Stats"), false);
            Result = Repl(Result, "{DP}", GetLocalizedBindingForCommand(ActiveBindings, "GBA_NextWeapon"), false);
            Result = Repl(Result, "{USE}", GetLocalizedBindingForCommand(ActiveBindings, "GBA_Use"), false);
            Result = Repl(Result, "{RSC}", GetLocalizedBindingForCommand(ActiveBindings, "GBA_Zoom"), false);
            Result = Repl(Result, "{RS}", ("<Color:R=1.0,G=0.0,B=0.0>" $ (Localize("KeycapMenuFont", "Map_RightStick", "PKHDGame"))) $ "</Color>", false);
        }
    }
    StickConfig = PKPlayerController(GetPC()).ProfileSettings.GetStickConfigOption();
    bInvertSticks = (int(StickConfig) == int(2)) || int(StickConfig) == int(3);
    Result = Repl(Result, "{A}", ("<" $ Path) $ ".Controller_A>", false);
    Result = Repl(Result, "{B}", ("<" $ Path) $ ".Controller_B>", false);
    Result = Repl(Result, "{USE}", ("<" $ Path) $ ".Controller_X>", false);
    Result = Repl(Result, "{X}", ("<" $ Path) $ ".Controller_X>", false);
    Result = Repl(Result, "{Y}", ("<" $ Path) $ ".Controller_Y>", false);
    Result = Repl(Result, "{RT}", ("<" $ Path) $ ".Controller_RightTrigger>", false);
    Result = Repl(Result, "{RB}", ("<" $ Path) $ ".Controller_RightBumper>", false);
    Result = Repl(Result, "{LT}", ("<" $ Path) $ ".Controller_LeftTrigger>", false);
    Result = Repl(Result, "{LB}", ("<" $ Path) $ ".Controller_LeftBumper>", false);
    Result = Repl(Result, "{RS}", ((("<" $ Path) $ ".Controller_") $ ((bInvertSticks) ? "Left" : "Right")) $ "Stick>", false);
    Result = Repl(Result, "{LS}", ((("<" $ Path) $ ".Controller_") $ ((bInvertSticks) ? "Right" : "Left")) $ "Stick>", false);
    Result = Repl(Result, "{RSC}", ((("<" $ Path) $ ".Controller_") $ ((bInvertSticks) ? "Left" : "Right")) $ "StickClick>", false);
    Result = Repl(Result, "{LSC}", ((("<" $ Path) $ ".Controller_") $ ((bInvertSticks) ? "Right" : "Left")) $ "StickClick>", false);
    Result = Repl(Result, "{ST}", ("<" $ Path) $ ".Controller_Start>", false);
    Result = Repl(Result, "{BK}", ("<" $ Path) $ ".Controller_Back>", false);
    Result = Repl(Result, "{DP}", ("<" $ Path) $ ".Controller_DPad>", false);
    return Result;
    //return ReturnValue;    
}

function SetLocalizedMessageText(string Text, optional bool long = false, optional bool html = false)
{
    // End:0x7D
    if(html)
    {
        CenterTextTF.SetBool("html", true);
        CenterTextTF.SetString("htmlText", ParseString(Text));        
    }
    else
    {
        CenterTextTF.SetBool("html", false);
        CenterTextTF.SetString("text", Text);
    }
    // End:0x106
    if(long)
    {
        CenterTextMC.GotoAndPlay("on5");        
    }
    else
    {
        CenterTextMC.GotoAndPlay("on");
    }
    //return;    
}

function SetLocalizedHintMessageText(string Text, optional bool html = false)
{
    // End:0x78
    if(html)
    {
        HintTextTF.SetBool("html", true);
        HintTextTF.SetString("htmlText", ParseString(Text));        
    }
    else
    {
        HintTextTF.SetBool("html", false);
        HintTextTF.SetString("text", Text);
    }
    HintTextMC.GotoAndPlay("on");
    //return;    
}

function HideLocalizedHintMessage()
{
    HintTextMC.GotoAndStop("off");
    //return;    
}

function ShowTutorialMessage(string Text, optional bool html = false)
{
    // End:0x78
    if(html)
    {
        TutorialMessageTF.SetBool("html", true);
        TutorialMessageTF.SetString("htmlText", ParseString(Text));        
    }
    else
    {
        TutorialMessageTF.SetBool("html", false);
        TutorialMessageTF.SetString("text", Text);
    }
    TutorialMessageMC.SetVisible(true);
    //return;    
}

function HideTutorialMessage()
{
    TutorialMessageTF.SetBool("html", false);
    TutorialMessageTF.SetString("text", " ");
    TutorialMessageMC.SetVisible(false);
    //return;    
}

function SetObjectiveMessageText(string Text, optional bool html = false)
{
    // End:0x78
    if(html)
    {
        ObjectiveMessageTF.SetBool("html", true);
        ObjectiveMessageTF.SetString("htmlText", ParseString(Text));        
    }
    else
    {
        ObjectiveMessageTF.SetBool("html", false);
        ObjectiveMessageTF.SetString("text", Text);
    }
    ObjectiveMessageMC.GotoAndPlay("show");
    //return;    
}

function GFxObject AddCaptionComponent()
{
    local GFxObject GFxObj;

    GFxObj = HUDOverlay.AttachMovie("caption", "caption" $ string(CaptionComponentItemCount++));
    return GFxObj;
    //return ReturnValue;    
}

function GFxObject AddCaptionComponentBorder()
{
    local GFxObject GFxObj;

    GFxObj = HUDOverlay.AttachMovie("border", "border" $ string(CaptionBorderComponentItemCount++));
    return GFxObj;
    //return ReturnValue;    
}

function AddHeadshot()
{
    // End:0x21D
    if(CurrentHeadshot.ElapsedTime >= CurrentHeadshot.MinimalTime)
    {
        // End:0x9A
        if(CurrentHeadshot.GFx != none)
        {
            CurrentHeadshot.GFx.GotoAndPlay("FadeOut");
        }
        CurrentHeadshot.ElapsedTime = 0.0000000;
        CurrentHeadshot.MinimalTime = 0.5000000;
        CurrentHeadshot.PersistTime = 2.0000000;
        CurrentHeadshot.GFx = HeadshotMC.AttachMovie("headshot", "headshot_" $ string(HeadshotCount++));
        CurrentHeadshot.GFx.GetObject("headshottf").GetObject("textField").SetText(HeadshotString);
        CurrentHeadshot.GFx.GotoAndPlay("FadeIn");
    }
    //return;    
}

function PlayOpenAnimation()
{
    HudMC.GotoAndPlay("open");
    //return;    
}

function PlayHitAnimation(float Damage)
{
    local string Anim;

    // End:0x28
    if(Damage < float(8))
    {
        Anim = "damage2";        
    }
    else
    {
        Anim = "damage";
    }
    HudMC.GotoAndPlay(Anim);
    //return;    
}

defaultproperties
{
    SameFloorThreshold=150.0000000
    BossIconMap[0]=(IconName="Giant",BossClass=Class'PkPawn_Boss_Giant_Base')
    BossIconMap[1]=(IconName="Alastor",BossClass=Class'PKPawn_Boss_Alastor_Base')
    BossIconMap[2]=(IconName="Swamp",BossClass=Class'PKPawn_Boss_Swamp_Base')
    TimeString="Time"
    ScoreString="Bodycount"
    LivesString="Lives"
    LowAmmoString="Ammunition Low"
    NoAmmoString="No Ammunition"
    MovieInfo=SwfMovie'PKHD_HUD.PKHud'
}