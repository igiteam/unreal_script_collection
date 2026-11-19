class AdvGFxHud extends EvilGFxHud
    config(UI);

const MAX_MAGAZINE_BULLETS = 75;
const MAX_KILLSTREAKS = 4;
const MAX_KILLSTREAK_COUNT = 12;
const MAX_BLESSINGS = 5;

enum EIndicatorType
{
    EIT_Compass,                    // 0
    EIT_Note,                       // 1
    EIT_Flashlight,                 // 2
    EIT_POI,                        // 3
    EIT_Map,                        // 4
    EIT_Flashlight2,                // 5
    EIT_MAX                         // 6
};

struct KillStreakObject
{
    var GFxObject KillStreakMC;
    var GFxObject ActivatorTF;
    var GFxObject IconMC;
    var GFxObject IconMC_g;
    var GFxObject IconMC_bg;

    structdefaultproperties
    {
        KillStreakMC=none
        ActivatorTF=none
        IconMC=none
        IconMC_g=none
        IconMC_bg=none
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
    var Pawn Instigator;
    var Vector ShotLoc;
    var float TimeOfHit;

    structdefaultproperties
    {
        GFx=none
        Instigator=none
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

struct TObjIcon
{
    var Actor Target;
    var string Type;
    var GFxObject ObjectiveRoot;
    var GFxObject ObjectiveMC;
    var GFxObject ObjectiveIconMC;
    var GFxObject ObjectiveArrowMC;

    structdefaultproperties
    {
        Target=none
        Type=""
        ObjectiveRoot=none
        ObjectiveMC=none
        ObjectiveIconMC=none
        ObjectiveArrowMC=none
    }
};

struct TWeaponTypeStringMap
{
    var Class Class;
    var string TypeString;

    structdefaultproperties
    {
        Class=none
        TypeString=""
    }
};

var GFxObject PlayerStatsMC;
var GFxObject HealthLabelTF;
var GFxObject HealthTF;
var GFxObject WeaponStatsMC;
var GFxObject AmmoAllMC;
var GFxObject GrenadeMC;
var GFxObject GrenadeIconMC;
var GFxObject TotalAmmoTF;
var GFxObject GrenadeTF;
var GFxObject AmmoMC;
var GFxObject BulletMC[75];
var transient bool bWeaponStatsVisible;
var transient bool bFlashlightVisible;
var transient bool bFlashlightWarn;
var transient bool bDeathTimerVisible;
var transient bool bReloadVisible;
var bool bObjectiveFocusModeVisible;
var transient float WeaponStatsTimeout;
var GFxObject FlashlightStatsMC;
var GFxObject FlashLightMC;
var GFxObject FlashlightMask;
var transient float FlashlightTimeout;
var GFxObject ItemsMC;
var GFxObject ItemsTF;
var string ItemsIcons[EAdvItemType];
var GFxObject TreasuresStatsMC;
var GFxObject TreasuresInfoLabelTF;
var GFxObject TreasuresLabelTF;
var GFxObject TreasuresTF;
var GFxObject NotepadHintsMC;
var GFxObject MapHintsMC;
var GFxObject NotepadHintTF;
var GFxObject MapHintTF;
var GFxObject MapCollectedHintTF;
var GFxObject MapLifeHintTF;
var GFxObject MapLightHintTF;
var GFxObject MapWarriorHintTF;
var GFxObject TutorialMC;
var GFxObject TutorialInnerMC;
var GFxObject TutorialContinueMC;
var GFxObject TutorialTF;
var GFxObject TutorialContinueTF;
var GFxObject ArtifactsMC;
var GFxObject ArtifactsTF;
var GFxObject BlessingsMC;
var GFxClikWidget Blessings[5];
var GFxObject MultiplayerStatsMC;
var GFxObject RedTeamMC;
var GFxObject BlueTeamMC;
var GFxObject TimeLeftTF;
var GFxObject TimeLeftTitleTF;
var GFxObject WinningTF;
var GFxObject RedTeamNameTF;
var GFxObject RedTeamScoreTF;
var GFxObject RedTeamIndicatorMC;
var GFxObject BlueTeamNameTF;
var GFxObject BlueTeamScoreTF;
var GFxObject BlueTeamIndicatorMC;
var GFxObject MultiplayerStreaksMC;
var KillStreakObject KillStreakObjects[4];
var GFxObject KillStreakCountMC[12];
var GFxObject DeathTimerMC;
var GFxObject DeathTimerMask;
var GFxObject DeathTimerTF;
var GFxObject CenterTextMC;
var GFxObject CenterTextTF;
var GFxObject TutorialMessageMC;
var GFxObject TutorialMessageTF;
var GFxObject HintTextMC;
var GFxObject HintTextTF;
var GFxObject UpgradeInfoMC;
var GFxObject UpgradeInfoTF;
var GFxObject UpgradeGFxMC;
var GFxObject UpgradeInfoUILoader;
var GFxObject UpgradeQueueMC1;
var GFxObject UpgradeQueueMC2;
var GFxObject UpgradeQueueTF1;
var GFxObject UpgradeQueueTF2;
var GFxObject KillInfoMC;
var GFxObject KillInfoTF;
var GFxObject KillInfoTF2;
var GFxObject ReloadMC;
var GFxObject ReloadTextTF;
var HeadshotInfo CurrentHeadshot;
var int HeadshotCount;
var GFxObject HeadshotMC;
var GFxObject HitLocMC[8];
var GFxObject MultiKillN_TF;
var GFxObject MultiKillMsg_TF;
var GFxObject MultiKillMC;
var GFxObject ReticuleMC;
var GFxObject EnemyHitMC;
var AdvGFxVotingComponent VotingComponent;
var GFxObject HitLocIndicator;
var array<THitLocIndicator> HitLocIndicators;
var int HitLocIndicatorsCount;
var array<GrenadeIndicator> GrenadeIndicators;
var int GrenadeIndicatorsCount;
var array<TObjIcon> ObjectivesIcons;
var transient int ObjectivesCount;
var AdvInventoryItem_Compass Compass;
var GFxObject CompassMC;
var GFxObject Compass_g;
var GFxObject Compass_tfMC;
var GFxObject Compass_tf;
var GFxObject CompassIndicatorMC;
var const localized string Reload;
var const localized string HeadshotString;
var const localized string CompassString;
var const localized string CompassStringPad;
var const localized string FlashlightString;
var const localized string FlashlightStringPad;
var const localized string FlashlightString2;
var const localized string FlashlightStringPad2;
var const localized string NoteString;
var const localized string NoteStringPad;
var const localized string MapString;
var const localized string MapStringPad;
var const localized string POIString;
var const localized string AmmoString;
var const localized string HealthString;
var const localized string TreasuresString;
var const localized string SavedCheckpointString;
var const localized string PressAnyButton;
var int CompassMessageCounter;
var Actor LastCompassTargetActor;
var int LastTreasureValCollected;
var int LastTreasureValAll;
var AdvTypes.ETreasureType LastTreasureTypeCollected;
var transient float LastCompassUpdateTime;
var transient float LastPOIUpdateTime;
var EvilWeap_Base LastWeapon;
var EvilWeap_Base LastThrowWeapon;
var int LastMagazineTotalAmmo;
var int LastMagazineTotalMaxAmmo;
var int LastGrenadeCount;
var float LastFlashlightPower;
var array<TWeaponTypeStringMap> WeaponTypeStringMap;
var int LastAmmoAmount;
var int LastGranadesAmount;

function AddDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Killed, int Switch, class<EvilDmgType_Base> Dmg)
{
    local string msg;

    msg = Class'EvilGame.EvilDeathMessage'.static.GetString(Switch, false, Killer, Killed, Dmg);
    AddMessage("htmlText", msg);
    //return;    
}

function Init(optional LocalPlayer Player)
{
    local int I;
    local GFxObject Cursor;

    super.Init(Player);
    bReloadVisible = false;
    bDeathTimerVisible = false;
    bObjectiveFocusModeVisible = false;
    CenterTextTF = GetVariableObject("_root.HUD.centerTextMC.centerText.textField");
    CenterTextMC = GetVariableObject("_root.HUD.centerTextMC");
    HintTextTF = GetVariableObject("_root.HUD.hinttextMC.hinttext.textField");
    HintTextMC = GetVariableObject("_root.HUD.hinttextMC");
    TutorialMessageTF = GetVariableObject("_root.HUD.TutorialMessageMC.TutorialMessage.textField");
    TutorialMessageMC = GetVariableObject("_root.HUD.TutorialMessageMC");
    UpgradeInfoTF = GetVariableObject("_root.HUD.upgradeInfoMC.upgradeInfo.textField");
    UpgradeInfoMC = GetVariableObject("_root.HUD.upgradeInfoMC");
    UpgradeGFxMC = GetVariableObject("_root.HUD.upgradeInfoMC.upgradegfxMC");
    UpgradeInfoUILoader = GetVariableObject("_root.HUD.upgradeInfoMC.upgradegfxMC.UILoader");
    UpgradeInfoUILoader.SetBool("visible", true);
    UpgradeInfoMC.SetVisible(true);
    UpgradeQueueMC1 = GetVariableObject("_root.HUD.upgradeInfoMC.UpgradeQueque2MC");
    UpgradeQueueMC2 = GetVariableObject("_root.HUD.upgradeInfoMC.UpgradeQueque3MC");
    UpgradeQueueTF1 = GetVariableObject("_root.HUD.upgradeInfoMC.UpgradeQueque2MC.upgradeQue2MC.textField");
    UpgradeQueueTF2 = GetVariableObject("_root.HUD.upgradeInfoMC.UpgradeQueque3MC.upgradeQue3MC.textField");
    KillInfoTF = GetVariableObject("_root.HUD.killinfoMC.killinfo.textField");
    KillInfoTF2 = GetVariableObject("_root.HUD.killinfoMC.killinfo.textField2");
    KillInfoMC = GetVariableObject("_root.HUD.killinfoMC");
    ReloadMC = GetVariableObject("_root.HUD.reload");
    ReloadTextTF = GetVariableObject("_root.HUD.reload.text.textField");
    HeadshotMC = GetVariableObject("_root.HUD.HeadshotMC");
    ReticuleMC = GetVariableObject("_root.HUD.reticule");
    EnemyHitMC = GetVariableObject("_root.HUD.enemyHitMC");
    HitLocMC[0] = GetVariableObject("_root.HUD.dirHit.t");
    HitLocMC[1] = GetVariableObject("_root.HUD.dirHit.tr");
    HitLocMC[2] = GetVariableObject("_root.HUD.dirHit.r");
    HitLocMC[3] = GetVariableObject("_root.HUD.dirHit.br");
    HitLocMC[4] = GetVariableObject("_root.HUD.dirHit.b");
    HitLocMC[5] = GetVariableObject("_root.HUD.dirHit.bl");
    HitLocMC[6] = GetVariableObject("_root.HUD.dirHit.l");
    HitLocMC[7] = GetVariableObject("_root.HUD.dirHit.tl");
    HitLocIndicator = GetVariableObject("_root.HUD.dirHit.indicator");
    PlayerStatsMC = HudMC.GetObject("PlayerStatsMC");
    HealthLabelTF = PlayerStatsMC.GetObject("health_tf");
    HealthTF = PlayerStatsMC.GetObject("health");
    WeaponStatsMC = HudMC.GetObject("WeaponStatsMC");
    GrenadeMC = WeaponStatsMC.GetObject("granadeMC");
    GrenadeIconMC = GrenadeMC.GetObject("granade_iconMC");
    GrenadeTF = GrenadeMC.GetObject("granade_tf");
    TotalAmmoTF = WeaponStatsMC.GetObject("ammoMC").GetObject("ammo");
    AmmoAllMC = WeaponStatsMC.GetObject("ammo_icons");
    ItemsMC = HudMC.GetObject("invIconsMC");
    ItemsTF = ItemsMC.GetObject("textField");
    FlashlightStatsMC = HudMC.GetObject("flashlightMainMC");
    FlashLightMC = FlashlightStatsMC.GetObject("light");
    FlashlightMask = FlashLightMC.GetObject("lightinsideMC").GetObject("flashlightmaskMC");
    AmmoMC = AmmoAllMC.GetObject("ammoMC");
    I = 0;
    J0xA85:

    // End:0xAEF [Loop If]
    if(I < 75)
    {
        BulletMC[I] = AmmoMC.GetObject("bullet" $ string(I + 1));
        I++;
        // [Loop Continue]
        goto J0xA85;
    }
    TreasuresStatsMC = HudMC.GetObject("TreasureInfoMC");
    TreasuresInfoLabelTF = TreasuresStatsMC.GetObject("TreasureInfoCollectedMC").GetObject("TreasureInfoCollectedTF");
    TreasuresLabelTF = TreasuresStatsMC.GetObject("TreasurePathMC").GetObject("TreasurePathTF");
    TreasuresTF = TreasuresStatsMC.GetObject("TreasureNumberMC").GetObject("TreasureNumberTF");
    CompassMC = HudMC.GetObject("compass");
    Compass_g = CompassMC.GetObject("compass_g");
    Compass_tfMC = CompassMC.GetObject("compass_tf");
    Compass_tf = Compass_tfMC.GetObject("textField");
    CompassIndicatorMC = HudMC.GetObject("compasMC");
    CompassIndicatorMC.SetVisible(false);
    NotepadHintsMC = HudMC.GetObject("notepad_hintsMC");
    MapHintsMC = HudMC.GetObject("map_hintMC");
    NotepadHintTF = NotepadHintsMC.GetObject("notepadHintMainMC").GetObject("textField");
    MapHintTF = MapHintsMC.GetObject("mapHintMainMC").GetObject("mapNameTF");
    MapCollectedHintTF = MapHintsMC.GetObject("mapHintMainMC").GetObject("treasureTF");
    MapLifeHintTF = MapHintsMC.GetObject("mapHintMainMC").GetObject("treasure1TF");
    MapLightHintTF = MapHintsMC.GetObject("mapHintMainMC").GetObject("treasure3TF");
    MapWarriorHintTF = MapHintsMC.GetObject("mapHintMainMC").GetObject("treasure2TF");
    TutorialMC = HudMC.GetObject("TutorialMC");
    TutorialInnerMC = TutorialMC.GetObject("InnerMC");
    TutorialContinueMC = TutorialInnerMC.GetObject("TutorialContinue");
    TutorialTF = TutorialInnerMC.GetObject("textField");
    TutorialContinueTF = TutorialContinueMC.GetObject("text").GetObject("textField");
    ArtifactsMC = HudMC.GetObject("artifactsMC");
    ArtifactsTF = ArtifactsMC.GetObject("artifactsTF");
    BlessingsMC = ArtifactsMC.GetObject("BlessingMC");
    I = 0;
    J0x1202:

    // End:0x129D [Loop If]
    if(I < 5)
    {
        Blessings[I] = GFxClikWidget(BlessingsMC.GetObject("Bless" $ string(I + 1)).GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        I++;
        // [Loop Continue]
        goto J0x1202;
    }
    MultiplayerStatsMC = HudMC.GetObject("MPStatisticsMC");
    TimeLeftTF = MultiplayerStatsMC.GetObject("timeTF");
    TimeLeftTitleTF = MultiplayerStatsMC.GetObject("timetitleTF");
    WinningTF = MultiplayerStatsMC.GetObject("statusTF");
    RedTeamMC = MultiplayerStatsMC.GetObject("redteam");
    BlueTeamMC = MultiplayerStatsMC.GetObject("blueteam");
    RedTeamIndicatorMC = RedTeamMC.GetObject("winningteam");
    RedTeamNameTF = RedTeamMC.GetObject("nameTF");
    RedTeamScoreTF = RedTeamMC.GetObject("scoreTF");
    BlueTeamIndicatorMC = BlueTeamMC.GetObject("winningteam");
    BlueTeamNameTF = BlueTeamMC.GetObject("nameTF");
    BlueTeamScoreTF = BlueTeamMC.GetObject("scoreTF");
    MultiplayerStreaksMC = HudMC.GetObject("killstreaksMainMC");
    I = 0;
    J0x155B:

    // End:0x17B8 [Loop If]
    if(I < 4)
    {
        KillStreakObjects[I].KillStreakMC = MultiplayerStreaksMC.GetObject(("streak" $ string(I + 1)) $ "MC");
        KillStreakObjects[I].ActivatorTF = KillStreakObjects[I].KillStreakMC.GetObject("activatorTF");
        KillStreakObjects[I].IconMC = KillStreakObjects[I].KillStreakMC.GetObject("activekillstreakMC");
        KillStreakObjects[I].IconMC_g = KillStreakObjects[I].IconMC.GetObject("activekillstreakM");
        KillStreakObjects[I].IconMC_bg = KillStreakObjects[I].KillStreakMC.GetObject("unactivekillstreakMC");
        I++;
        // [Loop Continue]
        goto J0x155B;
    }
    I = 0;
    J0x17C3:

    // End:0x1831 [Loop If]
    if(I < 12)
    {
        KillStreakCountMC[I] = MultiplayerStreaksMC.GetObject(("kill" $ string(I + 1)) $ "MC");
        I++;
        // [Loop Continue]
        goto J0x17C3;
    }
    DeathTimerMC = HudMC.GetObject("HealthStopMC");
    DeathTimerMask = DeathTimerMC.GetObject("healthMASK");
    DeathTimerTF = DeathTimerMC.GetObject("texthealthMC").GetObject("textMC").GetObject("textField");
    VotingComponent = new Class'AdvGFxVotingComponent';
    VotingComponent.Initialize(HudMC, AdvPlayerController(GetPC()));
    UpdateItemsOnHud();
    RefreshObjectiveIconsFromStorage();
    SetHUDElementsVisible(false);
    bVisibilityNeedsUpdate = true;
    Cursor = GetVariableObject("_root.HUD.mc_cursor");
    Cursor.SetVisible(false);
    ReloadTextTF.SetText(Reload);
    HealthLabelTF.SetText(HealthString);
    RedTeamNameTF.SetText(Class'AdvGFxUI_Scoreboard'.default.RedTeamShortText);
    BlueTeamNameTF.SetText(Class'AdvGFxUI_Scoreboard'.default.BlueTeamShortText);
    RedTeamScoreTF.SetText("");
    BlueTeamScoreTF.SetText("");
    MapCollectedHintTF.SetText(Class'AdvGFxUI_Upgrades'.default.TreasuresColectedString);
    TutorialContinueTF.SetText(PressAnyButton);
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
    mrow.TF.SetInt("_x", mrow.TF.GetInt("_x") - 25);
    mrow.TF.SetInt("_y", mrow.TF.GetInt("_y") + 40);
    mrow.TF.SetInt("_width", mrow.TF.GetInt("_width") + 330);
    mrow.TF.SetFloat("_xscale", mrow.TF.GetFloat("_xscale") * 0.7300000);
    mrow.TF.SetFloat("_yscale", mrow.TF.GetFloat("_yscale") * 0.7300000);
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
    local float dt;
    local AdvPlayerPawn UTP;
    local EvilVehicle_Base UTV;
    local UTWeaponPawn UWP;
    local EvilWeap_Base Weapon, WeaponLeft, WeaponThrow;
    local int MagazineTotalAmmo, MagazineTotalMaxAmmo;
    local AdvPlayerController PC;
    local int I;
    local float FlashlightPowerPerc;
    local ASDisplayInfo DI;
    local bool SomethingInRangeOfCompass;
    local Actor CompassTarget;
    local int CurrentTotalAmmoTFAmount, CurrentGranadeTFAmount;

    PC = AdvPlayerController(GetPC());
    // End:0x2E
    if(PC == none)
    {
        return;
    }
    dt = PC.WorldInfo.TimeSeconds - LastHUDRenderTime;
    GRI = EvilGameReplicationInfo(PC.WorldInfo.GRI);
    UTP = AdvPlayerPawn(PC.Pawn);
    // End:0x289
    if(EqualEqual_InterfaceInterface(EvilPlayer_interface(PC.Pawn), EvilPlayer_interface(none)))
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
                UTP = AdvPlayerPawn(UWP.Driver);
            }            
        }
        else
        {
            UTP = AdvPlayerPawn(UTV.Driver);
        }
        // End:0x289
        if(UTV == none)
        {
            SetHUDElementsVisible(false);
            bVisibilityNeedsUpdate = true;
            HitLocIndicator.SetVisible(true);
            return;
        }
    }
    // End:0x2FA
    if(UTP != none)
    {
        Weapon = EvilWeap_Base(UTP.Weapon);
        WeaponLeft = EvilWeap_Base(UTP.WeaponLeft);
    }
    // End:0xAFA
    if((Weapon != none) && !ClassIsChildOf(Weapon.Class, Class'EvilGame.EvilWeap_Melee_Base'))
    {
        WeaponStatsMC.SetVisible(true);
        // End:0x523
        if(((WeaponLeft != none) && !ClassIsChildOf(WeaponLeft.Class, Class'AdvInventoryItem_Base')) && !Weapon.IsPuttingDown() || WeaponLeft.IsPuttingDown() && Weapon.IsPuttingDown())
        {
            MagazineTotalAmmo = Weapon.MagazineAmmoCount + WeaponLeft.MagazineAmmoCount;
            MagazineTotalMaxAmmo = Weapon.MagazineMaxAmmoCount + WeaponLeft.MagazineMaxAmmoCount;
            CurrentTotalAmmoTFAmount = ((Weapon.AmmoCount + WeaponLeft.AmmoCount) - Weapon.MagazineAmmoCount) - WeaponLeft.MagazineAmmoCount;            
        }
        else
        {
            MagazineTotalAmmo = Weapon.MagazineAmmoCount;
            MagazineTotalMaxAmmo = Weapon.MagazineMaxAmmoCount;
            CurrentTotalAmmoTFAmount = Weapon.GetShareAmmoCount(true) - Weapon.MagazineAmmoCount;
        }
        // End:0x6D8
        if(CurrentTotalAmmoTFAmount != LastAmmoAmount)
        {
            LastAmmoAmount = CurrentTotalAmmoTFAmount;
            // End:0x6AD
            if(Weapon.DefaultInfiniteWeapon || Weapon.EvilInvManager.bInfiniteAmmo)
            {
                TotalAmmoTF.SetBool("html", true);
                TotalAmmoTF.SetString("htmlText", "<img src='t_infinity'>");                
            }
            else
            {
                TotalAmmoTF.SetText(string(CurrentTotalAmmoTFAmount));
            }
        }
        // End:0x8CC
        if(((LastMagazineTotalAmmo != MagazineTotalAmmo) || LastMagazineTotalMaxAmmo != MagazineTotalMaxAmmo) || LastWeapon != Weapon)
        {
            PlayShowHideWeaponStatsAnimation(true);
            WeaponStatsTimeout = default.WeaponStatsTimeout;
            AmmoAllMC.GotoAndStop(GetWeaponTypeString(Weapon));
            I = 0;
            J0x77C:

            // End:0x893 [Loop If]
            if(I < 75)
            {
                // End:0x7A8
                if(BulletMC[I] == none)
                {
                    // [Explicit Break]
                    goto J0x893;
                }
                // End:0x85B
                if(I < MagazineTotalMaxAmmo)
                {
                    BulletMC[I].SetVisible(true);
                    // End:0x82D
                    if(I < MagazineTotalAmmo)
                    {
                        BulletMC[I].GotoAndStopI(1);                        
                    }
                    else
                    {
                        BulletMC[I].GotoAndStopI(2);
                    }                    
                }
                else
                {
                    BulletMC[I].SetVisible(false);
                }
                I++;
                // [Loop Continue]
                goto J0x77C;
            }
            J0x893:

            LastWeapon = Weapon;
            LastMagazineTotalMaxAmmo = MagazineTotalMaxAmmo;
            LastMagazineTotalAmmo = MagazineTotalAmmo;
        }
        WeaponThrow = EvilWeap_Base(UTP.ThrowWeapon);
        // End:0xAD7
        if(WeaponThrow != none)
        {
            GrenadeMC.SetVisible(true);
            // End:0xAD4
            if((LastThrowWeapon != WeaponThrow) || LastGrenadeCount != WeaponThrow.AmmoCount)
            {
                PlayShowHideWeaponStatsAnimation(true);
                WeaponStatsTimeout = default.WeaponStatsTimeout;
                CurrentGranadeTFAmount = WeaponThrow.AmmoCount;
                // End:0xA21
                if(WeaponThrow.AmmoCount != LastGranadesAmount)
                {
                    LastGranadesAmount = CurrentGranadeTFAmount;
                    GrenadeTF.SetText(string(CurrentGranadeTFAmount));
                }
                // End:0xA99
                if(LastThrowWeapon != WeaponThrow)
                {
                    GrenadeIconMC.GotoAndStop(((ClassIsChildOf(WeaponThrow.Class, Class'AdvWeap_Throw_Dynamite_Base')) ? "dynamite" : "grenade"));
                }
                LastGrenadeCount = WeaponThrow.AmmoCount;
                LastThrowWeapon = WeaponThrow;
            }            
        }
        else
        {
            GrenadeMC.SetVisible(false);
        }        
    }
    else
    {
        WeaponStatsMC.SetVisible(false);
    }
    // End:0xE37
    if((UTP != none) && UTP.MyTorch != none)
    {
        FlashlightStatsMC.SetVisible(true);
        // End:0xE34
        if(UTP.MyTorch.Power != LastFlashlightPower)
        {
            PlayShowHideFlashlightAnimation(true);
            FlashlightTimeout = default.FlashlightTimeout;
            FlashlightPowerPerc = float(FCeil(UTP.MyTorch.Power * float(100)));
            EnableFlashlightWarn(UTP.MyTorch.bDeadBattery || UTP.MyTorch.Power < UTP.MyTorch.TorchParts.PowerBlinkRange.Y);
            // End:0xD8A
            if((UTP.MyTorch.Power > UTP.MyTorch.TorchParts.PowerRiseLevel) && bFlashlightWarn)
            {
                EnableFlashlightWarn(false);
            }
            DI.hasXScale = true;
            DI.XScale = FlashlightPowerPerc;
            FlashlightMask.SetDisplayInfo(DI);
            LastFlashlightPower = UTP.MyTorch.Power;
        }        
    }
    else
    {
        FlashlightStatsMC.SetVisible(false);
    }
    // End:0xF34
    if((LastHUDRenderTime - LastPOIUpdateTime) > 0.1000000)
    {
        LastPOIUpdateTime = LastHUDRenderTime;
        // End:0xF34
        if((PC.FindNewBestPOIToLookAt() != none) || (LastHUDRenderTime - LastGameplayIndicatorShowTime) > float(20))
        {
            // End:0xF34
            if(!PC.bLookingAtPointOfInterest && PC.HasBestPOIToLookAt())
            {
                ShowGameplayIndicator(3);
                LastGameplayIndicatorShowTime = LastHUDRenderTime;
            }
        }
    }
    // End:0x1196
    if(((LastHUDRenderTime - LastCompassUpdateTime) > 0.5000000) && UTP != none)
    {
        LastCompassUpdateTime = LastHUDRenderTime;
        // End:0xFE7
        if((Compass == none) || Compass.Owner == none)
        {
            Compass = AdvInventoryItem_Compass(UTP.FindInventoryType(Class'AdvInventoryItem_Compass'));
        }
        SomethingInRangeOfCompass = ((Compass == none) ? false : ((Compass.FindBestTargetFor(UTP, CompassTarget)) ? true : Compass.CheckTargetIsValidFor(UTP, false)));
        // End:0x1196
        if(SomethingInRangeOfCompass && (LastHUDRenderTime - LastGameplayIndicatorShowTime) > float(40))
        {
            // End:0x10B2
            if(LastCompassTargetActor != CompassTarget)
            {
                CompassMessageCounter = 0;
            }
            // End:0x1196
            if((CompassMessageCounter < 3) && Compass.AllowShowHints)
            {
                // End:0x1196
                if((UTP.WeaponLeft != Compass) && Compass.GetToTargetDistancePercFor(UTP) < 0.9000000)
                {
                    CompassMessageCounter++;
                    ShowGameplayIndicator(0);
                    PlayGameplayNotification('Compass');
                    LastGameplayIndicatorShowTime = LastHUDRenderTime;
                    LastCompassTargetActor = CompassTarget;
                }
            }
        }
    }
    // End:0x12B6
    if(CurrentHeadshot.ElapsedTime < CurrentHeadshot.PersistTime)
    {
        CurrentHeadshot.ElapsedTime += dt;
        // End:0x12B6
        if(CurrentHeadshot.ElapsedTime >= CurrentHeadshot.PersistTime)
        {
            // End:0x12B6
            if(CurrentHeadshot.GFx != none)
            {
                CurrentHeadshot.GFx.GotoAndPlay("FadeOutSlow");
                CurrentHeadshot.GFx = none;
            }
        }
    }
    // End:0x12D0
    if(GrenadeIndicators.Length > 0)
    {
        UpdateGrenadeIndicators();
    }
    // End:0x12EA
    if(HitLocIndicators.Length > 0)
    {
        UpdateHitLocIndicators();
    }
    // End:0x1312
    if(WeaponStatsTimeout > float(0))
    {
        WeaponStatsTimeout -= dt;        
    }
    else
    {
        PlayShowHideWeaponStatsAnimation(false);
    }
    // End:0x1345
    if(FlashlightTimeout > float(0))
    {
        FlashlightTimeout -= dt;        
    }
    else
    {
        PlayShowHideFlashlightAnimation(false);
    }
    UpdateObjectivesIcons();
    super.TickHud(DeltaTime);
    //return;    
}

