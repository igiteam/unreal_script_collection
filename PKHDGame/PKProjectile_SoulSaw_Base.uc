class PKProjectile_SoulSaw_Base extends EvilProjectile_Bouncing_Base
    abstract
    hidecategories(Navigation);

var array<name> AcceptedBoneNames;
var transient bool bIsManuallyAttached;
var EvilExplosion ExplosionBodyArchetype;
var int HowManyPawnsKilledByOneProjectile;
var() export editinline EvilDissolvingSkeletalMeshComponent SkelMesh;

simulated function PostBeginPlay()
{
    super(EvilProjectile_Base).PostBeginPlay();
    SkelMesh.SetupDissolving();
    //return;    
}

simulated function RepInit()
{
    super(EvilProjectile_Base).RepInit();
    SkelMesh.PlayAnim('Spin',, true);
    DamageVSPlayer = int(Damage);
    //return;    
}

simulated function SpawnFlightEffects()
{
    // End:0x7A
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        super(EvilProjectile_Base).SpawnFlightEffects();
        // End:0x7A
        if(ProjEffects != none)
        {
            ProjEffects.SetRotation(MakeRotator(0, 0, int(float(90) * 182.0444000)));
        }
    }
    //return;    
}

simulated function ReSpawnFlightEffects()
{
    // End:0x7A
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        super(EvilProjectile_Base).ReSpawnFlightEffects();
        // End:0x7A
        if(ProjEffects != none)
        {
            ProjEffects.SetRotation(MakeRotator(0, 0, int(float(90) * 182.0444000)));
        }
    }
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local PainGRI_SP PKGRI_SP;
    local PKPlayerController_SP PKPCSP;
    local editinline EvilDissolvingSkeletalMeshComponent SMC;
    local name BoneName;
    local PKPawn P;
    local Rotator boneSpaceRot;
    local Vector boneSpacePos, dirFromHitLocToBonePos, besthitloc;
    local float relScale;
    local Vector relScaleVector;
    local float newDamage;
    local Actor TraceHitActor;
    local Vector TraceOffset;
    local int I;
    local Vector TempHitLoc;
    local TraceHitInfo THitInfo;
    local bool OwnerHasPrerderDLC;

    // End:0x19
    if(LastHitActor == Other)
    {
        return;
    }
    // End:0xB61
    if(Damage > float(0))
    {
        // End:0xBF
        if(PKPlayerPawn(Instigator) != none)
        {
            PKPCSP = PKPlayerController_SP(PKPlayerPawn(Instigator).Controller);
            // End:0xBF
            if(PKPCSP != none)
            {
                OwnerHasPrerderDLC = int(PKPCSP.IsDLCInstalled(3)) == int(1);
            }
        }
        TraceHitActor = Trace(TempHitLoc, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
        // End:0x257
        if(TraceHitActor != Other)
        {
            I = -1;
            J0x139:

            // End:0x257 [Loop If]
            if(I < 2)
            {
                TraceOffset = vect(0.0000000, 0.0000000, 0.0000000);
                TraceOffset.Y = float(I * 10);
                TraceOffset = TraceOffset >> Rotator((HitLocation + Velocity) - HitLocation);
                TraceHitActor = Trace(TempHitLoc, HitNormal, (HitLocation + Velocity) + TraceOffset, HitLocation + TraceOffset, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
                // End:0x247
                if(TraceHitActor == Other)
                {
                    // [Explicit Break]
                    goto J0x257;
                }
                I += 2;
                // [Loop Continue]
                goto J0x139;
            }
        }
        J0x257:

        TempHitLoc = HitLocation;
        // End:0x2E1
        if(THitInfo.BoneName == 'Shield')
        {
            LastHitActor = Other;
            HitWall(HitNormal, Other, THitInfo.HitComponent);
            return;
        }
        // End:0x3A6
        if((ClassIsChildOf(Other.Class, Class'EvilGame.EvilDestructibleObject') || ClassIsChildOf(Other.Class, Class'EvilGame.EvilDynamicDestructibleObject')) || ClassIsChildOf(Other.Class, Class'Engine.FracturedStaticMeshActor'))
        {
            HitWall(HitNormal, Other, THitInfo.HitComponent);
            return;
        }
        // End:0x3E7
        if(NotEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)))
        {
            newDamage = float(DamageVSPlayer);            
        }
        else
        {
            newDamage = Damage;
        }
        // End:0x43C
        if(OwnerHasPrerderDLC)
        {
            newDamage = newDamage * ((VSize(Velocity) / MaxSpeed) * 1.3500000);            
        }
        else
        {
            newDamage = newDamage * ((VSize(Velocity) / MaxSpeed) * RandRange(0.7500000, 1.3500000));
        }
        // End:0x4F0
        if(EvilWeap_Base(Instigator.Weapon) != none)
        {
            EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Other);
        }
        Other.TakeDamage(int(newDamage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);
        P = PKPawn(Other);
        // End:0x64D
        if(((int(WorldInfo.NetMode) < int(NM_Client)) && P != none) && !P.IsAliveAndWell())
        {
            // End:0x64D
            if(++HowManyPawnsKilledByOneProjectile >= 3)
            {
                PKGRI_SP = PainGRI_SP(WorldInfo.GRI);
                // End:0x642
                if(PKGRI_SP != none)
                {
                    PKGRI_SP.IncrementThreeEnemiesKilledByOneSoulSaw();
                }
                HowManyPawnsKilledByOneProjectile = 0;
            }
        }
        // End:0xAE5
        if((((P != none) && P.Health > 0) && P.bBlockActors || P.bCanPinToThisActor) && !P.IsA('PKPawn_Boss_Base'))
        {
            // End:0x75F
            if(WorldInfo.GRI.IsCoopMultiplayerGame() && NotEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none)))
            {
                bIsManuallyAttached = true;
            }
            // End:0xAE2
            if(!bIsManuallyAttached)
            {
                Class'PainWeap_Base'.static.FindNearestBone(P, HitLocation, BoneName, besthitloc, AcceptedBoneNames);
                dirFromHitLocToBonePos = besthitloc - HitLocation;
                dirFromHitLocToBonePos *= 0.6000000;
                HitLocation += dirFromHitLocToBonePos;
                P.Mesh.TransformToBoneSpace(BoneName, HitLocation, Rotation, boneSpacePos, boneSpaceRot);
                SMC = new (Other) SkelMesh.Class (SkelMesh);
                SMC.SetLightEnvironment(P.LightEnvironment);
                relScale = 1.0000000 / P.Mesh.Scale;
                relScaleVector.X = relScale;
                relScaleVector.Y = relScale;
                relScaleVector.Z = relScale;
                P.Mesh.AttachComponent(SMC, BoneName, boneSpacePos, boneSpaceRot, relScaleVector);
                SMC.bGetLifeSpanFromParent = false;
                SMC.ComponentLifeSpan = 5.0000000;
                SMC.SetupDissolving();
                SMC.StartDissolving();
                SMC.PlayAnim('Spin_Stop',,, false);
                bIsManuallyAttached = true;
                ExplosionArchetype = ExplosionBodyArchetype;
                super(EvilProjectile_Base).ProcessTouch(Other, HitLocation, HitNormal);
            }            
        }
        else
        {
            // End:0xB61
            if(P != none)
            {
                ExplosionArchetype = ExplosionBodyArchetype;
                SpawnExplosionEffects(Location, HitNormal);
                ExplosionArchetype = default.ExplosionArchetype;
                // End:0xB46
                if(OwnerHasPrerderDLC)
                {                    
                }
                else
                {
                    Velocity *= (VelocityDampingFactor * 1.5000000);
                }
            }
        }
    }
    LastHitActor = Other;
    //return;    
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    local EvilExplosionActor ExplosionActor;

    // End:0x17D
    if(ExplosionArchetype != none)
    {
        ExplosionActor = Spawn(Class'EvilGame.EvilExplosionActor', self,, HitLocation + (HitNormal * float(5)), MakeRotator(0, 0, 0));
        // End:0xAD
        if(bInWater && ExplosionWaterArchetype != none)
        {
            ExplosionTemplate = new (self) ExplosionWaterArchetype.Class (ExplosionWaterArchetype);            
        }
        else
        {
            ExplosionTemplate = new (self) ExplosionArchetype.Class (ExplosionArchetype);
        }
        ExplosionTemplate.HitNormal = HitNormal;
        ExplosionTemplate.HitActor = ImpactedActor;
        ExplosionActor.Explode(ExplosionTemplate);
        ExplosionTemplate = none;
        bExploded = true;
        bSuppressExplosionFX = true;
    }
    //return;    
}

