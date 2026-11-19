class MOHAVoip extends Object
    transient;

enum VoipMode
{
    VOIPMODE_NONE,                  // 0
    VOIPMODE_ALL,                   // 1
    VOIPMODE_TEAM,                  // 2
    VOIPMODE_PROXIMITY,             // 3
    VOIPMODE_MAX                    // 4
};

var MOHAVoip.VoipMode mode;
var bool enemyFilter;
var bool sixthSense;
var private PlasmaSymmVoIPGroup Everyone;
var private PlasmaSymmVoIPGroup LiveAxis;
var private PlasmaSymmVoIPGroup LiveAllies;
var private PlasmaSymmVoIPGroup DeadAxis;
var private PlasmaSymmVoIPGroup DeadAllies;
var private Plasma P;

function Init()
{
    P = Class'Plasma.Plasma'.static.GetPlasma();
    //return;    
}

function GameStartup(MOHAVoip.VoipMode M, bool Filter, bool deadSpeak)
{
    local PlasmaGameVoIPManager vm;
    local MOHAPlayerReplicationInfo Who;

    // End:0x1A
    if(!P.IsHosting())
    {
        return;
    }
    mode = M;
    enemyFilter = Filter;
    sixthSense = deadSpeak;
    // End:0x54
    if(int(M) == int(1))
    {
        return;        
    }
    else
    {
        // End:0x84
        if((P == none) || P.GetHostedGame() == none)
        {
            mode = 0;
            return;
        }
    }
    vm = P.GetHostedGame().GetVoIPManager();
    Everyone = vm.GetDefaultSymmVoIpGroup();
    Everyone.DisableGroup();
    // End:0xE9
    if(int(M) == int(0))
    {
        return;
    }
    LiveAxis = vm.CreateSymmVoIpGroup();
    LiveAxis.SetDebugName("LiveAxis");
    LiveAxis.DisableGroup();
    LiveAllies = vm.CreateSymmVoIpGroup();
    LiveAllies.SetDebugName("LiveAllies");
    LiveAllies.DisableGroup();
    // End:0x21C
    if(!sixthSense)
    {
        DeadAxis = vm.CreateSymmVoIpGroup();
        DeadAxis.SetDebugName("DeadAxis");
        DeadAxis.DisableGroup();
        DeadAllies = vm.CreateSymmVoIpGroup();
        DeadAllies.SetDebugName("DeadAllies");
        DeadAllies.DisableGroup();
    }
    // End:0x24F
    foreach Class'Engine.Engine'.static.GetCurrentWorldInfo().DynamicActors(Class'MOHAPlayerReplicationInfo', Who)
    {
        PlayerJoins(Who);        
    }    
    //return;    
}

function PlayerJoins(MOHAPlayerReplicationInfo Who)
{
    local PlasmaPlayerRef playa;

    // End:0x24
    if((int(mode) == int(1)) || int(mode) == int(0))
    {
        return;
    }
    // End:0x3E
    if(!P.IsHosting())
    {
        return;
    }
    playa = Who.GetPlasmaPlayerRef();
    // End:0xB3
    if(sixthSense)
    {
        // End:0x98
        if(Who.Team.TeamIndex == 0)
        {
            LiveAllies.AddMember(playa);            
        }
        else
        {
            LiveAxis.AddMember(playa);
        }        
    }
    else
    {
        // End:0xEB
        if(Who.Team.TeamIndex == 0)
        {
            DeadAllies.AddMember(playa);            
        }
        else
        {
            DeadAxis.AddMember(playa);
        }
    }
    //return;    
}

function RoundStarts()
{
    // End:0x24
    if((int(mode) == int(1)) || int(mode) == int(0))
    {
        return;
    }
    // End:0x3E
    if(!P.IsHosting())
    {
        return;
    }
    LiveAxis.EnableGroup();
    LiveAllies.EnableGroup();
    // End:0x95
    if(!sixthSense)
    {
        DeadAxis.EnableGroup();
        DeadAllies.EnableGroup();
    }
    Everyone.DisableGroup();
    //return;    
}

