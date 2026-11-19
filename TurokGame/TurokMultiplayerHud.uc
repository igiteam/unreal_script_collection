class TurokMultiplayerHud extends TurokHud
    abstract
    transient
    native
    config(Game)
    hidecategories(Navigation);

const DEFAULT_GUTTER = 10;

struct Dimension
{
    var float Width;
    var float Height;

    structdefaultproperties
    {
        Width=0.0000000
        Height=0.0000000
    }
};

var protected config int mSecondsRemainingWarningLimit;
var protected config bool mDrawDebugMPHUD;
var protected config bool mDrawDebugCommentaryHUD;
var protected bool mDrawMissionInfo;
var protected bool mDrawWinLossText;
var bool mMedSecSpeechEnabled;
var bool mLowSecSpeechEnabled;
var bool m60SecsSpeechEnabled;
var bool m30SecsSpeechEnabled;
var protected @NULL mHudScoreboard;
var protected @NULL mTargetIcon;
var protected @NULL mCommentaryText;
var protected @NULL mLivesRemaining;
var protected @NULL mWinLossText;
var protected @NULL mConnectionLost360;
var protected @NULL mConnectionLost360_2;
var protected @NULL mConnectionLostPS3;
var protected @NULL mConnectionLostPS3_2;
var protected @NULL mSpectatorBG;
var protected @NULL mSpectatorXboxButtonL;
var protected @NULL mSpectatorXboxButtonR;
var protected @NULL mSpectatorPS3ButtonL;
var protected @NULL mSpectatorPS3ButtonR;
var protected @NULL mSpectatorFont;
var protected @NULL mSpectatorGamerTagFont;
var protected float mSpectatorGamerTagScale;
var protected int mSpectatorXboxButtonLOffset;
var protected int mSpectatorXboxButtonROffset;
var protected int mSpectatorXboxButtonTextOffset;
var protected int mSpectatorPS3ButtonLOffset;
var protected int mSpectatorPS3ButtonROffset;
var protected int mSpectatorPS3ButtonTextOffset;
var protected int mSpectatorYOffset;
var @NULL mOwnerLocation;
var @NULL mOwnerRotation;

// Export UTurokMultiplayerHud::execDisplayBadConnectionAlert(FFrame&, void* const)
native function DisplayBadConnectionAlert();

// Export UTurokMultiplayerHud::execDrawSpectatorHud(FFrame&, void* const)
native function DrawSpectatorHud();

// Export UTurokMultiplayerHud::execDrawDebugGameInfo(FFrame&, void* const)
native final function DrawDebugGameInfo();

// Export UTurokMultiplayerHud::execDrawDebugHealth(FFrame&, void* const)
native final function DrawDebugHealth();

event PostBeginPlay()
{
    super.PostBeginPlay();
    mHudScoreboard = new (self) Class'TurokHudScoreboard';
    mLivesRemaining = new (self) Class'TurokHudLivesRemaining';
    mWinLossText = new (self) Class'TurokHudWinLossText';
    mHudScoreboard.Init(self);
    mLivesRemaining.Init(self);
    mWinLossText.Init(self);
    mTargetIcon = new Class'TurokHudTargetIcon';
    mCommentaryText = new Class'TurokHudCommentaryText';
    mCommentaryText.Init(self);
    Reset();
    //return;    
}

event Destroyed()
{
    mHudScoreboard = none;
    mLivesRemaining = none;
    mWinLossText = none;
    mTargetIcon = none;
    mCommentaryText = none;
    super.Destroyed();
    //return;    
}

function Reset()
{
    mHudScoreboard.Reset();
    mLivesRemaining.Reset();
    mTargetIcon.Clear();
    mCommentaryText.Reset();
    mDrawMissionInfo = default.mDrawMissionInfo;
    mMedSecSpeechEnabled = default.mMedSecSpeechEnabled;
    mLowSecSpeechEnabled = default.mLowSecSpeechEnabled;
    m60SecsSpeechEnabled = default.m60SecsSpeechEnabled;
    m30SecsSpeechEnabled = default.m30SecsSpeechEnabled;
    //return;    
}

function AddMessage(@NULL Message)
{
    super.AddMessage(Message);
    mCommentaryText.AddTurokLocalizedMessage(Message);
    //return;    
}

event PostRender()
{
    super(HUD).PostRender();
    // End:0x24
    if(mSoundController != none)
    {
        mSoundController.TickQueuedSounds();
    }
    //return;    
}

function DrawHUD()
{
    super.DrawHUD();
    // End:0x7E
    if(TurokMPGameReplicationInfo(WorldInfo.GRI) != none)
    {
        // End:0x69
        if(TurokMPPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo) != none)
        {
            DrawMultiplayerHUD();
            // End:0x69
            if(mDrawDebugMPHUD)
            {
                DrawDebugPing();
                DrawDebugNetMovement();
                DrawDebugPawnInfo();
            }
        }
        // End:0x7E
        if(mDrawDebugMPHUD)
        {
            DrawDebugGameInfo();
            DrawDebugHealth();
        }
    }
    //return;    
}