simulated function ShutDown()
{
    // End:0x88
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x56
        if(ProjectileLight != none)
        {
            DetachComponent(ProjectileLight);
            ProjectileLight = none;
        }
        // End:0x88
        if(ProjectileLightActor != none)
        {
            ProjectileLightActor.Destroy();
            ProjectileLightActor = none;
        }
    }
    super(EvilProjectile_Base).ShutDown();
    //return;    
}

simulated function Destroyed()
{
    // End:0x88
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x56
        if(ProjectileLight != none)
        {
            DetachComponent(ProjectileLight);
            ProjectileLight = none;
        }
        // End:0x88
        if(ProjectileLightActor != none)
        {
            ProjectileLightActor.Destroy();
            ProjectileLightActor = none;
        }
    }
    super(EvilProjectile_Base).Destroyed();
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local float newDamage;

    ImpactedActor = Wall;
    // End:0x14C
    if(LastHitActor != Wall)
    {
        // End:0x14C
        if(Damage > float(0))
        {
            newDamage = Damage * ((VSize(Velocity) / MaxSpeed) * RandRange(0.7500000, 1.3500000));
            // End:0xEF
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Wall);
            }
            Wall.TakeDamage(int(newDamage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
        }
    }
    // End:0x1AF
    if(((Wall != none) && ShouldBounce(Wall, HitNormal)) && int(Physics) == int(2))
    {
        SpawnExplosionEffects(Location, HitNormal);
    }
    super.HitWall(HitNormal, Wall, WallComp);
    // End:0x267
    if(VSize(Velocity) < StopSimulatingVelocityThreshhold)
    {
        DesiredRotator = MakeRotator(0, Rotation.Yaw, Rotation.Roll);
        SkelMesh.PlayAnim('Spin_Stop',,, false);
    }
    //return;    
}

