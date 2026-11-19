class AdvGFxUI_Menu_MultiPlayerSettings extends AdvGFxUI_Menu_Base
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
var const localized string PredefinedClassStr[5];
var const localized string CustomClassStr[5];
var const localized string PlayerLevelString[5];
var const localized string SaveSettingsString;
var const localized string KillsRequiredStr;
var const localized string WeaponFullyUpgradedStr;
var const localized string PlayerLevelStr;
var const localized string PlayerXPStr;
var const localized string UnlockStr;
var const localized string StatBarStr[6];
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
var int CurrentViewedClassIndex;
var int MainWeaponIndex;
var int SecondWeaponIndex;
var int PlayerLevel;
var bool bMainWeaponAvailable;
var bool bSecondWeaponAvailable;
var array<int> MainWeaponsIndices;
var array<int> SecondWeaponsIndices;
var AdvGFxUI_Menu_MultiPlayerSettings.EMenuPart CurrentActiveMenuPart;
var StatBar StatBar1[6];
var StatBar StatBar2[6];
var transient AdvPreGameGRI GRI;
var GFxObject TimeToStartTF;

function bool CheckIfWeaponIsAccesibleInDLC(class<AdvWeap_Base> Weap)
{
    local int WeaponIndex, DLCIndex;

    WeaponIndex = Class'AdvClassInfo_MP_Base'.default.Equipment.Find(Weap);    
    DLCIndex = Class'AdvClassInfo_MP_Base'.default.EquipmentDLCIndex[WeaponIndex];
    return ((DLCIndex > 0) ? int(AdvPlayerController(GetPC()).IsDLCInstalled(byte(DLCIndex))) == int(1) : true);
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
    local class<AdvWeap_Base> Weap;
    local class<Inventory> Inv;

    super.Start(StartPaused);
    Advance(0.0000000);
    AdvPlayerController(GetPC()).ProfileSettings.GetProfileSettingValueInt(36, PlayerXP);
    PlayerLevel = Class'AdvPRI'.static.CalculatePlayerLevel(PlayerXP);
    // End:0x2CA
    foreach Class'AdvClassInfo_MP_Base'.default.Equipment(Inv, I)
    {
        Weap = class<AdvWeap_Base>(Inv);
        // End:0x2C9
        if(Weap != none)
        {
            // End:0x2C9
            if(CheckIfWeaponIsAccesibleInDLC(Weap))
            {
                // End:0x206
                if(((((int(Weap.default.EWeaponType) == int(1)) || int(Weap.default.EWeaponType) == int(5)) || int(Weap.default.EWeaponType) == int(7)) || int(Weap.default.EWeaponType) == int(8)) || int(Weap.default.EWeaponType) == int(9))
                {
                    MainWeaponsIndices.AddItem(I);                                        
                }
                else
                {
                    // End:0x2C6
                    if((((int(Weap.default.EWeaponType) == int(2)) || int(Weap.default.EWeaponType) == int(3)) || int(Weap.default.EWeaponType) == int(6)) || int(Weap.default.EWeaponType) == int(4))
                    {
                        SecondWeaponsIndices.AddItem(I);                        
                    }
                }                
            }
        }        
    }    
    MainWeaponsIndices.Sort(CompareWeaponIndices);    
    SecondWeaponsIndices.Sort(CompareWeaponIndices);    
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
    TimeToStartTF = ButtonsMC.GetObject("timetostartTF");
    LevelThresholds = Class'AdvClassInfo_MP_Base'.default.LevelThresholds;
    displayInfo.hasXScale = true;
    // End:0x633
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
    PlayerLevelTF.SetText(((Repl(PlayerLevelStr, "`l", string(PlayerLevel)) @ " [") @ PlayerLevelString[GetRankGroupNumber(PlayerLevel)]) @ "]");
    TitleTF.SetText(GetPC().PlayerReplicationInfo.PlayerName);
    // End:0x928
    if(Class'AdvClassInfo_MP_Base'.default.LevelThresholds.Length == PlayerLevel)
    {
        PlayerXPTF.SetText(Repl(PlayerXPStr, "`x", string(PlayerXP)));        
    }
    else
    {
        PlayerXPTF.SetText((Repl(PlayerXPStr, "`x", string(PlayerXP)) @ "/") @ string(LevelThresholds[PlayerLevel]));
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
    J0xC4A:

    // End:0xE06 [Loop If]
    if(I < 6)
    {
        LineMC = WeaponStatBars1[I].GetObject("line_bgMC");
        J = 0;
        J0xCA4:

        // End:0xD29 [Loop If]
        if(J < 10)
        {
            StatBar1[I].Rects[J] = LineMC.GetObject("rect" $ string(J + 1));
            J++;
            // [Loop Continue]
            goto J0xCA4;
        }
        LineMC = WeaponStatBars2[I].GetObject("line_bgMC");
        J = 0;
        J0xD73:

        // End:0xDF8 [Loop If]
        if(J < 10)
        {
            StatBar2[I].Rects[J] = LineMC.GetObject("rect" $ string(J + 1));
            J++;
            // [Loop Continue]
            goto J0xD73;
        }
        I++;
        // [Loop Continue]
        goto J0xC4A;
    }
    WeaponStatTF = UpgradeStats1.GetObject("bar1TF");
    WeaponStatTF.SetText(StatBarStr[0]);
    WeaponStatTF = UpgradeStats1.GetObject("bar2TF");
    WeaponStatTF.SetText(StatBarStr[1]);
    WeaponStatTF = UpgradeStats1.GetObject("bar3TF");
    WeaponStatTF.SetText(StatBarStr[2]);
    WeaponStatTF = UpgradeStats1.GetObject("bar4TF");
    WeaponStatTF.SetText(StatBarStr[3]);
    WeaponStatTF = UpgradeStats1.GetObject("bar5TF");
    WeaponStatTF.SetText(StatBarStr[4]);
    WeaponStatTF = UpgradeStats1.GetObject("bar6TF");
    WeaponStatTF.SetText(StatBarStr[5]);
    WeaponStatTF = UpgradeStats2.GetObject("bar1TF");
    WeaponStatTF.SetText(StatBarStr[0]);
    WeaponStatTF = UpgradeStats2.GetObject("bar2TF");
    WeaponStatTF.SetText(StatBarStr[1]);
    WeaponStatTF = UpgradeStats2.GetObject("bar3TF");
    WeaponStatTF.SetText(StatBarStr[2]);
    WeaponStatTF = UpgradeStats2.GetObject("bar4TF");
    WeaponStatTF.SetText(StatBarStr[3]);
    WeaponStatTF = UpgradeStats2.GetObject("bar5TF");
    WeaponStatTF.SetText(StatBarStr[4]);
    WeaponStatTF = UpgradeStats2.GetObject("bar6TF");
    WeaponStatTF.SetText(StatBarStr[5]);
    KillsRequiredLabel1 = UpgradeStats1.GetObject("KillsTF");
    KillsRequiredLabel1.SetText(KillsRequiredStr);
    KillsRequiredLabel2 = UpgradeStats2.GetObject("KillsTF");
    KillsRequiredLabel2.SetText(KillsRequiredStr);
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
    SaveBaton.SetString("label", SaveSettingsString);
    SaveBaton.SetVisible(false);
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    MainRightArrow = GFxClikWidget(MainWeaponMC.GetObject("rightarrowBtn", Class'GFxUI.GFxClikWidget'));
    MainLeftArrow = GFxClikWidget(MainWeaponMC.GetObject("leftarrowBtn", Class'GFxUI.GFxClikWidget'));
    SecondRightArrow = GFxClikWidget(SecondWeaponMC.GetObject("rightarrowBtn", Class'GFxUI.GFxClikWidget'));
    SecondLeftArrow = GFxClikWidget(SecondWeaponMC.GetObject("leftarrowBtn", Class'GFxUI.GFxClikWidget'));
    MainRightArrow.AddEventListener('CLIK_click', OnRightArrow1);
    MainLeftArrow.AddEventListener('CLIK_click', OnLeftArrow1);
    SecondRightArrow.AddEventListener('CLIK_click', OnRightArrow2);
    SecondLeftArrow.AddEventListener('CLIK_click', OnLeftArrow2);
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
    J0x263B:

    // End:0x27FA [Loop If]
    if(I < 5)
    {
        PredefinedClassBtn[I] = GFxClikWidget(ButtonsMC.GetObject(("class" $ string(I + 1)) $ "_btn", Class'GFxUI.GFxClikWidget'));
        PredefinedClassBtn[I].SetString("label", PredefinedClassStr[I]);
        CustomClassBtn[I] = GFxClikWidget(ButtonsMC.GetObject(("class" $ string(I + 6)) $ "_btn", Class'GFxUI.GFxClikWidget'));
        CustomClassBtn[I].SetString("label", CustomClassStr[I]);
        ActiveMarkBtn[I] = ButtonsMC.GetObject("itemActive" $ string(I + 1));
        I++;
        // [Loop Continue]
        goto J0x263B;
    }
    // End:0x288B
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    CurrentViewedClassIndex = 0;
    UpdateMainWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[0]);
    UpdateSecondWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[1]);
    return true;
    //return ReturnValue;    
}

