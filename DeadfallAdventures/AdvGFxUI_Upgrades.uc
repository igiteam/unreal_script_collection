class AdvGFxUI_Upgrades extends AdvGfxMoviePlayer
    config(UI);

enum ESkillUnlockState
{
    ESUS_NotReached,                // 0
    ESUS_Reached,                   // 1
    ESUS_ReadyToUnlock,             // 2
    ESUS_Unlocked,                  // 3
    ESUS_MAX                        // 4
};

struct TSkillBtn
{
    var GFxObject SkillMC;
    var GFxObject UILoaderMC;
    var GFxClikWidget Button;
    var GFxClikWidget UILoader;
    var Texture2D SkillIcon;
    var const localized string SkillName;
    var const localized string SkillDesc;
    var AdvGFxUI_Upgrades.ESkillUnlockState SkillUnlockState;

    structdefaultproperties
    {
        SkillMC=none
        UILoaderMC=none
        Button=none
        UILoader=none
        SkillIcon=none
        SkillName=""
        SkillDesc=""
        SkillUnlockState=ESkillUnlockState.ESUS_NotReached
    }
};

var GFxObject RootMC;
var GFxObject MenuMC;
var GFxObject BgMC;
var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject KursorMC;
var GFxClikWidget SaveBtn;
var GFxClikWidget ResetBtn;
var GFxClikWidget BackBtn;
var array<TSkillBtn> PathOfLife;
var array<TSkillBtn> PathOfLight;
var array<TSkillBtn> PathOfWarrior;
var GFxObject PathOfLifeMC;
var GFxObject PathOfLightMC;
var GFxObject PathOfWarriorMC;
var GFxObject PathOfLifeTF;
var GFxObject PathOfLifeTreasuresTF;
var GFxObject PathOfLightTF;
var GFxObject PathOfLightTreasuresTF;
var GFxObject PathOfWarriorTF;
var GFxObject PathOfWarriorTreasuresTF;
var GFxObject SkillDescMC;
var GFxObject SkillNameTF;
var GFxObject SkillStatusTF;
var GFxObject SkillDescTF;
var const localized string TitleString;
var const localized string SaveString;
var const localized string ResetString;
var const localized string TreasuresColectedString;
var const localized string TreasuresAvailabeString;
var const localized string NeedToUnlockString;
var const localized string NeedPreviousToUnlockString;
var const localized string UnlockedString;
var const localized string YouCanUnlockString;
var bool bHasChanges;
var transient bool bIsPlayingCloseAnimation;
var transient bool bIsMenuPPOverrideOn;
var string Action;
var transient TTreasurePerkInfo LocalTreasurePerks[ETreasureType];
var transient int LocalTreasuresPerTypeAvailable[ETreasureType];
var AdvGFxUI_Menu_Footer footer;

