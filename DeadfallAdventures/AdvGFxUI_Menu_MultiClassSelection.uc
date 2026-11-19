class AdvGFxUI_Menu_MultiClassSelection extends AdvGFxUI_Menu_Base
    config(UI);

enum EMenuPart
{
    MENU_ClassSelection,            // 0
    MENU_WeaponSelection,           // 1
    MENU_MAX                        // 2
};

struct StatBar
{
    var GFxObject Rects[10];

    structdefaultproperties
    {
        Rects[0]=none
        Rects[1]=none
        Rects[2]=none
        Rects[3]=none
        Rects[4]=none
        Rects[5]=none
        Rects[6]=none
        Rects[7]=none
        Rects[8]=none
        Rects[9]=none
    }
};

var GFxObject ButtonsMC;
var GFxObject MainWeaponMC;
var GFxObject SecondWeaponMC;
var GFxClikWidget SaveBaton;
var GFxClikWidget BackBtn;
var GFxClikWidget PredefinedClassBtn[5];
var GFxClikWidget CustomClassBtn[5];
var GFxClikWidget MainRightArrow;
var GFxClikWidget SecondRightArrow;
var GFxClikWidget MainLeftArrow;
var GFxClikWidget SecondLeftArrow;
var GFxClikWidget MainUILoader;
var GFxClikWidget SecondUILoader;
var array<GFxClikWidget> UpgradeUILoaders1;
var array<GFxClikWidget> UpgradeUILoaders2;
var GFxObject ActiveMarkBtn[5];
var GFxObject MainWeaponName;
var GFxObject MainWeaponType;
var GFxObject SecondWeaponName;
var GFxObject SecondWeaponType;
var GFxObject WeaponMain;
var GFxObject WeaponSecond;
var GFxObject WeaponMainLeftTF;
var GFxObject WeaponMainRightTF;
var GFxObject WeaponSecondLeftTF;
var GFxObject WeaponSecondRightTF;
var GFxObject KillsRequiredTF1;
var GFxObject KillsRequiredTF2;
var GFxObject UnlockMainWeaponStr;
var GFxObject UnlockSecondWeaponStr;
var array<GFxObject> WeaponStatBars1;
var array<GFxObject> WeaponStatBars2;
var string UpgradeIconPath_Spread_On;
var string UpgradeIconPath_ReloadSpeed_On;
var string UpgradeIconPath_Firerate_On;
var string UpgradeIconPath_Stamina_On;
var string UpgradeIconPath_Magazines_On;
var string UpgradeIconPath_Spread_Off;
var string UpgradeIconPath_ReloadSpeed_Off;
var string UpgradeIconPath_Firerate_Off;
var string UpgradeIconPath_Stamina_Off;
var string UpgradeIconPath_Magazines_Off;
var const localized string ReturnToMenu;
var bool bIsMenuPPOverrideOn;
var bool bShouldDisplayClassChangedInfo;
var bool bMainWeaponAvailable;
var bool bSecondWeaponAvailable;
var AdvGFxUI_Menu_MultiPause ParentMenu;
var AdvGFxUI_Menu_Footer footer;
var int CurrentViewedClassIndex;
var int MainWeaponIndex;
var int SecondWeaponIndex;
var int PlayerLevel;
var AdvGFxUI_Menu_MultiClassSelection.EMenuPart CurrentActiveMenuPart;
var StatBar StatBar1[6];
var StatBar StatBar2[6];