function int CompareWeaponIndices(int WeaponIndex1, int WeaponIndex2)
{
    local int FirstWeaponUnlockLevel, SecondWeaponUnlockLevel;

    FirstWeaponUnlockLevel = Class'AdvClassInfo_MP_Base'.default.EquipmentUnlockLevel[WeaponIndex1];
    SecondWeaponUnlockLevel = Class'AdvClassInfo_MP_Base'.default.EquipmentUnlockLevel[WeaponIndex2];
    // End:0x80
    if(FirstWeaponUnlockLevel == SecondWeaponUnlockLevel)
    {
        return 0;        
    }
    else
    {
        // End:0xA0
        if(FirstWeaponUnlockLevel > SecondWeaponUnlockLevel)
        {
            return -1;            
        }
        else
        {
            return 1;
        }
    }
    //return ReturnValue;    
}

static function int GetRankGroupNumber(int PlayerXPLevel)
{
    // End:0x12
    if(PlayerXPLevel < 10)
    {
        return 0;
    }
    // End:0x24
    if(PlayerXPLevel < 20)
    {
        return 1;
    }
    // End:0x37
    if(PlayerXPLevel < 30)
    {
        return 2;
    }
    // End:0x4D
    if(PlayerXPLevel < 35)
    {
        return 3;        
    }
    else
    {
        return 4;
    }
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    // End:0x17A
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        // End:0xB1
        if(int(CurrentActiveMenuPart) == int(1))
        {
            // End:0xAE
            if(bMainWeaponAvailable && bSecondWeaponAvailable)
            {
                ButtonAliases.AddItem('GenericSelect');                
            }            
        }
        else
        {
            // End:0xD7
            if(CurrentViewedClassIndex > 4)
            {
                ButtonAliases.AddItem('GenericSelect');                
            }
        }
        ButtonAliases.AddItem('GenericBack');        
        // End:0x13D
        if(GetPC().WorldInfo.IsConsoleBuild(0))
        {
            ButtonAliases.AddItem('PartyDetails');            
        }
        Frontend.footer.FooterUpdate(ButtonAliases);
    }
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