simulated function bool Start(optional bool StartPaused = false)
{
    local int I;
    local bool bWasUsingGamepad;

    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    BgMC = RootMC.GetObject("bg");
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    KursorMC = RootMC.GetObject("kursor");
    // End:0x204
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        KursorMC.SetVisible(false);
        bIgnoreMouseInput = true;        
    }
    else
    {
        KursorMC.SetVisible(AdvGFxHudWrapper(GetPC().myHUD).bShowCursor);
        bIgnoreMouseInput = !AdvGFxHudWrapper(GetPC().myHUD).bShowCursor;
    }
    PathOfLifeMC = ButtonsMC.GetObject("LifeMC");
    PathOfLightMC = ButtonsMC.GetObject("LightMC");
    PathOfWarriorMC = ButtonsMC.GetObject("WarriorMC");
    PathOfLifeTF = PathOfLifeMC.GetObject("PathNameTF");
    PathOfLifeTreasuresTF = PathOfLifeMC.GetObject("TreasuresCollectedTF");
    PathOfLightTF = PathOfLightMC.GetObject("PathNameTF");
    PathOfLightTreasuresTF = PathOfLightMC.GetObject("TreasuresCollectedTF");
    PathOfWarriorTF = PathOfWarriorMC.GetObject("PathNameTF");
    PathOfWarriorTreasuresTF = PathOfWarriorMC.GetObject("TreasuresCollectedTF");
    SkillDescMC = ButtonsMC.GetObject("DescMC");
    SkillNameTF = SkillDescMC.GetObject("NameTF");
    SkillStatusTF = SkillDescMC.GetObject("StatusTF");
    SkillDescTF = SkillDescMC.GetObject("DescTF");
    I = 0;
    J0x57D:

    // End:0x819 [Loop If]
    if(I < PathOfLife.Length)
    {
        PathOfLife[I].SkillMC = ButtonsMC.GetObject("LifeBtn" $ string(I + 1));
        PathOfLife[I].UILoaderMC = PathOfLife[I].SkillMC.GetObject("UILoaderMC");
        PathOfLife[I].Button = GFxClikWidget(PathOfLife[I].SkillMC.GetObject("SkillBtn", Class'GFxUI.GFxClikWidget'));
        PathOfLife[I].UILoader = GFxClikWidget(PathOfLife[I].UILoaderMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        PathOfLife[I].UILoader.SetString("source", "img://" $ PathName(PathOfLife[I].SkillIcon));
        PathOfLife[I].SkillUnlockState = 0;
        I++;
        // [Loop Continue]
        goto J0x57D;
    }
    I = 0;
    J0x824:

    // End:0xAC3 [Loop If]
    if(I < PathOfWarrior.Length)
    {
        PathOfWarrior[I].SkillMC = ButtonsMC.GetObject("WarriorBtn" $ string(I + 1));
        PathOfWarrior[I].UILoaderMC = PathOfWarrior[I].SkillMC.GetObject("UILoaderMC");
        PathOfWarrior[I].Button = GFxClikWidget(PathOfWarrior[I].SkillMC.GetObject("SkillBtn", Class'GFxUI.GFxClikWidget'));
        PathOfWarrior[I].UILoader = GFxClikWidget(PathOfWarrior[I].UILoaderMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        PathOfWarrior[I].UILoader.SetString("source", "img://" $ PathName(PathOfWarrior[I].SkillIcon));
        PathOfWarrior[I].SkillUnlockState = 0;
        I++;
        // [Loop Continue]
        goto J0x824;
    }
    I = 0;
    J0xACE:

    // End:0xD6B [Loop If]
    if(I < PathOfLight.Length)
    {
        PathOfLight[I].SkillMC = ButtonsMC.GetObject("LightBtn" $ string(I + 1));
        PathOfLight[I].UILoaderMC = PathOfLight[I].SkillMC.GetObject("UILoaderMC");
        PathOfLight[I].Button = GFxClikWidget(PathOfLight[I].SkillMC.GetObject("SkillBtn", Class'GFxUI.GFxClikWidget'));
        PathOfLight[I].UILoader = GFxClikWidget(PathOfLight[I].UILoaderMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        PathOfLight[I].UILoader.SetString("source", "img://" $ PathName(PathOfLight[I].SkillIcon));
        PathOfLight[I].SkillUnlockState = 0;
        I++;
        // [Loop Continue]
        goto J0xACE;
    }
    SaveBtn = GFxClikWidget(ButtonsMC.GetObject("save_btn", Class'GFxUI.GFxClikWidget'));
    ResetBtn = GFxClikWidget(ButtonsMC.GetObject("reset_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", Class'AdvGFxUI_Menu_Base'.default.Exit);
    // End:0xF11
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    SaveBtn.SetBool("visible", false);
    ResetBtn.SetBool("visible", false);
    TitleTF.SetText(TitleString);
    SaveBtn.SetString("label", SaveString);
    ResetBtn.SetString("label", ResetString);
    PathOfLifeTF.SetText(Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 0)), "ADVGame"));
    PathOfLightTF.SetText(Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 1)), "ADVGame"));
    PathOfWarriorTF.SetText(Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 2)), "ADVGame"));
    SkillNameTF.SetText("");
    SkillStatusTF.SetBool("html", true);
    SkillStatusTF.SetString("htmlText", "");
    SkillDescTF.SetText("");
    UpdatePathsAndLocalData();
    PlayOpenAnimation();
    bIsPlayingCloseAnimation = false;
    bWasUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
    FlushPlayerInput(false);
    GetPC().PlayerInput.bUsingGamepad = bWasUsingGamepad;
    AdvPlayerController(GetPC()).SetSprint(false);
    PathOfLife[0].Button.SetBool("focused", true);
    // End:0x130E
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        InitializeFooter();
        UpdateFooter();
    }
    return true;
    //return ReturnValue;    
}

function InitializeFooter()
{
    // End:0x50
    if(footer == none)
    {
        footer = new Class'AdvGFxUI_Menu_Footer';
        footer.Init(GetLP());
    }
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericExit');    
    footer.FooterUpdate(ButtonAliases);
    //return;    
}

