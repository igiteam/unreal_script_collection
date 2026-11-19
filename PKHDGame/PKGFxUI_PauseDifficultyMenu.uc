class PKGFxUI_PauseDifficultyMenu extends PainGFxUI_PauseMenu
    config(UI);

var PainGFxUI_PauseMenu ParentMenu;
var string Action;

function SetupMenuButtons()
{
    local int I;

    PainGFxHudWrapper(GetPC().myHUD).DifficultyChangeMovie = self;
    // End:0x65
    if(PauseMenuButtons.Length > 0)
    {
        PauseMenuButtons.Remove(0, PauseMenuButtons.Length);
    }
    I = 0;
    J0x70:

    // End:0x40B [Loop If]
    if(I < 4)
    {
        PauseMenuButtons[I] = GFxClikWidget(PauseMC.GetObject("option" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        PauseMenuButtons[I].SetBool("visible", true);
        switch(byte(I))
        {
            // End:0x1C2
            case 0:
                PauseMenuButtons[I].AddEventListener('CLIK_click', OnPressDaydreamButton);
                PauseMenuButtons[I].SetString("label", Class'PKGFxUI_Menu_DifficultyMenu'.default.DaydreamString);
                // End:0x3FD
                break;
            // End:0x25F
            case 1:
                PauseMenuButtons[I].AddEventListener('CLIK_click', OnPressInsomniaButton);
                PauseMenuButtons[I].SetString("label", Class'PKGFxUI_Menu_DifficultyMenu'.default.InsomniaString);
                // End:0x3FD
                break;
            // End:0x2FC
            case 2:
                PauseMenuButtons[I].AddEventListener('CLIK_click', OnPressNightmareButton);
                PauseMenuButtons[I].SetString("label", Class'PKGFxUI_Menu_DifficultyMenu'.default.NightmareString);
                // End:0x3FD
                break;
            // End:0x3FA
            case 3:
                PauseMenuButtons[I].AddEventListener('CLIK_click', OnPressTraumaButton);
                PauseMenuButtons[I].SetString("label", Class'PKGFxUI_Menu_DifficultyMenu'.default.TraumaString);
                // End:0x3F7
                if(!PKPlayerController(GetPC()).IsTraumaUnlocked())
                {
                    PauseMenuButtons[I].SetBool("visible", false);
                }
                // End:0x3FD
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x70;
    }
    //return;    
}

function OnPressDaydreamButton(EventData ev)
{
    local array<name> ButtonAliases;

    Action = "daydream";
    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('DifficultyOptionConfirm', Class'PKGFxUI_Menu_DifficultyMenu'.default.DaydreamString, DifficultyWarningMsg, ButtonAliases, OnDifficultyOptionSelected);
    //return;    
}

function OnPressInsomniaButton(EventData ev)
{
    local array<name> ButtonAliases;

    Action = "insomnia";
    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('DifficultyOptionConfirm', Class'PKGFxUI_Menu_DifficultyMenu'.default.InsomniaString, DifficultyWarningMsg, ButtonAliases, OnDifficultyOptionSelected);
    //return;    
}

function OnPressNightmareButton(EventData ev)
{
    local array<name> ButtonAliases;

    Action = "nightmare";
    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('DifficultyOptionConfirm', Class'PKGFxUI_Menu_DifficultyMenu'.default.NightmareString, DifficultyWarningMsg, ButtonAliases, OnDifficultyOptionSelected);
    //return;    
}

function OnPressTraumaButton(EventData ev)
{
    local array<name> ButtonAliases;

    Action = "trauma";
    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('DifficultyOptionConfirm', Class'PKGFxUI_Menu_DifficultyMenu'.default.TraumaString, DifficultyWarningMsg, ButtonAliases, OnDifficultyOptionSelected);
    //return;    
}

function bool OnDifficultyOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x24
    if(SelectedInputAlias == 'GenericYes')
    {
        PlayCloseAnimation();        
    }
    else
    {
        Action = "";
    }
    return true;
    //return ReturnValue;    
}

function OnCloseAnimationComplete()
{
    local bool bChangedDifficulty;
    local float X, Y;
    local PKTypes.EDifficultyLevel DifficultyIdx;

    bChangedDifficulty = false;
    switch(Action)
    {
        // End:0x47
        case "daydream":
            DifficultyIdx = 0;
            bChangedDifficulty = true;
            // End:0xC4
            break;
        // End:0x6F
        case "insomnia":
            DifficultyIdx = 1;
            bChangedDifficulty = true;
            // End:0xC4
            break;
        // End:0x98
        case "nightmare":
            DifficultyIdx = 2;
            bChangedDifficulty = true;
            // End:0xC4
            break;
        // End:0xBE
        case "trauma":
            DifficultyIdx = 3;
            bChangedDifficulty = true;
            // End:0xC4
            break;
        // End:0xFFFF
        default:
            // End:0xC4
            break;
            break;
    }
    // End:0x103
    if(bChangedDifficulty)
    {
        PKPlayerController(GetPC()).SetDifficulty(DifficultyIdx);
    }
    // End:0x1B2
    if(ParentMenu != none)
    {
        ParentMenu.ActivatePauseScene(GetLP());
        KursorMC.GetPosition(X, Y);
        ParentMenu.KursorMC.SetPosition(X, Y);
    }
    Close(false);
    Action = "";
    //return;    
}

defaultproperties
{
    PauseMenuOptions=none
}