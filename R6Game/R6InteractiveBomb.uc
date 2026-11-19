class R6InteractiveBomb extends R6InteractiveSimpleObject
    native
    config(Game)
    editinlinenew
    placeable
    hidecategories(lighting,Object);

enum EBombState
{
    EBombState_None,                // 0
    EBombState_Deactivated,         // 1
    EBombState_Activated,           // 2
    EBombState_Exploded,            // 3
    EBombState_MAX                  // 4
};

var(Bomb) /*0x40000000-0x00000000*/ R6ExplosionParams m_Explosion;
var(Bomb) repnotify float m_fBombTimer;
var(Bomb) repnotify R6InteractiveBomb.EBombState m_eBombState;
var(Bomb) bool m_bUsePostExplosionEffect;
var(Bomb) /*0x04000000-0x00000000*/ SoundCue m_SoundPostExplosion;
var(Bomb) /*0x04000000-0x00000000*/ SoundCue m_SoundBeeping;
var(Bomb) /*0x04000000-0x00000000*/ SoundCue m_SoundCriticalBeeping;
var(Bomb) /*0x04000000-0x00000000*/ SoundCue m_SoundDiffusion;
var(Bomb) /*0x04000000-0x00000000*/ SoundCue m_SoundExplosion;
var float m_fBombCurrentTime;
var MaterialInstanceConstant m_MatMinutesTens;
var MaterialInstanceConstant m_MatMinutesUnits;
var MaterialInstanceConstant m_MatSecondsTens;
var MaterialInstanceConstant m_MatSecondsUnits;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_eBombState, m_fBombTimer;
}

// Export UR6InteractiveBomb::execExplode(FFrame&, void* const)
native final function Explode();

simulated function PostBeginPlay()
{
    PostBeginPlay();
    m_fBombCurrentTime = m_fBombTimer;
    return;
}

function MatchStarting()
{
    local R6MultiPlayerGame pGameInfo;

    // End:0x2D
    if(WorldInfo.Game != none)
    {
        pGameInfo = R6MultiPlayerGame(WorldInfo.Game);
    }
    // End:0x96
    if((pGameInfo != none) && float(pGameInfo.m_iTimeLimitSeconds) > 0.0000000)
    {
        // End:0x96
        if((m_fBombTimer == 0.0000000) || m_fBombTimer > float(pGameInfo.m_iTimeLimitSeconds))
        {
            ChangeBombTimer(float(pGameInfo.m_iTimeLimitSeconds));
        }
    }
    MatchStarting();
    return;
}

function SaveOriginalData()
{
    SaveOriginalData();
    return;
}

function ResetOriginalData()
{
    m_fBombCurrentTime = m_fBombTimer;
    m_eBombState = 0;
    ResetOriginalData();
    return;
}

function ChangeBombTimer(float fTimer)
{
    m_fBombTimer = fTimer;
    m_fBombCurrentTime = m_fBombTimer;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    return;
}

function StartBombTimer()
{
    m_eBombState = 2;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    PlaySound(m_SoundBeeping, 4, true, false);
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    m_eState = 2;
    m_eBombState = 1;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    StopTickSounds();
    PlaySound(m_SoundDiffusion, 4, true, false);
    InteractSuccesful(pInteractor);
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x3F
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_eBombState = 2;
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;        
    }
    else
    {
        // End:0x7E
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_eBombState = 1;
            NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;            
        }
        else
        {
            // End:0xCF
            if(Action.InputLinks[2].bHasImpulse)
            {
                m_eBombState = ((int(m_eBombState) == int(2)) ? 1 : 2);
                NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
            }
        }
    }
    return;
}

simulated event StartExplosion(R6Explosion pExplosion)
{
    local Vector vNormal;

    vNormal.X = 0.0000000;
    vNormal.Y = 0.0000000;
    vNormal.Z = 1.0000000;
    pExplosion.InitParams(m_Explosion, vNormal, none, m_Mesh, Class'Engine.R6DmgTypeLevelExplosion');
    // End:0x8D
    if(pExplosion.m_bInit)
    {
        pExplosion.__OnExplosionFinished__Delegate = OnExplosionFinished;
        pExplosion.Explode();        
    }
    else
    {
        pExplosion.Explode();
        StopRadarSignal();
        // End:0xD7
        if(WorldInfo.Game != none)
        {
            R6GameInfo(WorldInfo.Game).Exploded(self);
        }
    }
    StopTickSounds();
    PlaySound(m_SoundExplosion, 4, true, false);
    return;
}

simulated function OnExplosionFinished(R6Explosion pExplosion)
{
    local R6PlayerController PC;

    // End:0x46
    if(m_bUsePostExplosionEffect)
    {
        // End:0x28
        foreach LocalPlayerControllers(PC)
        {
            PC.ShowWhiteFlash();            
        }        
        // End:0x46
        if(m_SoundPostExplosion != none)
        {
            PlaySound(m_SoundPostExplosion, 4, true, true);
        }
    }
    StopRadarSignal();
    // End:0x80
    if(WorldInfo.Game != none)
    {
        R6GameInfo(WorldInfo.Game).Exploded(self);
    }
    return;
}

function StopTickSounds()
{
    StopSound(m_SoundBeeping);
    StopSound(m_SoundCriticalBeeping);
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    local R6GameEnums.ETEAMIDENTITY ePlayerTeam;
    local bool bReturn;

    bReturn = GetInteractDesc(eDesc, PC);
    // End:0x83
    if(bReturn && PC != none)
    {
        ePlayerTeam = PC.GetTeamNum();
        // End:0x83
        if(((GetGameManager() != none) && int(GetGameManager().GetGameMode()) == int(1)) && int(ePlayerTeam) != int(0))
        {
            return false;
        }
    }
    return bReturn;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    local R6GameEnums.ETEAMIDENTITY ePlayerTeam;
    local bool bReturn;

    bReturn = GetBusyInteractDesc(eDesc, PC);
    // End:0x82
    if(bReturn && PC != none)
    {
        ePlayerTeam = PC.GetTeamNum();
        // End:0x82
        if(((GetGameManager() != none) && int(GetGameManager().GetGameMode()) == int(1)) && int(ePlayerTeam) != int(0))
        {
            return false;
        }
    }
    return bReturn;
    return;
}

defaultproperties
{
    m_fBombTimer=10.0000000
    m_SoundBeeping=SoundCue'Dare.O_Bombs.Play_O_Bomb_Beep'
    m_SoundCriticalBeeping=SoundCue'Dare.O_Bombs.StnGo_Bomb_CriticalPhase'
    m_SoundDiffusion=SoundCue'Dare.O_Bombs.StNGo_Bomb_Diffuse'
    m_SoundExplosion=SoundCue'Dare.O_Bombs.StnGo_Bomb_Explode'
    m_AnimNameTP="StandReadyMG_Canister_Delivery"
    m_eRadarIcon=8
    m_ActorName="Interactive BOMB"
    m_eInteractDesc=22
}