function UpdatePathsAndLocalData()
{
    local AdvPlayerController PC;
    local AdvPRI PRI;
    local int I, J, K;
    local TTreasurePerkPathInfo PathInfo;

    PC = AdvPlayerController(GetPC());
    PRI = AdvPRI(PC.PlayerReplicationInfo);
    I = 0;
    J0x59:

    // End:0xB3 [Loop If]
    if(I < 3)
    {
        LocalTreasuresPerTypeAvailable[I] = PRI.TreasuresPerTypeAvailable[I];
        I++;
        // [Loop Continue]
        goto J0x59;
    }
    I = 0;
    J0xBE:

    // End:0x3BD [Loop If]
    if(I < 3)
    {
        LocalTreasurePerks[I].PerkPath.Remove(0, LocalTreasurePerks[I].PerkPath.Length);        
        LocalTreasurePerks[I].PerkPath.Length = 0;
        J = 0;
        J0x152:

        // End:0x3AF [Loop If]
        if(J < PC.TreasurePerks[I].PerkPath.Length)
        {
            PathInfo.CurrentLevel = PC.TreasurePerks[I].PerkPath[J].CurrentLevel;
            PathInfo.LevelCost.Remove(0, PathInfo.LevelCost.Length);            
            PathInfo.LevelCost.Length = 0;
            K = 0;
            J0x277:

            // End:0x36E [Loop If]
            if(K < PC.TreasurePerks[I].PerkPath[J].LevelCost.Length)
            {
                PathInfo.LevelCost.AddItem(PC.TreasurePerks[I].PerkPath[J].LevelCost[K]);                
                K++;
                // [Loop Continue]
                goto J0x277;
            }
            LocalTreasurePerks[I].PerkPath.AddItem(PathInfo);            
            J++;
            // [Loop Continue]
            goto J0x152;
        }
        I++;
        // [Loop Continue]
        goto J0xBE;
    }
    InternalUpdateLabels();
    I = 0;
    J0x3D2:

    // End:0x40D [Loop If]
    if(I < PathOfLife.Length)
    {
        InternalCheckAndSetSkillState(0, I);
        I++;
        // [Loop Continue]
        goto J0x3D2;
    }
    I = 0;
    J0x418:

    // End:0x453 [Loop If]
    if(I < PathOfLight.Length)
    {
        InternalCheckAndSetSkillState(1, I);
        I++;
        // [Loop Continue]
        goto J0x418;
    }
    I = 0;
    J0x45E:

    // End:0x499 [Loop If]
    if(I < PathOfWarrior.Length)
    {
        InternalCheckAndSetSkillState(2, I);
        I++;
        // [Loop Continue]
        goto J0x45E;
    }
    bHasChanges = false;
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x2F
    if(GetLP().ControllerId != ControllerId)
    {
        return true;
    }
    // End:0x94
    if(Class'AdvFrontEnd'.static.IsGamepadKey(ButtonName))
    {
        GetPC().PlayerInput.bUsingGamepad = true;        
    }
    else
    {
        GetPC().PlayerInput.bUsingGamepad = false;
    }
    return super(GFxMoviePlayer).FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function InternalUpdateLabels()
{
    local AdvPRI PRI;

    PRI = AdvPRI(GetPC().PlayerReplicationInfo);
    PathOfLifeTreasuresTF.SetText((((TreasuresColectedString @ string(PRI.TreasuresPerTypeColected[0])) @ "   ") @ TreasuresAvailabeString) @ string(LocalTreasuresPerTypeAvailable[0]));
    PathOfLightTreasuresTF.SetText((((TreasuresColectedString @ string(PRI.TreasuresPerTypeColected[1])) @ "   ") @ TreasuresAvailabeString) @ string(LocalTreasuresPerTypeAvailable[1]));
    PathOfWarriorTreasuresTF.SetText((((TreasuresColectedString @ string(PRI.TreasuresPerTypeColected[2])) @ "   ") @ TreasuresAvailabeString) @ string(LocalTreasuresPerTypeAvailable[2]));
    //return;    
}

function InternalCheckAndSetSkillState(AdvTypes.ETreasureType TreasureType, int Index)
{
    local int SkillCost;

    SkillCost = GetSkillCost(TreasureType, Index);
    // End:0x1E4
    if((LocalTreasurePerks[int(TreasureType)].PerkPath.Length > 0) && Index < LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length)
    {
        // End:0x110
        if(LocalTreasurePerks[int(TreasureType)].PerkPath[0].CurrentLevel > Index)
        {
            SetSkillUnlockState(TreasureType, Index, 3, false);            
        }
        else
        {
            // End:0x1C2
            if(LocalTreasurePerks[int(TreasureType)].PerkPath[0].CurrentLevel == Index)
            {
                // End:0x1A0
                if(LocalTreasuresPerTypeAvailable[int(TreasureType)] >= SkillCost)
                {
                    SetSkillUnlockState(TreasureType, Index, 2);                    
                }
                else
                {
                    SetSkillUnlockState(TreasureType, Index, 1);
                }                
            }
            else
            {
                SetSkillUnlockState(TreasureType, Index, 0);
            }
        }        
    }
    else
    {
        // End:0x45F
        if((LocalTreasurePerks[int(TreasureType)].PerkPath.Length > 1) && (Index - LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length) < LocalTreasurePerks[int(TreasureType)].PerkPath[1].LevelCost.Length)
        {
            // End:0x34E
            if((LocalTreasurePerks[int(TreasureType)].PerkPath[1].CurrentLevel + LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length) > Index)
            {
                SetSkillUnlockState(TreasureType, Index, 3, false);                
            }
            else
            {
                // End:0x440
                if((LocalTreasurePerks[int(TreasureType)].PerkPath[1].CurrentLevel + LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length) == Index)
                {
                    // End:0x41E
                    if(LocalTreasuresPerTypeAvailable[int(TreasureType)] >= SkillCost)
                    {
                        SetSkillUnlockState(TreasureType, Index, 2);                        
                    }
                    else
                    {
                        SetSkillUnlockState(TreasureType, Index, 1);
                    }                    
                }
                else
                {
                    SetSkillUnlockState(TreasureType, Index, 0);
                }
            }
        }
    }
    //return;    
}

function SavePathsLevelData()
{
    local AdvPlayerController PC;
    local AdvPRI PRI;
    local int I, J;

    PC = AdvPlayerController(GetPC());
    PRI = AdvPRI(PC.PlayerReplicationInfo);
    I = 0;
    J0x59:

    // End:0xB3 [Loop If]
    if(I < 3)
    {
        PRI.TreasuresPerTypeAvailable[I] = LocalTreasuresPerTypeAvailable[I];
        I++;
        // [Loop Continue]
        goto J0x59;
    }
    I = 0;
    J0xBE:

    // End:0x1C6 [Loop If]
    if(I < 3)
    {
        J = 0;
        J0xD9:

        // End:0x1B8 [Loop If]
        if(J < LocalTreasurePerks[I].PerkPath.Length)
        {
            PC.TreasurePerks[I].PerkPath[J].CurrentLevel = LocalTreasurePerks[I].PerkPath[J].CurrentLevel;
            J++;
            // [Loop Continue]
            goto J0xD9;
        }
        I++;
        // [Loop Continue]
        goto J0xBE;
    }
    bHasChanges = false;
    //return;    
}

function int GetSkillCost(AdvTypes.ETreasureType TreasureType, int Index)
{
    // End:0xC8
    if((LocalTreasurePerks[int(TreasureType)].PerkPath.Length > 0) && Index < LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length)
    {
        return LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost[Index];        
    }
    else
    {
        // End:0x20D
        if((LocalTreasurePerks[int(TreasureType)].PerkPath.Length > 1) && (Index - LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length) < LocalTreasurePerks[int(TreasureType)].PerkPath[1].LevelCost.Length)
        {
            return LocalTreasurePerks[int(TreasureType)].PerkPath[1].LevelCost[Index - LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length];
        }
    }
    return -1;
    //return ReturnValue;    
}

function bool TryToUnlockSkill(AdvTypes.ETreasureType TreasureType, int Index)
{
    local int SkillCost, I, K;

    SkillCost = GetSkillCost(TreasureType, Index);
    // End:0x5F1
    if((SkillCost > -1) && LocalTreasuresPerTypeAvailable[int(TreasureType)] >= SkillCost)
    {
        // End:0x309
        if((LocalTreasurePerks[int(TreasureType)].PerkPath.Length > 0) && Index < LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length)
        {
            LocalTreasuresPerTypeAvailable[int(TreasureType)] -= SkillCost;
            LocalTreasurePerks[int(TreasureType)].PerkPath[0].CurrentLevel++;
            InternalUpdateLabels();
            K = 0;
            I = 0;
            J0x15A:

            // End:0x304 [Loop If]
            if(I < LocalTreasurePerks[int(TreasureType)].PerkPath.Length)
            {
                // End:0x242
                if(LocalTreasurePerks[int(TreasureType)].PerkPath[I].CurrentLevel > 0)
                {
                    InternalCheckAndSetSkillState(TreasureType, (K + LocalTreasurePerks[int(TreasureType)].PerkPath[I].CurrentLevel) - 1);
                }
                InternalCheckAndSetSkillState(TreasureType, K + LocalTreasurePerks[int(TreasureType)].PerkPath[I].CurrentLevel);
                K += LocalTreasurePerks[int(TreasureType)].PerkPath[I].LevelCost.Length;
                I++;
                // [Loop Continue]
                goto J0x15A;
            }
            return true;            
        }
        else
        {
            // End:0x5F1
            if((LocalTreasurePerks[int(TreasureType)].PerkPath.Length > 1) && (Index - LocalTreasurePerks[int(TreasureType)].PerkPath[0].LevelCost.Length) < LocalTreasurePerks[int(TreasureType)].PerkPath[1].LevelCost.Length)
            {
                LocalTreasuresPerTypeAvailable[int(TreasureType)] -= SkillCost;
                LocalTreasurePerks[int(TreasureType)].PerkPath[1].CurrentLevel++;
                InternalUpdateLabels();
                K = 0;
                I = 0;
                J0x445:

                // End:0x5EF [Loop If]
                if(I < LocalTreasurePerks[int(TreasureType)].PerkPath.Length)
                {
                    // End:0x52D
                    if(LocalTreasurePerks[int(TreasureType)].PerkPath[I].CurrentLevel > 0)
                    {
                        InternalCheckAndSetSkillState(TreasureType, (K + LocalTreasurePerks[int(TreasureType)].PerkPath[I].CurrentLevel) - 1);
                    }
                    InternalCheckAndSetSkillState(TreasureType, K + LocalTreasurePerks[int(TreasureType)].PerkPath[I].CurrentLevel);
                    K += LocalTreasurePerks[int(TreasureType)].PerkPath[I].LevelCost.Length;
                    I++;
                    // [Loop Continue]
                    goto J0x445;
                }
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    local AdvLocalPlayer LP;

    MenuMC.GotoAndPlay("open");
    // End:0xA7
    if(!bIsMenuPPOverrideOn)
    {
        LP = AdvLocalPlayer(GetPC().Player);
        // End:0xA7
        if(LP != none)
        {
            LP.SetMenuOverride(true, 0.4000000);
            bIsMenuPPOverrideOn = true;
        }
    }
    //return;    
}

function PlayCloseAnimation()
{
    local AdvLocalPlayer LP;

    // End:0x0F
    if(bIsPlayingCloseAnimation)
    {
        return;
    }
    bIsPlayingCloseAnimation = true;
    MenuMC.GotoAndPlay("close");
    // End:0xC1
    if(bIsMenuPPOverrideOn)
    {
        LP = AdvLocalPlayer(GetPC().Player);
        // End:0xC1
        if(LP != none)
        {
            LP.SetMenuOverride(false, 0.4000000);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function OnBack(EventData ev)
{
    local array<name> ButtonAliases;

    // End:0x109
    if(bHasChanges)
    {
        ButtonAliases.AddItem('GenericYes');        
        ButtonAliases.AddItem('GenericNo');        
        Class'AdvUIManager'.static.ShowUIMessage('UpgradesConfirm', Localize("MessageBoxStrings", "UpgradesConfirm_Title", "ADVGame"), Localize("MessageBoxStrings", "UpgradesConfirm_Body", "ADVGame"), ButtonAliases, OnExitOptionSelected, GetLP(),,,,,, false, true);        
    }
    else
    {
        Action = "back";
        PlayCloseAnimation();
    }
    //return;    
}

function bool OnExitOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x2A
    if(SelectedInputAlias == 'GenericYes')
    {
        Action = "save";        
    }
    else
    {
        Action = "back";
    }
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnSaveBtn(EventData ev)
{
    Action = "save";
    PlayCloseAnimation();
    //return;    
}

function OnResetBtn(EventData ev)
{
    UpdatePathsAndLocalData();
    SkillNameTF.SetText("");
    SkillStatusTF.SetString("htmlText", "");
    SkillDescTF.SetText("");
    //return;    
}

function SetSkillUnlockState(AdvTypes.ETreasureType TreasureType, int Index, AdvGFxUI_Upgrades.ESkillUnlockState UnlockState, optional bool bPlayOpenAnimation)
{
    switch(TreasureType)
    {
        // End:0x174
        case 0:
            // End:0x171
            if(Index < PathOfLife.Length)
            {
                // End:0xDE
                if(int(UnlockState) == int(3))
                {
                    // End:0x97
                    if(bPlayOpenAnimation)
                    {
                        PathOfLife[Index].SkillMC.GotoAndPlay("open");                        
                    }
                    else
                    {
                        PathOfLife[Index].SkillMC.GotoAndStop("active");
                    }                    
                }
                else
                {
                    PathOfLife[Index].SkillMC.GotoAndStop(((int(UnlockState) > int(1)) ? "ready" : "notready"));
                }
                PathOfLife[Index].SkillUnlockState = UnlockState;
            }
            // End:0x437
            break;
        // End:0x2D4
        case 1:
            // End:0x2D1
            if(Index < PathOfLight.Length)
            {
                // End:0x23E
                if(int(UnlockState) == int(3))
                {
                    // End:0x1F7
                    if(bPlayOpenAnimation)
                    {
                        PathOfLight[Index].SkillMC.GotoAndPlay("open");                        
                    }
                    else
                    {
                        PathOfLight[Index].SkillMC.GotoAndStop("active");
                    }                    
                }
                else
                {
                    PathOfLight[Index].SkillMC.GotoAndStop(((int(UnlockState) > int(1)) ? "ready" : "notready"));
                }
                PathOfLight[Index].SkillUnlockState = UnlockState;
            }
            // End:0x437
            break;
        // End:0x434
        case 2:
            // End:0x431
            if(Index < PathOfWarrior.Length)
            {
                // End:0x39E
                if(int(UnlockState) == int(3))
                {
                    // End:0x357
                    if(bPlayOpenAnimation)
                    {
                        PathOfWarrior[Index].SkillMC.GotoAndPlay("open");                        
                    }
                    else
                    {
                        PathOfWarrior[Index].SkillMC.GotoAndStop("active");
                    }                    
                }
                else
                {
                    PathOfWarrior[Index].SkillMC.GotoAndStop(((int(UnlockState) > int(1)) ? "ready" : "notready"));
                }
                PathOfWarrior[Index].SkillUnlockState = UnlockState;
            }
            // End:0x437
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function OnLifeBtn(int Index)
{
    // End:0x82
    if((int(PathOfLife[Index].SkillUnlockState) < int(2)) || int(PathOfLife[Index].SkillUnlockState) == int(3))
    {
        PlaySoundFromTheme('press', 'upgrade_block');
        return;
    }
    // End:0xD8
    if(TryToUnlockSkill(0, Index))
    {
        OverLifeBtn(Index);
        bHasChanges = true;
        PlaySoundFromTheme('press', 'Upgrade');        
    }
    else
    {
        PlaySoundFromTheme('press', 'upgrade_block');
    }
    //return;    
}

function OnWarriorBtn(int Index)
{
    // End:0x82
    if((int(PathOfWarrior[Index].SkillUnlockState) < int(2)) || int(PathOfWarrior[Index].SkillUnlockState) == int(3))
    {
        PlaySoundFromTheme('press', 'upgrade_block');
        return;
    }
    // End:0xD8
    if(TryToUnlockSkill(2, Index))
    {
        OverWarriorBtn(Index);
        bHasChanges = true;
        PlaySoundFromTheme('press', 'Upgrade');        
    }
    else
    {
        PlaySoundFromTheme('press', 'upgrade_block');
    }
    //return;    
}

function OnLightBtn(int Index)
{
    // End:0x82
    if((int(PathOfLight[Index].SkillUnlockState) < int(2)) || int(PathOfLight[Index].SkillUnlockState) == int(3))
    {
        PlaySoundFromTheme('press', 'upgrade_block');
        return;
    }
    // End:0xD8
    if(TryToUnlockSkill(1, Index))
    {
        OverLightBtn(Index);
        bHasChanges = true;
        PlaySoundFromTheme('press', 'Upgrade');        
    }
    else
    {
        PlaySoundFromTheme('press', 'upgrade_block');
    }
    //return;    
}

function OverLifeBtn(int Index)
{
    local int SkillCost;

    SkillNameTF.SetText(PathOfLife[Index].SkillName);
    SkillDescTF.SetText(PathOfLife[Index].SkillDesc);
    PlaySoundFromTheme('rollOver', 'Upgrade');
    // End:0x139
    if(int(PathOfLife[Index].SkillUnlockState) == int(3))
    {
        SkillStatusTF.SetString("htmlText", ("<Color:R=1.0,G=0.33,B=0.0>" $ UnlockedString) $ "</Color>");        
    }
    else
    {
        // End:0x1CB
        if(int(PathOfLife[Index].SkillUnlockState) == int(0))
        {
            SkillStatusTF.SetString("htmlText", ("<Color:R=0.925,G=0.0,B=0.0>" $ NeedPreviousToUnlockString) $ "</Color>");            
        }
        else
        {
            SkillCost = GetSkillCost(0, Index);
            // End:0x289
            if(int(PathOfLife[Index].SkillUnlockState) == int(2))
            {
                SkillStatusTF.SetString("htmlText", (("<Color:R=0.0,G=0.72,B=0.03>" $ YouCanUnlockString) @ string(SkillCost)) $ "</Color>");                
            }
            else
            {
                SkillStatusTF.SetString("htmlText", (("<Color:R=0.925,G=0.0,B=0.0>" $ NeedToUnlockString) @ string(SkillCost - LocalTreasuresPerTypeAvailable[0])) $ "</Color>");
            }
        }
    }
    //return;    
}

function OverWarriorBtn(int Index)
{
    local int SkillCost;

    SkillNameTF.SetText(PathOfWarrior[Index].SkillName);
    SkillDescTF.SetText(PathOfWarrior[Index].SkillDesc);
    PlaySoundFromTheme('rollOver', 'Upgrade');
    // End:0x139
    if(int(PathOfWarrior[Index].SkillUnlockState) == int(3))
    {
        SkillStatusTF.SetString("htmlText", ("<Color:R=1.0,G=0.33,B=0.0>" $ UnlockedString) $ "</Color>");        
    }
    else
    {
        // End:0x1CB
        if(int(PathOfWarrior[Index].SkillUnlockState) == int(0))
        {
            SkillStatusTF.SetString("htmlText", ("<Color:R=0.925,G=0.0,B=0.0>" $ NeedPreviousToUnlockString) $ "</Color>");            
        }
        else
        {
            SkillCost = GetSkillCost(2, Index);
            // End:0x289
            if(int(PathOfWarrior[Index].SkillUnlockState) == int(2))
            {
                SkillStatusTF.SetString("htmlText", (("<Color:R=0.0,G=0.72,B=0.03>" $ YouCanUnlockString) @ string(SkillCost)) $ "</Color>");                
            }
            else
            {
                SkillStatusTF.SetString("htmlText", (("<Color:R=0.925,G=0.0,B=0.0>" $ NeedToUnlockString) @ string(SkillCost - LocalTreasuresPerTypeAvailable[2])) $ "</Color>");
            }
        }
    }
    //return;    
}

function OverLightBtn(int Index)
{
    local int SkillCost;

    SkillNameTF.SetText(PathOfLight[Index].SkillName);
    SkillDescTF.SetText(PathOfLight[Index].SkillDesc);
    PlaySoundFromTheme('rollOver', 'Upgrade');
    // End:0x139
    if(int(PathOfLight[Index].SkillUnlockState) == int(3))
    {
        SkillStatusTF.SetString("htmlText", ("<Color:R=1.0,G=0.33,B=0.0>" $ UnlockedString) $ "</Color>");        
    }
    else
    {
        // End:0x1CB
        if(int(PathOfLight[Index].SkillUnlockState) == int(0))
        {
            SkillStatusTF.SetString("htmlText", ("<Color:R=0.925,G=0.0,B=0.0>" $ NeedPreviousToUnlockString) $ "</Color>");            
        }
        else
        {
            SkillCost = GetSkillCost(1, Index);
            // End:0x289
            if(int(PathOfLight[Index].SkillUnlockState) == int(2))
            {
                SkillStatusTF.SetString("htmlText", (("<Color:R=0.0,G=0.72,B=0.03>" $ YouCanUnlockString) @ string(SkillCost)) $ "</Color>");                
            }
            else
            {
                SkillStatusTF.SetString("htmlText", (("<Color:R=0.925,G=0.0,B=0.0>" $ NeedToUnlockString) @ string(SkillCost - LocalTreasuresPerTypeAvailable[1])) $ "</Color>");
            }
        }
    }
    //return;    
}

function OnOpenAnimationComplete()
{
    //return;    
}

function OnCloseAnimationComplete()
{
    switch(Action)
    {
        // End:0x54
        case "save":
            SavePathsLevelData();
            AdvPlayerController(GetPC()).ApplyTreasurePerk();
            // End:0x5A
            break;
        // End:0xFFFF
        default:
            // End:0x5A
            break;
            break;
    }
    AdvGFxHudWrapper(GetPC().myHUD).CompleteUpgradesMenuClose();
    Action = "";
    //return;    
}

event OnClose()
{
    local AdvLocalPlayer LP;

    // End:0x3A
    if(footer != none)
    {
        footer.Close();
        footer = none;
    }
    // End:0xBA
    if(bIsMenuPPOverrideOn)
    {
        LP = AdvLocalPlayer(GetPC().Player);
        // End:0xBA
        if(LP != none)
        {
            LP.SetMenuOverride(false, 0.0000000);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

defaultproperties
{
    PathOfLife[0]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill1',SkillName="Your health and stamina",SkillDesc="Base health increased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLife[1]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill2',SkillName="Your health and stamina",SkillDesc="Health recovery speed increased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLife[2]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill3',SkillName="Your health and stamina",SkillDesc="Base health increased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLife[3]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill4',SkillName="Your health and stamina",SkillDesc="Health recovery speed increased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLife[4]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill5',SkillName="Your health and stamina",SkillDesc="Base stamina level increased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLife[5]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill6',SkillName="Your health and stamina",SkillDesc="Stamina recovery speed increased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLife[6]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill7',SkillName="Your health and stamina",SkillDesc="Base stamina level increased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLife[7]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill8',SkillName="Your health and stamina",SkillDesc="Stamina recovery speed increased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLight[0]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill17',SkillName="Your combat effectiveness against creatures of the dark",SkillDesc="Flashlight recharge speed increased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLight[1]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill18',SkillName="Your combat effectiveness against creatures of the dark",SkillDesc="Damage from flashlight increased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLight[2]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill19',SkillName="Your combat effectiveness against creatures of the dark",SkillDesc="Flashlight recharge speed increased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfLight[3]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill20',SkillName="Your combat effectiveness against creatures of the dark",SkillDesc="Damage from flashlight increased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfWarrior[0]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill9',SkillName="Your weapon abilities",SkillDesc="Reload speed increased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfWarrior[1]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill10',SkillName="Your weapon abilities",SkillDesc="Aiming spread decreased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfWarrior[2]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill11',SkillName="Your weapon abilities",SkillDesc="Reload speed increased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfWarrior[3]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill12',SkillName="Your weapon abilities",SkillDesc="Aiming spread decreased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfWarrior[4]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill13',SkillName="Your weapon abilities",SkillDesc="Rate of fire increased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfWarrior[5]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill14',SkillName="Your weapon abilities",SkillDesc="Recoil decreased",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfWarrior[6]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill15',SkillName="Your weapon abilities",SkillDesc="Rate of fire increased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    PathOfWarrior[7]=(SkillMC=none,UILoaderMC=none,Button=none,UILoader=none,SkillIcon=Texture2D'UI_AdvCommon.Textures.skill16',SkillName="Your weapon abilities",SkillDesc="Recoil decreased more!",SkillUnlockState=ESkillUnlockState.ESUS_NotReached)
    TitleString="Skill Upgrades"
    SaveString="Save Selected Upgrades"
    ResetString="Cancel Selected Upgrades"
    TreasuresColectedString="Treasures Collected:"
    TreasuresAvailabeString="Treasures Available:"
    NeedToUnlockString="More treasures needed to unlock:"
    NeedPreviousToUnlockString="Unlock previous skill to enable this one"
    UnlockedString="Unlocked"
    YouCanUnlockString="You can unlock this skill! Treasures needed:"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvSkillTree'
    bPauseGameWhileActive=true
    bDiscardNonOwnerInput=true
    bCaptureInput=true
    bHideLesserMovies=true
    SoundThemes=/* Array type was not detected. */
}