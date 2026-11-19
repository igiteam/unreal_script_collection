class SkyHandoffItem extends SkySecondaryItem
    native
    config(Game);

var transient bool bCanHandoff;
var const localized string HandoffString;
var const localized string HandoffOfferBaseString;
var const localized string HandoffOfferItemString;
var const localized string OfferedHandoffString;
var() Color HandoffColor;
var transient SkyPlayerReplicationInfo HandoffPRI;
var() float HandoffDistSq;
var() int TeamRestriction;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetOwner
        HandoffPRI, bCanHandoff;
}

function FindHandoffTarget()
{
    ClearTimer('FindHandoffTarget');
    //return;    
}

reliable server function OfferHandoff()
{
    // End:0x5D
    if(HandoffPRI != none)
    {
        HandoffPRI.HandoffString = Repl(Repl(HandoffOfferBaseString, "%p", Instigator.PlayerReplicationInfo.PlayerName), "%i", HandoffOfferItemString);
        HandoffPRI.OfferedHandoff = self;
    }
    //return;    
}

reliable server function CancelHandoff()
{
    // End:0x2E
    if(HandoffPRI != none)
    {
        HandoffPRI.HandoffString = "";
        HandoffPRI.OfferedHandoff = none;
    }
    //return;    
}

reliable server function Handoff()
{
    local SkyPlayerController PC;

    // End:0xAF
    foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
    {
        // End:0xAE
        if(PC.PlayerReplicationInfo == HandoffPRI)
        {
            // End:0xAB
            if(PC.Pawn != none)
            {
                HandoffPRI.OfferedHandoff = none;
                HandoffPRI = none;
                Instigator.InvManager.RemoveFromInventory(self);
                PC.DropSecondary();
                GiveTo(PC.Pawn);
            }            
            return;
        }        
    }    
    //return;    
}

simulated function Activate()
{
    GotoState('Active');
    //return;    
}

simulated function PutDownWeapon()
{
    //return;    
}

simulated function HolderDied()
{
    //return;    
}

simulated event RealEndFire()
{
    //return;    
}

simulated event AttachItem(name SocketName)
{
    //return;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(0.5000000, true, 'FindHandoffTarget');
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('FindHandoffTarget');
        CancelHandoff();
        HandoffPRI = none;
        super.EndState(NextStateName);
        //return;        
    }

    function FindHandoffTarget()
    {
        local Controller C, bestC;
        local float Cdist2, bestCdist2;

        // End:0x1E
        if(!bCanHandoff)
        {
            CancelHandoff();
            HandoffPRI = none;
            return;
        }
        bestC = none;
        // End:0x17E
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x17D
            if(((((C.Pawn != none) && C.Pawn.Health > 0) && C.Pawn != Instigator) && C.Pawn != Instigator.DrivenVehicle) && (TeamRestriction == 255) || int(C.GetTeamNum()) == TeamRestriction)
            {
                Cdist2 = VSizeSq(Instigator.Location - C.Pawn.Location);
                // End:0x17D
                if(((Cdist2 <= HandoffDistSq) && (Cdist2 < bestCdist2) || bestC == none) && SkyPlayerReplicationInfo(C.PlayerReplicationInfo) != none)
                {
                    bestCdist2 = Cdist2;
                    bestC = C;
                }
            }            
        }        
        // End:0x1A7
        if(bestC != none)
        {
            HandoffPRI = SkyPlayerReplicationInfo(bestC.PlayerReplicationInfo);            
        }
        else
        {
            CancelHandoff();
            HandoffPRI = none;
        }
        //return;        
    }
    stop;    
}

state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        //return;        
    }
    stop;    
}
