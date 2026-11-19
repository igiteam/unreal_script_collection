class AdvGFxUI_EndScreenRound extends AdvGfxMoviePlayer
    config(UI);

var GFxObject TeamMC;
var GFxObject ButtonsMC;
var GFxObject MenuMC;
var GFxObject RootMC;
var GFxObject KursorMC;
var GFxObject TextMC1;
var GFxObject TextField1;
var GFxObject TextMC2;
var GFxObject TextField2;
var const localized string RoundWinStr;
var const localized string RoundLoseStr;
var const localized string RoundStr;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    return false;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    local int PlayerTeamIndex;
    local AdvTeamInfo Winner;

    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    ButtonsMC = MenuMC.GetObject("buttons");
    KursorMC = RootMC.GetObject("kursor");
    KursorMC.SetVisible(false);
    TeamMC = MenuMC.GetObject("teamMC");
    TextMC1 = ButtonsMC.GetObject("text1MC");
    TextMC2 = ButtonsMC.GetObject("text2MC");
    TextField1 = TextMC1.GetObject("textField");
    TextField2 = TextMC2.GetObject("textField");
    TextField1.SetText(RoundStr);
    Winner = AdvGRI(GetPC().WorldInfo.GRI).RoundWinner;
    PlayerTeamIndex = GetPC().PlayerReplicationInfo.Team.TeamIndex;
    // End:0x300
    if(PlayerTeamIndex == 0)
    {
        TeamMC.GotoAndStop("red");        
    }
    else
    {
        TeamMC.GotoAndStop("blue");
    }
    // End:0x389
    if(Winner == none)
    {
        TextField2.SetText(Localize("AdvGFxUI_EndScreenMP", "DrawStr", "AdvGame"));        
    }
    else
    {
        // End:0x3E1
        if(Winner.TeamIndex == PlayerTeamIndex)
        {
            TextField2.SetText(RoundWinStr);            
        }
        else
        {
            TextField2.SetText(RoundLoseStr);
        }
    }
    PlaySoundFromTheme('open1');
    return true;
    //return ReturnValue;    
}

function EndOfMovie()
{
    AdvGFxHudWrapper(GetPC().myHUD).AdvMultiRoundEndScreenMovie = none;
    Close(true);
    //return;    
}

function CloseAnimStart()
{
    PlaySoundFromTheme('Close');
    //return;    
}

defaultproperties
{
    RoundWinStr="Point for your team!"
    RoundLoseStr="Point for enemy team!"
    RoundStr="End of round"
    MovieInfoPath="UI_AdvMultiplayerInGame.AdvEndRound"
    SoundThemes=/* Array type was not detected. */
}