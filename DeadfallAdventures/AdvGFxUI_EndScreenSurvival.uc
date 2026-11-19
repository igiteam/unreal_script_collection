class AdvGFxUI_EndScreenSurvival extends AdvGfxMoviePlayer
    config(UI);

var GFxObject RankMC;
var GFxObject ButtonsMC;
var GFxObject MenuMC;
var GFxObject RootMC;
var GFxObject KursorMC;
var GFxObject TextMC;
var GFxObject TextField1;
var GFxObject TextField2;
var GFxObject ScoreField;
var const localized string PlayingTimeStr;
var const localized string ScoreStr;
var const localized string MummiesKilledStr;
var const localized string TreetersKilledStr;
var const localized string BossesKilledStr;
var const localized string TrapKillsStr;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    return false;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    local array<PlayerReplicationInfo> PRIArray;
    local PlayerReplicationInfo PRI;
    local int I;

    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    ButtonsMC = MenuMC.GetObject("buttons");
    RankMC = MenuMC.GetObject("rankMC");
    KursorMC = RootMC.GetObject("kursor");
    KursorMC.SetVisible(false);
    TextMC = ButtonsMC.GetObject("text1MC");
    TextField1 = TextMC.GetObject("textField");
    TextField2 = TextMC.GetObject("textField2");
    TextField1.SetText(PlayingTimeStr);
    TextField2.SetText(Class'AdvGFxUI_Scoreboard'.static.FormatTime(GetPC().WorldInfo.GRI.ElapsedTime));
    TextMC = ButtonsMC.GetObject("text2MC");
    TextField1 = TextMC.GetObject("textField");
    TextField2 = TextMC.GetObject("textField2");
    TextField1.SetText(ScoreStr);
    TextField2.SetText(string(int(GetPC().PlayerReplicationInfo.Score)));
    TextMC = ButtonsMC.GetObject("text3MC");
    TextField1 = TextMC.GetObject("textField");
    TextField2 = TextMC.GetObject("textField2");
    TextField1.SetText(MummiesKilledStr);
    TextField2.SetText(string(AdvPRI(GetPC().PlayerReplicationInfo).SurvivalMummiesKilledStat));
    TextMC = ButtonsMC.GetObject("text4MC");
    TextField1 = TextMC.GetObject("textField");
    TextField2 = TextMC.GetObject("textField2");
    TextField1.SetText(TreetersKilledStr);
    TextField2.SetText(string(AdvPRI(GetPC().PlayerReplicationInfo).SurvivalTreetersKilledStat));
    TextMC = ButtonsMC.GetObject("text5MC");
    TextField1 = TextMC.GetObject("textField");
    TextField2 = TextMC.GetObject("textField2");
    TextField1.SetText(BossesKilledStr);
    TextField2.SetText(string(AdvPRI(GetPC().PlayerReplicationInfo).SurvivalBossesKilledStat));
    TextMC = ButtonsMC.GetObject("text6MC");
    TextField1 = TextMC.GetObject("textField");
    TextField2 = TextMC.GetObject("textField2");
    TextField1.SetText(TrapKillsStr);
    TextField2.SetText(string(AdvPRI(GetPC().PlayerReplicationInfo).SurvivalTrapKillsStat));
    // End:0x896
    foreach GetPC().WorldInfo.GRI.PRIArray(PRI)
    {
        PRIArray.AddItem(PRI);                
    }    
    PRIArray.Sort(ComparePRIByScore);    
    I = 1;
    J0x8C0:

    // End:0xC31 [Loop If]
    if(I < 5)
    {
        TextMC = RankMC.GetObject("player" $ string(I));
        TextField1 = TextMC.GetObject("textField");
        ScoreField = TextMC.GetObject("score");
        // End:0xBDF
        if(PRIArray.Length >= I)
        {
            // End:0xB42
            if(PRIArray[I - 1].PlayerName == GetPC().PlayerReplicationInfo.PlayerName)
            {
                TextField1.SetBool("html", true);
                TextField1.SetString("htmlText", ("<Color:R=1.0,G=0.6,B=0.15>" $ PRIArray[I - 1].PlayerName) $ "</Color>");
                ScoreField.SetBool("html", true);
                ScoreField.SetString("htmlText", ("<Color:R=1.0,G=0.6,B=0.15>" $ string(int(PRIArray[I - 1].Score))) $ "</Color>");                
            }
            else
            {
                TextField1.SetText(PRIArray[I - 1].PlayerName);
                ScoreField.SetText(string(int(PRIArray[I - 1].Score)));
            }            
        }
        else
        {
            TextField1.SetText("");
            ScoreField.SetText("");
        }
        I++;
        // [Loop Continue]
        goto J0x8C0;
    }
    PlaySoundFromTheme('open1');
    return true;
    //return ReturnValue;    
}

function int ComparePRIByScore(PlayerReplicationInfo A, PlayerReplicationInfo B)
{
    // End:0x46
    if(A.Score == B.Score)
    {
        return 0;        
    }
    else
    {
        // End:0x8C
        if(A.Score > B.Score)
        {
            return 1;            
        }
        else
        {
            return -1;
        }
    }
    //return ReturnValue;    
}

function EndOfMovie()
{
    Close(true);
    AdvGFxHudWrapper(GetPC().myHUD).AdvSurvivalEndScreenMovie = none;
    //return;    
}

function CloseAnimStart()
{
    PlaySoundFromTheme('Close');
    //return;    
}

defaultproperties
{
    PlayingTimeStr="Play time:"
    ScoreStr="Score:"
    MummiesKilledStr="Mummies killed:"
    TreetersKilledStr="Daru killed:"
    BossesKilledStr="Bosses killed:"
    TrapKillsStr="Trap kills:"
    MovieInfoPath="UI_AdvMultiplayerInGame.AdvEndMatchSurvival"
    SoundThemes=/* Array type was not detected. */
}