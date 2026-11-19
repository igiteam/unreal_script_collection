class TurokTeamGameHud extends TurokMultiplayerHud
    abstract
    transient
    native
    config(Game)
    hidecategories(Navigation);

const ICON_MAX_PLAYERS = 16;

var protected config int mTeamIconDistanceFeet;
var protected @NULL mTeamIconBlock[16];
var protected @NULL mTeamIconPool;
var protected @NULL mTeammateIcons;
var protected @NULL mTeamNotification;
var protected bool mShowTeamNotification;
var protected bool mShowObjectiveLocator;
var bool mGameStartSpeechEnabled;
var bool mTeamLivesSpeechEnabled;

// Export UTurokTeamGameHud::execSetAllIndicatorsDrawableState(FFrame&, void* const)
native function SetAllIndicatorsDrawableState(bool bDrawable);

// Export UTurokTeamGameHud::execSquelchObjectiveIndicatorAndText(FFrame&, void* const)
native function SquelchObjectiveIndicatorAndText();

// Export UTurokTeamGameHud::execDrawTeammateIcons(FFrame&, void* const)
protected native function DrawTeammateIcons();

// Export UTurokTeamGameHud::execClearTeamIcons(FFrame&, void* const)
protected native function ClearTeamIcons();

// Export UTurokTeamGameHud::execGetFreeIcon(FFrame&, void* const)
private native final function @NULL GetFreeIcon();

// Export UTurokTeamGameHud::execFreeIcon(FFrame&, void* const)
private native final function FreeIcon(@NULL Icon);

// Export UTurokTeamGameHud::execShouldRenderTarget(FFrame&, void* const)
private native final function bool ShouldRenderTarget(@NULL TargetPawn, float MaxRangeSquared);