function UpdateSaveAbility()
{
    // End:0x75
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        UpdateFooter();        
    }
    else
    {
        // End:0xBE
        if(bMainWeaponAvailable && bSecondWeaponAvailable)
        {
            SaveBaton.SetBool("disabled", false);            
        }
        else
        {
            SaveBaton.SetBool("disabled", true);
        }
    }
    //return;    
}

function UpdateMainWeaponsDisplay(int EquipmentIndex)
{
    local class<AdvWeap_Base> WeapClass;

    WeapClass = class<AdvWeap_Base>(Class'AdvClassInfo_MP_Base'.default.Equipment[EquipmentIndex]);
    // End:0xC7
    if(PlayerLevel >= Class'AdvClassInfo_MP_Base'.default.EquipmentUnlockLevel[EquipmentIndex])
    {
        bMainWeaponAvailable = true;
        WeaponMain.GotoAndStop("active");
        UnlockMainWeaponStr.SetVisible(false);        
    }
    else
    {
        bMainWeaponAvailable = false;
        WeaponMain.GotoAndStop("unactive");
        UnlockMainWeaponStr.SetVisible(true);
        UnlockMainWeaponStr.SetText(Repl(UnlockStr, "`l", string(Class'AdvClassInfo_MP_Base'.default.EquipmentUnlockLevel[EquipmentIndex])));
    }
    MainWeaponName.SetText(WeapClass.default.ItemName);
    MainUILoader.SetString("source", "img://" $ Class'AdvClassInfo_MP_Base'.default.EquipmentIconPath[EquipmentIndex]);
    UpdateUpgradesSection(EquipmentIndex, true);
    UpdateSaveAbility();
    //return;    
}