function bool CheckIfWeaponIsAccesibleInDLC(class<AdvWeap_Base> Weap)
{
    return true;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    local int I, J, PlayerXP;
    local array<int> LevelThresholds;
    local GFxObject WeaponStatus, UpgradeStats1, UpgradeStats2, Upgrades1, Upgrades2, UpgradeMC,
	    UpgradeIcon, KillsRequiredLabel1, KillsRequiredLabel2, WeaponStatsMC1, WeaponStatsMC2,
	    TitleTF, PlayerLevelTF, PlayerXPTF, WeaponStatTF, LevelMC,
	    XPmaskMC, LineMC;

    local ASDisplayInfo displayInfo;

    super.Start(StartPaused);
    Advance(0.0000000);
    AdvPlayerController(GetPC()).ProfileSettings.GetProfileSettingValueInt(36, PlayerXP);
    PlayerLevel = Class'AdvPRI'.static.CalculatePlayerLevel(PlayerXP);
    ButtonsMC = MenuMC.GetObject("buttons");
    MainWeaponMC = ButtonsMC.GetObject("mainweaponMC");
    SecondWeaponMC = ButtonsMC.GetObject("secondweaponMC");
    LevelMC = ButtonsMC.GetObject("levelMC");
    UpgradeStats1 = ButtonsMC.GetObject("nazwyMC");
    UpgradeStats2 = ButtonsMC.GetObject("nazwyMC2");
    Upgrades1 = ButtonsMC.GetObject("upgrades");
    Upgrades2 = ButtonsMC.GetObject("upgrades2");
    WeaponStatsMC1 = ButtonsMC.GetObject("weaponStatsMC");
    WeaponStatsMC2 = ButtonsMC.GetObject("weaponStatsMC2");
    LevelThresholds = Class'AdvClassInfo_MP_Base'.default.LevelThresholds;
    displayInfo.hasXScale = true;
    // End:0x396
    if(PlayerLevel < LevelThresholds.Length)
    {
        displayInfo.XScale = (float(PlayerXP - LevelThresholds[PlayerLevel - 1]) / float(LevelThresholds[PlayerLevel] - LevelThresholds[PlayerLevel - 1])) * 100.0000000;        
    }
    else
    {
        displayInfo.XScale = 100.0000000;
    }
    XPmaskMC = LevelMC.GetObject("xpmaskMC");
    XPmaskMC.SetDisplayInfo(displayInfo);
    UnlockMainWeaponStr = MainWeaponMC.GetObject("upgradenextTF");
    UnlockMainWeaponStr.SetVisible(false);
    UnlockSecondWeaponStr = SecondWeaponMC.GetObject("upgradenextTF");
    UnlockSecondWeaponStr.SetVisible(false);
    PlayerLevelTF = ButtonsMC.GetObject("playerlevelTF");
    TitleTF = ButtonsMC.GetObject("nickTF");
    PlayerXPTF = ButtonsMC.GetObject("playerxpTF");
    PlayerLevelTF.SetText(((Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerLevelStr", "ADVGame"), "`l", string(PlayerLevel)) @ " [") @ (Localize("AdvGFxUI_Menu_MultiPlayerSettings", ("PlayerLevelString[" $ string(Class'AdvGFxUI_Menu_MultiPlayerSettings'.static.GetRankGroupNumber(PlayerLevel))) $ "]", "ADVGame"))) @ "]");
    TitleTF.SetText(GetPC().PlayerReplicationInfo.PlayerName);
    // End:0x760
    if(Class'AdvClassInfo_MP_Base'.default.LevelThresholds.Length == PlayerLevel)
    {
        PlayerXPTF.SetText(Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerXPStr", "ADVGame"), "`x", string(PlayerXP)));        
    }
    else
    {
        PlayerXPTF.SetText((Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerXPStr", "ADVGame"), "`x", string(PlayerXP)) @ "/") @ string(LevelThresholds[PlayerLevel]));
    }
    WeaponStatBars1[0] = WeaponStatsMC1.GetObject("weaponStats1");
    WeaponStatBars1[1] = WeaponStatsMC1.GetObject("weaponStats2");
    WeaponStatBars1[2] = WeaponStatsMC1.GetObject("weaponStats3");
    WeaponStatBars1[3] = WeaponStatsMC1.GetObject("weaponStats4");
    WeaponStatBars1[4] = WeaponStatsMC1.GetObject("weaponStats5");
    WeaponStatBars1[5] = WeaponStatsMC1.GetObject("weaponStats6");
    WeaponStatBars2[0] = WeaponStatsMC2.GetObject("weaponStats1");
    WeaponStatBars2[1] = WeaponStatsMC2.GetObject("weaponStats2");
    WeaponStatBars2[2] = WeaponStatsMC2.GetObject("weaponStats3");
    WeaponStatBars2[3] = WeaponStatsMC2.GetObject("weaponStats4");
    WeaponStatBars2[4] = WeaponStatsMC2.GetObject("weaponStats5");
    WeaponStatBars2[5] = WeaponStatsMC2.GetObject("weaponStats6");
    I = 0;
    J0xABC:

    // End:0xC78 [Loop If]
    if(I < 6)
    {
        LineMC = WeaponStatBars1[I].GetObject("line_bgMC");
        J = 0;
        J0xB16:

        // End:0xB9B [Loop If]
        if(J < 10)
        {
            StatBar1[I].Rects[J] = LineMC.GetObject("rect" $ string(J + 1));
            J++;
            // [Loop Continue]
            goto J0xB16;
        }
        LineMC = WeaponStatBars2[I].GetObject("line_bgMC");
        J = 0;
        J0xBE5:

        // End:0xC6A [Loop If]
        if(J < 10)
        {
            StatBar2[I].Rects[J] = LineMC.GetObject("rect" $ string(J + 1));
            J++;
            // [Loop Continue]
            goto J0xBE5;
        }
        I++;
        // [Loop Continue]
        goto J0xABC;
    }
    WeaponStatTF = UpgradeStats1.GetObject("bar1TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[0]", "ADVGame"));
    WeaponStatTF = UpgradeStats1.GetObject("bar2TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[1]", "ADVGame"));
    WeaponStatTF = UpgradeStats1.GetObject("bar3TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[2]", "ADVGame"));
    WeaponStatTF = UpgradeStats1.GetObject("bar4TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[3]", "ADVGame"));
    WeaponStatTF = UpgradeStats1.GetObject("bar5TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[4]", "ADVGame"));
    WeaponStatTF = UpgradeStats1.GetObject("bar6TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[5]", "ADVGame"));
    WeaponStatTF = UpgradeStats2.GetObject("bar1TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[0]", "ADVGame"));
    WeaponStatTF = UpgradeStats2.GetObject("bar2TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[1]", "ADVGame"));
    WeaponStatTF = UpgradeStats2.GetObject("bar3TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[2]", "ADVGame"));
    WeaponStatTF = UpgradeStats2.GetObject("bar4TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[3]", "ADVGame"));
    WeaponStatTF = UpgradeStats2.GetObject("bar5TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[4]", "ADVGame"));
    WeaponStatTF = UpgradeStats2.GetObject("bar6TF");
    WeaponStatTF.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "StatBarStr[5]", "ADVGame"));
    KillsRequiredLabel1 = UpgradeStats1.GetObject("KillsTF");
    KillsRequiredLabel1.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "KillsRequiredStr", "ADVGame"));
    KillsRequiredLabel2 = UpgradeStats2.GetObject("KillsTF");
    KillsRequiredLabel2.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "KillsRequiredStr", "ADVGame"));
    KillsRequiredTF1 = UpgradeStats1.GetObject("KillsNumberTF");
    KillsRequiredTF1.SetText("");
    KillsRequiredTF2 = UpgradeStats2.GetObject("KillsNumberTF");
    KillsRequiredTF2.SetText("");
    UpgradeMC = Upgrades1.GetObject("upgrade1MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders1[0] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeMC = Upgrades1.GetObject("upgrade2MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders1[1] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeMC = Upgrades1.GetObject("upgrade3MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders1[2] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeMC = Upgrades1.GetObject("upgrade4MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders1[3] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeMC = Upgrades1.GetObject("upgrade5MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders1[4] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeUILoaders1[0].SetBool("visible", true);
    UpgradeUILoaders1[1].SetBool("visible", true);
    UpgradeUILoaders1[2].SetBool("visible", true);
    UpgradeUILoaders1[3].SetBool("visible", true);
    UpgradeUILoaders1[4].SetBool("visible", true);
    UpgradeUILoaders1[0].SetString("source", UpgradeIconPath_Spread_Off);
    UpgradeUILoaders1[1].SetString("source", UpgradeIconPath_ReloadSpeed_Off);
    UpgradeUILoaders1[2].SetString("source", UpgradeIconPath_Firerate_Off);
    UpgradeUILoaders1[3].SetString("source", UpgradeIconPath_Stamina_Off);
    UpgradeUILoaders1[4].SetString("source", UpgradeIconPath_Magazines_Off);
    UpgradeMC = Upgrades2.GetObject("upgrade1MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders2[0] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeMC = Upgrades2.GetObject("upgrade2MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders2[1] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeMC = Upgrades2.GetObject("upgrade3MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders2[2] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeMC = Upgrades2.GetObject("upgrade4MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders2[3] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeMC = Upgrades2.GetObject("upgrade5MC");
    UpgradeIcon = UpgradeMC.GetObject("upgradeIcon");
    UpgradeUILoaders2[4] = GFxClikWidget(UpgradeIcon.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    UpgradeUILoaders2[0].SetBool("visible", true);
    UpgradeUILoaders2[1].SetBool("visible", true);
    UpgradeUILoaders2[2].SetBool("visible", true);
    UpgradeUILoaders2[3].SetBool("visible", true);
    UpgradeUILoaders2[4].SetBool("visible", true);
    UpgradeUILoaders2[0].SetString("source", UpgradeIconPath_Spread_Off);
    UpgradeUILoaders2[1].SetString("source", UpgradeIconPath_ReloadSpeed_Off);
    UpgradeUILoaders2[2].SetString("source", UpgradeIconPath_Firerate_Off);
    UpgradeUILoaders2[3].SetString("source", UpgradeIconPath_Stamina_Off);
    UpgradeUILoaders2[4].SetString("source", UpgradeIconPath_Magazines_Off);
    SaveBaton = GFxClikWidget(ButtonsMC.GetObject("saveMe", Class'GFxUI.GFxClikWidget'));
    SaveBaton.SetVisible(false);
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    MainRightArrow = GFxClikWidget(MainWeaponMC.GetObject("rightarrowBtn", Class'GFxUI.GFxClikWidget'));
    MainLeftArrow = GFxClikWidget(MainWeaponMC.GetObject("leftarrowBtn", Class'GFxUI.GFxClikWidget'));
    SecondRightArrow = GFxClikWidget(SecondWeaponMC.GetObject("rightarrowBtn", Class'GFxUI.GFxClikWidget'));
    SecondLeftArrow = GFxClikWidget(SecondWeaponMC.GetObject("leftarrowBtn", Class'GFxUI.GFxClikWidget'));
    MainRightArrow.SetVisible(false);
    MainLeftArrow.SetVisible(false);
    SecondRightArrow.SetVisible(false);
    SecondLeftArrow.SetVisible(false);
    MainWeaponName = MainWeaponMC.GetObject("weapontypeTF");
    MainWeaponName.SetText("");
    MainWeaponType = MainWeaponMC.GetObject("weaponTF");
    MainWeaponType.SetText("");
    SecondWeaponName = SecondWeaponMC.GetObject("weapontypeTF");
    SecondWeaponName.SetText("");
    SecondWeaponType = SecondWeaponMC.GetObject("weaponTF");
    SecondWeaponType.SetText("");
    WeaponMainLeftTF = MainWeaponMC.GetObject("left_btnTF");
    WeaponMainRightTF = MainWeaponMC.GetObject("right_btnTF");
    WeaponSecondLeftTF = SecondWeaponMC.GetObject("left_btnTF");
    WeaponSecondRightTF = SecondWeaponMC.GetObject("right_btnTF");
    WeaponMain = MainWeaponMC.GetObject("weaponmain");
    WeaponStatus = WeaponMain.GetObject("weaponStatus");
    MainUILoader = GFxClikWidget(WeaponStatus.GetObject("UI_loader", Class'GFxUI.GFxClikWidget'));
    MainUILoader.SetBool("visible", true);
    WeaponSecond = SecondWeaponMC.GetObject("weaponmain");
    WeaponStatus = WeaponSecond.GetObject("weaponStatus");
    SecondUILoader = GFxClikWidget(WeaponStatus.GetObject("UI_loader", Class'GFxUI.GFxClikWidget'));
    SecondUILoader.SetBool("visible", true);
    I = 0;
    J0x26BB:

    // End:0x290A [Loop If]
    if(I < 5)
    {
        PredefinedClassBtn[I] = GFxClikWidget(ButtonsMC.GetObject(("class" $ string(I + 1)) $ "_btn", Class'GFxUI.GFxClikWidget'));
        PredefinedClassBtn[I].SetString("label", Localize("AdvGFxUI_Menu_MultiPlayerSettings", ("PredefinedClassStr[" $ string(I)) $ "]", "ADVGame"));
        CustomClassBtn[I] = GFxClikWidget(ButtonsMC.GetObject(("class" $ string(I + 6)) $ "_btn", Class'GFxUI.GFxClikWidget'));
        CustomClassBtn[I].SetString("label", Localize("AdvGFxUI_Menu_MultiPlayerSettings", ("CustomClassStr[" $ string(I)) $ "]", "ADVGame"));
        ActiveMarkBtn[I] = ButtonsMC.GetObject("itemActive" $ string(I + 1));
        I++;
        // [Loop Continue]
        goto J0x26BB;
    }
    // End:0x29AF
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
        InitializeFooter();
        UpdateFooter();
    }
    CurrentViewedClassIndex = 0;
    UpdateMainWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[0]);
    UpdateSecondWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[1]);
    return true;
    //return ReturnValue;    
}

function InitializeFooter()
{
    // End:0x71
    if(footer == none)
    {
        footer = new Class'AdvGFxUI_Menu_Footer';
        footer.SetPriority(70);
        footer.Init(GetLP());
    }
    //return;    
}

function PlayOpenAnimation()
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;

    MenuMC.GotoAndPlay("open");
    // End:0x114
    if(!bIsMenuPPOverrideOn)
    {
        ELP = EvilLocalPlayer(GetLP());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x114
        if(ELP != none)
        {
            ELP.SetMenuOverride(true, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = true;
        }
    }
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    footer.FooterUpdate(ButtonAliases);
    //return;    
}

function Cleanup()
{
    local SkeletalMeshActor SMA;
    local string Tag;

    // End:0xDA
    foreach GetPC().AllActors(Class'Engine.SkeletalMeshActor', SMA)
    {
        Tag = string(SMA.Tag);
        // End:0x9D
        if(InStr(Tag, "PlayerModel") >= 0)
        {
            SMA.SetHidden(true);
            // End:0xD9
            continue;
        }
        // End:0xD9
        if(InStr(Tag, "Statue") >= 0)
        {
            SMA.SetHidden(false);
        }        
    }    
    //return;    
}

function UpdateMainWeaponsDisplay(int EquipmentIndex)
{
    local class<AdvWeap_Base> WeapClass;

    WeapClass = class<AdvWeap_Base>(Class'AdvClassInfo_MP_Base'.default.Equipment[EquipmentIndex]);
    bMainWeaponAvailable = true;
    WeaponMain.GotoAndStop("active");
    MainWeaponName.SetText(WeapClass.default.ItemName);
    MainUILoader.SetString("source", "img://" $ Class'AdvClassInfo_MP_Base'.default.EquipmentIconPath[EquipmentIndex]);
    UpdateUpgradesSection(EquipmentIndex, true);
    //return;    
}

function UpdateSecondWeaponsDisplay(int EquipmentIndex)
{
    local class<AdvWeap_Base> WeapClass;

    WeapClass = class<AdvWeap_Base>(Class'AdvClassInfo_MP_Base'.default.Equipment[EquipmentIndex]);
    bSecondWeaponAvailable = true;
    WeaponSecond.GotoAndStop("active");
    SecondWeaponName.SetText(WeapClass.default.ItemName);
    SecondUILoader.SetString("source", "img://" $ Class'AdvClassInfo_MP_Base'.default.EquipmentIconPath[EquipmentIndex]);
    UpdateUpgradesSection(EquipmentIndex, false);
    //return;    
}

function UpdateUpgradesSection(int EquipmentIndex, bool bMainWeapon)
{
    local array<int> WeaponKillCounts, UpgradeRequirements;
    local array<string> UpgradeIconsOn, UpgradeIconsOff;
    local class<AdvWeap_Base> WeapClass;
    local int KillsToNextUpgrade, KillsFromLastUpgrade, I, J;

    WeapClass = class<AdvWeap_Base>(Class'AdvClassInfo_MP_Base'.default.Equipment[EquipmentIndex]);
    AdvPlayerController(GetPC()).ProfileSettings.GetWeaponLevels(42, WeaponKillCounts);
    I = 0;
    J0x8F:

    // End:0x182 [Loop If]
    if(I < 6)
    {
        J = 0;
        J0xAA:

        // End:0x174 [Loop If]
        if(J < 10)
        {
            // End:0x118
            if(bMainWeapon)
            {
                StatBar1[I].Rects[J].GotoAndStop("normal");                
            }
            else
            {
                StatBar2[I].Rects[J].GotoAndStop("normal");
            }
            J++;
            // [Loop Continue]
            goto J0xAA;
        }
        I++;
        // [Loop Continue]
        goto J0x8F;
    }
    // End:0x328
    if(bMainWeapon)
    {
        WeaponStatBars1[0].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_Damage);
        WeaponStatBars1[1].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_Firerate);
        WeaponStatBars1[2].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_Accuracy);
        WeaponStatBars1[3].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_Magazines);
        WeaponStatBars1[4].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_ReloadSpeed);
        WeaponStatBars1[5].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_RunFriendly);        
    }
    else
    {
        WeaponStatBars2[0].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_Damage);
        WeaponStatBars2[1].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_Firerate);
        WeaponStatBars2[2].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_Accuracy);
        WeaponStatBars2[3].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_Magazines);
        WeaponStatBars2[4].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_ReloadSpeed);
        WeaponStatBars2[5].GotoAndStopI(11 - WeapClass.default.WeaponStatMP_RunFriendly);
    }
    // End:0x559
    if((WeaponKillCounts.Length == 0) || WeaponKillCounts[0] != Class'AdvClassInfo_MP_Base'.default.Version)
    {
        I = 0;
        J0x509:

        // End:0x559 [Loop If]
        if(I < Class'AdvClassInfo_MP_Base'.default.Equipment.Length)
        {
            WeaponKillCounts[I] = 0;
            I++;
            // [Loop Continue]
            goto J0x509;
        }
    }
    KillsToNextUpgrade = 999999;
    KillsFromLastUpgrade = 999999;
    UpgradeRequirements[0] = WeapClass.default.KillsRequiredForUpgrade_Spread;
    UpgradeRequirements[1] = WeapClass.default.KillsRequiredForUpgrade_ReloadSpeed;
    UpgradeRequirements[2] = WeapClass.default.KillsRequiredForUpgrade_FireInterval;
    UpgradeRequirements[3] = WeapClass.default.KillsRequiredForUpgrade_StaminaDecrease;
    UpgradeRequirements[4] = WeapClass.default.KillsRequiredForUpgrade_BonusMagazines;
    UpgradeIconsOn[0] = UpgradeIconPath_Spread_On;
    UpgradeIconsOn[1] = UpgradeIconPath_ReloadSpeed_On;
    UpgradeIconsOn[2] = UpgradeIconPath_Firerate_On;
    UpgradeIconsOn[3] = UpgradeIconPath_Stamina_On;
    UpgradeIconsOn[4] = UpgradeIconPath_Magazines_On;
    UpgradeIconsOff[0] = UpgradeIconPath_Spread_Off;
    UpgradeIconsOff[1] = UpgradeIconPath_ReloadSpeed_Off;
    UpgradeIconsOff[2] = UpgradeIconPath_Firerate_Off;
    UpgradeIconsOff[3] = UpgradeIconPath_Stamina_Off;
    UpgradeIconsOff[4] = UpgradeIconPath_Magazines_Off;
    I = 0;
    J0x72F:

    // End:0x1074 [Loop If]
    if(I < 5)
    {
        // End:0xF4A
        if(WeaponKillCounts[EquipmentIndex + 1] >= UpgradeRequirements[I])
        {
            // End:0x7DB
            if((WeaponKillCounts[EquipmentIndex + 1] - UpgradeRequirements[I]) < KillsFromLastUpgrade)
            {
                KillsFromLastUpgrade = WeaponKillCounts[EquipmentIndex + 1] - UpgradeRequirements[I];
            }
            // End:0xB99
            if(bMainWeapon)
            {
                switch(I)
                {
                    // End:0x8A3
                    case 0:
                        WeaponStatBars1[2].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Accuracy);
                        StatBar1[2].Rects[WeapClass.default.WeaponStatMP_Accuracy].GotoAndStop("upgrade");
                        // End:0xB47
                        break;
                    // End:0x94B
                    case 1:
                        WeaponStatBars1[4].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_ReloadSpeed);
                        StatBar1[4].Rects[WeapClass.default.WeaponStatMP_ReloadSpeed].GotoAndStop("upgrade");
                        // End:0xB47
                        break;
                    // End:0x9F2
                    case 2:
                        WeaponStatBars1[1].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Firerate);
                        StatBar1[1].Rects[WeapClass.default.WeaponStatMP_Firerate].GotoAndStop("upgrade");
                        // End:0xB47
                        break;
                    // End:0xA9B
                    case 3:
                        WeaponStatBars1[5].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_RunFriendly);
                        StatBar1[5].Rects[WeapClass.default.WeaponStatMP_RunFriendly].GotoAndStop("upgrade");
                        // End:0xB47
                        break;
                    // End:0xB44
                    case 4:
                        WeaponStatBars1[3].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Magazines);
                        StatBar1[3].Rects[WeapClass.default.WeaponStatMP_Magazines].GotoAndStop("upgrade");
                        // End:0xB47
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                UpgradeUILoaders1[I].SetString("source", "img://" $ UpgradeIconsOn[I]);                
            }
            else
            {
                switch(I)
                {
                    // End:0xC54
                    case 0:
                        WeaponStatBars2[2].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Accuracy);
                        StatBar2[2].Rects[WeapClass.default.WeaponStatMP_Accuracy].GotoAndStop("upgrade");
                        // End:0xEF8
                        break;
                    // End:0xCFC
                    case 1:
                        WeaponStatBars2[4].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_ReloadSpeed);
                        StatBar2[4].Rects[WeapClass.default.WeaponStatMP_ReloadSpeed].GotoAndStop("upgrade");
                        // End:0xEF8
                        break;
                    // End:0xDA3
                    case 2:
                        WeaponStatBars2[1].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Firerate);
                        StatBar2[1].Rects[WeapClass.default.WeaponStatMP_Firerate].GotoAndStop("upgrade");
                        // End:0xEF8
                        break;
                    // End:0xE4C
                    case 3:
                        WeaponStatBars2[5].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_RunFriendly);
                        StatBar2[5].Rects[WeapClass.default.WeaponStatMP_RunFriendly].GotoAndStop("upgrade");
                        // End:0xEF8
                        break;
                    // End:0xEF5
                    case 4:
                        WeaponStatBars2[3].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Magazines);
                        StatBar2[3].Rects[WeapClass.default.WeaponStatMP_Magazines].GotoAndStop("upgrade");
                        // End:0xEF8
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                UpgradeUILoaders2[I].SetString("source", "img://" $ UpgradeIconsOn[I]);
            }            
        }
        else
        {
            // End:0xFB8
            if((UpgradeRequirements[I] - WeaponKillCounts[EquipmentIndex + 1]) < KillsToNextUpgrade)
            {
                KillsToNextUpgrade = UpgradeRequirements[I] - WeaponKillCounts[EquipmentIndex + 1];
            }
            // End:0x1017
            if(bMainWeapon)
            {
                UpgradeUILoaders1[I].SetString("source", "img://" $ UpgradeIconsOff[I]);                
            }
            else
            {
                UpgradeUILoaders2[I].SetString("source", "img://" $ UpgradeIconsOff[I]);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x72F;
    }
    // End:0x1176
    if(KillsToNextUpgrade == 999999)
    {
        // End:0x1105
        if(bMainWeapon)
        {
            KillsRequiredTF1.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "WeaponFullyUpgradedStr", "ADVGame"));            
        }
        else
        {
            KillsRequiredTF2.SetText(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "WeaponFullyUpgradedStr", "ADVGame"));
        }        
    }
    else
    {
        // End:0x11A9
        if(KillsFromLastUpgrade == 999999)
        {
            KillsFromLastUpgrade = WeaponKillCounts[EquipmentIndex + 1];
        }
        // End:0x1201
        if(bMainWeapon)
        {
            KillsRequiredTF1.SetText((string(KillsFromLastUpgrade) @ "/") @ string(KillsFromLastUpgrade + KillsToNextUpgrade));            
        }
        else
        {
            KillsRequiredTF2.SetText((string(KillsFromLastUpgrade) @ "/") @ string(KillsFromLastUpgrade + KillsToNextUpgrade));
        }
    }
    //return;    
}

function SetNextSpawnInventory(int NextSpawnClassIndex)
{
    local byte InventoryInfo[4];

    // End:0x57
    if(NextSpawnClassIndex != AdvPRI(GetPC().PlayerReplicationInfo).NextSpawnClassIndex)
    {
        bShouldDisplayClassChangedInfo = true;
    }
    // End:0x11F
    if(NextSpawnClassIndex >= 5)
    {
        AdvPlayerControllerMP(GetPC()).ProfileSettings.GetMPCustomClassInfo(NextSpawnClassIndex - 5, InventoryInfo);
        AdvPRI(GetPC().PlayerReplicationInfo).SetNextSpawnInfo(NextSpawnClassIndex, int(InventoryInfo[0]), int(InventoryInfo[1]));        
    }
    else
    {
        AdvPRI(GetPC().PlayerReplicationInfo).SetNextSpawnInfo(NextSpawnClassIndex);
    }
    //return;    
}

function InClass1(EventData ev)
{
    CurrentViewedClassIndex = 0;
    UpdateMainWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[0]);
    UpdateSecondWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[1]);
    //return;    
}

function OnClass1(EventData ev)
{
    SetNextSpawnInventory(0);
    PlayCloseAnimation();
    //return;    
}

function InClass2(EventData ev)
{
    CurrentViewedClassIndex = 1;
    UpdateMainWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[0]);
    UpdateSecondWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[1]);
    //return;    
}

function OnClass2(EventData ev)
{
    SetNextSpawnInventory(1);
    PlayCloseAnimation();
    //return;    
}

function InClass3(EventData ev)
{
    CurrentViewedClassIndex = 2;
    UpdateMainWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[0]);
    UpdateSecondWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[1]);
    //return;    
}

function OnClass3(EventData ev)
{
    SetNextSpawnInventory(2);
    PlayCloseAnimation();
    //return;    
}

function InClass4(EventData ev)
{
    CurrentViewedClassIndex = 3;
    UpdateMainWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[0]);
    UpdateSecondWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[1]);
    //return;    
}

function OnClass4(EventData ev)
{
    SetNextSpawnInventory(3);
    PlayCloseAnimation();
    //return;    
}

function InClass5(EventData ev)
{
    CurrentViewedClassIndex = 4;
    UpdateMainWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[0]);
    UpdateSecondWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[1]);
    //return;    
}

function OnClass5(EventData ev)
{
    SetNextSpawnInventory(4);
    PlayCloseAnimation();
    //return;    
}

function InClass6(EventData ev)
{
    local byte ClassInfo[4];

    CurrentViewedClassIndex = 5;
    AdvPlayerController(GetPC()).ProfileSettings.GetMPCustomClassInfo(CurrentViewedClassIndex - 5, ClassInfo);
    UpdateMainWeaponsDisplay(int(ClassInfo[0]));
    UpdateSecondWeaponsDisplay(int(ClassInfo[1]));
    //return;    
}

function OnClass6(EventData ev)
{
    SetNextSpawnInventory(5);
    PlayCloseAnimation();
    //return;    
}

function InClass7(EventData ev)
{
    local byte ClassInfo[4];

    CurrentViewedClassIndex = 6;
    AdvPlayerController(GetPC()).ProfileSettings.GetMPCustomClassInfo(CurrentViewedClassIndex - 5, ClassInfo);
    UpdateMainWeaponsDisplay(int(ClassInfo[0]));
    UpdateSecondWeaponsDisplay(int(ClassInfo[1]));
    //return;    
}

function OnClass7(EventData ev)
{
    SetNextSpawnInventory(6);
    PlayCloseAnimation();
    //return;    
}

function InClass8(EventData ev)
{
    local byte ClassInfo[4];

    CurrentViewedClassIndex = 7;
    AdvPlayerController(GetPC()).ProfileSettings.GetMPCustomClassInfo(CurrentViewedClassIndex - 5, ClassInfo);
    UpdateMainWeaponsDisplay(int(ClassInfo[0]));
    UpdateSecondWeaponsDisplay(int(ClassInfo[1]));
    //return;    
}

function OnClass8(EventData ev)
{
    SetNextSpawnInventory(7);
    PlayCloseAnimation();
    //return;    
}

function InClass9(EventData ev)
{
    local byte ClassInfo[4];

    CurrentViewedClassIndex = 8;
    AdvPlayerController(GetPC()).ProfileSettings.GetMPCustomClassInfo(CurrentViewedClassIndex - 5, ClassInfo);
    UpdateMainWeaponsDisplay(int(ClassInfo[0]));
    UpdateSecondWeaponsDisplay(int(ClassInfo[1]));
    //return;    
}

function OnClass9(EventData ev)
{
    SetNextSpawnInventory(8);
    PlayCloseAnimation();
    //return;    
}

function InClass10(EventData ev)
{
    local byte ClassInfo[4];

    CurrentViewedClassIndex = 9;
    AdvPlayerController(GetPC()).ProfileSettings.GetMPCustomClassInfo(CurrentViewedClassIndex - 5, ClassInfo);
    UpdateMainWeaponsDisplay(int(ClassInfo[0]));
    UpdateSecondWeaponsDisplay(int(ClassInfo[1]));
    //return;    
}

function OnClass10(EventData ev)
{
    SetNextSpawnInventory(9);
    PlayCloseAnimation();
    //return;    
}

function OnBack(EventData ev)
{
    PlayCloseAnimation();
    //return;    
}

function OnSave2Btn(EventData ev)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', Localize("MessageBoxStrings", "ReturnToMainMenu_Header", "ADVGame"), Localize("MessageBoxStrings", "ReturnToMainMenu_Message", "ADVGame"), ButtonAliases, OnExitOptionSelected, GetLP(),,,, false,,, true);
    //return;    
}

function bool OnExitOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x40
    if(SelectedInputAlias == 'GenericYes')
    {
        AdvPlayerController(GetPC()).ExitFromMPGame();
    }
    return true;
    //return ReturnValue;    
}

function PlayCloseAnimation()
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;

    // End:0x0F
    if(bIsPlayingCloseAnimation)
    {
        return;
    }
    AdvPlayerControllerMP(GetPC()).AdvHudWrapper.SetVisibilityForPause(false);
    bIsPlayingCloseAnimation = true;
    MenuMC.GotoAndPlay("close");
    // End:0x102
    if(AdvPlayerControllerMP(GetPC()).AdvHudWrapper.AdvClassSelectionMenuMovie != none)
    {
        AdvPlayerControllerMP(GetPC()).AdvHudWrapper.AdvClassSelectionMenuMovie = none;
    }
    // End:0x1EF
    if(bIsMenuPPOverrideOn)
    {
        ELP = EvilLocalPlayer(GetLP());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x1EF
        if(ELP != none)
        {
            ELP.SetMenuOverride(false, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = false;
        }
    }
    // End:0x225
    if(bShouldDisplayClassChangedInfo)
    {
        AdvPlayerControllerMP(GetPC()).SetClassChangedMessage();
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    AdvGFxHudWrapper(GetPC().myHUD).SetVisible(true);
    Close(true);
    //return;    
}

event OnClose()
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;

    super.OnClose();
    // End:0x44
    if(footer != none)
    {
        footer.Close();
        footer = none;
    }
    // End:0x131
    if(bIsMenuPPOverrideOn)
    {
        ELP = EvilLocalPlayer(GetLP());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x131
        if(ELP != none)
        {
            ELP.SetMenuOverride(false, 0.0000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function bool ActivatePauseScene(LocalPlayer LP)
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;
    local bool bWasUsingGamepad;

    // End:0xED
    if(bIsMenuPPOverrideOn)
    {
        ELP = EvilLocalPlayer(GetLP());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0xE1
        if(ELP != none)
        {
            ELP.SetMenuOverride(false, 0.0000000, (WI.Game != none) && WI.Game.bPauseable);
        }
        bIsMenuPPOverrideOn = false;
    }
    bWasUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
    FlushPlayerInput(false);
    GetPC().PlayerInput.bUsingGamepad = bWasUsingGamepad;
    Init(LP);
    PlayOpenAnimation();
    bIsPlayingCloseAnimation = false;
    return true;
    //return ReturnValue;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local EventData ev;

    // End:0x2F
    if(GetLP().ControllerId != ControllerId)
    {
        return true;
    }
    // End:0x9A
    if(GetPC().WorldInfo.IsConsoleBuild(1) && !Class'AdvFrontEnd'.static.IsGamepadKey(ButtonName))
    {
        return true;
    }
    // End:0x187
    if((GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode()) && int(CurrentActiveMenuPart) == int(1))
    {
        // End:0x187
        if((int(InputEvent) == int(0)) && ControllerId == GetLP().ControllerId)
        {
            // End:0x187
            if(ButtonName == 'XboxTypeS_B')
            {
                OnBack(ev);
                return true;
            }
        }
    }
    // End:0x1D1
    if(Frontend != none)
    {
        return Frontend.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    return false;
    //return ReturnValue;    
}

final function UT_ConsoleCommand(string Cmd, optional bool bWriteToLog)
{
    GetPC().Player.Actor.ConsoleCommand(Cmd, bWriteToLog);
    //return;    
}

defaultproperties
{
    UpgradeIconPath_Spread_On="UI_AdvMultiplayer.Textures.t_steadyaim_on"
    UpgradeIconPath_ReloadSpeed_On="UI_AdvMultiplayer.Textures.t_quickreload_on"
    UpgradeIconPath_Firerate_On="UI_AdvMultiplayer.Textures.t_bullets_on"
    UpgradeIconPath_Stamina_On="UI_AdvMultiplayer.Textures.t_longsprint_on"
    UpgradeIconPath_Magazines_On="UI_AdvMultiplayer.Textures.t_moreammo_on"
    UpgradeIconPath_Spread_Off="UI_AdvMultiplayer.Textures.t_steadyaim_off"
    UpgradeIconPath_ReloadSpeed_Off="UI_AdvMultiplayer.Textures.t_quickreload_off"
    UpgradeIconPath_Firerate_Off="UI_AdvMultiplayer.Textures.t_bullets_off"
    UpgradeIconPath_Stamina_Off="UI_AdvMultiplayer.Textures.t_longsprint_off"
    UpgradeIconPath_Magazines_Off="UI_AdvMultiplayer.Textures.t_moreammo_off"
    ReturnToMenu="Return to main menu"
    MovieInfoPath="UI_AdvCommon.AdvPlayerSettings"
    bOnlyOwnerFocusable=true
}