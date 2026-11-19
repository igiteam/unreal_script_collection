class AirborneTeamGameInfo extends TeamGameInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var array<MultiplayerCinematicActor> CinematicITPActors;
var array<MOHATeamPlayerStart> OrderedITPSpawnPoints;
var int OrderedITPSpawnPointIndex;
var int CurrentPlaneIndex;
var int CurrentITPMeshIndex;
var bool bAllowInAirReswpawns;
var bool bPlayingInitialCinematic;
var int NumberOfSeatsInPlane;

function RequestRespawn(MOHAMultiplayerController mpc)
{
    //return;    
}

function PostBeginPlay()
{
    local MultiplayerCinematicActor MCA;
    local MOHATeamPlayerStart PS;
    local int I, J;

    super(MOHAMultiplayerGameInfo).PostBeginPlay();
    // End:0x29
    foreach DynamicActors(Class'MultiplayerCinematicActor', MCA)
    {
        CinematicITPActors[CinematicITPActors.Length] = MCA;        
    }    
    I = 0;
    J0x31:

    // End:0xD1 [Loop If]
    if(I < CinematicITPActors.Length)
    {
        J = 0;
        J0x48:

        // End:0xC7 [Loop If]
        if(J < I)
        {
            // End:0xBD
            if(CinematicITPActors[I].iCinematicActorNumber < CinematicITPActors[J].iCinematicActorNumber)
            {
                MCA = CinematicITPActors[I];
                CinematicITPActors[I] = CinematicITPActors[J];
                CinematicITPActors[J] = MCA;
            }
            ++J;
            // [Loop Continue]
            goto J0x48;
        }
        ++I;
        // [Loop Continue]
        goto J0x31;
    }
    // End:0x11A
    foreach DynamicActors(Class'MOHATeamPlayerStart', PS)
    {
        // End:0x119
        if(PS.bInAirSpawnPoint)
        {
            m_iAirborneTeamIndex = PS.OwnerTeam;
            OrderedITPSpawnPoints[OrderedITPSpawnPoints.Length] = PS;
        }        
    }    
    I = 0;
    J0x122:

    // End:0x1C2 [Loop If]
    if(I < OrderedITPSpawnPoints.Length)
    {
        J = 0;
        J0x139:

        // End:0x1B8 [Loop If]
        if(J < I)
        {
            // End:0x1AE
            if(OrderedITPSpawnPoints[I].ITPSpawnScore > OrderedITPSpawnPoints[J].ITPSpawnScore)
            {
                PS = OrderedITPSpawnPoints[I];
                OrderedITPSpawnPoints[I] = OrderedITPSpawnPoints[J];
                OrderedITPSpawnPoints[J] = PS;
            }
            ++J;
            // [Loop Continue]
            goto J0x139;
        }
        ++I;
        // [Loop Continue]
        goto J0x122;
    }
    //return;    
}

function bool CanRespawn(MOHAPlayerController C)
{
    return false;
    //return ReturnValue;    
}

function bool CheckIfTeamEliminated()
{
    return false;
    //return ReturnValue;    
}

function Reset()
{
    super(MOHAMultiplayerGameInfo).Reset();
    RespawnTimer = SecondsBetweenRespawn;
    //return;    
}

function StartMatch()
{
    super(GameInfo).StartMatch();
    //return;    
}

exec function RestartServer()
{
    local int I;
    local MOHAPlayerPlane_MP mpPlane;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x76
    if(((((P != none) && P.GetGame() != none) && !bPlayerCreatedUnrankedMatch) && !bCanRestartRankedServer) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        return;
    }
    I = 0;
    J0x7D:

    // End:0xB0 [Loop If]
    if(I < CinematicITPActors.Length)
    {
        CinematicITPActors[I].ResetMultiplayerCinematicActor();
        ++I;
        // [Loop Continue]
        goto J0x7D;
    }
    // End:0xD1
    foreach DynamicActors(Class'MOHAPlayerPlane_MP', mpPlane)
    {
        mpPlane.SetHidden(false);        
    }    
    bPlayingInitialCinematic = true;
    super(MOHAMultiplayerGameInfo).RestartServer();
    //return;    
}

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam)
{
    return super(GameInfo).ChoosePlayerStart(Player, InTeam);
    //return ReturnValue;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    return super.RatePlayerStart(P, Team, Player);
    //return ReturnValue;    
}

function bool GameModeFilteredOutThisPlayerStart(PlayerStart P, byte Team, Controller Player)
{
    return false;
    //return ReturnValue;    
}

