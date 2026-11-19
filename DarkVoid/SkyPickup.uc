class SkyPickup extends DroppedPickup
    native;

var float DropPickupDelay;
var bool bJustDropped;
var bool bCanPlayDroppedSound;
var transient bool bSkyPoolActive;
var export editinline PrimitiveComponent MeshComp;
var int Team;
var transient int InvMaterialIndex;
var transient MaterialInstanceConstant InvMaterialInst;
var deprecated transient MaterialInterface MeshMaterialInst;
var deprecated float InvMaterialValue;
var() export editinline DynamicLightEnvironmentComponent LightEnv;
var repnotify Inventory DroppedItemArchetype;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        DroppedItemArchetype;
}

simulated function InitForPooling()
{
    SetNoDelete(true);
    bSkyPoolActive = false;
    SetHidden(true);
    Reset();
    //return;    
}

// Export USkyPickup::execSetNoDelete(FFrame&, void* const)
native final function SetNoDelete(bool bNewNoDelete);

simulated function Init(Inventory Inv)
{
    Inventory = Inv;
    // End:0x59
    if(Inv != none)
    {
        InventoryClass = Inv.Class;
        Instigator = Inv.Instigator;
        SetPickupMesh(Inv.DroppedPickupMesh);
    }
    SetHidden(false);
    bSkyPoolActive = true;
    //return;    
}

simulated function Reset()
{
    // End:0x1B
    if(bNoDelete)
    {
        bSkyPoolActive = false;
        SetHidden(true);        
    }
    else
    {
        super.Reset();
    }
    //return;    
}

simulated function DestroyFromPooling()
{
    SetNoDelete(false);
    Destroy();
    //return;    
}

// Export USkyPickup::execIsPoolAvailable(FFrame&, void* const)
native simulated function bool IsPoolAvailable();

simulated event ReplicatedEvent(name VarName)
{
    // End:0x3C
    if((VarName == 'DroppedItemArchetype') && DroppedItemArchetype != none)
    {
        SetPickupMesh(DroppedItemArchetype.DroppedPickupMesh);        
    }
    else
    {
        // End:0x52
        if(VarName == 'InventoryClass')
        {            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}

simulated function ResetCanPlayDroppedSound()
{
    bCanPlayDroppedSound = true;
    //return;    
}

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    SetTimer(DropPickupDelay, false, 'TimerDropped');
    //return;    
}

simulated event SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
    local LightingChannelContainer LCC;

    // End:0x77
    if((NewPickupMesh != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x3D
        if(MeshComp != none)
        {
            DetachComponent(MeshComp);
        }
        MeshComp = new (self) NewPickupMesh.Class (NewPickupMesh);
        AttachComponent(MeshComp);
        MeshComp.SetNotifyRigidBodyCollision(true);
    }
    MeshComp.SetLightEnvironment(LightEnv);
    LCC.bInitialized = true;
    LCC.CompositeDynamic = true;
    LCC.Dynamic = false;
    MeshComp.SetLightingChannels(LCC);
    SetupPhysics();
    //return;    
}

simulated function EnableGlimmer()
{
    local editinline MeshComponent M;

    M = MeshComponent(MeshComp);
    // End:0xBC
    if(M != none)
    {
        // End:0x67
        if(InvMaterialInst == none)
        {
            InvMaterialInst = new (Outer) Class'Engine.MaterialInstanceConstant';
            InvMaterialInst.SetParent(M.GetMaterial(InvMaterialIndex));
        }
        M.SetMaterial(InvMaterialIndex, InvMaterialInst);
        InvMaterialInst.SetVectorParameterValue('itemflash', MakeLinearColor(1.0000000, 1.0000000, 1.0000000, 1.0000000));
    }
    //return;    
}

// Export USkyPickup::execSetupPhysics(FFrame&, void* const)
native function SetupPhysics();

function TimerDropped()
{
    bJustDropped = false;
    //return;    
}

function Give(Pawn P)
{
    return;
    //return;    
}

simulated function bool CanGive(SkyPlayerReplicationInfo PRI)
{
    return false;
    //return ReturnValue;    
}

auto state Pickup
{
    function Give(Pawn P)
    {
        GiveTo(P);
        //return;        
    }

    simulated function bool CanGive(SkyPlayerReplicationInfo PRI)
    {
        return (Team == 255) || Team == int(PRI.GetTeamNum());
        //return ReturnValue;        
    }
Begin:

    EnableGlimmer();
    stop;        
}
