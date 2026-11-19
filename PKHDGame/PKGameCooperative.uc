class PKGameCooperative extends PKGameSP
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var config int NumberOfSoulsToRespawn;
var config float TimeToRespawn;
var config float SoulTakeTimeReductionToRespawn;

function InitGameReplicationInfo()
{
    super.InitGameReplicationInfo();
    PainGRI_SP(GameReplicationInfo).TimeToRespawnInCOOP = TimeToRespawn;
    //return;    
}

function PlayStartupMessage()
{
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    local PKPlayerController PC;

    super.PostLogin(NewPlayer);
    // End:0xA9
    if((WorldInfo.Pauser != none) && !NewPlayer.IsSplitscreenPlayer())
    {
        PC = PKPlayerController(NewPlayer);
        // End:0xA9
        if(PC != none)
        {
            PC.ClientUpdateHostPause(true);
        }
    }
    //return;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return false;
    //return ReturnValue;    
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local PlayerController PC;

    PC = super(PKGame).Login(Portal, Options, UniqueId, ErrorMessage);
    return PC;
    //return ReturnValue;    
}

function bool ShouldSpawnAtStartSpot(Controller Player)
{
    return false;
    //return ReturnValue;    
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local class<Pawn> DefaultPlayerClass;
    local Rotator StartRotation;
    local Pawn ResultPawn;

    // End:0x35
    if(PlayerController(NewPlayer) == none)
    {
        return super(GameInfo).SpawnDefaultPawnFor(NewPlayer, StartSpot);
    }
    DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);
    StartRotation.Yaw = StartSpot.Rotation.Yaw;
    ResultPawn = Spawn(DefaultPlayerClass,,, StartSpot.Location, StartRotation,, true);
    // End:0xF7
    if(ResultPawn == none)
    {
    }
    return ResultPawn;
    //return ReturnValue;    
}

function RestartPlayer(Controller NewPlayer)
{
    local PKPlayerController NewPC, InGamePC, IterPC;
    local int PlayersNum;
    local bool bGameAlreadyStarted;
    local Vector ValidSpawnLoc;
    local array<SequenceObject> Events;
    local SeqEvent_CoopPlayerSpawned SpawnedEvent;
    local int Idx;

    super.RestartPlayer(NewPlayer);
    NewPC = PKPlayerController(NewPlayer);
    // End:0x99
    foreach WorldInfo.AllControllers(Class'PKPlayerController', IterPC)
    {
        // End:0x8D
        if(NewPC != IterPC)
        {
            InGamePC = IterPC;
        }
        PlayersNum++;        
    }    
    bGameAlreadyStarted = PlayersNum > 1;
    // End:0x1EB
    if(bGameAlreadyStarted && WorldInfo.GetGameSequence() != none)
    {
        WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_CoopPlayerSpawned', true, Events);
        Idx = 0;
        J0x138:

        // End:0x1EB [Loop If]
        if(Idx < Events.Length)
        {
            SpawnedEvent = SeqEvent_CoopPlayerSpawned(Events[Idx]);
            // End:0x1DD
            if((SpawnedEvent != none) && SpawnedEvent.CheckActivate(NewPlayer, NewPlayer))
            {
                SpawnedEvent.PopulateLinkedVariableValues();
            }
            Idx++;
            // [Loop Continue]
            goto J0x138;
        }
    }
    // End:0x399
    if((NewPC.Pawn != none) && NewPC.bRespawnInGhostMode)
    {
        NewPC.bRespawnInGhostMode = false;
        // End:0x2C6
        if(!NewPC.bDeathLocationNotValid)
        {
            NewPC.Pawn.SetLocation(NewPC.Location);            
        }
        else
        {
            // End:0x34A
            if(bGameAlreadyStarted && GetValidSpawnLocationNearPawn(ValidSpawnLoc, InGamePC.Pawn, 150.0000000, 600.0000000))
            {
                NewPC.Pawn.SetLocation(ValidSpawnLoc);
            }
        }
        NewPC.GotoState('CoopGhost');
        NewPC.ClientGotoState('CoopGhost');        
    }
    else
    {
        // End:0x52C
        if((InGamePC != none) && InGamePC.Pawn != none)
        {
            // End:0x52C
            if(bGameAlreadyStarted)
            {
                // End:0x450
                if(GetValidSpawnLocationNearPawn(ValidSpawnLoc, InGamePC.Pawn, 150.0000000, 600.0000000))
                {
                    NewPC.Pawn.SetLocation(ValidSpawnLoc);
                }
                // End:0x52C
                if(InGamePC.bCinematicMode && !NewPC.bCinematicMode)
                {
                    NewPC.SetCinematicMode(true, InGamePC.Pawn.bHidden, true, InGamePC.bCinemaDisableInputMove, InGamePC.bCinemaDisableInputLook, true);
                }
            }
        }
    }
    NewPC.bDeathLocationNotValid = false;
    //return;    
}

event Tick(float DeltaTime)
{
    local PKPlayerController PC;

    super(Actor).Tick(DeltaTime);
    // End:0xDC
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        // End:0xDB
        if(PC.TimeRemainingInGhost > float(0))
        {
            PC.TimeRemainingInGhost -= DeltaTime;
            // End:0xDB
            if(PC.TimeRemainingInGhost <= float(0))
            {
                PC.RespawnInSamePlace();
            }
        }        
    }    
    //return;    
}

event Broadcast(Actor Sender, coerce string msg, optional name Type)
{
    // End:0x7C
    if(((Type != 'Say') && Type != 'TeamSay') || !Class'Engine.Engine'.static.IsSplitScreen())
    {
        super(GameInfo).Broadcast(Sender, msg, Type);
    }
    //return;    
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
    // End:0x7C
    if(((Type != 'Say') && Type != 'TeamSay') || !Class'Engine.Engine'.static.IsSplitScreen())
    {
        super(GameInfo).BroadcastTeam(Sender, msg, Type);
    }
    //return;    
}

function UpdateGameplayMuteList(PlayerController PC)
{
    local PKPlayerController OtherPC;

    // End:0xF0
    foreach WorldInfo.AllControllers(Class'PKPlayerController', OtherPC)
    {
        // End:0xEF
        if(OtherPC != PC)
        {
            PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
            OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
        }        
    }    
    super(EvilGame).UpdateGameplayMuteList(PC);
    //return;    
}

defaultproperties
{
    TimeToRespawn=20.0000000
    SoulTakeTimeReductionToRespawn=4.0000000
    bSpawnSkeletons=true
    NetWait=0
    MaxPlayersAllowed=2
    GameName="Cooperative"
    OnlineGameSettingsClass=Class'PKGameCoopSettings'
}