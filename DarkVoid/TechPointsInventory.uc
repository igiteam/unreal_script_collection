class TechPointsInventory extends SkyInventory
    native;

var(TechPoint) float ChanceOfDrop;
var(TechPoint) int NumToSpawn;
var(TechPoint) DroppedTechPoints TechPointArchetype;

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    local DroppedPickup P;
    local int I;
    local SkyGame SG;

    // End:0x41
    if((Instigator != none) && Instigator.InvManager != none)
    {
        Instigator.InvManager.RemoveFromInventory(self);
    }
    // End:0x5E
    if((DroppedPickupClass == none) || DroppedPickupMesh == none)
    {
        Destroy();
        return;
    }
    SG = SkyGame(WorldInfo.Game);
    // End:0xAE
    if(((SG != none) && SG.bXPackInstalled == true) || FRand() > ChanceOfDrop)
    {
        Destroy();
        return;
    }
    I = 0;
    J0xB5:

    // End:0x11C [Loop If]
    if(I < NumToSpawn)
    {
        P = Spawn(TechPointArchetype.Class,,, StartLocation,, TechPointArchetype, true);
        // End:0xFD
        if(P == none)
        {
            Destroy();
            return;
        }
        P.Init(self);
        ++I;
        // [Loop Continue]
        goto J0xB5;
    }
    Instigator = none;
    //return;    
}
