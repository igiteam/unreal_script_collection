class SkyInvPickupFactory extends SkyPickupFactory
    native;

var(Pickup) SkyInventory SpawnedInvArchetype;

simulated function PostBeginPlay()
{
    InventoryType = SpawnedInvArchetype.Class;
    InvMaterialIndex = SpawnedInvArchetype.GlimmerMaterialIndex;
    super(Actor).PostBeginPlay();
    //return;    
}

simulated function bool CanGive(SkyPlayerReplicationInfo PRI)
{
    // End:0x5D
    if((!SkyGameReplicationInfo(WorldInfo.GRI).bUseRep || PRI == none) || PRI.ReputationPoints >= SpawnedInvArchetype.RepCost)
    {
        return bCanGive;
    }
    return false;
    //return ReturnValue;    
}

simulated function SetPickupMesh()
{
    local LightingChannelContainer LCC;

    // End:0xA8
    if(SpawnedInvArchetype.DroppedPickupMesh != none)
    {
        // End:0xA8
        if(PickupMesh != SpawnedInvArchetype.DroppedPickupMesh)
        {
            // End:0x4B
            if(PickupMesh != none)
            {
                DetachComponent(PickupMesh);
                PickupMesh = none;
            }
            PickupMesh = new (self) SpawnedInvArchetype.DroppedPickupMesh.Class (SpawnedInvArchetype.DroppedPickupMesh);
            AttachComponent(PickupMesh);
            // End:0x9E
            if(bPickupHidden)
            {
                SetPickupHidden();                
            }
            else
            {
                SetPickupVisible();
            }
        }
    }
    SetupPhysics();
    PickupMesh.SetLightEnvironment(LightEnv);
    LCC.bInitialized = true;
    LCC.CompositeDynamic = true;
    LCC.Dynamic = false;
    PickupMesh.SetLightingChannels(LCC);
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    local Inventory Inv;

    Inv = Spawn(InventoryType,,,,, SpawnedInvArchetype);
    // End:0x54
    if(Inv != none)
    {
        Inv.GiveTo(Recipient);
        Inv.AnnouncePickup(Recipient);
    }
    //return;    
}

auto state Pickup
{
    function Give(Pawn P)
    {
        // End:0x6D
        if((SkyPlayerReplicationInfo(P.PlayerReplicationInfo) != none) && SkyGameReplicationInfo(WorldInfo.GRI).bUseRep)
        {
            SkyPlayerReplicationInfo(P.PlayerReplicationInfo).ReputationPoints -= SpawnedInvArchetype.RepCost;
        }
        GiveTo(P);
        //return;        
    }
    stop;    
}
