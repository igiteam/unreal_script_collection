class HUDObjective extends MOHAHUD_MP
    transient
    config(Game)
    hidecategories(Navigation);

var Texture2D ObjectiveUnarmedIcon;
var Texture2D ObjectiveAarmedIcon;
var Texture2D ObjectiveCapturePointIcon;
var const localized string RoundOverMsg;
var const localized string SingularTeamWinMsg;
var const localized string PluralTeamWinMsg;
var const localized string NextRoundBeginsMsg;
var const localized string WillSpawnNextRoundMsg;
var const localized string SpectatorModeMsg;
var const localized string FollowingMsg;
var LinearColor NeutralBackGroundColor;
var LinearColor AlliedBackGroundColor;
var LinearColor AxisBackGroundColor;
var LinearColor AlliedCaptureColor;
var LinearColor AxisCaptureColor;
var float flagSize;

function DrawHUD()
{
    super.DrawHUD();
    SetDefaultFont();
    DrawRounds();
    UpdateObjectiveStatus();
    DrawFlagStatus();
    UpdateHudVoip();
    //return;    
}

function DrawRounds()
{
    local MOHAPlayerController PC;
    local string Text;
    local int Seconds;

    Seconds = WorldInfo.GRI.RemainingTime;
    PC = MOHAPlayerController(PlayerOwner);
    // End:0x68
    if(PC != none)
    {
        SetDefaultFont();
        // End:0x58
        if(Seconds < 0)
        {
            Text = RoundOverMsg;
        }
        SetSupertitleText(Text, true);
    }
    //return;    
}

simulated function UpdateObjectiveStatus()
{
    local MOHAMultiplayerController PC;

    PC = MOHAMultiplayerController(PlayerOwner);
    // End:0x3C
    if(PC.m_ObjectiveInFocus != none)
    {
        DrawObjectiveIcon(PC.m_ObjectiveInFocus);
    }
    //return;    
}

function DrawHUDSpectator()
{
    local MOHAPlayerController PC;
    local array<string> LocalizedStringVars;

    PC = MOHAPlayerController(PlayerOwner);
    SetSupertitleText(SpectatorModeMsg);
    SetSubtitleText(WillSpawnNextRoundMsg);
    // End:0x92
    if(PC.RealViewTarget != none)
    {
        LocalizedStringVars[LocalizedStringVars.Length] = PC.RealViewTarget.PlayerName;
        SetExtraText(Class'Engine.FormattedString'.static.FormatLocalizedStringVars(FollowingMsg, LocalizedStringVars));        
    }
    else
    {
        SetExtraText("");
    }
    hud_subtitle.Render(Canvas);
    hud_supertitle.Render(Canvas);
    hud_gameText.Render(Canvas);
    //return;    
}

simulated function DrawObjectiveIcon(MPObjective ObjectiveInFocus)
{
    local MOHAMultiplayerController PC;
    local float Scale;
    local int XPos, YPos;

    Scale = Canvas.ClipX / float(1024);
    XPos = int(float(Canvas.SizeX) * 0.6250000);
    YPos = int(float(Canvas.SizeY) * 0.0500000);
    PC = MOHAMultiplayerController(PlayerOwner);
    // End:0x105
    if((int(ObjectiveInFocus.ObjectiveState) == int(0)) && ObjectiveInFocus.Team != PC.PlayerReplicationInfo.Team.TeamIndex)
    {
        DrawIcon(ObjectiveUnarmedIcon, float(XPos), float(YPos), 64.0000000 * Scale, 64.0000000 * Scale, 0.0000000, 0.0000000, 64.0000000, 64.0000000);        
    }
    else
    {
        // End:0x19F
        if((int(ObjectiveInFocus.ObjectiveState) == int(1)) && ObjectiveInFocus.Team == PC.PlayerReplicationInfo.Team.TeamIndex)
        {
            DrawIcon(ObjectiveAarmedIcon, float(XPos), float(YPos), 64.0000000 * Scale, 64.0000000 * Scale, 0.0000000, 0.0000000, 64.0000000, 64.0000000);            
        }
        else
        {
            // End:0x239
            if((int(ObjectiveInFocus.ObjectiveState) == int(3)) && ObjectiveInFocus.Team == PC.PlayerReplicationInfo.Team.TeamIndex)
            {
                DrawIcon(ObjectiveCapturePointIcon, float(XPos), float(YPos), 64.0000000 * Scale, 64.0000000 * Scale, 0.0000000, 0.0000000, 64.0000000, 64.0000000);                
            }
            else
            {
                // End:0x2D0
                if((int(ObjectiveInFocus.ObjectiveState) == int(4)) && ObjectiveInFocus.Team != PC.PlayerReplicationInfo.Team.TeamIndex)
                {
                    DrawIcon(ObjectiveCapturePointIcon, float(XPos), float(YPos), 64.0000000 * Scale, 64.0000000 * Scale, 0.0000000, 0.0000000, 64.0000000, 64.0000000);
                }
            }
        }
    }
    DrawObjectiveCountdown(PC, XPos, YPos);
    //return;    
}

function DrawObjectiveCountdown(MOHAMultiplayerController PC, int X, int Y)
{
    local string TimerText;

    // End:0x71
    if(PC.m_iObjectiveTimer > float(-1))
    {
        TimerText = "" @ string(PC.GetBombTimerLeft());
        Canvas.SetPos(float(X + 64), float(Y + 16));
        Canvas.__NFUN_465__(TimerText, true);
    }
    //return;    
}

defaultproperties
{
    ObjectiveUnarmedIcon=Texture2D'GCm_Icn_Obj_Triggers.GCm_Icn_Obj_PlantBomb'
    ObjectiveAarmedIcon=Texture2D'GCm_Icn_Obj_Triggers.GCm_Icn_Obj_DisarmBomb'
    ObjectiveCapturePointIcon=Texture2D'GCm_Icn_Obj_Triggers.GCm_Icn_Obj_CapturePoint'
    RoundOverMsg="Round Over!"
    SingularTeamWinMsg="%1 Wins!"
    PluralTeamWinMsg="%1 Win!"
    NextRoundBeginsMsg="Next round begins in %1"
    WillSpawnNextRoundMsg="You will spawn next round"
    SpectatorModeMsg="Spectator Mode"
    FollowingMsg="You are following %1"
    NeutralBackGroundColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    AlliedBackGroundColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    AxisBackGroundColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    AlliedCaptureColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    AxisCaptureColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    flagSize=64.0000000
}