defaultproperties
{
    // Reference: EvilDissolvingSkeletalMeshComponent'Default__PKProjectile_SoulSaw_Base.SkeletalMesh'
    begin object name="SkeletalMesh" class=Class'EvilGame.EvilDissolvingSkeletalMeshComponent'
        bDissolveStarted=true
        bGetLifeSpanFromParent=true
        ReplacementPrimitive=none
    end object
    SkelMesh=SkeletalMesh
    // Reference: StaticMeshComponent'Default__PKProjectile_SoulSaw_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    // Archetype: StaticMeshComponent'EvilGame.Default__EvilProjectile_Bouncing_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
        CollideActors=false
        AlwaysCheckCollision=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    Mesh=StaticMesh
    VelocityDampingFactor=0.5000000
    StopSimulatingVelocityThreshhold=400.0000000
    CustomGravityScaling=0.5000000
    Speed=4000.0000000
    MaxSpeed=4000.0000000
    bRotationFollowsVelocity=true
    MyDamageType=Class'PKDmgType_SoulSaw'
    // Reference: CylinderComponent'Default__PKProjectile_SoulSaw_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Bouncing_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=2.0000000
        CollisionRadius=10.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    Components[2]=SkeletalMesh
    LifeSpan=5.0000000
    CollisionComponent=CollisionCylinder
}