function Timer()
{
    // End:0x14
    if(m_iAirborneTeamIndex != 255)
    {
        RespawnTimer = 5;
    }
    super(MOHAMultiplayerGameInfo).Timer();
    //return;    
}

function bool RequestInAirRespawn(MOHAMultiplayerController Controller)
{
    local bool bDidSpawn;

    bDidSpawn = false;
    // End:0x16B
    if(bAllowInAirReswpawns && Controller.IsSpectating() || Controller.IsInState('DeadWaitingForRespawn'))
    {
        // End:0x16B
        if(m_iAirborneTeamIndex == Controller.PlayerReplicationInfo.Team.TeamIndex)
        {
            // End:0x16B
            if(CinematicITPActors[CurrentPlaneIndex] != none)
            {
                // End:0x16B
                if(CinematicITPActors[CurrentPlaneIndex].IsInState('PlayingCinematic'))
                {
                    Controller.SetITPMeshIndices(CurrentPlaneIndex, CurrentITPMeshIndex);
                    MOHAPlayerReplicationInfo(Controller.PlayerReplicationInfo).SetITPMeshIndices(CurrentPlaneIndex, CurrentITPMeshIndex);
                    Controller.GotoState('PlayingITPCinematic');
                    Controller.ClientGotoState('PlayingITPCinematic');
                    CurrentITPMeshIndex++;
                    // End:0x152
                    if(CurrentITPMeshIndex >= NumberOfSeatsInPlane)
                    {
                        Controller.bOverPlaneSpawnLimit = true;
                        CurrentITPMeshIndex = NumberOfSeatsInPlane - 1;                        
                    }
                    else
                    {
                        Controller.bOverPlaneSpawnLimit = false;
                    }
                    bDidSpawn = true;
                }
            }
        }
    }
    return bDidSpawn;
    //return ReturnValue;    
}

event RespawnAllDead(SeqAct_RespawnAllDead.ERespawnAllDeadType RespawnAllDeadType)
{
    local MOHAMultiplayerController P;

    OrderedITPSpawnPointIndex = -1;
    CurrentITPMeshIndex = 0;
    // End:0x33
    if(MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus == 0)
    {
        bPlayingInitialCinematic = false;
    }
    // End:0x300
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
    {
        // End:0x2FF
        if((P.IsSpectating() || P.IsInState('DeadWaitingForRespawn')) && !P.IsInState('WeaponSelect'))
        {
            // End:0x27B
            if(m_iAirborneTeamIndex == P.PlayerReplicationInfo.Team.TeamIndex)
            {
                // End:0xDB
                if(int(RespawnAllDeadType) == int(1))
                {
                    continue;                    
                }
                P.m_bInWaitingState = false;
                // End:0x267
                if((bAllowInAirReswpawns && CinematicITPActors[CurrentPlaneIndex] != none) && CinematicITPActors[CurrentPlaneIndex].IsInState('PlayingCinematic'))
                {
                    // End:0x180
                    if((int(RespawnAllDeadType) != int(3)) && P.bOverPlaneSpawnLimit == true)
                    {
                        P.PlayerReplicationInfo.bOutOfLives = false;
                        P.ServerPreReStartPlayer();                        
                    }
                    else
                    {
                        // End:0x1D0
                        if(CurrentITPMeshIndex >= NumberOfSeatsInPlane)
                        {
                            P.bOverPlaneSpawnLimit = true;
                            P.PlayerReplicationInfo.bOutOfLives = false;
                            P.ServerPreReStartPlayerAndWait();                            
                        }
                        else
                        {
                            P.SetITPMeshIndices(CurrentPlaneIndex, CurrentITPMeshIndex);
                            MOHAPlayerReplicationInfo(P.PlayerReplicationInfo).SetITPMeshIndices(CurrentPlaneIndex, CurrentITPMeshIndex);
                            P.GotoState('PlayingITPCinematic');
                            P.ClientGotoState('PlayingITPCinematic');
                            CurrentITPMeshIndex++;
                            P.bOverPlaneSpawnLimit = false;
                        }
                    }                    
                }
                else
                {
                    P.m_bInWaitingState = true;
                }
                // End:0x2FF
                continue;
            }
            // End:0x292
            if(int(RespawnAllDeadType) == int(2))
            {
                continue;                
                // End:0x2FF
                continue;
            }
            // End:0x2D2
            if(int(RespawnAllDeadType) == int(3))
            {
                P.PlayerReplicationInfo.bOutOfLives = false;
                P.ServerPreReStartPlayerAndWait();
                // End:0x2FF
                continue;
            }
            P.PlayerReplicationInfo.bOutOfLives = false;
            P.ServerPreReStartPlayer();
        }        
    }    
    //return;    
}

