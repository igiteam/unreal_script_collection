class UIScene_SelectEpisodeMenu extends UIScene_BaseFrontEnd;

var array<string> MapName;
var(Menu) array<Surface> mapTextures;
var(Menu) name mapImageName;
var transient UIImage imgMap;
var transient int ChapterUnlocked;
var transient string LockedEpisode;
var transient int IsDone;
var transient int GameExists;
var transient int DataCorrupt;
var transient bool bCheckSavedGame;

event InitScene()
{
    local int I;
    local UILabel lblGameDiff;

    super.InitScene();
    imgMap = UIImage(FindChild(mapImageName, true));
    lblGameDiff = UILabel(FindChild('lblGameDifficulty', true));
    // End:0x7B
    if(imgMap != none)
    {
        // End:0x7B
        if((CurrMenuItemIdx >= 0) && CurrMenuItemIdx < mapTextures.Length)
        {
            imgMap.SetValue(mapTextures[CurrMenuItemIdx]);
        }
    }
    // End:0x180
    if((myPC != none) && myPC.ProfileSettings != none)
    {
        ChapterUnlocked = myPC.ProfileSettings.GetChapterUnlocked();
        I = 0;
        J0xC8:

        // End:0x180 [Loop If]
        if(I < MenuItems.Length)
        {
            // End:0x176
            if(((ChapterUnlocked >> I) & 1) == 0)
            {
                // End:0x15D
                if(MenuItems[I].MenuItemUIObject != none)
                {
                    MenuItems[I].MenuItemUIObject.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                    UILabelButton(MenuItems[I].MenuItemUIObject).SetDataStoreBinding(LockedEpisode);
                }
                MenuItems[I].bDisabled = true;
            }
            I++;
            // [Loop Continue]
            goto J0xC8;
        }
    }
    // End:0x2A6
    if((myPC != none) && lblGameDiff != none)
    {
        switch(myPC.ProfileSettings.GetGameDifficulty())
        {
            // End:0x207
            case 2:
                lblGameDiff.SetDataStoreBinding("<strings:PandoraGame.HelperText.GameDifficultyHard>");
                // End:0x2A6
                break;
            // End:0x254
            case 1:
                lblGameDiff.SetDataStoreBinding("<strings:PandoraGame.HelperText.GameDifficultyEasy>");
                // End:0x2A6
                break;
            // End:0x258
            case 0:
            // End:0xFFFF
            default:
                lblGameDiff.SetDataStoreBinding("<strings:PandoraGame.HelperText.GameDifficultyNormal>");
                // End:0x2A6
                break;
                break;
        }
    }
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    super.UpdateScene(DeltaTime, WorldInfo);
    // End:0x186
    if(IsPS3Build())
    {
        // End:0x2C
        if(bCheckSavedGame)
        {
            EnableButtonDelay();
        }
        // End:0x186
        if(IsDone > 0)
        {
            IsDone = 0;
            bCheckSavedGame = false;
            // End:0xFC
            if(GameExists > 0)
            {
                // End:0xE9
                if(DataCorrupt > 0)
                {
                    ShowMsgBox("<strings:PandoraGame.ErrorMessages.ErrorLoadingGame_Message>", "<strings:PandoraGame.ErrorMessages.ErrorLoadingGame_Title>", 0);                    
                }
                else
                {
                    LoadEpisode(-1, false);
                }                
            }
            else
            {
                ShowMsgBox("<strings:PandoraGame.ErrorMessages.ErrorLoadingGame_Message>", "<strings:PandoraGame.ErrorMessages.ErrorLoadingGame_Title>", 0);
            }
        }
    }
    //return;    
}

function LoadEpisode(int MenuIndex, bool bDoLoadCheck)
{
    local string Filename;
    local bool bDoLoadEpisode;

    bDoLoadEpisode = false;
    // End:0x22
    if(MenuIndex == -1)
    {
        MenuIndex = CurrMenuItemIdx;
    }
    // End:0x1AE
    if(((LocPlayer != none) && LocPlayer.Actor != none) && MenuIndex < MapName.Length)
    {
        // End:0x14B
        if(bDoLoadCheck)
        {
            // End:0x148
            if(myPC.SPCM != none)
            {
                Filename = MapName[MenuIndex] $ ".sav";
                // End:0xBE
                if(myPC.SPCM.LoadCheckpointData(Filename))
                {
                    bDoLoadEpisode = true;                    
                }
                else
                {
                    ShowMsgBox("<strings:PandoraGame.ErrorMessages.ErrorLoadingGame_Message>", "<strings:PandoraGame.ErrorMessages.ErrorLoadingGame_Title>", 0);
                }
            }            
        }
        else
        {
            bDoLoadEpisode = true;
        }
        // End:0x1AE
        if(bDoLoadEpisode)
        {            
            LocPlayer.Actor.ConsoleCommand("open pandoragame_p?LoadChapter=" $ MapName[MenuIndex]);
        }
    }
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    local string Filename;
    local int PlayerIndex, ControllerId;

    // End:0x109
    if(((LocPlayer != none) && LocPlayer.Actor != none) && MenuIndex < MapName.Length)
    {
        // End:0xF9
        if(IsPS3Build())
        {
            // End:0xF6
            if((myPC != none) && myPC.SPCM != none)
            {
                bCheckSavedGame = true;
                EnableButtonDelay();
                PlayerIndex = myPC.GetUIPlayerIndex();
                ControllerId = Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
                Filename = MapName[MenuIndex] $ ".sav";
                myPC.SPCM.SavedGameFileExists(ControllerId, Filename, IsDone, GameExists, DataCorrupt);
            }            
        }
        else
        {
            LoadEpisode(MenuIndex, true);
        }
    }
    //return;    
}

function SetCurrentlyActivatedMenuItemToCurrentIndex()
{
    super.SetCurrentlyActivatedMenuItemToCurrentIndex();
    // End:0x49
    if(imgMap != none)
    {
        // End:0x49
        if((CurrMenuItemIdx >= 0) && CurrMenuItemIdx < mapTextures.Length)
        {
            imgMap.SetValue(mapTextures[CurrMenuItemIdx]);
        }
    }
    //return;    
}

function bool ProcessVerticalMenuInput(const out InputEventParameters EventParms)
{
    // End:0x53
    if(super.ProcessVerticalMenuInput(EventParms))
    {
        // End:0x51
        if(imgMap != none)
        {
            // End:0x51
            if((CurrMenuItemIdx >= 0) && CurrMenuItemIdx < mapTextures.Length)
            {
                imgMap.SetValue(mapTextures[CurrMenuItemIdx]);
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}
