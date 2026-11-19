class SkyPickup_SabotageBomb extends SkyWeaponPickupFactory;

var(Pickup) int Team;
var transient SkyItem_SabotageBomb TheBomb;

simulated function PostBeginPlay()
{
    local SkyGame_Sabotage G;

    G = SkyGame_Sabotage(WorldInfo.Game);
    // End:0x39
    if(G != none)
    {
        G.BombFactory = self;        
    }
    else
    {
        // End:0x57
        if(int(Role) == int(ROLE_Authority))
        {
            GotoState('Disabled');
        }
    }
    super(Actor).PostBeginPlay();
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    local SkyItem_SabotageBomb Inv;
    local SkyGame_Sabotage G;

    G = SkyGame_Sabotage(WorldInfo.Game);
    // End:0xC6
    if((G != none) && SpawnedArchetype != none)
    {
        Inv = SkyItem_SabotageBomb(Spawn(SpawnedArchetype.Class,,,,, SpawnedArchetype));
        // End:0xC6
        if(Inv != none)
        {
            TheBomb = Inv;
            Inv.Factory = self;
            Inv.TeamRestriction = Team;
            Inv.GiveTo(Recipient);
            Inv.AnnouncePickup(Recipient);
        }
    }
    //return;    
}

function AdjustObjective(out Actor Objective, out string Text, PlayerReplicationInfo PRI)
{
    // End:0x2C
    if(SkyGame_Sabotage(WorldInfo.Game) == none)
    {
        Objective = none;
        Text = "";        
    }
    else
    {
        // End:0x67
        if(int(PRI.GetTeamNum()) == Team)
        {
            Text = "Go get the bomb.";            
        }
        else
        {
            Text = "Defend the bomb.";
        }
    }
    //return;    
}

auto state Pickup
{
    simulated function BeginState(name PrevStateName)
    {
        super.BeginState(PrevStateName);
        // End:0x20
        if(TheBomb != none)
        {
            StartSleeping();
        }
        //return;        
    }

    simulated function bool CanGive(SkyPlayerReplicationInfo PRI)
    {
        // End:0x3A
        if((Team == 255) || int(PRI.GetTeamNum()) == Team)
        {
            return super(SkyWeaponPickupFactory).CanGive(PRI);
        }
        return false;
        //return ReturnValue;        
    }
    stop;    
}