function string GetWeaponTypeString(EvilWeap_Base Weap)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0xA2 [Loop If]
    if(I < WeaponTypeStringMap.Length)
    {
        // End:0x94
        if(ClassIsChildOf(Weap.Class, WeaponTypeStringMap[I].Class))
        {
            return WeaponTypeStringMap[I].TypeString;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return "smg";
    //return ReturnValue;    
}

function PlayShowHideWeaponStatsAnimation(bool bShow)
{
    // End:0x50
    if(bShow)
    {
        // End:0x4D
        if(!bWeaponStatsVisible)
        {
            WeaponStatsMC.GotoAndPlay("show");
            bWeaponStatsVisible = true;
        }        
    }
    else
    {
        // End:0x8E
        if(bWeaponStatsVisible)
        {
            WeaponStatsMC.GotoAndStop("hide");
            bWeaponStatsVisible = false;
        }
    }
    //return;    
}

function PlayShowHideFlashlightAnimation(bool bShow)
{
    // End:0x50
    if(bShow)
    {
        // End:0x4D
        if(!bFlashlightVisible)
        {
            FlashlightStatsMC.GotoAndPlay("show");
            bFlashlightVisible = true;
        }        
    }
    else
    {
        // End:0x8E
        if(bFlashlightVisible)
        {
            FlashlightStatsMC.GotoAndStop("hide");
            bFlashlightVisible = false;
        }
    }
    //return;    
}

function EnableFlashlightWarn(bool bEnable)
{
    // End:0x50
    if(bEnable)
    {
        // End:0x4D
        if(!bFlashlightWarn)
        {
            FlashLightMC.GotoAndPlay("warn");
            bFlashlightWarn = true;
        }        
    }
    else
    {
        // End:0x8E
        if(bFlashlightWarn)
        {
            FlashLightMC.GotoAndStop("show");
            bFlashlightWarn = false;
        }
    }
    //return;    
}

function UpdateGrenadeIndicators()
{
    local int I;
    local Vector Loc;
    local Rotator Rot;
    local float DirOfProj, Distance;
    local Vector AxisX, AxisY, AxisZ, ProjDistance, ProjDirection;

    local bool bIsInFront;
    local Vector2D AngularDist;
    local Rotator tmpRotator;
    local Vector tmpVector;
    local GrenadeIndicator GI;

    GetPC().GetPlayerViewPoint(Loc, Rot);
    GetAxes(Rot, AxisX, AxisY, AxisZ);
    I = GrenadeIndicators.Length - 1;
    J0x6F:

    // End:0x4A4 [Loop If]
    if(I >= 0)
    {
        GI = GrenadeIndicators[I];
        // End:0x108
        if(GI.Proj == none)
        {
            GI.GFx.SetVisible(false);
            GrenadeIndicators.Remove(I, 1);                        
        }
        else
        {
            ProjDistance = GI.Proj.Location - Loc;
            Distance = VSize(ProjDistance);
            // End:0x430
            if((Distance < float(1000)) && (GetPC().WorldInfo.TimeSeconds - GI.Proj.CreationTime) > float(1))
            {
                ProjDirection = Normal(ProjDistance);
                bIsInFront = GetAngularDistance(AngularDist, ProjDirection, AxisX, AxisY, AxisZ);
                GetAngularDegreesFromRadians(AngularDist);
                // End:0x2AC
                if(bIsInFront)
                {
                    DirOfProj = AngularDist.X;
                    // End:0x2A9
                    if(DirOfProj < float(0))
                    {
                        DirOfProj += float(360);
                    }                    
                }
                else
                {
                    DirOfProj = 180.0000000 + AngularDist.X;
                }
                tmpRotator = MakeRotator(0, int(DirOfProj * 182.0444000), 0);
                tmpVector.Y = -FClamp((Distance / float(1000)) * float(200), 10.0000000, 200.0000000);
                tmpVector = TransformVectorByRotation(tmpRotator, tmpVector, !bIsInFront);
                GI.GFx.SetVisible(true);
                GI.GFx.SetPosition((1920.0000000 / float(2)) + tmpVector.X, (1080.0000000 / float(2)) + tmpVector.Y);                
            }
            else
            {
                GI.GFx.GotoAndPlayI(1);
                GI.GFx.SetVisible(false);
            }
        }
        I--;
        // [Loop Continue]
        goto J0x6F;
    }
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
    // End:0x317
    foreach HitLocIndicators(HI)
    {
        // End:0x2CD
        if((((GetPC().WorldInfo.TimeSeconds - HI.TimeOfHit) < float(3)) && HI.Instigator != none) && HI.Instigator.IsAliveAndWell())
        {
            HitDirection = Normal(HI.Instigator.Location - Loc);
            bIsInFront = GetAngularDistance(AngularDist, HitDirection, AxisX, AxisY, AxisZ);
            GetAngularDegreesFromRadians(AngularDist);
            // End:0x1FF
            if(bIsInFront)
            {
                DirOfShot = 180.0000000 + AngularDist.X;                
            }
            else
            {
                DirOfShot = -AngularDist.X;
                // End:0x24A
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

function ShowGrenadeIndicator(Projectile Proj, bool bShow)
{
    local GrenadeIndicator GI;

    // End:0xD1
    if((Proj != none) && bShow)
    {
        GI.GFx = HUDOverlay.AttachMovie("grenade_indicator", "grenade_indicator_" $ string(GrenadeIndicatorsCount++));
        GI.Proj = Proj;
        GrenadeIndicators.AddItem(GI);                
    }
    else
    {
        // End:0x16F
        if(Proj != none)
        {
            // End:0x16E
            foreach GrenadeIndicators(GI)
            {
                // End:0x16D
                if(GI.Proj == Proj)
                {
                    GI.GFx.SetVisible(false);
                    GrenadeIndicators.RemoveItem(GI);                                        
                }
                else
                {                    
                }
            }            
        }
    }
    //return;    
}

function DisplayHit(Pawn InstigatorPawn, Vector HitDir, int Damage, class<DamageType> DamageType)
{
    local THitLocIndicator HI;

    // End:0x191
    if((class<EvilDmgType_Base>(DamageType) != none) && class<EvilDmgType_Base>(DamageType).default.bLocationalHit)
    {
        HI.GFx = HitLocIndicator.AttachMovie("dirHitArc", "dirHitArc" $ string(HitLocIndicatorsCount++));
        HI.TimeOfHit = GetPC().WorldInfo.TimeSeconds;
        HI.Instigator = InstigatorPawn;
        HI.ShotLoc = HitDir;
        HI.GFx.GotoAndPlay("on");
        HitLocIndicators.AddItem(HI);        
    }
    //return;    
}

function SetHUDElementsVisible(bool Visible)
{
    super.SetHUDElementsVisible(Visible);
    ReloadMC.SetVisible(Visible);
    HeadshotMC.SetVisible(Visible);
    CompassMC.SetVisible(Visible);
    HintTextMC.SetVisible(Visible);
    TutorialMC.SetVisible(Visible);
    HitLocIndicator.SetVisible(Visible);
    EnemyHitMC.SetVisible(Visible);
    WeaponStatsMC.SetVisible(Visible);
    ItemsMC.SetVisible(Visible);
    TreasuresStatsMC.SetVisible(Visible);
    FlashlightStatsMC.SetVisible(Visible);
    NotepadHintsMC.SetVisible(Visible);
    MapHintsMC.SetVisible(Visible);
    PlayerStatsMC.SetVisible(false);
    ArtifactsMC.SetVisible(false);
    MultiplayerStatsMC.SetVisible(false);
    MultiplayerStreaksMC.SetVisible(false);
    DeathTimerMC.SetVisible(false);
    // End:0x356
    if((AdvGRI(GRI) != none) && int(AdvGRI(GRI).LastVotingState) == int(1))
    {
        VotingComponent.VoteMC.SetVisible(Visible);        
    }
    else
    {
        VotingComponent.VoteMC.SetVisible(false);
    }
    //return;    
}

simulated function bool IsVotingCompontentVisible()
{
    local ASDisplayInfo DI;

    DI = VotingComponent.VoteMC.GetDisplayInfo();
    return DI.Visible;
    //return ReturnValue;    
}

function PlayGameplayNotification(name ThemeName)
{
    local int ThemeIndex, EventIndex;
    local UISoundTheme Theme;

    ThemeIndex = SoundThemes.Find('ThemeName', ThemeName);    
    // End:0x143
    if(ThemeIndex != -1)
    {
        Theme = SoundThemes[ThemeIndex].Theme;
        // End:0x143
        if((Theme != none) && Theme.SoundEventBindings.Length > 0)
        {
            EventIndex = Rand(Theme.SoundEventBindings.Length);
            GetPC().Kismet_ClientPlaySound(Theme.SoundEventBindings[EventIndex].SoundToPlay, GetPC(), 1.0000000, 1.0000000, 0.0000000, false, true);
        }
    }
    //return;    
}

function ShowGameplayIndicator(optional AdvGFxHud.EIndicatorType IndicatorType = 0)
{
    local string Message, postfix;

    Compass_tf.SetBool("html", true);
    switch(IndicatorType)
    {
        // End:0x158
        case 1:
            GetPC().PlaySound(SoundCue'a_GameplaySounds.Treasure.a_compass_announce', true);
            Message = NoteString;
            postfix = "_v";
            // End:0x10E
            if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
            {
                Message = NoteStringPad;
            }
            Compass_tf.SetString("htmlText", ParseString(Message, GetPC()));
            // End:0x598
            break;
        // End:0x271
        case 2:
            GetPC().PlaySound(SoundCue'a_GameplaySounds.Treasure.a_compass_announce', true);
            Message = FlashlightString;
            postfix = "_x";
            // End:0x227
            if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
            {
                Message = FlashlightStringPad;
            }
            Compass_tf.SetString("htmlText", ParseString(Message, GetPC()));
            // End:0x598
            break;
        // End:0x39E
        case 3:
            GetPC().PlaySound(SoundCue'a_GameplaySounds.Treasure.a_compass_announce', true);
            Message = POIString;
            postfix = "_z";
            // End:0x354
            if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
            {
                Message = Repl(POIString, "{MMB}", "{SELECT}", false);
            }
            Compass_tf.SetString("htmlText", ParseString(Message, GetPC()));
            // End:0x598
            break;
        // End:0x420
        case 4:
            GetPC().PlaySound(SoundCue'a_GameplaySounds.Treasure.a_compass_announce', true);
            TreasuresInfoLabelTF.SetText(MapString);
            TreasuresStatsMC.GotoAndPlay("map");
            return;
        // End:0x539
        case 5:
            GetPC().PlaySound(SoundCue'a_GameplaySounds.Treasure.a_compass_announce', true);
            Message = FlashlightString2;
            postfix = "_x";
            // End:0x4EF
            if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
            {
                Message = FlashlightStringPad2;
            }
            Compass_tf.SetString("htmlText", ParseString(Message, GetPC()));
            // End:0x598
            break;
        // End:0x588
        case 0:
            CompassIndicatorMC.SetVisible(true);
            CompassIndicatorMC.GotoAndStop("open");
            return;
            // End:0x598
            break;
        // End:0xFFFF
        default:
            ScriptTrace();
            // End:0x598
            break;
            break;
    }
    CompassMC.SetVisible(true);
    Compass_g.GotoAndStop("pc" $ postfix);
    CompassMC.GotoAndPlay("open");
    GetPC().ClientPlayForceFeedbackWaveform(EvilPlayerController(GetPC()).CameraShakeShortWaveForm);
    //return;    
}

function HideGameplayIndicator()
{
    CompassMC.GotoAndPlay("close");
    CompassMC.SetVisible(false);
    //return;    
}

function ShowReload(bool Show)
{
    // End:0x35
    if(Show)
    {
        ReloadMC.GotoAndPlay("show");        
    }
    else
    {
        ReloadMC.GotoAndStop("hide");
    }
    bReloadVisible = Show;
    //return;    
}

static function string ParseString(string Text, PlayerController PC)
{
    local string Result, Prefix, postfix;
    local AdvPlayerInput AdvInput;

    // End:0x22
    if(AdvPlayerController(PC) == none)
    {
        return Result;
    }
    AdvInput = AdvPlayerInput(PC.PlayerInput);
    postfix = "_small";
    // End:0xB1
    if(PC.WorldInfo.IsConsoleBuild(2))
    {
        Prefix = "ps3_";        
    }
    else
    {
        // End:0x12B
        if(PC.WorldInfo.IsConsoleBuild(1) || AdvPlayerController(PC).IsPCGamepadMode())
        {
            Prefix = "xbox_";            
        }
        else
        {
            Result = Text;
            Result = Repl(Result, "{A}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Jump", true))) $ "]", false);
            Result = Repl(Result, "{B}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Melee", true))) $ "]", false);
            Result = Repl(Result, "{X}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_ReloadWeapon", true))) $ "]", false);
            Result = Repl(Result, "{Y}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_WeaponSwitch", true))) $ "]", false);
            Result = Repl(Result, "{R1}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Grenade", true))) $ "]", false);
            Result = Repl(Result, "{R2}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Fire", true))) $ "]", false);
            Result = Repl(Result, "{L1}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_GameplayObject", true))) $ "]", false);
            Result = Repl(Result, "{L2}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_AltFire", true))) $ "]", false);
            Result = Repl(Result, "{SELECT}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Stats", true))) $ "]", false);
            Result = Repl(Result, "{DPAD_UP}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_TEST_None", true))) $ "]", false);
            Result = Repl(Result, "{DPAD_RIGHT}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_PC_TEST_NotepadNext", true))) $ "]", false);
            Result = Repl(Result, "{DPAD_LEFT}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_PC_TEST_NotepadPrev", true))) $ "]", false);
            Result = Repl(Result, "{DPAD_DOWN}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_PC_TEST_Compass", true))) $ "]", false);
            Result = Repl(Result, "{R3}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Duck", true))) $ "]", false);
            Result = Repl(Result, "{L3}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Sprint", true))) $ "]", false);
            Result = Repl(Result, "{RSTICK}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName('UILook')) $ "]", false);
            Result = Repl(Result, "{LSTICK}", ((((((("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_MoveForward", true))) $ "], [") $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Backward", true))) $ "], [") $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_StrafeLeft", true))) $ "], [") $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_StrafeRight", true))) $ "]", false);
            Result = Repl(Result, "{MMB}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Melee", true))) $ "]", false);
            Result = Repl(Result, "{USE}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_Use", true))) $ "]", false);
            Result = Repl(Result, "{4}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_TEST_None", true))) $ "]", false);
            Result = Repl(Result, "{5}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_TEST_Torch", true))) $ "]", false);
            Result = Repl(Result, "{6}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_TEST_Compass", true))) $ "]", false);
            Result = Repl(Result, "{7}", ("[" $ Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_TEST_Map", true))) $ "]", false);
            return Result;
        }
    }
    Result = Text;
    Result = Repl(Result, "{A}", ((("<img src='" $ Prefix) $ "a") $ postfix) $ "'>", false);
    Result = Repl(Result, "{B}", ((("<img src='" $ Prefix) $ "b") $ postfix) $ "'>", false);
    Result = Repl(Result, "{X}", ((("<img src='" $ Prefix) $ "x") $ postfix) $ "'>", false);
    Result = Repl(Result, "{Y}", ((("<img src='" $ Prefix) $ "y") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R1}", ((("<img src='" $ Prefix) $ "r1") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R2}", ((("<img src='" $ Prefix) $ "r2") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L1}", ((("<img src='" $ Prefix) $ "l1") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L2}", ((("<img src='" $ Prefix) $ "l2") $ postfix) $ "'>", false);
    Result = Repl(Result, "{SELECT}", ((("<img src='" $ Prefix) $ "select") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_UP}", ((("<img src='" $ Prefix) $ "lup") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_RIGHT}", ((("<img src='" $ Prefix) $ "lright") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_LEFT}", ((("<img src='" $ Prefix) $ "lleft") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_DOWN}", ((("<img src='" $ Prefix) $ "ldown") $ postfix) $ "'>", false);
    // End:0x1269
    if((AdvPlayerController(PC).ProfileSettings != none) && int(AdvPlayerController(PC).ProfileSettings.GetStickConfigOption()) == int(2))
    {
        Result = Repl(Result, "{R3}", ((("<img src='" $ Prefix) $ "l3") $ postfix) $ "'>", false);
        Result = Repl(Result, "{L3}", ((("<img src='" $ Prefix) $ "r3") $ postfix) $ "'>", false);
        Result = Repl(Result, "{RSTICK}", ((("<img src='" $ Prefix) $ "lstick") $ postfix) $ "'>", false);
        Result = Repl(Result, "{LSTICK}", ((("<img src='" $ Prefix) $ "rstick") $ postfix) $ "'>", false);        
    }
    else
    {
        Result = Repl(Result, "{R3}", ((("<img src='" $ Prefix) $ "r3") $ postfix) $ "'>", false);
        Result = Repl(Result, "{L3}", ((("<img src='" $ Prefix) $ "l3") $ postfix) $ "'>", false);
        Result = Repl(Result, "{RSTICK}", ((("<img src='" $ Prefix) $ "rstick") $ postfix) $ "'>", false);
        Result = Repl(Result, "{LSTICK}", ((("<img src='" $ Prefix) $ "lstick") $ postfix) $ "'>", false);
    }
    Result = Repl(Result, "{USE}", ((("<img src='" $ Prefix) $ "a") $ postfix) $ "'>", false);
    Result = Repl(Result, "{4}", ((("<img src='" $ Prefix) $ "lup") $ postfix) $ "'>", false);
    Result = Repl(Result, "{5}", ((("<img src='" $ Prefix) $ "lleft") $ postfix) $ "'>", false);
    Result = Repl(Result, "{6}", ((("<img src='" $ Prefix) $ "ldown") $ postfix) $ "'>", false);
    Result = Repl(Result, "{7}", ((("<img src='" $ Prefix) $ "lright") $ postfix) $ "'>", false);
    return Result;
    //return ReturnValue;    
}

function ShowTutorialMessage(string Text, optional bool html = false)
{
    // End:0x82
    if(html)
    {
        TutorialMessageTF.SetBool("html", true);
        TutorialMessageTF.SetString("htmlText", ParseString(Text, GetPC()));        
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

function SetCenterMessageText(string Text, optional bool long = false, optional bool html = false)
{
    // End:0x87
    if(html)
    {
        CenterTextTF.SetBool("html", true);
        CenterTextTF.SetString("htmlText", ParseString(Text, GetPC()));        
    }
    else
    {
        CenterTextTF.SetBool("html", false);
        CenterTextTF.SetString("text", Text);
    }
    // End:0x110
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

function SetHintMessageText(string Text, optional bool html = false)
{
    // End:0x82
    if(html)
    {
        HintTextTF.SetBool("html", true);
        HintTextTF.SetString("htmlText", ParseString(Text, GetPC()));        
    }
    else
    {
        HintTextTF.SetBool("html", false);
        HintTextTF.SetString("text", Text);
    }
    HintTextMC.GotoAndPlay("on");
    //return;    
}

function HideHintMessage()
{
    HintTextMC.GotoAndStop("off");
    //return;    
}

function SetUpgradeInfoText(string Text, optional bool html = false, optional string IconPath = "")
{
    // End:0x59
    if(IconPath != "")
    {
        UpgradeInfoUILoader.SetString("source", "img://" $ IconPath);        
    }
    else
    {
        UpgradeInfoUILoader.SetString("source", "img://UI_AdvCommon.Textures.Blank");
    }
    // End:0x121
    if(html)
    {
        UpgradeInfoTF.SetBool("html", true);
        UpgradeInfoTF.SetString("htmlText", ParseString(Text, GetPC()));        
    }
    else
    {
        UpgradeInfoTF.SetBool("html", false);
        UpgradeInfoTF.SetString("text", Text);
    }
    UpgradeInfoMC.GotoAndPlay("show");
    //return;    
}

function SetUpgrade2InfoText(string Text)
{
    UpgradeQueueTF1.SetBool("html", false);
    UpgradeQueueTF1.SetString("text", Text);
    UpgradeQueueMC1.GotoAndPlay("Upgrade2Show");
    //return;    
}

function SetUpgrade3InfoText(string Text)
{
    UpgradeQueueTF2.SetBool("html", false);
    UpgradeQueueTF2.SetString("text", Text);
    UpgradeQueueMC2.GotoAndPlay("Upgrade3Show");
    //return;    
}

function HideUpgrades2InfoText()
{
    UpgradeQueueMC1.GotoAndPlay("Upgrade2Hide");
    //return;    
}

function HideUpgrades3InfoText()
{
    UpgradeQueueMC2.GotoAndPlay("Upgrade3Hide");
    //return;    
}

function SetKillInfoText(string text1, string text2, optional bool html = false)
{
    // End:0xEF
    if(html)
    {
        KillInfoTF.SetBool("html", true);
        KillInfoTF.SetString("htmlText", ParseString(text1, GetPC()));
        KillInfoTF2.SetBool("html", true);
        KillInfoTF2.SetString("htmlText", ParseString(text2, GetPC()));        
    }
    else
    {
        KillInfoTF.SetBool("html", false);
        KillInfoTF.SetString("text", text1);
        KillInfoTF2.SetBool("html", false);
        KillInfoTF2.SetString("text", text2);
    }
    KillInfoMC.GotoAndPlay("show");
    //return;    
}

function ShowTreasureCollectedMessage(AdvTypes.ETreasureType TreasureType)
{
    local int TreasuresCollected, TreasuresAll, I, TreasureMappingIndex;
    local AdvEngine Eng;
    local AdvTypes.ELevelID LevelID;

    // End:0x3C6
    if(AdvGRI_SP(GRI) != none)
    {
        LevelID = byte(AdvGRI_SP(GRI).ChapterNum);
        Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
        TreasureMappingIndex = -1;
        I = 0;
        J0x97:

        // End:0x135 [Loop If]
        if(I < Eng.TreasureMapping.Length)
        {
            // End:0x127
            if(int(LevelID) == int(Eng.TreasureMapping[I].LevelID))
            {
                TreasureMappingIndex = I;
                // [Explicit Break]
                goto J0x135;
            }
            I++;
            // [Loop Continue]
            goto J0x97;
        }
        J0x135:

        // End:0x3C6
        if(TreasureMappingIndex > -1)
        {
            I = 0;
            J0x153:

            // End:0x29E [Loop If]
            if(I < Eng.TreasureMapping[TreasureMappingIndex].TreasureID.Length)
            {
                // End:0x290
                if(int(TreasureType) == int(Class'AdvTreasureTrigger_Base'.static.GetTreasureTypeFromID(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I])))
                {
                    TreasuresAll++;
                    // End:0x290
                    if(Eng.IsTreasureCollected(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I]))
                    {
                        TreasuresCollected++;
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x153;
            }
            LastTreasureValCollected = TreasuresCollected;
            LastTreasureValAll = TreasuresAll;
            LastTreasureTypeCollected = TreasureType;
            TreasuresInfoLabelTF.SetText(TreasuresString);
            TreasuresLabelTF.SetText(Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', int(TreasureType))), "ADVGame"));
            TreasuresTF.SetText((string(Max(TreasuresCollected - 1, 0)) $ "/") $ string(TreasuresAll));
            TreasuresStatsMC.GotoAndPlay("show");
        }
    }
    //return;    
}

function TreasureAddHUD()
{
    TreasuresTF.SetText((string(LastTreasureValCollected) $ "/") $ string(LastTreasureValAll));
    //return;    
}

function ShowTreasurePerkMessage(AdvTypes.ETreasureType TreasureType)
{
    SetCenterMessageText("BLA!", true);
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

function ShowEnemyHitIndicator()
{
    EnemyHitMC.GotoAndPlay("play");
    //return;    
}

function ShowMapHints(bool bShow)
{
    local int TreasuresCollected[ETreasureType], TreasuresAll, I, TreasureMappingIndex;
    local AdvTypes.ETreasureType TreasureType;
    local AdvEngine Eng;
    local AdvTypes.ELevelID LevelID;
    local array<UDKUIResourceDataProvider> ProviderList;

    // End:0x5C3
    if(AdvGRI_SP(GRI) != none)
    {
        LevelID = byte(AdvGRI_SP(GRI).ChapterNum);
        Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
        TreasureMappingIndex = -1;
        I = 0;
        J0x97:

        // End:0x135 [Loop If]
        if(I < Eng.TreasureMapping.Length)
        {
            // End:0x127
            if(int(LevelID) == int(Eng.TreasureMapping[I].LevelID))
            {
                TreasureMappingIndex = I;
                // [Explicit Break]
                goto J0x135;
            }
            I++;
            // [Loop Continue]
            goto J0x97;
        }
        J0x135:

        // End:0x183
        if(TreasureMappingIndex > -1)
        {
            MapHintsMC.GotoAndPlay(((bShow) ? "open" : "close"));
        }
        // End:0x5C3
        if((TreasureMappingIndex > -1) && bShow)
        {
            Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
            I = 0;
            J0x1E1:

            // End:0x2E6 [Loop If]
            if(I < ProviderList.Length)
            {
                // End:0x2D8
                if(GetPC().WorldInfo.GetMapName(true) == UTUIDataProvider_MapInfo(ProviderList[I]).MapName)
                {
                    MapHintTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.static.ConvertFriendlyNameToReadable(UTUIDataProvider_MapInfo(ProviderList[I]).FriendlyName));
                    // [Explicit Break]
                    goto J0x2E6;
                }
                I++;
                // [Loop Continue]
                goto J0x1E1;
            }
            J0x2E6:

            I = 0;
            J0x2F1:

            // End:0x44C [Loop If]
            if(I < Eng.TreasureMapping[TreasureMappingIndex].TreasureID.Length)
            {
                TreasureType = Class'AdvTreasureTrigger_Base'.static.GetTreasureTypeFromID(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I]);
                TreasuresAll[int(TreasureType)]++;
                // End:0x43E
                if(Eng.IsTreasureCollected(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I]))
                {
                    TreasuresCollected[int(TreasureType)]++;
                }
                I++;
                // [Loop Continue]
                goto J0x2F1;
            }
            MapLifeHintTF.SetText(((((Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 0)), "ADVGame")) $ ":") @ string(TreasuresCollected[0])) $ "/") $ string(TreasuresAll[0]));
            MapWarriorHintTF.SetText(((((Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 2)), "ADVGame")) $ ":") @ string(TreasuresCollected[2])) $ "/") $ string(TreasuresAll[2]));
            MapLightHintTF.SetText(((((Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 1)), "ADVGame")) $ ":") @ string(TreasuresCollected[1])) $ "/") $ string(TreasuresAll[1]));
        }
    }
    //return;    
}

