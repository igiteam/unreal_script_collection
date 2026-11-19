class R6InteractiveSimpleObject extends R6InteractiveActor
    native
    config(Game)
    placeable
    hidecategories(lighting);

var() /*0x10000000-0x00000000*/ name m_AnimNameFP;
var() /*0x10000000-0x00000000*/ name m_AnimNameTP;
var() bool m_bLoopAnim;
var() bool m_bMoveToInteract;
var(Radar) bool m_bAutoStartSignal;
var() float m_fInteractingTime;
var() Vector m_vInteractPlace;
var() Rotator m_rInteractRot;
var(TeamGame) R6GameEnums.ETEAMIDENTITY m_eAllowedInteractTeam;
var R6Radar.ERadarIcon m_eRadarIcon;
var R6RadarObjectiveRepInfo m_pRadarInfo;
var float m_fInteractCounter;
var float m_fRepInteractCounter;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_eAllowedInteractTeam, m_fRepInteractCounter;
}

simulated function bool BlocksView()
{
    return HasFPAnim();
    return;
}

// Export UR6InteractiveSimpleObject::execHasFPAnim(FFrame&, void* const)
native final function bool HasFPAnim();

function MatchStarting()
{
    MatchStarting();
    // End:0x17
    if(m_bAutoStartSignal)
    {
        StartRadarSignal();
    }
    return;
}

function SaveOriginalData()
{
    SaveOriginalData();
    return;
}

function ResetOriginalData()
{
    m_fInteractCounter = 0.0000000;
    StopRadarSignal();
    ResetOriginalData();
    return;
}

simulated event byte GetTeamNum()
{
    return m_eAllowedInteractTeam;
    return;
}

simulated function byte GetRadarIcon()
{
    return m_eRadarIcon;
    return;
}

function EnableRadarDetection(bool bEnable)
{
    m_bAutoStartSignal = bEnable;
    return;
}

function StartRadarSignal()
{
    // End:0x12
    if(int(Role) != int(ROLE_Authority))
    {
        return;
    }
    // End:0x42
    if(m_pRadarInfo == none)
    {
        m_pRadarInfo = __NFUN_278__(Class'R6RadarObjectiveRepInfo');
        m_pRadarInfo.Init(self);
    }
    return;
}

function StopRadarSignal()
{
    // End:0x12
    if(int(Role) != int(ROLE_Authority))
    {
        return;
    }
    // End:0x30
    if(m_pRadarInfo != none)
    {
        m_pRadarInfo.Destroy();
        m_pRadarInfo = none;
    }
    return;
}

defaultproperties
{
    m_eAllowedInteractTeam=2
    m_eRadarIcon=7
    m_ActorName="Simple Object"
    m_eType=2
    SupportedEvents=/* Array type was not detected. */
}