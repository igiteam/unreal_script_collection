class UTInventory extends Inventory
    abstract
    hidecategories(Navigation);

var bool bReceiveOwnerEvents;

static simulated function AddWeaponOverlay(UTGameReplicationInfo GRI)
{
    //return;    
}

reliable client simulated function ClientLostItem()
{
    // End:0x18
    if(int(Role) < int(ROLE_Authority))
    {
        SetOwner(none);
    }
    //return;    
}

simulated event Destroyed()
{
    local Pawn P;

    P = Pawn(Owner);
    // End:0xB8
    if((P != none) && P.IsLocallyControlled() || (P.DrivenVehicle != none) && P.DrivenVehicle.IsLocallyControlled())
    {
        ClientLostItem();
    }
    super.Destroyed();
    //return;    
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    ClientLostItem();
    super.DropFrom(StartLocation, StartVelocity);
    //return;    
}

function OwnerEvent(name EventName)
{
    //return;    
}

defaultproperties
{
    DroppedPickupClass=Class'UTRotatingDroppedPickup'
    MessageClass=Class'EvilPickupMessage'
}