function UpdateSecondWeaponsDisplay(int EquipmentIndex)
{
    local class<AdvWeap_Base> WeapClass;

    WeapClass = class<AdvWeap_Base>(Class'AdvClassInfo_MP_Base'.default.Equipment[EquipmentIndex]);
    // End:0xC7
    if(PlayerLevel >= Class'AdvClassInfo_MP_Base'.default.EquipmentUnlockLevel[EquipmentIndex])
    {
        bSecondWeaponAvailable = true;
        WeaponSecond.GotoAndStop("active");
        UnlockSecondWeaponStr.SetVisible(false);        
    }
    else
    {
        bSecondWeaponAvailable = false;
        WeaponSecond.GotoAndStop("unactive");
        UnlockSecondWeaponStr.SetVisible(true);
        UnlockSecondWeaponStr.SetText(Repl(UnlockStr, "`l", string(Class'AdvClassInfo_MP_Base'.default.EquipmentUnlockLevel[EquipmentIndex])));
    }
    SecondWeaponName.SetText(WeapClass.default.ItemName);
    SecondUILoader.SetString("source", "img://" $ Class'AdvClassInfo_MP_Base'.default.EquipmentIconPath[EquipmentIndex]);
    UpdateUpgradesSection(EquipmentIndex, false);
    UpdateSaveAbility();
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
    // End:0x55C
    if((WeaponKillCounts.Length == 0) || WeaponKillCounts[0] != Class'AdvClassInfo_MP_Base'.default.Version)
    {
        I = 0;
        J0x509:

        // End:0x55C [Loop If]
        if(I < (Class'AdvClassInfo_MP_Base'.default.Equipment.Length + 1))
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
    J0x732:

    // End:0x1077 [Loop If]
    if(I < 5)
    {
        // End:0xF4D
        if(WeaponKillCounts[EquipmentIndex + 1] >= UpgradeRequirements[I])
        {
            // End:0x7DE
            if((WeaponKillCounts[EquipmentIndex + 1] - UpgradeRequirements[I]) < KillsFromLastUpgrade)
            {
                KillsFromLastUpgrade = WeaponKillCounts[EquipmentIndex + 1] - UpgradeRequirements[I];
            }
            // End:0xB9C
            if(bMainWeapon)
            {
                switch(I)
                {
                    // End:0x8A6
                    case 0:
                        WeaponStatBars1[2].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Accuracy);
                        StatBar1[2].Rects[WeapClass.default.WeaponStatMP_Accuracy].GotoAndStop("upgrade");
                        // End:0xB4A
                        break;
                    // End:0x94E
                    case 1:
                        WeaponStatBars1[4].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_ReloadSpeed);
                        StatBar1[4].Rects[WeapClass.default.WeaponStatMP_ReloadSpeed].GotoAndStop("upgrade");
                        // End:0xB4A
                        break;
                    // End:0x9F5
                    case 2:
                        WeaponStatBars1[1].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Firerate);
                        StatBar1[1].Rects[WeapClass.default.WeaponStatMP_Firerate].GotoAndStop("upgrade");
                        // End:0xB4A
                        break;
                    // End:0xA9E
                    case 3:
                        WeaponStatBars1[5].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_RunFriendly);
                        StatBar1[5].Rects[WeapClass.default.WeaponStatMP_RunFriendly].GotoAndStop("upgrade");
                        // End:0xB4A
                        break;
                    // End:0xB47
                    case 4:
                        WeaponStatBars1[3].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Magazines);
                        StatBar1[3].Rects[WeapClass.default.WeaponStatMP_Magazines].GotoAndStop("upgrade");
                        // End:0xB4A
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
                    // End:0xC57
                    case 0:
                        WeaponStatBars2[2].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Accuracy);
                        StatBar2[2].Rects[WeapClass.default.WeaponStatMP_Accuracy].GotoAndStop("upgrade");
                        // End:0xEFB
                        break;
                    // End:0xCFF
                    case 1:
                        WeaponStatBars2[4].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_ReloadSpeed);
                        StatBar2[4].Rects[WeapClass.default.WeaponStatMP_ReloadSpeed].GotoAndStop("upgrade");
                        // End:0xEFB
                        break;
                    // End:0xDA6
                    case 2:
                        WeaponStatBars2[1].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Firerate);
                        StatBar2[1].Rects[WeapClass.default.WeaponStatMP_Firerate].GotoAndStop("upgrade");
                        // End:0xEFB
                        break;
                    // End:0xE4F
                    case 3:
                        WeaponStatBars2[5].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_RunFriendly);
                        StatBar2[5].Rects[WeapClass.default.WeaponStatMP_RunFriendly].GotoAndStop("upgrade");
                        // End:0xEFB
                        break;
                    // End:0xEF8
                    case 4:
                        WeaponStatBars2[3].GotoAndStopI(10 - WeapClass.default.WeaponStatMP_Magazines);
                        StatBar2[3].Rects[WeapClass.default.WeaponStatMP_Magazines].GotoAndStop("upgrade");
                        // End:0xEFB
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
            // End:0xFBB
            if((UpgradeRequirements[I] - WeaponKillCounts[EquipmentIndex + 1]) < KillsToNextUpgrade)
            {
                KillsToNextUpgrade = UpgradeRequirements[I] - WeaponKillCounts[EquipmentIndex + 1];
            }
            // End:0x101A
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
        goto J0x732;
    }
    // End:0x10EF
    if(KillsToNextUpgrade == 999999)
    {
        // End:0x10C3
        if(bMainWeapon)
        {
            KillsRequiredTF1.SetText(WeaponFullyUpgradedStr);            
        }
        else
        {
            KillsRequiredTF2.SetText(WeaponFullyUpgradedStr);
        }        
    }
    else
    {
        // End:0x1122
        if(KillsFromLastUpgrade == 999999)
        {
            KillsFromLastUpgrade = WeaponKillCounts[EquipmentIndex + 1];
        }
        // End:0x117A
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

function OnLeftArrow1(EventData ev)
{
    MainWeaponIndex--;
    // End:0x31
    if(MainWeaponIndex < 0)
    {
        MainWeaponIndex = MainWeaponsIndices.Length - 1;
    }
    UpdateMainWeaponsDisplay(MainWeaponsIndices[MainWeaponIndex]);
    //return;    
}

function OnRightArrow1(EventData ev)
{
    MainWeaponIndex++;
    // End:0x2E
    if(MainWeaponIndex >= MainWeaponsIndices.Length)
    {
        MainWeaponIndex = 0;
    }
    UpdateMainWeaponsDisplay(MainWeaponsIndices[MainWeaponIndex]);
    //return;    
}

function OnLeftArrow2(EventData ev)
{
    SecondWeaponIndex--;
    // End:0x31
    if(SecondWeaponIndex < 0)
    {
        SecondWeaponIndex = SecondWeaponsIndices.Length - 1;
    }
    UpdateSecondWeaponsDisplay(SecondWeaponsIndices[SecondWeaponIndex]);
    //return;    
}

function OnRightArrow2(EventData ev)
{
    SecondWeaponIndex++;
    // End:0x2E
    if(SecondWeaponIndex >= SecondWeaponsIndices.Length)
    {
        SecondWeaponIndex = 0;
    }
    UpdateSecondWeaponsDisplay(SecondWeaponsIndices[SecondWeaponIndex]);
    //return;    
}

function ChangeFocus(AdvGFxUI_Menu_MultiPlayerSettings.EMenuPart NewFocusedMenuPart)
{
    local int I;
    local ASDisplayInfo displayInfo;

    CurrentActiveMenuPart = NewFocusedMenuPart;
    // End:0x67B
    if(int(CurrentActiveMenuPart) == int(1))
    {
        // End:0x416
        if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            WeaponMainLeftTF.SetBool("html", true);
            WeaponMainRightTF.SetBool("html", true);
            WeaponSecondLeftTF.SetBool("html", true);
            WeaponSecondRightTF.SetBool("html", true);
            WeaponMainLeftTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_LeftBumper", "ADVGame"));
            WeaponMainRightTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_RightBumper", "ADVGame"));
            WeaponSecondLeftTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_LeftTrigger", "ADVGame"));
            WeaponSecondRightTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_RightTrigger", "ADVGame"));            
        }
        else
        {
            SaveBaton.SetVisible(true);
            MainRightArrow.SetVisible(true);
            MainLeftArrow.SetVisible(true);
            SecondRightArrow.SetVisible(true);
            SecondLeftArrow.SetVisible(true);
        }
        displayInfo.hasAlpha = true;
        displayInfo.Alpha = 100.0000000;
        ActiveMarkBtn[CurrentViewedClassIndex - 5].SetDisplayInfo(displayInfo);
        I = 0;
        J0x538:

        // End:0x678 [Loop If]
        if(I < 5)
        {
            PredefinedClassBtn[I].SetBool("disabled", true);
            // End:0x636
            if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
            {
                // End:0x633
                if(I != (CurrentViewedClassIndex - 5))
                {
                    CustomClassBtn[I].SetBool("disabled", true);
                }                
            }
            else
            {
                CustomClassBtn[I].SetBool("disabled", true);
            }
            I++;
            // [Loop Continue]
            goto J0x538;
        }        
    }
    else
    {
        // End:0x92A
        if(int(CurrentActiveMenuPart) == int(0))
        {
            // End:0x782
            if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
            {
                WeaponMainLeftTF.SetText("");
                WeaponMainRightTF.SetText("");
                WeaponSecondLeftTF.SetText("");
                WeaponSecondRightTF.SetText("");                
            }
            else
            {
                SaveBaton.SetVisible(false);
                MainRightArrow.SetVisible(false);
                MainLeftArrow.SetVisible(false);
                SecondRightArrow.SetVisible(false);
                SecondLeftArrow.SetVisible(false);
            }
            displayInfo.hasAlpha = true;
            displayInfo.Alpha = 0.0000000;
            ActiveMarkBtn[CurrentViewedClassIndex - 5].SetDisplayInfo(displayInfo);
            I = 0;
            J0x8A4:

            // End:0x92A [Loop If]
            if(I < 5)
            {
                PredefinedClassBtn[I].SetBool("disabled", false);
                CustomClassBtn[I].SetBool("disabled", false);
                I++;
                // [Loop Continue]
                goto J0x8A4;
            }
        }
    }
    UpdateFooter();
    //return;    
}