function ShowNotepadHints(bool bShow, optional bool bShowCloseAnim = true, optional string Text)
{
    // End:0x74
    if(bShow)
    {
        // End:0x71
        if(Text != "")
        {
            NotepadHintsMC.GotoAndPlay("open");
            NotepadHintTF.SetText(Text);
        }        
    }
    else
    {
        // End:0xA7
        if(bShowCloseAnim)
        {
            NotepadHintsMC.GotoAndPlay("close");
        }
    }
    //return;    
}

function SetKillStreakVisible(int StreakIndex, bool bVisible)
{
    // End:0x56
    if(StreakIndex < 4)
    {
        KillStreakObjects[StreakIndex].KillStreakMC.SetVisible(bVisible);
    }
    //return;    
}

function SetKillStreakActivationText(int StreakIndex, string ActivationText)
{
    // End:0xA3
    if(StreakIndex < 4)
    {
        KillStreakObjects[StreakIndex].ActivatorTF.SetBool("html", true);
        KillStreakObjects[StreakIndex].ActivatorTF.SetString("htmlText", ActivationText);
    }
    //return;    
}

function SetKillStreakIcon(int StreakIndex, int IconIndex)
{
    // End:0x9A
    if(StreakIndex < 4)
    {
        KillStreakObjects[StreakIndex].IconMC_g.GotoAndStopI(IconIndex);
        KillStreakObjects[StreakIndex].IconMC_bg.GotoAndStopI(IconIndex);
    }
    //return;    
}

