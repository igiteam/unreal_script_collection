class AdvGFxUI_PauseDifficultyMenu extends AdvGFxUI_PauseMenu
    config(UI);

var AdvGFxUI_PauseMenu ParentMenu;
var string Action;

function SetupMenuButtons()
{
    local int I;

    AdvGFxHudWrapper(GetPC().myHUD).DifficultyChangeMovie = self;
    // End:0x65
    if(PauseMenuButtons.Length > 0)
    {
        PauseMenuButtons.Remove(0, PauseMenuButtons.Length);        
    }
    I = 0;
    J0x70:

    // End:0x40A [Loop If]
    if(I < 4)
    {
        PauseMenuButtons[I] = GFxClikWidget(PauseMC.GetObject("option" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        PauseMenuButtons[I].SetBool("visible", true);
        switch(byte(I))
        {
            // End:0x1DA
            case 0:
                PauseMenuButtons[I].AddEventListener('CLIK_press', OnPressDaydreamButton);
                PauseMenuButtons[I].SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(0).default.DifficultyName);
                // End:0x3FC
                break;
            // End:0x28F
            case 1:
                PauseMenuButtons[I].AddEventListener('CLIK_press', OnPressInsomniaButton);
                PauseMenuButtons[I].SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
                // End:0x3FC
                break;
            // End:0x344
            case 2:
                PauseMenuButtons[I].AddEventListener('CLIK_press', OnPressNightmareButton);
                PauseMenuButtons[I].SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(2).default.DifficultyName);
                // End:0x3FC
                break;
            // End:0x3F9
            case 3:
                PauseMenuButtons[I].AddEventListener('CLIK_press', OnPressTraumaButton);
                PauseMenuButtons[I].SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(3).default.DifficultyName);
                // End:0x3FC
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
    Class'AdvUIManager'.static.ShowUIMessage('DifficultyOptionConfirm', Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(0).default.DifficultyName, DifficultyWarningMsg, ButtonAliases, OnDifficultyOptionSelected);
    ev.Target.SetBool("focused", false);
    ev.Target.SetBool("focused", true);
    //return;    
}

function OnPressInsomniaButton(EventData ev)
{
    local array<name> ButtonAliases;

    Action = "insomnia";
    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('DifficultyOptionConfirm', Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName, DifficultyWarningMsg, ButtonAliases, OnDifficultyOptionSelected);
    ev.Target.SetBool("focused", false);
    ev.Target.SetBool("focused", true);
    //return;    
}

function OnPressNightmareButton(EventData ev)
{
    local array<name> ButtonAliases;

    Action = "nightmare";
    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('DifficultyOptionConfirm', Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(2).default.DifficultyName, DifficultyWarningMsg, ButtonAliases, OnDifficultyOptionSelected);
    ev.Target.SetBool("focused", false);
    ev.Target.SetBool("focused", true);
    //return;    
}

function OnPressTraumaButton(EventData ev)
{
    local array<name> ButtonAliases;

    Action = "trauma";
    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('DifficultyOptionConfirm', Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(3).default.DifficultyName, DifficultyWarningMsg, ButtonAliases, OnDifficultyOptionSelected);
    ev.Target.SetBool("focused", false);
    ev.Target.SetBool("focused", true);
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
    local EvilTypesNative.EDifficultyLevel DifficultyIdx;

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
        AdvPlayerController(GetPC()).SetPuzzleDifficultyLevel(DifficultyIdx);
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