class SkyPickupFactory extends PickupFactory
    native;

var bool bCanGive;
var() export editinline DynamicLightEnvironmentComponent LightEnv;
var transient int InvMaterialIndex;
var transient MaterialInstanceConstant InvMaterialInst;
var deprecated transient MaterialInterface MeshMaterialInst;
var deprecated float InvMaterialValue;
var export editinline SkeletalMeshComponent EdPickupMesh;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        bCanGive;
}

simulated function bool CanGive(SkyPlayerReplicationInfo PRI)
{
    return bCanGive;
    //return ReturnValue;    
}

function Give(Pawn P)
{
    return;
    //return;    
}

simulated function SetPickupMesh()
{
    super.SetPickupMesh();
    SetupPhysics();
    PickupMesh.SetLightEnvironment(LightEnv);
    //return;    
}

simulated function SetupPhysics()
{
    local editinline SkeletalMeshComponent SkelMesh;

    SkelMesh = SkeletalMeshComponent(PickupMesh);
    // End:0x34
    if((SkelMesh == none) || SkelMesh.PhysicsAsset == none)
    {
        return;
    }
    SkelMesh.SetHasPhysicsAssetInstance(true);
    SkelMesh.PhysicsWeight = 1.0000000;
    SkelMesh.SetBlockRigidBody(true);
    SkelMesh.SetRBCollidesWithChannel(2, false);
    SkelMesh.WakeRigidBody();
    CollisionComponent = SkelMesh;
    SetPhysics(10);
    SetTickGroup(2);
    //return;    
}

simulated function EnableGlimmer()
{
    local editinline MeshComponent M;

    M = MeshComponent(PickupMesh);
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

auto state Pickup
{
    function Give(Pawn P)
    {
        GiveTo(P);
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        bCanGive = true;
        EnableGlimmer();
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state Sleeping
{
    event BeginState(name PreviousStateName)
    {
        bCanGive = false;
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}
