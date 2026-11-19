class EvilThrowedPickup extends UTDroppedPickup
    hidecategories(Navigation);

var ParticleSystem DissapearEffectPS;
var export editinline UTParticleSystemComponent DissapearEffectPSC;
var class<DamageType> CustomDamageType;
var float RotRate;
var Vector Accel;

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    local editinline SkeletalMeshComponent PickupSkelMesh;

    super.Landed(HitNormal, FloorActor);
    PickupSkelMesh = SkeletalMeshComponent(PickupMesh);
    // End:0x1A8
    if(PickupSkelMesh != none)
    {
        PickupSkelMesh.MinDistFactorForKinematicUpdate = 0.0000000;
        PickupSkelMesh.ForceSkelUpdate();
        PickupSkelMesh.SetTickGroup(2);
        SetTickGroup(2);
        PickupSkelMesh.SetRBPosition(Location);
        PickupSkelMesh.SetRBRotation(Rotation);
        SetPhysics(10);
        PickupSkelMesh.PhysicsWeight = 1.0000000;
        PickupSkelMesh.bUpdateKinematicBonesFromAnimation = false;
        PickupSkelMesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        PickupSkelMesh.WakeRigidBody();
    }
    SpawnEffects();
    LifeSpan = 5.0000000;
    //return;    
}

function SpawnEffects()
{
    // End:0x8B
    if(DissapearEffectPS != none)
    {
        DissapearEffectPSC = new (Outer) Class'UTParticleSystemComponent';
        DissapearEffectPSC.bAutoActivate = true;
        DissapearEffectPSC.SetTemplate(DissapearEffectPS);
        AttachComponent(DissapearEffectPSC);
    }
    //return;    
}

simulated event SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
    // End:0x1E0
    if((NewPickupMesh != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        PickupMesh = new (self) NewPickupMesh.Class (NewPickupMesh);
        // End:0xCB
        if(class<EvilWeap_Base>(InventoryClass) != none)
        {
            PickupMesh.SetScale(PickupMesh.Scale * 1.0000000);
        }
        SkeletalMeshComponent(PickupMesh).SetPhysicsAsset(SkeletalMeshComponent(PickupMesh).default.PhysicsAsset);
        PickupMesh.SetLightEnvironment(MyLightEnvironment);
        SetRotation(Instigator.Rotation);
        AttachComponent(PickupMesh);
        CollisionComponent = PickupMesh;
        Accel = Velocity;
        Accel.Z *= float(1);
        Velocity.Z *= float(4);
    }
    //return;    
}

function GiveDamageTo(Pawn P, Vector HitLocation, Vector HitNormal)
{
    local class<DamageType> dmgType;
    local EvilWeap_Base Weapon;
    local float Damage;
    local Vector Momentum;

    Weapon = EvilWeap_Base(Inventory);
    Momentum = HitNormal;
    // End:0x54
    if(CustomDamageType != none)
    {
        dmgType = CustomDamageType;        
    }
    else
    {
        // End:0xEC
        if(Weapon != none)
        {
            dmgType = Weapon.InstantHitDamageTypes[1];
            Damage = Weapon.InstantHitDamage[1];
            Momentum = Momentum * Weapon.InstantHitMomentum[1];
        }
    }
    P.TakeDamage(int(Damage), Instigator.Controller, HitLocation, Momentum, dmgType,, Instigator);
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local Rotator NewRotation;

    // End:0x19F
    if((((PickupMesh != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && (WorldInfo.TimeSeconds - LastRenderTime) < 0.2000000) && VSizeSq(Velocity) > float(256))
    {
        NewRotation = PickupMesh.Rotation;
        NewRotation.Pitch -= int(DeltaTime * RotRate);
        PickupMesh.SetRotation(NewRotation);
        // End:0x19F
        if(PickupParticles != none)
        {
            NewRotation = PickupParticles.Rotation;
            NewRotation.Pitch -= int(DeltaTime * RotRate);
            PickupParticles.SetRotation(NewRotation);
        }
    }
    //return;    
}

auto state Pickup
{
    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;

        P = Pawn(Other);
        // End:0x6C
        if((P != none) && P != Instigator)
        {
            GiveDamageTo(P, HitLocation, HitNormal);
            Destroy();
        }
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    RotRate=65536.0000000
    bPickupable=false
    // Reference: DynamicLightEnvironmentComponent'Default__EvilThrowedPickup.DroppedPickupLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'DroppedPickupLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__UTDroppedPickup.DroppedPickupLightEnvironment'
    begin object name="DroppedPickupLightEnvironment"
    end object
    MyLightEnvironment=DroppedPickupLightEnvironment
    Components[0]=none
    // Reference: CylinderComponent'Default__EvilThrowedPickup.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTDroppedPickup.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=0.0000000
        CollisionRadius=0.0000000
        ReplacementPrimitive=none
    end object
    Components[1]=CollisionCylinder
    Components[2]=DroppedPickupLightEnvironment
    CollisionComponent=CollisionCylinder
}