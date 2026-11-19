class AdvGFxUI_EndScreenMP extends AdvGfxMoviePlayer
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
var GFxObject TextMC3;
var GFxObject TextField3;
var GFxObject ScoreField3;
var GFxObject TextMC3_2;
var GFxObject TextField3_2;
var GFxObject ScoreField3_2;
var GFxObject TextMC4;
var GFxObject TextField4;
var GFxObject ScoreField4;
var GFxObject TextMC4_2;
var GFxObject TextField4_2;
var GFxObject ScoreField4_2;
var GFxObject PlayerLevelMC;
var GFxObject PlayerLevelTF;
var GFxObject PlayerXPTF;
var GFxObject PlayerTitleTF;
var GFxObject LevelMC;
var GFxObject XPmaskMC;
var const localized string WinStr;
var const localized string LoseStr;
var const localized string DrawStr;
var const localized string MatchScore;
var const localized string MatchXP;
var const localized string Bonus;
var int CurrentScore;
var int CurrentScoreBonus;
var int CurrentXP;
var int CurrentXPBonus;
var bool bScoreAnim;
var bool bXPAnim;
var transient float LastScreenRenderTime;
var export editinline AudioComponent CountingSoundLoop;
var SoundCue CountingSnd;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    return false;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    local int WinnerTeamIndex, PlayerTeamIndex;
    local Actor Winner;
    local int BonusXP, PlayerLevel, PlayerXP;
    local array<int> LevelThresholds;
    local ASDisplayInfo displayInfo;

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
    TextMC3 = ButtonsMC.GetObject("text3MC");
    TextMC3_2 = ButtonsMC.GetObject("text3_2MC");
    TextMC4 = ButtonsMC.GetObject("text4MC");
    TextMC4_2 = ButtonsMC.GetObject("text4_2MC");
    TextField3 = TextMC3.GetObject("textField");
    ScoreField3 = TextMC3.GetObject("score");
    TextField3_2 = TextMC3_2.GetObject("textField");
    ScoreField3_2 = TextMC3_2.GetObject("score");
    TextField4 = TextMC4.GetObject("textField");
    ScoreField4 = TextMC4.GetObject("score");
    TextField4_2 = TextMC4_2.GetObject("textField");
    ScoreField4_2 = TextMC4_2.GetObject("score");
    PlayerLevelMC = ButtonsMC.GetObject("playerXP");
    LevelMC = PlayerLevelMC.GetObject("levelMC");
    XPmaskMC = LevelMC.GetObject("xpmaskMC");
    PlayerLevelTF = PlayerLevelMC.GetObject("playerlevelTF");
    PlayerTitleTF = PlayerLevelMC.GetObject("nickTF");
    PlayerXPTF = PlayerLevelMC.GetObject("playerxpTF");
    TextField3.SetText(MatchScore);
    TextField3_2.SetText(Bonus);
    TextField4.SetText(MatchXP);
    TextField4_2.SetText(Bonus);
    LastScreenRenderTime = GetPC().WorldInfo.TimeSeconds;
    bScoreAnim = false;
    bXPAnim = false;
    Winner = GetPC().WorldInfo.GRI.Winner;
    BonusXP = 0;
    // End:0x8CF
    if(Winner == none)
    {
        // End:0x85E
        if(class<AdvGameTeamDeathmatchBase>(GetPC().WorldInfo.GRI.GameClass) != none)
        {
            // End:0x7E1
            if(PlayerTeamIndex == 0)
            {
                TextField1.SetText(Localize("AdvGFxUI_Menu_MultiPause", "MercStr", "AdvGame"));
                TeamMC.GotoAndStop("red");                
            }
            else
            {
                TextField1.SetText(Localize("AdvGFxUI_Menu_MultiPause", "AdvStr", "AdvGame"));
                TeamMC.GotoAndStop("blue");
            }            
        }
        else
        {
            TextField1.SetVisible(false);
            TeamMC.GotoAndStop("blue");
        }
        TextField2.SetText(DrawStr);        
    }
    else
    {
        // End:0xB92
        if(AdvTeamInfo(Winner) != none)
        {
            WinnerTeamIndex = AdvTeamInfo(Winner).TeamIndex;
            PlayerTeamIndex = GetPC().PlayerReplicationInfo.Team.TeamIndex;
            // End:0x9F7
            if(PlayerTeamIndex == 0)
            {
                TextField1.SetText(Localize("AdvGFxUI_Menu_MultiPause", "MercStr", "AdvGame"));
                TeamMC.GotoAndStop("red");                
            }
            else
            {
                TextField1.SetText(Localize("AdvGFxUI_Menu_MultiPause", "AdvStr", "AdvGame"));
                TeamMC.GotoAndStop("blue");
            }
            // End:0xB66
            if(PlayerTeamIndex == WinnerTeamIndex)
            {
                TextField2.SetText(WinStr);
                // End:0xB63
                if(AdvGRI(GetPC().WorldInfo.GRI).CanWriteStats())
                {
                    BonusXP = AdvGRI(GetPC().WorldInfo.GRI).XPForWin;
                }                
            }
            else
            {
                TextField2.SetText(LoseStr);
            }            
        }
        else
        {
            // End:0xD8E
            if(AdvPRI(Winner) != none)
            {
                TeamMC.GotoAndStop("blue");
                TextField1.SetVisible(false);
                // End:0xD65
                if((GetPC().PlayerReplicationInfo == AdvPRI(Winner)) || GetPC().PlayerReplicationInfo.Score == AdvPRI(Winner).Score)
                {
                    TextField2.SetText(WinStr);
                    // End:0xD62
                    if(AdvGRI(GetPC().WorldInfo.GRI).CanWriteStats())
                    {
                        BonusXP = AdvGRI(GetPC().WorldInfo.GRI).XPForWin;
                    }                    
                }
                else
                {
                    TextField2.SetText(LoseStr);
                }
            }
        }
    }
    // End:0xFA1
    if(AdvPRI(GetPC().PlayerReplicationInfo) != none)
    {
        CurrentScore = int(AdvPRI(GetPC().PlayerReplicationInfo).Score - float(AdvPRI(GetPC().PlayerReplicationInfo).BonusScore));
        CurrentScoreBonus = AdvPRI(GetPC().PlayerReplicationInfo).BonusScore;
        ScoreField3.SetText(string(CurrentScore));
        ScoreField3_2.SetText(string(CurrentScoreBonus));
        CurrentXP = AdvPRI(GetPC().PlayerReplicationInfo).XP - BonusXP;
        CurrentXPBonus = BonusXP;
        ScoreField4.SetText(string(CurrentXP));
        ScoreField4_2.SetText(string(CurrentXPBonus));        
    }
    else
    {
        TextMC3.SetVisible(false);
        TextMC3_2.SetVisible(false);
        TextMC4.SetVisible(false);
        TextMC4_2.SetVisible(false);
    }
    // End:0x1479
    if(AdvPRI(GetPC().PlayerReplicationInfo) != none)
    {
        AdvPlayerController(GetPC()).ProfileSettings.GetProfileSettingValueInt(36, PlayerXP);
        PlayerLevel = Class'AdvPRI'.static.CalculatePlayerLevel(PlayerXP);
        LevelThresholds = Class'AdvClassInfo_MP_Base'.default.LevelThresholds;
        displayInfo.hasXScale = true;
        // End:0x11A2
        if(PlayerLevel < LevelThresholds.Length)
        {
            displayInfo.XScale = (float(PlayerXP - LevelThresholds[PlayerLevel - 1]) / float(LevelThresholds[PlayerLevel] - LevelThresholds[PlayerLevel - 1])) * 100.0000000;            
        }
        else
        {
            displayInfo.XScale = 100.0000000;
        }
        XPmaskMC.SetDisplayInfo(displayInfo);
        PlayerLevelTF.SetText(((Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerLevelStr", "ADVGame"), "`l", string(PlayerLevel)) @ " [") @ (Localize("AdvGFxUI_Menu_MultiPlayerSettings", ("PlayerLevelString[" $ string(Class'AdvGFxUI_Menu_MultiPlayerSettings'.static.GetRankGroupNumber(PlayerLevel))) $ "]", "ADVGame"))) @ "]");
        PlayerTitleTF.SetText(GetPC().PlayerReplicationInfo.PlayerName);
        // End:0x13E5
        if(Class'AdvClassInfo_MP_Base'.default.LevelThresholds.Length == PlayerLevel)
        {
            PlayerXPTF.SetText(Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerXPStr", "ADVGame"), "`x", string(PlayerXP)));            
        }
        else
        {
            PlayerXPTF.SetText((Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerXPStr", "ADVGame"), "`x", string(PlayerXP)) @ "/") @ string(LevelThresholds[PlayerLevel]));
        }        
    }
    else
    {
        PlayerLevelMC.SetVisible(false);
    }
    CountingSoundLoop = GetPC().CreateAudioComponent(CountingSnd, false, true);
    // End:0x1501
    if(CountingSoundLoop != none)
    {
        CountingSoundLoop.bAllowSpatialization = false;
    }
    PlaySoundFromTheme('open2');
    return true;
    //return ReturnValue;    
}

function EndOfMovie()
{
    // End:0x62
    if(CountingSoundLoop != none)
    {
        GetPC().DetachComponent(CountingSoundLoop);
        CountingSoundLoop.Stop();
        CountingSoundLoop = none;
    }
    Close(true);
    AdvGFxHudWrapper(GetPC().myHUD).AdvMultiEndScreenMovie = none;
    //return;    
}

function CloseAnimStart()
{
    PlaySoundFromTheme('Close');
    //return;    
}

function PlayerLevelShow()
{
    PlaySoundFromTheme('Level');
    //return;    
}

function Text3Start()
{
    PlaySoundFromTheme('Score');
    //return;    
}

function Text3Done()
{
    // End:0x53
    if(CurrentScoreBonus > 0)
    {
        bScoreAnim = true;
        // End:0x53
        if(CountingSoundLoop != none)
        {
            CountingSoundLoop.FadeIn(0.0100000, 1.0000000);
        }
    }
    //return;    
}

function Text4Start()
{
    PlaySoundFromTheme('XP');
    //return;    
}

function Text4Done()
{
    // End:0x64
    if(CurrentXPBonus > 0)
    {
        bXPAnim = true;
        // End:0x64
        if(!bScoreAnim && CountingSoundLoop != none)
        {
            CountingSoundLoop.FadeIn(0.0100000, 1.0000000);
        }
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local float dt;
    local AdvPRI PRI;

    dt = GetPC().WorldInfo.TimeSeconds - LastScreenRenderTime;
    PRI = AdvPRI(GetPC().PlayerReplicationInfo);
    // End:0x393
    if(PRI != none)
    {
        // End:0x219
        if(bScoreAnim)
        {
            CurrentScore += int(dt * float(700));
            CurrentScoreBonus -= int(dt * float(700));
            // End:0x15F
            if(float(CurrentScore) < PRI.Score)
            {
                ScoreField3.SetText(string(CurrentScore));
                ScoreField3_2.SetText(string(Max(CurrentScoreBonus, 0)));                
            }
            else
            {
                ScoreField3.SetText(string(int(PRI.Score)));
                ScoreField3_2.SetText("0");
                bScoreAnim = false;
                // End:0x219
                if(!bXPAnim && CountingSoundLoop != none)
                {
                    CountingSoundLoop.FadeOut(0.0500000, 0.0000000);
                }
            }
        }
        // End:0x393
        if(bXPAnim)
        {
            CurrentXP += int(dt * float(700));
            CurrentXPBonus -= int(dt * float(700));
            // End:0x2EC
            if(CurrentXP < PRI.XP)
            {
                ScoreField4.SetText(string(CurrentXP));
                ScoreField4_2.SetText(string(Max(CurrentXPBonus, 0)));                
            }
            else
            {
                ScoreField4.SetText(string(PRI.XP));
                ScoreField4_2.SetText("0");
                bXPAnim = false;
                // End:0x393
                if(CountingSoundLoop != none)
                {
                    CountingSoundLoop.FadeOut(0.0500000, 0.0000000);
                }
            }
        }
    }
    LastScreenRenderTime = GetPC().WorldInfo.TimeSeconds;
    super(UTGFxTweenableMoviePlayer).Tick(DeltaTime);
    //return;    
}

defaultproperties
{
    WinStr="You win!"
    LoseStr="You lose!"
    DrawStr="Draw!"
    MatchScore="Match Score"
    MatchXP="Match XP"
    Bonus="Bonus"
    CountingSnd=SoundCue'a_Accents.Cue.a_ScoreLoop'
    MovieInfoPath="UI_AdvMultiplayerInGame.AdvEndMatch"
    SoundThemes=/* Array type was not detected. */
}