event DrawEndOfGameHudElements()
{
    super(HUD).DrawEndOfGameHudElements();
    // End:0x22
    if(mDrawWinLossText)
    {
        mWinLossText.Draw();
    }
    //return;    
}

event DrawEndOfRoundHudElements()
{
    super(HUD).DrawEndOfRoundHudElements();
    // End:0x22
    if(mDrawWinLossText)
    {
        mWinLossText.Draw();
    }
    //return;    
}

protected function DrawMultiplayerHUD()
{
    local int killModifiers;
    local class<Class> DamageType, mFlagStolenMessage;

    PlayerOwner.GetPlayerViewPoint(mOwnerLocation, mOwnerRotation);
    // End:0x123
    if(mDrawDebugCommentaryHUD)
    {
        DamageType = Class'TurokDamageTypeSniper';
        mFlagStolenMessage = Class'TurokTestMessage';
        killModifiers = 0;
        BroadcastLocalizedMessage(Class'TurokDeathMessage', killModifiers, none, PlayerOwner.PlayerReplicationInfo, DamageType);
        BroadcastLocalizedMessage(Class'TurokDeathMessage', killModifiers, none, PlayerOwner.PlayerReplicationInfo, DamageType);
        BroadcastLocalizedMessage(Class'TurokDeathMessage', killModifiers, none, PlayerOwner.PlayerReplicationInfo, DamageType);
        BroadcastLocalizedMessage(Class'TurokDeathMessage', killModifiers, none, PlayerOwner.PlayerReplicationInfo, DamageType);
        BroadcastLocalizedMessage(mFlagStolenMessage, 0, PlayerOwner.PlayerReplicationInfo, none, none);
        BroadcastLocalizedMessage(mFlagStolenMessage, 0, PlayerOwner.PlayerReplicationInfo, none, none);
    }
    mCommentaryText.Draw();
    // End:0x16D
    if((mPawnOwner != none) && mPawnOwner.Health > 0)
    {
        // End:0x16D
        if(mbShowStatsScreen == false)
        {
            DrawTargetIcon();
        }
    }
    // End:0x1DE
    if(((WorldInfo.GRI != none) && WorldInfo.GRI.bMatchHasBegun == true) && WorldInfo.GRI.bMatchIsOver == false)
    {
        mLivesRemaining.Draw();
        DrawTurokHudScoreboard();
    }
    // End:0x1F1
    if(mDrawMissionInfo)
    {
        DrawMissionInfo();
    }
    // End:0x20D
    if(mDrawWinLossText)
    {
        mWinLossText.Draw();
    }
    // End:0x232
    if((IsSpectating()) && mbShowStatsScreen == false)
    {
        DrawSpectatorHud();
    }
    DrawStatsScoreboard();
    //return;    
}

protected function DrawTurokHudScoreboard()
{
    // End:0x1E
    if(mHudScoreboard != none)
    {
        mHudScoreboard.Draw();
    }
    //return;    
}

function DisplayProgressMessage()
{
    // End:0x3C
    if((Class'Engine.Engine'.static.GetTurokNet() == none) || Class'Engine.Engine'.static.GetTurokNet().GetLobby() == none)
    {
        super(HUD).DisplayProgressMessage();
    }
    //return;    
}

protected function DrawMissionInfo()
{
    local @NULL GRI, mi;
    local int nameHashID, TextHashID;

    mDrawMissionInfo = false;
    GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
    // End:0x9D
    if(GRI != none)
    {
        mi = GRI.GetMissionInfo();
        // End:0x9D
        if(mi != none)
        {
            // End:0x9D
            if(mi.GetObjectiveStrings(int(PlayerOwner.GetTeamNum()), nameHashID, TextHashID))
            {
                mObjectiveText.InitObjText(TextHashID);
            }
        }
    }
    //return;    
}

function DrawWinLossInfo(bool GameOver)
{
    local @NULL GRI, mi;

    mDrawWinLossText = true;
    mWinLossText.Initialize();
    GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
    // End:0x58
    if(GRI != none)
    {
        mi = GRI.GetMissionInfo();
    }
    // End:0x78
    if(mi == none)
    {
        // End:0x77
        foreach AllActors(Class'TurokMPMissionInfo', mi)
        {
            // End:0x77
            break;            
        }        
    }
    // End:0xB7
    if(mi != none)
    {
        mi.CommunicateWinLossInfo(GameOver, int(PlayerOwner.GetTeamNum()), self, mWinLossText);
    }
    //return;    
}