function SetKillStreakKillCount(int KillStreakCount)
{
    local int I;

    // End:0x1C
    if(KillStreakCount > 12)
    {
        KillStreakCount = 12;
    }
    I = 0;
    J0x27:

    // End:0x138 [Loop If]
    if(I < 12)
    {
        // End:0xB8
        if((GRI != none) && AdvGRI(GRI) != none)
        {
            // End:0xB8
            if(AdvGRI(GRI).KillStrikeDots[I] == 0)
            {
                // End:0xB5
                if((I + 1) < 12)
                {
                    KillStreakCount++;
                }
                // [Explicit Continue]
                goto J0x12A;
            }
        }
        // End:0xFF
        if((I + 1) > KillStreakCount)
        {
            KillStreakCountMC[I].GotoAndStopI(1);            
        }
        else
        {
            KillStreakCountMC[I].GotoAndStopI(2);
        }
        J0x12A:

        I++;
        // [Loop Continue]
        goto J0x27;
    }
    //return;    
}

function PlayKillStreakActiveAnim(int StreakIndex)
{
    // End:0x52
    if(StreakIndex < 4)
    {
        KillStreakObjects[StreakIndex].IconMC.GotoAndPlay("open");
    }
    //return;    
}

function PlayKillStreakUseAnim(int StreakIndex)
{
    // End:0x51
    if(StreakIndex < 4)
    {
        KillStreakObjects[StreakIndex].IconMC.GotoAndPlay("use");
    }
    //return;    
}