function InClass1(EventData ev)
{
    UpdateWeaponsDisplay(0);
    //return;    
}

function OnClass1(EventData ev)
{
    //return;    
}

function InClass2(EventData ev)
{
    UpdateWeaponsDisplay(1);
    //return;    
}

function OnClass2(EventData ev)
{
    //return;    
}

function InClass3(EventData ev)
{
    UpdateWeaponsDisplay(2);
    //return;    
}

function OnClass3(EventData ev)
{
    //return;    
}

function InClass4(EventData ev)
{
    UpdateWeaponsDisplay(3);
    //return;    
}

function OnClass4(EventData ev)
{
    //return;    
}

function InClass5(EventData ev)
{
    UpdateWeaponsDisplay(4);
    //return;    
}

function OnClass5(EventData ev)
{
    //return;    
}

function InClass6(EventData ev)
{
    UpdateWeaponsDisplay(5);
    //return;    
}

function OnClass6(EventData ev)
{
    CurrentViewedClassIndex = 5;
    ChangeFocus(1);
    //return;    
}

function InClass7(EventData ev)
{
    UpdateWeaponsDisplay(6);
    //return;    
}

function OnClass7(EventData ev)
{
    CurrentViewedClassIndex = 6;
    ChangeFocus(1);
    //return;    
}