function PlayerJumps(MOHAPlayerReplicationInfo Who)
{
    local PlasmaPlayerRef playa;

    // End:0x2F
    if(((int(mode) == int(1)) || int(mode) == int(0)) || sixthSense)
    {
        return;
    }
    // End:0x49
    if(!P.IsHosting())
    {
        return;
    }
    playa = Who.GetPlasmaPlayerRef();
    DeadAllies.RemoveMember(playa);
    DeadAxis.RemoveMember(playa);
    // End:0xCA
    if(Who.Team.TeamIndex == 0)
    {
        LiveAllies.AddMember(playa);        
    }
    else
    {
        LiveAxis.AddMember(playa);
    }
    //return;    
}

function PlayerLands(MOHAPlayerReplicationInfo Who)
{
    // End:0x2F
    if(((int(mode) == int(1)) || int(mode) == int(0)) || sixthSense)
    {
        return;
    }
    //return;    
}

function PlayerDies(MOHAPlayerReplicationInfo Who)
{
    local PlasmaPlayerRef playa;

    // End:0x1D
    if((int(mode) == int(1)) || sixthSense)
    {
        return;
    }
    // End:0x37
    if(!P.IsHosting())
    {
        return;
    }
    playa = Who.GetPlasmaPlayerRef();
    LiveAllies.RemoveMember(playa);
    LiveAxis.RemoveMember(playa);
    // End:0xB8
    if(Who.Team.TeamIndex == 0)
    {
        DeadAllies.AddMember(playa);        
    }
    else
    {
        DeadAxis.AddMember(playa);
    }
    //return;    
}

function PlayerSwitchesTeams(MOHAPlayerReplicationInfo Who)
{
    local PlasmaPlayerRef playa;

    // End:0x24
    if((int(mode) == int(1)) || int(mode) == int(0))
    {
        return;
    }
    // End:0x3E
    if(!P.IsHosting())
    {
        return;
    }
    // End:0x58
    if(!Who.HasUniqueIdBeenSet())
    {
        return;
    }
    playa = Who.GetPlasmaPlayerRef();
    LiveAxis.RemoveMember(playa);
    LiveAllies.RemoveMember(playa);
    // End:0xDC
    if(!sixthSense)
    {
        DeadAxis.RemoveMember(playa);
        DeadAllies.RemoveMember(playa);
    }
    PlayerJoins(Who);
    //return;    
}

function RoundOver()
{
    // End:0x24
    if((int(mode) == int(1)) || int(mode) == int(0))
    {
        return;
    }
    // End:0x3E
    if(!P.IsHosting())
    {
        return;
    }
    Everyone.EnableGroup();
    LiveAllies.DisableGroup();
    LiveAxis.DisableGroup();
    // End:0xA8
    if(!sixthSense)
    {
        DeadAllies.DisableGroup();
        DeadAxis.DisableGroup();
    }
    //return;    
}

function GameCleanup()
{
    local PlasmaGameVoIPManager vm;

    // End:0x24
    if((int(mode) == int(1)) || int(mode) == int(0))
    {
        return;
    }
    vm = P.GetHostedGame().GetVoIPManager();
    // End:0xC1
    if(vm != none)
    {
        vm.DestroySymmVoIPGroup(LiveAxis);
        vm.DestroySymmVoIPGroup(LiveAllies);
        // End:0xC1
        if(!sixthSense)
        {
            vm.DestroySymmVoIPGroup(DeadAxis);
            vm.DestroySymmVoIPGroup(DeadAllies);
        }
    }
    LiveAxis = none;
    LiveAllies = none;
    DeadAxis = none;
    DeadAllies = none;
    //return;    
}

defaultproperties
{
    mode=2
    enemyFilter=true
}