exec function ToggleLocatorState()
{
    local @NULL Icon;

    Icon = mTeammateIcons;
    J0x0B:

    // End:0x40 [Loop If]
    if(Icon != none)
    {
        Icon.ToggleLocatorState();
        Icon = Icon.mNext;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

exec function SetTeamIconDistance(int DistanceFeet)
{
    mTeamIconDistanceFeet = DistanceFeet;
    //return;    
}

event PostBeginPlay()
{
    mTeamNotification = new (self) Class'TurokHudTeamNotification';
    mTeamNotification.Init(self);
    CreateTeamIcons();
    ClearTeamIcons();
    super.PostBeginPlay();
    //return;    
}

event Destroyed()
{
    mTeamNotification = none;
    ClearTeamIcons();
    super.Destroyed();
    //return;    
}

function NotifyViewTargetChanged()
{
    ClearTeamIcons();
    //return;    
}

function ResetHUD()
{
    HideObjectiveLocator();
    super(TurokHud).ResetHUD();
    //return;    
}

function Reset()
{
    mGameStartSpeechEnabled = default.mGameStartSpeechEnabled;
    mTeamLivesSpeechEnabled = default.mTeamLivesSpeechEnabled;
    mTeamNotification.Reset();
    HideObjectiveLocator();
    super.Reset();
    //return;    
}

protected function DrawMultiplayerHUD()
{
    local @NULL GRI;

    GRI = TurokTeamGameReplicationInfo(WorldInfo.GRI);
    // End:0x84
    if((((GRI == none) || TurokTeamInfo(GRI.Teams[0]) == none) || TurokTeamInfo(GRI.Teams[1]) == none) || TurokTeamInfo(PlayerOwner.PlayerReplicationInfo.Team) == none)
    {
        return;
    }
    // End:0xA5
    if(mPawnOwner != none)
    {
        // End:0xA5
        if(mbShowStatsScreen == false)
        {
            DrawTeammateIcons();
        }
    }
    super.DrawMultiplayerHUD();
    // End:0xF1
    if(mShowTeamNotification)
    {
        mTeamNotification.ShowTeamNotification(int(PlayerOwner.PlayerReplicationInfo.Team.TeamIndex));
        mShowTeamNotification = false;
    }
    mTeamNotification.Draw();
    // End:0x146
    if((mPawnOwner != none) && mPawnOwner.Health > 0)
    {
        // End:0x146
        if(mShowObjectiveLocator && mbShowStatsScreen == false)
        {
            DrawObjectiveLocators();
        }
    }
    // End:0x1A7
    if(mGameStartSpeechEnabled)
    {
        // End:0x19F
        if(GRI.GetMissionInfo() != none)
        {
            GRI.GetMissionInfo().PlayGameStartSpeech(int(PlayerOwner.GetTeamNum()), self);
        }
        mGameStartSpeechEnabled = false;
    }
    //return;    
}

protected function DrawObjectiveLocators()
{
    local int I;
    local @NULL GRI;

    GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
    I = 0;
    J0x20:

    // End:0xA7 [Loop If]
    if(I < GRI.mIndicatorsNum)
    {
        // End:0x9D
        if((GRI.mIndicators[I] != none) && GRI.mIndicators[I].CanDraw(self))
        {
            GRI.mIndicators[I].Draw(self);
        }
        ++I;
        // [Loop Continue]
        goto J0x20;
    }
    //return;    
}

function TimeObjectiveLocator()
{
    mShowObjectiveLocator = false;
    //return;    
}

function ShowObjectiveLocator()
{
    local int I;
    local @NULL GRI;

    GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
    // End:0xDF
    if(GRI != none)
    {
        I = 0;
        J0x2B:

        // End:0xDF [Loop If]
        if(I < GRI.mIndicatorsNum)
        {
            // End:0xD5
            if((GRI.mIndicators[I] != none) && GRI.mIndicators[I].CanDraw(self))
            {
                ClearTimer('TimeObjectiveLocator');
                SetTimer(11.0000000, false, 'TimeObjectiveLocator');
                GRI.mIndicators[I].DrawInitialize();
                mShowObjectiveLocator = true;
                // [Explicit Break]
                goto J0xDF;
            }
            ++I;
            // [Loop Continue]
            goto J0x2B;
        }
    }
    J0xDF:

    super.ShowObjectiveLocator();
    //return;    
}

function HideObjectiveLocator()
{
    ClearTimer('TimeObjectiveLocator');
    mShowObjectiveLocator = false;
    //return;    
}

protected function DrawDebugTeamLives()
{
    local string lifeString;
    local @NULL TGRI;

    TGRI = TurokTeamGameReplicationInfo(WorldInfo.GRI);
    // End:0xCE
    if(TGRI.mMaxTeamLives != 0)
    {
        lifeString = (("TeamLives:" @ string(TurokTeamInfo(PlayerOwner.PlayerReplicationInfo.Team).mNumLives)) @ "/") @ string(TGRI.mMaxTeamLives);
        Canvas.SetPos(float(Canvas.SizeX) * 0.0750000, float(Canvas.SizeY) * 0.1500000);
        Canvas.__NFUN_465__(lifeString);
    }
    //return;    
}

protected function DrawDebugTeamIndicators()
{
    local @NULL P, BoxExtent, TeamColor;

    BoxExtent.X = 20.0000000;
    BoxExtent.Y = 20.0000000;
    BoxExtent.Z = 20.0000000;
    // End:0x12B
    foreach WorldInfo.AllPawns(Class'TurokPawnPlayer', P)
    {
        TeamColor = MakeColor(byte(255), byte(255), byte(255), byte(255));
        // End:0xDA
        if((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team != none)
        {
            TeamColor = TurokTeamInfo(P.PlayerReplicationInfo.Team).GetTeamColor();
        }
        P.DrawDebugBox(P.Location, BoxExtent, TeamColor.R, TeamColor.G, TeamColor.B, false);        
    }    
    //return;    
}

protected function CreateTeamIcons()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x33 [Loop If]
    if(I < 16)
    {
        mTeamIconBlock[I] = new Class'TurokHudTargetIcon';
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

defaultproperties
{
    mShowTeamNotification=true
    mGameStartSpeechEnabled=true
    mTeamLivesSpeechEnabled=true
    // Reference: TurokSoundController'Default__TurokTeamGameHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    Components[0]=TurokSoundControllerComponent
}