function InClass8(EventData ev)
{
    UpdateWeaponsDisplay(7);
    //return;    
}

function OnClass8(EventData ev)
{
    CurrentViewedClassIndex = 7;
    ChangeFocus(1);
    //return;    
}

function InClass9(EventData ev)
{
    UpdateWeaponsDisplay(8);
    //return;    
}

function OnClass9(EventData ev)
{
    CurrentViewedClassIndex = 8;
    ChangeFocus(1);
    //return;    
}

function InClass10(EventData ev)
{
    UpdateWeaponsDisplay(9);
    //return;    
}

function OnClass10(EventData ev)
{
    CurrentViewedClassIndex = 9;
    ChangeFocus(1);
    //return;    
}

function UpdateWeaponsDisplay(int ViewedClassIndex)
{
    local byte ClassInfo[4];

    CurrentViewedClassIndex = ViewedClassIndex;
    // End:0xB4
    if(CurrentViewedClassIndex < 5)
    {
        UpdateMainWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[0]);
        UpdateSecondWeaponsDisplay(Class'AdvClassInfo_MP_Base'.default.ClassInfo[CurrentViewedClassIndex].EquipmentIndices[1]);        
    }
    else
    {
        AdvPlayerController(GetPC()).ProfileSettings.GetMPCustomClassInfo(CurrentViewedClassIndex - 5, ClassInfo);
        MainWeaponIndex = MainWeaponsIndices.Find(int(ClassInfo[0]));        
        SecondWeaponIndex = SecondWeaponsIndices.Find(int(ClassInfo[1]));        
        UpdateMainWeaponsDisplay(int(ClassInfo[0]));
        UpdateSecondWeaponsDisplay(int(ClassInfo[1]));
    }
    //return;    
}