function HideWinLossInfo(optional bool RestoreColorCube = false)
{
    mDrawWinLossText = false;
    // End:0x29
    if(RestoreColorCube)
    {
        mWinLossText.RestoreColorCube();
    }
    mWinLossText.Teardown();
    //return;    
}

function ShowObjectiveLocator()
{
    local @NULL mi;
    local int nameHashID, TextHashID;
    local @NULL GRI;

    GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
    // End:0x95
    if(GRI != none)
    {
        mi = GRI.GetMissionInfo();
        // End:0x95
        if(mi != none)
        {
            // End:0x95
            if(mi.GetObjectiveStrings(int(PlayerOwner.GetTeamNum()), nameHashID, TextHashID))
            {
                mObjectiveText.InitObjText(TextHashID);
            }
        }
    }
    //return;    
}

protected function DrawTargetIcon()
{
    local @NULL TargetPawn;

    TargetPawn = TurokPawnHuman(TurokPlayerController(PlayerOwner).mAimAssistTarget);
    // End:0xD8
    if((((mPawnOwner == none) || mPawnOwner.bDeleteMe) || ((TargetPawn == none) || TargetPawn.bDeleteMe) || TargetPawn.PlayerReplicationInfo == none) || (int(mPawnOwner.GetTeamNum()) != 255) && int(mPawnOwner.GetTeamNum()) == int(TargetPawn.GetTeamNum()))
    {
        mTargetIcon.Clear();
        return;
    }
    // End:0x13B
    if(TargetPawn != mTargetIcon.GetTarget())
    {
        // End:0x13B
        if(!mTargetIcon.Init(self, TargetPawn, TurokMPGameReplicationInfo(WorldInfo.GRI)))
        {
            mTargetIcon.Clear();
            return;
        }
    }
    // End:0x17A
    if(mTargetIcon.GetTarget() != none)
    {
        mTargetIcon.Update();
        mTargetIcon.Draw();
    }
    //return;    
}

function DisplayConsoleMessages()
{
    local int I;
    local @NULL messageOrigin, messageOffset;

    messageOrigin.X = Canvas.ClipX * 0.1000000;
    messageOrigin.Y = Canvas.ClipY * 0.7500000;
    Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
    // End:0xAF
    if(ConsoleMessages.Length > 0)
    {
        Canvas.__NFUN_464__(ConsoleMessages[0].Text, messageOffset.Width, messageOffset.Height);
    }
    I = 0;
    J0xB6:

    // End:0x195 [Loop If]
    if(I < ConsoleMessages.Length)
    {
        // End:0x18B
        if(ConsoleMessages[I].MessageLife > WorldInfo.TimeSeconds)
        {
            Canvas.DrawColor = ConsoleMessages[I].TextColor;
            Canvas.SetPos(messageOrigin.X, messageOrigin.Y);
            Canvas.__NFUN_465__(ConsoleMessages[I].Text);
            messageOrigin.Y -= (messageOffset.Height + float(10 / 2));
        }
        I++;
        // [Loop Continue]
        goto J0xB6;
    }
    //return;    
}

exec function ToggleDebugMPHUD()
{
    mDrawDebugMPHUD = !mDrawDebugMPHUD;
    //return;    
}

exec function ToggleDebugCommentary()
{
    mDrawDebugCommentaryHUD = !mDrawDebugCommentaryHUD;
    //return;    
}

protected function DrawDebugPing()
{
    local string pingString;
    local @NULL gameHost;

    Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    pingString = ("Ping:" $ string(int((float(PlayerOwner.PlayerReplicationInfo.Ping) / 250.0000000) * 1000.0000000))) $ " ms";
    Canvas.SetPos(Canvas.ClipX * 0.8000000, 10.0000000);
    Canvas.__NFUN_465__(pingString);
    // End:0x162
    if((Class'Engine.Engine'.static.GetTurokNet() != none) && Class'Engine.Engine'.static.GetTurokNet().GetLobby() != none)
    {
        Class'Engine.Engine'.static.GetTurokNet().GetLobby().GetOnlineGameHost(gameHost);
        Canvas.SetPos(Canvas.ClipX * 0.8000000, 25.0000000);
        Canvas.__NFUN_465__("Host:" $ gameHost.NickName);
    }
    //return;    
}

protected function DrawDebugNetMovement()
{
    local @NULL TPC;
    local int NetErrors;

    TPC = TurokPlayerController(PlayerOwner);
    // End:0xC8
    if(TPC != none)
    {
        NetErrors = TPC.GetNetErrorCount();
        // End:0xC8
        if(NetErrors != 0)
        {
            Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
            Canvas.SetDrawColor(byte(255), 128, 128);
            Canvas.SetPos(float(Canvas.SizeX) * 0.7500000, 300.0000000);
            Canvas.__NFUN_465__("Net Move Errors:" $ string(NetErrors));
        }
    }
    //return;    
}