function RestartPlayer(Controller NewPlayer)
{
    super(MOHAMultiplayerGameInfo).RestartPlayer(NewPlayer);
    // End:0xDF
    if(NewPlayer.Pawn != none)
    {
        // End:0xC5
        if(m_iAirborneTeamIndex == NewPlayer.PlayerReplicationInfo.Team.TeamIndex)
        {
            MOHAMultiplayerPawn(NewPlayer.Pawn).AirDrop_DeployChuteEvent();
            MOHAPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).SetITPMeshIndices(-1, 0);
            NewPlayer.GotoState('AirDropDeployChute');
            MOHAMultiplayerController(NewPlayer).ClientSetSpawnInAir(0);            
        }
        else
        {
            MOHAMultiplayerController(NewPlayer).ClientSetSpawnInAir(1);
        }
    }
    //return;    
}

function RestartITPPlayer(MOHAMultiplayerController ITPPlayer)
{
    local int PlaneNum, SeatNum;
    local Vector PawnLoc;
    local Rotator PawnRot;

    // End:0x1B
    if(ITPPlayer.IsInState('RoundEnded'))
    {
        return;
    }
    RestartPlayer(ITPPlayer);
    // End:0x41
    if(ITPPlayer.bOverPlaneSpawnLimit == true)
    {
        return;
    }
    PlaneNum = ITPPlayer.m_iCinematicActorIndex;
    SeatNum = ITPPlayer.m_iCinematicActorMeshIndex;
    // End:0x1D5
    if((ITPPlayer.Pawn != none) && CinematicITPActors[PlaneNum] != none)
    {
        PawnLoc = CinematicITPActors[PlaneNum].Meshes[SeatNum].GetBoneLocation('Root', 0);
        PawnRot = QuatToRotator(CinematicITPActors[PlaneNum].Meshes[SeatNum].GetBoneQuaternion('Root'));
        PawnRot.Yaw += 32768;
        PawnRot.Roll = 0;
        PawnRot.Pitch = 0;
        // End:0x1A3
        if(!ITPPlayer.Pawn.SetLocation(PawnLoc))
        {
            ITPPlayer.Pawn.bCollideWorld = false;
            ITPPlayer.Pawn.SetLocation(PawnLoc);
            ITPPlayer.Pawn.bCollideWorld = true;
        }
        ITPPlayer.Pawn.SetRotation(PawnRot);
        ITPPlayer.SetClientRotation(PawnRot);
    }
    ITPPlayer.ClientRespawn();
    //return;    
}

function NewPlane(int PlaneNumber)
{
    CurrentPlaneIndex = int(float(PlaneNumber) % float(CinematicITPActors.Length));
    CurrentITPMeshIndex = 0;
    OrderedITPSpawnPointIndex = -1;
    //return;    
}

function int GetCurrentPlaneIndex()
{
    return CurrentPlaneIndex;
    //return ReturnValue;    
}

function int GetCurrentITPMeshIndex()
{
    return CurrentITPMeshIndex;
    //return ReturnValue;    
}

function AllowInAirSpawns(bool B)
{
    bAllowInAirReswpawns = B;
    //return;    
}

state RoundOver
{
    function RestartRound()
    {
        local Controller P;
        local MOHAPlayerPlane_MP mpPlane;
        local int I;

        super.RestartRound();
        // End:0x3D
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            P.PlayerReplicationInfo.bOutOfLives = true;            
        }        
        I = 0;
        J0x45:

        // End:0x78 [Loop If]
        if(I < CinematicITPActors.Length)
        {
            CinematicITPActors[I].ResetMultiplayerCinematicActor();
            ++I;
            // [Loop Continue]
            goto J0x45;
        }
        bPlayingInitialCinematic = true;
        // End:0xA1
        foreach DynamicActors(Class'MOHAPlayerPlane_MP', mpPlane)
        {
            mpPlane.SetHidden(false);            
        }        
        GameReplicationInfo.RemainingTime = 60 * TimeLimit;
        GameReplicationInfo.ElapsedTime = 0;
        MOHAGameReplicationInfo(GameReplicationInfo).ResetRoundStartTime();
        MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus = 3;
        //return;        
    }
    stop;    
}

defaultproperties
{
    OrderedITPSpawnPointIndex=-1
    bAllowInAirReswpawns=true
    bPlayingInitialCinematic=true
    NumberOfSeatsInPlane=6
    m_bUseDelayedRespawns=true
    m_iAirborneTeamIndex=0
    ScoreBoardType=Class'MOHAScoreboard_AB'
}