function OnSave2Btn(EventData ev)
{
    local byte ClassData[4];

    // End:0xB6
    if(int(CurrentActiveMenuPart) == int(1))
    {
        ClassData[0] = byte(MainWeaponsIndices[MainWeaponIndex]);
        ClassData[1] = byte(SecondWeaponsIndices[SecondWeaponIndex]);
        AdvPlayerController(GetPC()).ProfileSettings.SaveMPCustomClassInfo(CurrentViewedClassIndex - 5, ClassData);
        ChangeFocus(0);
    }
    //return;    
}

function OnBack(EventData ev)
{
    local byte ClassInfo[4];

    // End:0xA5
    if(int(CurrentActiveMenuPart) == int(1))
    {
        ChangeFocus(0);
        AdvPlayerController(GetPC()).ProfileSettings.GetMPCustomClassInfo(CurrentViewedClassIndex - 5, ClassInfo);
        UpdateMainWeaponsDisplay(int(ClassInfo[0]));
        UpdateSecondWeaponsDisplay(int(ClassInfo[1]));        
    }
    else
    {
        AdvPlayerController(GetPC()).ClientSaveAllPlayerData();
        Action = "back";
        PlayCloseAnimation();
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x130
        case "back":
            // End:0x8E
            if(Frontend.bPreGameLobby && AdvFrontEndParty(Frontend) != none)
            {
                bTransitionResult = AdvFrontEndParty(Frontend).OpenClientLobbyScreen();                
            }
            else
            {
                // End:0xF9
                if(((GetMenuGame()) == none) || GetMenuGRI().IsInPregameLobby())
                {
                    bTransitionResult = AdvFrontEndParty(Frontend).OpenPregameLobbyScreen();                    
                }
                else
                {
                    bTransitionResult = Frontend.OpenMultiMenuScreen();
                }
            }
            Cleanup();
            // End:0x136
            break;
        // End:0xFFFF
        default:
            // End:0x136
            break;
            break;
    }
    // End:0x162
    if(bTransitionResult)
    {
        Frontend.CloseMultiPlayerSettingsScreen();
    }
    Action = "";
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local EventData ev;

    // End:0x207
    if((GetPC().WorldInfo.IsConsoleBuild(0) || GetPC().PlayerInput.bUsingGamepad) && int(CurrentActiveMenuPart) == int(1))
    {
        // End:0x207
        if((int(InputEvent) == int(0)) && ControllerId == GetLP().ControllerId)
        {
            // End:0xF9
            if(ButtonName == 'XboxTypeS_RightTrigger')
            {
                OnRightArrow2(ev);
                return true;
            }
            // End:0x125
            if(ButtonName == 'XboxTypeS_LeftTrigger')
            {
                OnLeftArrow2(ev);
                return true;
            }
            // End:0x151
            if(ButtonName == 'XboxTypeS_RightShoulder')
            {
                OnRightArrow1(ev);
                return true;
            }
            // End:0x17D
            if(ButtonName == 'XboxTypeS_LeftShoulder')
            {
                OnLeftArrow1(ev);
                return true;
            }
            // End:0x1A9
            if(ButtonName == 'XboxTypeS_B')
            {
                OnBack(ev);
                return true;
            }
            // End:0x207
            if(ButtonName == 'XboxTypeS_A')
            {
                // End:0x205
                if(((int(CurrentActiveMenuPart) == int(1)) && bMainWeaponAvailable) && bSecondWeaponAvailable)
                {
                    OnSave2Btn(ev);
                }
                return true;
            }
        }
    }
    // End:0x251
    if(Frontend != none)
    {
        return Frontend.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    return false;
    //return ReturnValue;    
}

function SetDelegates()
{
    GRI = AdvPreGameGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0xCA
    if(GRI != none)
    {
        GRI.__OnLobbyStateChanged__Delegate = LobbyStateChanged;
        GRI.__OnSelectionCountdownTick__Delegate = SelectionCountdownTick;
        LobbyStateChanged();
        SelectionCountdownTick();
    }
    //return;    
}

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x2C
    if(GRI == none)
    {
        SetDelegates();
    }
    //return;    
}