protected function DrawDebugLives()
{
    local string lifeString;

    // End:0x176
    if(WorldInfo.GRI.MaxLives != 0)
    {
        switch(PlayerOwner.PlayerReplicationInfo.NumLives)
        {
            // End:0x54
            case 0:
                Canvas.SetDrawColor(128, 128, 128, 128);
                // End:0xC0
                break;
            // End:0x76
            case 1:
                Canvas.SetDrawColor(byte(255), 0, 0, byte(255));
                // End:0xC0
                break;
            // End:0x9B
            case 2:
                Canvas.SetDrawColor(byte(255), byte(255), 0, byte(255));
                // End:0xC0
                break;
            // End:0xFFFF
            default:
                Canvas.SetDrawColor(byte(255), byte(255), byte(255), byte(255));
                // End:0xC0
                break;
                break;
        }
        lifeString = (("Lives:" @ string(PlayerOwner.PlayerReplicationInfo.NumLives)) @ "/") @ string(WorldInfo.GRI.MaxLives);
        Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
        Canvas.SetPos(float(Canvas.SizeX) * 0.0750000, float(Canvas.SizeY) * 0.1500000);
        Canvas.__NFUN_465__(lifeString);
    }
    //return;    
}

protected function DrawDebugPawnInfo()
{
    local @NULL TP;
    local int NumPlayers, NumAIHumans, NumAICreatures;

    NumPlayers = 0;
    NumAIHumans = 0;
    NumAICreatures = 0;
    // End:0x9D
    foreach WorldInfo.AllPawns(Class'TurokPawn', TP)
    {
        // End:0x61
        if((TP.Health <= 0) || TP.IsDying())
        {
            continue;            
        }
        // End:0x7B
        if(TurokPawnPlayer(TP) != none)
        {
            ++NumPlayers;
            // End:0x9C
            continue;
        }
        // End:0x95
        if(TurokPawnHuman(TP) != none)
        {
            ++NumAIHumans;
            // End:0x9C
            continue;
        }
        ++NumAICreatures;        
    }    
    Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
    Canvas.SetDrawColor(byte(255), byte(255), byte(255), byte(255));
    Canvas.SetPos(5.0000000, 25.0000000);
    Canvas.__NFUN_465__("Players:" @ string(NumPlayers));
    Canvas.SetPos(5.0000000, 40.0000000);
    Canvas.__NFUN_465__("AI-Creatures:" @ string(NumAICreatures));
    Canvas.SetPos(5.0000000, 55.0000000);
    Canvas.__NFUN_465__("AI-Humans:" @ string(NumAIHumans));
    //return;    
}

defaultproperties
{
    mDrawMissionInfo=true
    mMedSecSpeechEnabled=true
    mLowSecSpeechEnabled=true
    m60SecsSpeechEnabled=true
    m30SecsSpeechEnabled=true
    mConnectionLost360=Texture2D'TurokHudMultiplayer.MPHUDIcon_BadConnection_360_HD'
    mConnectionLost360_2=Texture2D'TurokHudMultiplayer.MPHUDIcon_BadConnection_360_2_HD'
    mConnectionLostPS3=Texture2D'TurokHudMultiplayer.MPHUDIcon_BadConnection_PS3_HD'
    mConnectionLostPS3_2=Texture2D'TurokHudMultiplayer.MPHUDIcon_BadConnection_PS3_2_HD'
    mSpectatorBG=Texture2D'TurokHudMultiplayer.Spectator_BG'
    mSpectatorXboxButtonL=Texture2D'TurokHudMultiplayer.Trigger_LT_HD_Eng'
    mSpectatorXboxButtonR=Texture2D'TurokHudMultiplayer.Trigger_RT_HD_Eng'
    mSpectatorPS3ButtonL=Texture2D'TurokHudMultiplayer.PS3_L2_1_HD_Eng'
    mSpectatorPS3ButtonR=Texture2D'TurokHudMultiplayer.PS3_R2_1_HD_Eng'
    mSpectatorFont=TurokFont'TurokFontsNew.TurokConduitTCBold'
    mSpectatorGamerTagFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mSpectatorGamerTagScale=0.3280000
    mSpectatorXboxButtonLOffset=-31
    mSpectatorXboxButtonROffset=64
    mSpectatorXboxButtonTextOffset=29
    mSpectatorPS3ButtonLOffset=-20
    mSpectatorPS3ButtonROffset=64
    mSpectatorPS3ButtonTextOffset=46
    mSpectatorYOffset=-46
    // Reference: TurokSoundController'Default__TurokMultiplayerHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    Components[0]=TurokSoundControllerComponent
}