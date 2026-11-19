class AdvPreGameLobbyPRI extends AdvPartyPRI
    hidecategories(Navigation,Movement,Collision);

var bool bRequestedTeamChange;
var bool bLobbySceneOpened;
var bool bSubmittedMapVote;
var bool bSubmittedGameVote;
var bool bReady;
var int LastCheckedTeamNum;
//var delegate<OnPlayerMessage> __OnPlayerMessage__Delegate;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty || bNetInitial
        bReady, bRequestedTeamChange;
}

delegate OnPlayerMessage(string PName, string PlayerMessage)
{
    //return;    
}

reliable server function SetReadyToStartMatch(bool bSet)
{
    local AdvPreGameGRI GRI;

    GRI = AdvPreGameGRI(WorldInfo.GRI);
    // End:0xC0
    if(GRI != none)
    {
        switch(GRI.PreGameLobbyState)
        {
            // End:0x6D
            case 1:
            // End:0x72
            case 2:
            // End:0x77
            case 3:
            // End:0xBD
            case 4:
                bReady = bSet;
                ForceNetRelevant();
                GRI.PlayerReady();
                // End:0xC0
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

reliable client simulated function PlayerMessageReceived(string PName, string PlayerMessage)
{
    OnPlayerMessage(PName, PlayerMessage);
    //return;    
}

simulated function SendPlayerMessage(string PlayerMessage)
{
    SendPlayerMessageServer(PlayerMessage);
    //return;    
}

protected reliable server function SendPlayerMessageServer(string PlayerMessage)
{
    local AdvPreGameGRI PartyGRI;

    PartyGRI = AdvPreGameGRI(WorldInfo.GRI);
    // End:0x71
    if(PartyGRI != none)
    {
        PartyGRI.SendPlayerMessageServer(PlayerName, PlayerMessage);
    }
    //return;    
}

simulated function SubmitGameVote(AdvPreGameGRI.EVoteLobby VoteType)
{
    // End:0x2E
    if(!bSubmittedGameVote)
    {
        bSubmittedGameVote = true;
        ServerSubmitGameVote(VoteType);
    }
    //return;    
}

protected reliable server function ServerSubmitGameVote(AdvPreGameGRI.EVoteLobby VoteType)
{
    local AdvPreGameGRI PartyGRI;

    PartyGRI = AdvPreGameGRI(WorldInfo.GRI);
    // End:0x69
    if(PartyGRI != none)
    {
        PartyGRI.SubmitGameVote(self, VoteType);
    }
    //return;    
}

reliable server function ServerNotifyLobbySceneOpened()
{
    bLobbySceneOpened = true;
    //return;    
}

function OverrideWith(PlayerReplicationInfo PRI)
{
    local AdvPreGameLobbyPRI LobbyPRI;

    super(EvilPlayerReplicationInfo).OverrideWith(PRI);
    LobbyPRI = AdvPreGameLobbyPRI(PRI);
    // End:0x68
    if(LobbyPRI != none)
    {
        bLobbySceneOpened = LobbyPRI.bLobbySceneOpened;
    }
    //return;    
}

function bool IsFullyInitialized()
{
    local UniqueNetId ZeroId;

    return bLobbySceneOpened && UniqueId != ZeroId;
    //return ReturnValue;    
}

simulated function UnregisterPlayerFromSession()
{
    UnregisterPlayerFromParty();
    //return;    
}

simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    LastCheckedTeamNum=255
    NetUpdateFrequency=100.0000000
}