simulated function LobbyStateChanged()
{
    switch(GRI.PreGameLobbyState)
    {
        // End:0x2D
        case 0:
        // End:0x73
        case 1:
            TimeToStartTF.SetText(Class'AdvGFxUI_Menu_PregameLobby'.default.PreparingGameString);
            // End:0x150
            break;
        // End:0xB9
        case 2:
            TimeToStartTF.SetText(Class'AdvGFxUI_Menu_PregameLobby'.default.WaitingForPlayersString);
            // End:0x150
            break;
        // End:0xC1
        case 4:
            // End:0x150
            break;
        // End:0xC6
        case 5:
        // End:0x10C
        case 6:
            TimeToStartTF.SetText(Class'AdvGFxUI_Menu_PregameLobby'.default.StartingGameString);
            // End:0x150
            break;
        // End:0xFFFF
        default:
            TimeToStartTF.SetText(Class'AdvGFxUI_Menu_PregameLobby'.default.PreparingGameString);
            // End:0x150
            break;
            break;
    }
    //return;    
}

simulated function SelectionCountdownTick()
{
    local string Time;

    // End:0xD0
    if(int(GRI.PreGameLobbyState) == int(4))
    {
        // End:0x7F
        if(int(GRI.RemainingGameVoteSeconds) > int(0))
        {
            Time = string(GRI.RemainingGameVoteSeconds);            
        }
        else
        {
            Time = Class'AdvGFxUI_Menu_PregameLobby'.default.StartingGameString;
        }
        TimeToStartTF.SetText(Time);
    }
    //return;    
}

defaultproperties
{
    PredefinedClassStr[0]="Commando"
    PredefinedClassStr[1]="Guard"
    PredefinedClassStr[2]="Ranger"
    PredefinedClassStr[3]="Scout"
    PredefinedClassStr[4]="Sniper"
    CustomClassStr[0]="Custom Class 1"
    CustomClassStr[1]="Custom Class 2"
    CustomClassStr[2]="Custom Class 3"
    CustomClassStr[3]="Custom Class 4"
    CustomClassStr[4]="Custom Class 5"
    PlayerLevelString[0]="Tourist"
    PlayerLevelString[1]="Traveler"
    PlayerLevelString[2]="Treasure Hunter"
    PlayerLevelString[3]="Adventurer"
    PlayerLevelString[4]="Globetrotter"
    SaveSettingsString="Save settings"
    KillsRequiredStr="Kills to next upgrade:"
    WeaponFullyUpgradedStr="Fully upgraded!"
    PlayerLevelStr="Level: `l"
    PlayerXPStr="XP: `x"
    UnlockStr="Unlock at level `l"
    StatBarStr[0]="Damage"
    StatBarStr[1]="Firerate"
    StatBarStr[2]="Accuracy"
    StatBarStr[3]="Max ammo"
    StatBarStr[4]="Reload speed"
    StatBarStr[5]="Weightless"
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
    MovieInfo=SwfMovie'UI_AdvCommon.AdvPlayerSettings'
}