function PlayKillStreakDeadAnim()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x6B [Loop If]
    if(I < 4)
    {
        KillStreakObjects[I].IconMC.GotoAndPlay("dead");
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function PlayKillStreakInactiveAnim(int StreakIndex)
{
    // End:0x4D
    if(StreakIndex < 4)
    {
        KillStreakObjects[StreakIndex].IconMC.GotoAndStopI(1);
    }
    //return;    
}

function UpdateItemsOnHud()
{
    local int I;
    local string FinalString;
    local AdvPlayerController PC;
    local AdvPRI PRI;

    PC = AdvPlayerController(GetPC());
    PRI = AdvPRI(PC.PlayerReplicationInfo);
    // End:0x5F
    if(PRI == none)
    {
        return;
    }
    I = 0;
    J0x6A:

    // End:0x150 [Loop If]
    if(I < 24)
    {
        // End:0x142
        if(PRI.ItemsCount[I] > 0)
        {            
            FinalString @= ItemsIcons[I];
            // End:0x142
            if(PRI.ItemsCount[I] > 1)
            {                
                FinalString $= ("x" $ string(PRI.ItemsCount[I]));
            }
        }
        I++;
        // [Loop Continue]
        goto J0x6A;
    }
    ItemsTF.SetBool("html", true);
    ItemsTF.SetString("htmlText", FinalString);
    //return;    
}

function AddObjectiveIcon(Actor Target, string Type)
{
    local TObjIcon ObjIcon;
    local int I;

    // End:0x35
    if((Target == none) || Target.bDeleteMe)
    {
        return;
    }
    I = 0;
    J0x40:

    // End:0x9C [Loop If]
    if(I < ObjectivesIcons.Length)
    {
        // End:0x8E
        if(ObjectivesIcons[I].Target == Target)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x40;
    }
    ObjIcon.Target = Target;
    ObjIcon.Type = Type;
    ObjIcon.ObjectiveRoot = HUDOverlay.AttachMovie("waypoint", "waypoint" $ string(ObjectivesCount++));
    ObjIcon.ObjectiveMC = ObjIcon.ObjectiveRoot.GetObject("waypoint");
    ObjIcon.ObjectiveIconMC = ObjIcon.ObjectiveMC.GetObject("waypoint_mc");
    ObjIcon.ObjectiveArrowMC = ObjIcon.ObjectiveMC.GetObject("waypoint_arrow_mc");
    ObjIcon.ObjectiveMC.GotoAndStop(Type);
    ObjectivesIcons.AddItem(ObjIcon);    
    //return;    
}

function DeleteObjectiveIcon(Actor Target)
{
    local int I;
    local ASDisplayInfo D;

    D.hasVisible = true;
    D.Visible = false;
    I = ObjectivesIcons.Length - 1;
    J0x55:

    // End:0x102 [Loop If]
    if(I >= 0)
    {
        // End:0xF4
        if(ObjectivesIcons[I].Target == Target)
        {
            ObjectivesIcons[I].ObjectiveRoot.SetDisplayInfo(D);
            ObjectivesIcons.Remove(I, 1);            
            return;
        }
        I--;
        // [Loop Continue]
        goto J0x55;
    }
    //return;    
}

function ClearObjectiveIcons()
{
    local int I;
    local ASDisplayInfo D;

    D.hasVisible = true;
    D.Visible = false;
    I = ObjectivesIcons.Length - 1;
    J0x55:

    // End:0xCC [Loop If]
    if(I >= 0)
    {
        ObjectivesIcons[I].ObjectiveRoot.SetDisplayInfo(D);
        ObjectivesIcons.Remove(I, 1);        
        I--;
        // [Loop Continue]
        goto J0x55;
    }
    //return;    
}

function RefreshObjectiveIconsFromStorage()
{
    local AdvPlayerController PC;
    local int I;

    PC = AdvPlayerController(GetPC());
    // End:0xFC
    if(PC != none)
    {
        ClearObjectiveIcons();
        I = 0;
        J0x41:

        // End:0xFC [Loop If]
        if(I < PC.ObjectiveIconStorage.Length)
        {
            AddObjectiveIcon(PC.ObjectiveIconStorage[I].Target, PC.ObjectiveIconStorage[I].Type);
            I++;
            // [Loop Continue]
            goto J0x41;
        }
    }
    //return;    
}

function UpdateObjectivesIcons()
{
    local ASDisplayInfo D;
    local int I;
    local Vector V, PCLoc, AxisX, AxisY, AxisZ, TargetDirection,
	    TargetDistance, Dir2D, ScreenCenterVect;

    local Rotator PCRot;
    local bool bIsInFront, bShouldBeVisible;
    local Vector2D ScreenInvScale, ViewportSize, AngularDist;

    D.hasVisible = true;
    D.Visible = false;
    GetPC().GetPlayerViewPoint(PCLoc, PCRot);
    GetAxes(PCRot, AxisX, AxisY, AxisZ);
    ViewportSize.X = 1920.0000000;
    ViewportSize.Y = 1080.0000000;
    ScreenInvScale.X = ViewportSize.X / float(GetPC().myHUD.Canvas.SizeX);
    ScreenInvScale.Y = ViewportSize.Y / float(GetPC().myHUD.Canvas.SizeY);
    ScreenCenterVect.X = ViewportSize.X * 0.5000000;
    ScreenCenterVect.Y = ViewportSize.Y * 0.5000000;
    I = ObjectivesIcons.Length - 1;
    J0x27D:

    // End:0xD14 [Loop If]
    if(I >= 0)
    {
        // End:0xC8D
        if((ObjectivesIcons[I].Target != none) && !ObjectivesIcons[I].Target.bDeleteMe)
        {
            // End:0x37F
            if((ObjectivesIcons[I].Type == "bank_surv") || ObjectivesIcons[I].Type == "ammo_surv")
            {
                UpdateObjectiveIconNotSnapped(I);
                // [Explicit Continue]
                goto J0xD06;
            }
            bShouldBeVisible = true;
            // End:0x56B
            if(ObjectivesIcons[I].Type == "objective")
            {
                // End:0x455
                if(!bObjectiveFocusModeVisible && GetPC().IsInState('NotepadFocus'))
                {
                    ObjectivesIcons[I].ObjectiveMC.GotoAndStop("objectivefocused");
                    bObjectiveFocusModeVisible = true;                    
                }
                else
                {
                    // End:0x4FA
                    if(bObjectiveFocusModeVisible && !GetPC().IsInState('NotepadFocus'))
                    {
                        ObjectivesIcons[I].ObjectiveMC.GotoAndStop(ObjectivesIcons[I].Type);
                        bObjectiveFocusModeVisible = false;
                    }
                }
                bShouldBeVisible = bObjectiveFocusModeVisible && int(AdvPlayerController(GetPC()).GetPuzzleDifficultyLevel()) <= int(AdvPlayerController(GetPC()).FocusMaxDifficultyLevel);
            }
            // End:0xC04
            if(bShouldBeVisible)
            {
                TargetDistance = ObjectivesIcons[I].Target.Location - PCLoc;
                TargetDirection = Normal(TargetDistance);
                bIsInFront = GetAngularDistance(AngularDist, TargetDirection, AxisX, AxisY, AxisZ);
                GetAngularDegreesFromRadians(AngularDist);
                V = GetPC().myHUD.Canvas.Project(ObjectivesIcons[I].Target.Location);
                V.X *= ScreenInvScale.X;
                V.Y *= ScreenInvScale.Y;
                // End:0x7DF
                if(!bIsInFront)
                {
                    // End:0x7A6
                    if(V.X > ScreenCenterVect.X)
                    {
                        V.X = 0.0000000;                        
                    }
                    else
                    {
                        V.X = ViewportSize.X;
                    }
                }
                // End:0xAC5
                if((((V.X <= float(120)) || V.Y <= float(140)) || V.X >= (ViewportSize.X - float(120))) || V.Y >= (ViewportSize.Y - float(140)))
                {
                    V.Y = (-AngularDist.Y + ((GetPC().GetFOVAngle() / (ViewportSize.X / ViewportSize.Y)) * 0.5000000)) * (ViewportSize.Y / (GetPC().GetFOVAngle() / (ViewportSize.X / ViewportSize.Y)));
                    Dir2D = V - ScreenCenterVect;
                    ObjectivesIcons[I].ObjectiveArrowMC.SetFloat("_rotation", (Atan2(Dir2D.Y, Dir2D.X) * 57.2957800) + float(90));
                    ObjectivesIcons[I].ObjectiveArrowMC.SetVisible(true);                    
                }
                else
                {
                    ObjectivesIcons[I].ObjectiveArrowMC.SetVisible(false);
                }
                D.hasX = true;
                D.hasY = true;
                D.X = FClamp(V.X, 120.0000000, ViewportSize.X - float(120));
                D.Y = FClamp(V.Y, 140.0000000, ViewportSize.Y - float(140));
            }
            D.Visible = bShouldBeVisible && VSize(TargetDistance) > float(300);
            ObjectivesIcons[I].ObjectiveRoot.SetDisplayInfo(D);            
        }
        else
        {
            D.Visible = false;
            ObjectivesIcons[I].ObjectiveRoot.SetDisplayInfo(D);
            ObjectivesIcons.Remove(I, 1);            
        }
        J0xD06:

        I--;
        // [Loop Continue]
        goto J0x27D;
    }
    //return;    
}

function UpdateObjectiveIconNotSnapped(int I)
{
    local ASDisplayInfo D;
    local Vector V, PCLoc, AxisX, AxisY, AxisZ, TargetDirection,
	    TargetDistance;

    local Rotator PCRot;
    local bool bIsInFront;
    local Vector2D ScreenInvScale, ViewportSize, AngularDist;

    D.hasVisible = true;
    D.Visible = false;
    GetPC().GetPlayerViewPoint(PCLoc, PCRot);
    GetAxes(PCRot, AxisX, AxisY, AxisZ);
    ViewportSize.X = 1920.0000000;
    ViewportSize.Y = 1080.0000000;
    ScreenInvScale.X = ViewportSize.X / float(GetPC().myHUD.Canvas.SizeX);
    ScreenInvScale.Y = ViewportSize.Y / float(GetPC().myHUD.Canvas.SizeY);
    TargetDistance = ObjectivesIcons[I].Target.Location - PCLoc;
    TargetDirection = Normal(TargetDistance);
    bIsInFront = GetAngularDistance(AngularDist, TargetDirection, AxisX, AxisY, AxisZ);
    V = GetPC().myHUD.Canvas.Project(ObjectivesIcons[I].Target.Location);
    V.X *= ScreenInvScale.X;
    V.Y *= ScreenInvScale.Y;
    // End:0x47F
    if(bIsInFront)
    {
        D.hasX = true;
        D.hasY = true;
        D.X = V.X;
        D.Y = V.Y;
        D.Visible = VSize(TargetDistance) > float(300);
    }
    ObjectivesIcons[I].ObjectiveRoot.SetDisplayInfo(D);
    //return;    
}

function ShowDeathTimer()
{
    //return;    
}

function HideDeathTimer()
{
    //return;    
}

function UpdateDeathTimer(int Perc)
{
    local int HealthScale;

    HealthScale = Clamp(Perc, 0, 99);
    DeathTimerMask.GotoAndStopI(100 - HealthScale);
    //return;    
}

function ShowTutorialPopup(bool bShow, optional bool bShowCloseAnim = true, optional string Text)
{
    // End:0xB8
    if(bShow)
    {
        // End:0xB5
        if(Text != "")
        {
            TutorialMC.GotoAndPlay("show");
            TutorialTF.SetBool("html", true);
            TutorialTF.SetString("htmlText", ParseString(Text, GetPC()));
        }        
    }
    else
    {
        // End:0xEA
        if(bShowCloseAnim)
        {
            TutorialMC.GotoAndPlay("hide");
        }
    }
    //return;    
}

defaultproperties
{
    bWeaponStatsVisible=true
    bFlashlightVisible=true
    WeaponStatsTimeout=3.0000000
    FlashlightTimeout=3.0000000
    ItemsIcons[0]="<img src='t_bug'>"
    ItemsIcons[1]="<img src='t_deska'>"
    ItemsIcons[2]="<img src='t_gas'>"
    ItemsIcons[3]="<img src='t_heartofatlantis'>"
    ItemsIcons[4]="<img src='t_key'>"
    ItemsIcons[5]="<img src='t_kula'>"
    ItemsIcons[6]="<img src='t_lom'>"
    ItemsIcons[7]="<img src='t_lzy'>"
    ItemsIcons[8]="<img src='t_moneys'>"
    ItemsIcons[9]="<img src='t_puzzel'>"
    ItemsIcons[10]="<img src='t_skull'>"
    ItemsIcons[11]="<img src='t_statuetka'>"
    ItemsIcons[12]="<img src='t_wiadro'>"
    ItemsIcons[13]="<img src='t_dlctreasure'>"
    Reload="Mag Ammo Low"
    HeadshotString="Boom! Headshot!"
    CompassString="Hold {MMB} and select Compass"
    CompassStringPad="Press {DPAD_DOWN} to use Compass"
    FlashlightString="Hold {L1} to use flashlight. It's the only way to make mummy vulnerable to bullets."
    FlashlightStringPad="Hold {L1} to use flashlight. It's the only way to make mummy vulnerable to bullets."
    FlashlightString2="Hold {L1} to use flashlight."
    FlashlightStringPad2="Hold {L1} to use flashlight."
    NoteString="Hold {MMB} and select Notepad"
    NoteStringPad="Press {DPAD_LEFT} / {DPAD_RIGHT} to use Notepad"
    MapString="Treasure Map Collected"
    MapStringPad="Treasure Map Collected"
    AmmoString="Ammo"
    HealthString="Health"
    TreasuresString="Treasure Collected"
    SavedCheckpointString="Checkpoint saved"
    PressAnyButton="Press any button to continue"
    LastCompassUpdateTime=-1000.0000000
    LastPOIUpdateTime=-1000.0000000
    LastMagazineTotalAmmo=-1
    LastMagazineTotalMaxAmmo=-1
    LastGrenadeCount=-1
    LastFlashlightPower=-1.0000000
    WeaponTypeStringMap[0]=(Class=Class'EvilGame.EvilWeap_Melee_Base',TypeString="none")
    WeaponTypeStringMap[1]=(Class=Class'AdvWeap_MG34_Base',TypeString="hmg")
    WeaponTypeStringMap[2]=(Class=Class'AdvWeap_Browning_Base',TypeString="shotgun")
    WeaponTypeStringMap[3]=(Class=Class'AdvWeap_M1887_Base',TypeString="shotgun")
    WeaponTypeStringMap[4]=(Class=Class'AdvWeap_SLD_Base',TypeString="shotgun")
    WeaponTypeStringMap[5]=(Class=Class'AdvWeap_LugerFix_Base',TypeString="pistol")
    WeaponTypeStringMap[6]=(Class=Class'AdvWeap_P38_Base',TypeString="pistol")
    WeaponTypeStringMap[7]=(Class=Class'AdvWeap_Roth_Base',TypeString="pistol")
    WeaponTypeStringMap[8]=(Class=Class'AdvWeap_Tokarev_Base',TypeString="pistol")
    WeaponTypeStringMap[9]=(Class=Class'AdvWeap_Vis_Base',TypeString="pistol")
    WeaponTypeStringMap[10]=(Class=Class'AdvWeap_Walther_Base',TypeString="pistol")
    WeaponTypeStringMap[11]=(Class=Class'AdvWeap_Webley_Base',TypeString="pistol")
    WeaponTypeStringMap[12]=(Class=Class'AdvWeap_AVS36_Base',TypeString="sniper")
    WeaponTypeStringMap[13]=(Class=Class'AdvWeap_kar98k_scope_Base',TypeString="sniper")
    WeaponTypeStringMap[14]=(Class=Class'AdvWeap_PZB38_Base',TypeString="sniper")
    WeaponTypeStringMap[15]=(Class=Class'AdvWeap_Gew98_Base',TypeString="rifle")
    WeaponTypeStringMap[16]=(Class=Class'AdvWeap_GEW06P_Base',TypeString="rifle")
    WeaponTypeStringMap[17]=(Class=Class'AdvWeap_MauserSelbstlader_Base',TypeString="rifle")
    WeaponTypeStringMap[18]=(Class=Class'AdvWeap_kar98k_Base',TypeString="rifle")
    WeaponTypeStringMap[19]=(Class=Class'AdvWeap_Musket_Base',TypeString="rifle")
    WeaponTypeStringMap[20]=(Class=Class'AdvWeap_FlareGun_Base',TypeString="special")
    WeaponTypeStringMap[21]=(Class=Class'AdvWeap_Leuchpistol_Base',TypeString="special")
    LastAmmoAmount=-1
    LastGranadesAmount=-1
    LastGameplayIndicatorShowTime=-1000.0000000
    MovieInfo=SwfMovie'UI_AdvHUD.AdvHUD'
    SoundThemes=/* Array type was not detected. */
}