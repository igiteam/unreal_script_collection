class SkyWeaponPickupFactory extends SkyPickupFactory
    native;

var(Pickup) SkyWeapon SpawnedArchetype;

replication
{
    // Pos:0x000
    if(bNetInitial
        SpawnedArchetype;
}

simulated function PreBeginPlay()
{
    InventoryType = SpawnedArchetype.Class;
    InvMaterialIndex = SpawnedArchetype.GlimmerMaterialIndex;
    super(PickupFactory).PreBeginPlay();
    //return;    
}

simulated function bool CanGive(SkyPlayerReplicationInfo PRI)
{
    return bCanGive;
    //return ReturnValue;    
}

function SpawnCopyFor(Pawn Recipient)
{
    local Inventory Inv;

    // End:0x30
    if(SpawnedArchetype != none)
    {
        Inv = Spawn(SpawnedArchetype.Class,,,,, SpawnedArchetype);
    }
    // End:0x69
    if(Inv != none)
    {
        Inv.GiveTo(Recipient);
        Inv.AnnouncePickup(Recipient);
    }
    //return;    
}

simulated function SetPickupMesh()
{
    local SkyWeapon WeaponArchetype;
    local LightingChannelContainer LCC;

    // End:0x16
    if(SpawnedArchetype != none)
    {
        WeaponArchetype = SpawnedArchetype;
    }
    // End:0xF8
    if((WeaponArchetype != none) && WeaponArchetype.DroppedPickupMesh != none)
    {
        // End:0xF8
        if(PickupMesh != WeaponArchetype.DroppedPickupMesh)
        {
            // End:0x6E
            if(PickupMesh != none)
            {
                DetachComponent(PickupMesh);
                PickupMesh = none;
            }
            PickupMesh = new (self) WeaponArchetype.DroppedPickupMesh.Class (WeaponArchetype.DroppedPickupMesh);
            AttachComponent(PickupMesh);
            WeaponArchetype.SetUpgradeSkelControls(WeaponArchetype.UpgradeSkelControls, SkeletalMeshComponent(PickupMesh));
            // End:0xEE
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

auto state Pickup
{
    function Give(Pawn P)
    {
        // End:0x6D
        if((SkyPlayerReplicationInfo(P.PlayerReplicationInfo) != none) && SkyGameReplicationInfo(WorldInfo.GRI).bUseRep)
        {
            SkyPlayerReplicationInfo(P.PlayerReplicationInfo).ReputationPoints -= SpawnedArchetype.RepCost;
        }
        GiveTo(P);
        //return;        
    }
    stop;    
}
