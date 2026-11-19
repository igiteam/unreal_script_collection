class AdvWayPointMPBase extends Actor
    notplaceable
    hidecategories(Navigation);

var export editinline ParticleSystemComponent BaseParticles;
var repnotify AdvTeamInfo MyTeam;
var float Lifetime;
var bool bShouldBeDisplayed;

replication
{
    // Pos:0x000
    if(bNetDirty
        MyTeam;
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    MyTeam = AdvTeamInfo(Owner);
    // End:0x59
    if(int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        InitializeDisplayingState();
    }
    SetTimer(Lifetime, false, 'DestroyDelayed');
    SetTimer(Lifetime - 1.0000000, false, 'DeactivateSystem', BaseParticles);
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x21
    if(VarName == 'MyTeam')
    {
        InitializeDisplayingState();
    }
    //return;    
}

reliable client simulated function InitializeDisplayingState()
{
    local AdvPlayerControllerMP PC;

    PC = AdvPlayerControllerMP(WorldInfo.GetALocalPlayerController());
    // End:0xDD
    if((PC != none) && PC.PlayerReplicationInfo != none)
    {
        // End:0xDD
        if(AdvTeamInfo(PC.PlayerReplicationInfo.Team) == MyTeam)
        {
            BaseParticles.ActivateSystem(true);
            bShouldBeDisplayed = true;
        }
    }
    //return;    
}

function DestroyDelayed()
{
    MyTeam.TeamWayPoint = none;
    Destroy();
    //return;    
}

defaultproperties
{
    Lifetime=20.0000000
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bAlwaysRelevant=true
}