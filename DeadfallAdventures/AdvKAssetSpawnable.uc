class AdvKAssetSpawnable extends KAssetSpawnable
    hidecategories(Navigation);

var array<MaterialInstanceConstant> DissolveMICs;
var repnotify bool bReplicatedWakeUp;
var repnotify float ReplicatedScale;
var() float TimeToDissapear;
var float DissolveAmount;
var float LastImpactSoundTime;

replication
{
    // Pos:0x000
    if(bNetDirty
        ReplicatedScale, bReplicatedWakeUp;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'bReplicatedWakeUp')
    {
        ClientWakeUp();        
    }
    else
    {
        // End:0x66
        if(VarName == 'ReplicatedScale')
        {
            SkeletalMeshComponent.SetScale(ReplicatedScale);            
        }
        else
        {
            super(KAsset).ReplicatedEvent(VarName);
            // End:0xA3
            if(VarName == 'ReplicatedMesh')
            {
                AddMICsToArray(SkeletalMeshComponent);
            }
        }
    }
    //return;    
}

simulated event PostBeginPlay()
{
    local float Scale;
    local EvilPawn EvilInstigator;

    super(KAsset).PostBeginPlay();
    LastImpactSoundTime = WorldInfo.TimeSeconds;
    // End:0x1CA
    if((Instigator != none) && Instigator.Mesh != none)
    {
        Scale = Instigator.Mesh.Scale;
        EvilInstigator = EvilPawn(Instigator);
        // End:0x183
        if(((EvilInstigator != none) && EvilInstigator.CurrentWeaponAttachment != none) && EvilInstigator.CurrentWeaponAttachment.Mesh != none)
        {
            Scale *= EvilInstigator.CurrentWeaponAttachment.Mesh.Scale;
        }
        ReplicatedScale = Scale;
        bForceNetUpdate = true;
        SkeletalMeshComponent.SetScale(Scale);
    }
    AddMICsToArray(SkeletalMeshComponent);
    SetTimer(TimeToDissapear, false, 'Dissolve_T');
    //return;    
}

simulated function ClientWakeUp()
{
    SkeletalMeshComponent.WakeRigidBody();
    //return;    
}

simulated function Dissolve_T()
{
    local MaterialInstanceConstant MIC;

    // End:0x4B
    if(DissolveAmount > 0.0000000)
    {
        DissolveAmount = FMax(0.0000000, DissolveAmount - 0.0500000);
        SetTimer(0.0500000, false, GetFuncName());        
    }
    else
    {
        // End:0x62
        if(int(Role) == int(ROLE_Authority))
        {
            Destroy();
        }
    }
    // End:0xAB
    foreach DissolveMICs(MIC)
    {
        MIC.SetScalarParameterValue('DissolveAmount', DissolveAmount);        
    }    
    //return;    
}

simulated function AddMICsToArray(MeshComponent MC)
{
    local int I;
    local MaterialInterface MI;
    local MaterialInstanceConstant MIC;

    I = 0;
    J0x0B:

    // End:0x166 [Loop If]
    if(I < MC.GetNumElements())
    {
        MI = MC.GetMaterial(I);
        // End:0xD0
        if((MaterialInstanceConstant(MI) != none) && MI.GetPackageName() == 'Transient')
        {
            MIC = MaterialInstanceConstant(MI);            
        }
        else
        {
            MIC = MC.CreateAndSetMaterialInstanceConstant(I);
        }
        // End:0x158
        if(MIC != none)
        {
            MIC.SetScalarParameterValue('DissolveAmount', DissolveAmount);
            DissolveMICs.AddItem(MIC);            
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    local PhysicalMaterial PM;

    super(Actor).RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
    // End:0x16E
    if(RigidCollisionData.ContactInfos.Length > 0)
    {
        PM = RigidCollisionData.ContactInfos[0].PhysMaterial[0];
        // End:0x16E
        if(((PM != none) && PM.ImpactSound != none) && WorldInfo.TimeSeconds > (LastImpactSoundTime + PM.ImpactReFireDelay))
        {
            PlaySound(PM.ImpactSound,,,, Location);
            LastImpactSoundTime = WorldInfo.TimeSeconds;
        }
    }
    //return;    
}

defaultproperties
{
    TimeToDissapear=5.0000000
    DissolveAmount=1.0000000
    // Reference: SkeletalMeshComponent'Default__AdvKAssetSpawnable.KAssetSkelMeshComponent'
    begin object name=KAssetSkelMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvKAssetSpawnable.MyLightEnvironment'
        CastShadow=false
        BlockActors=false
        bNotifyRigidBodyCollision=true
        ScriptRigidBodyCollisionThreshold=50.0000000
    end object
    SkeletalMeshComponent=KAssetSkelMeshComponent
    // Reference: DynamicLightEnvironmentComponent'Default__AdvKAssetSpawnable.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[0]=MyLightEnvironment
    Components[1]=KAssetSkelMeshComponent
    CollisionComponent=KAssetSkelMeshComponent
}