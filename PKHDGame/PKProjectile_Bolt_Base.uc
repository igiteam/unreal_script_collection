class PKProjectile_Bolt_Base extends EvilProjectile_Pinnable_Base
    abstract
    hidecategories(Navigation);

var bool bIsComboActive;
var repnotify bool bIsBurning;
var repnotify EvilProjectile_Base ComboOther;
var() float ComboCkeckInterval;
var() float ComboCheckDistance;
var() class<EvilProjectile_Base> ComboCheckClass;
var EvilExplosion ExplosionComboArchetype;
var() float BurnStartTime;
var export editinline ParticleSystemComponent OldProjEffects;
var ParticleSystem ProjFlightBurningTemplate;
var EvilLightActor ProjectileLightBurningArchetype;
var PKWeap_Boltgun_Base WeaponFireOwner;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        ComboOther, bIsBurning, 
        bIsComboActive;
}

function Init(Vector Direction)
{
    // End:0x7A
    if((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
    {
        Speed *= 1.2000000;
        MaxSpeed *= 1.2000000;
    }
    super(EvilProjectile_Base).Init(Direction);
    // End:0xF7
    if((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
    {
        Damage *= 1.5000000;
    }
    SetTimer(ComboCkeckInterval, true, 'CheckForCombo');
    //return;    
}

simulated function RepInit()
{
    super.RepInit();
    // End:0x76
    if((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
    {
        BurnStartTime = 0.0100000;        
    }
    else
    {
        BurnStartTime = default.BurnStartTime;
    }
    //return;    
}

function CheckForCombo()
{
    local Actor Other;
    local EvilProjectile_Base OtherProj;

    // End:0x23
    if(bIsComboActive)
    {
        ClearTimer('CheckForCombo');
        return;
    }
    // End:0xF1
    foreach OverlappingActors(ComboCheckClass, Other, ComboCheckDistance,, true)
    {
        OtherProj = EvilProjectile_Base(Other);
        // End:0xF0
        if(((OtherProj != none) && !OtherProj.bShuttingDown) && !OtherProj.bExploded)
        {
            ComboOther = OtherProj;
            DoCombo();
            bIsComboActive = true;
            // End:0xF1
            break;
        }        
    }    
    //return;    
}

simulated function DoCombo()
{
    local editinline StaticMeshComponent OtherMeshComponent, SMC;

    ExplosionArchetype = ExplosionComboArchetype;
    // End:0x4B
    foreach ComboOther.ComponentList(Class'Engine.StaticMeshComponent', OtherMeshComponent)
    {
        // End:0x4B
        break;        
    }    
    // End:0xCF
    if(OtherMeshComponent != none)
    {
        SMC = new (self) OtherMeshComponent.Class (OtherMeshComponent);
        AttachComponent(SMC);
        SMC.SetRotation(MakeRotator(0, 0, 0));
    }
    ComboOther.ShutdownNoFX();
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local name BoneName;
    local PKPawn P;
    local int FinalDmg;
    local Vector besthitloc;
    local TraceHitInfo THitInfo;

    P = PKPawn(Other);
    // End:0x123
    if((((((P != none) && WorldInfo.GRI.IsCoopMultiplayerGame()) && NotEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none))) && !bIsComboActive) || !bIsComboActive && !CanAttachToActorClass(Other.Class)) || (P != none) && !P.bCanPinToThisActor)
    {
        bIsManuallyAttached = true;
    }
    // End:0x219
    if(((P != none) && !bIsManuallyAttached) && !bIsComboActive)
    {
        Class'EvilGame.EvilWeap_Base'.static.FindNearestBone(P, HitLocation, BoneName, besthitloc, AcceptedBoneNames);
        // End:0x219
        if((int(P.Role) == int(ROLE_Authority)) && int(WorldInfo.NetMode) == int(NM_Client))
        {
            ProcessPostDeathTouch(P, BoneName, HitLocation);
        }
    }
    // End:0x4A9
    if(Damage > float(0))
    {
        // End:0x269
        if(NotEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)))
        {
            FinalDmg = DamageVSPlayer;            
        }
        else
        {
            FinalDmg = int(Damage);
        }
        Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
        // End:0x33B
        if(EvilWeap_Base(Instigator.Weapon) != none)
        {
            EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Other);
        }
        Other.TakeDamage(FinalDmg, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);
        // End:0x4A9
        if((P != none) && P.bBlockActors || P.bCanBePinned)
        {
            // End:0x4A9
            if(!bIsManuallyAttached && !bIsComboActive)
            {
                // End:0x487
                if((P.Health <= 0) && !P.bIsFrozen)
                {
                    ProcessPostDeathTouch(P, BoneName, HitLocation);                    
                }
                else
                {
                    ProcessPostTouch(P, HitLocation, self);
                }
                Destroy();
                return;
            }
        }
    }
    // End:0x4BC
    if(bIsManuallyAttached)
    {
        Destroy();        
    }
    else
    {
        // End:0x54B
        if(((P == none) || P.bBlockActors) || P.bCanBePinned)
        {
            super(EvilProjectile_Base).ProcessTouch(Other, HitLocation, HitNormal);
            PinnedToActor = Other;
        }
    }
    //return;    
}

simulated function ShutDown()
{
    // End:0x19
    if(bIsComboActive)
    {
        super(EvilProjectile_Base).ShutDown();
        return;
    }
    super.ShutDown();
    //return;    
}

simulated function HideProjectile()
{
    // End:0x19
    if(bIsComboActive)
    {
        super(EvilProjectile_Base).HideProjectile();
        return;
    }
    super.HideProjectile();
    //return;    
}

simulated function Destroyed()
{
    // End:0x6A
    if(OldProjEffects != none)
    {
        DetachComponent(OldProjEffects);
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(OldProjEffects);
        OldProjEffects = none;
    }
    super(EvilProjectile_Base).Destroyed();
    //return;    
}

simulated function SpawnFlightEffects()
{
    super(EvilProjectile_Base).SpawnFlightEffects();
    // End:0x6F
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x6F
        if(ProjEffects != none)
        {
            ProjEffects.SetFloatParameter('Burn', 0.0000000);
        }
    }
    //return;    
}

simulated function StartBurning()
{
    bIsBurning = true;
    ProjectileLightArchetype = ProjectileLightBurningArchetype;
    // End:0x187
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x84
        if(ProjEffects != none)
        {
            ProjEffects.SetFloatParameter('Burn', 1.0000000);
        }
        // End:0xB1
        if(ProjectileLight != none)
        {
            DetachComponent(ProjectileLight);
            ProjectileLight = none;
        }
        // End:0xE3
        if(ProjectileLightActor != none)
        {
            ProjectileLightActor.Destroy();
            ProjectileLightActor = none;
        }
        // End:0x187
        if((ProjectileLightArchetype != none) && !WorldInfo.IsConsoleBuild())
        {
            ProjectileLightActor = Spawn(Class'EvilGame.EvilLightActor', self,, Location,, ProjectileLightArchetype);
            ProjectileLightActor.SetBase(self);
            ProjectileLightActor.Activate();
        }
    }
    // End:0x1F4
    if((PKPlayerPawn(Instigator) == none) || !PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
    {
        bRotationFollowsVelocity = true;
        SetPhysics(2);
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(EvilProjectile_Base).Tick(DeltaTime);
    // End:0x9A
    if(((((int(Role) == int(ROLE_Authority)) && bInit) && BurnStartTime > float(0)) && !bIsComboActive) && !bShuttingDown)
    {
        BurnStartTime -= DeltaTime;
        // End:0x9A
        if(BurnStartTime <= float(0))
        {
            StartBurning();
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'ComboOther')
    {
        DoCombo();        
    }
    else
    {
        // End:0x48
        if(VarName == 'bIsBurning')
        {
            StartBurning();            
        }
        else
        {
            super(EvilProjectile_Base).ReplicatedEvent(VarName);
        }
    }
    //return;    
}

reliable server function ServerAttachProjectileToPawn(EvilPawn P, Vector HitLocation, EvilProjectile_Pinnable_Base Proj)
{
    local PKPlayerController PKPC;
    local name BoneName;
    local Rotator boneSpaceRot;
    local Vector boneSpacePos, dirFromHitLocToBonePos, besthitloc;

    // End:0x1DC
    if((P != none) && !Proj.bIsManuallyAttached)
    {
        Class'EvilGame.EvilWeap_Base'.static.FindNearestBone(P, HitLocation, BoneName, besthitloc, AcceptedBoneNames);
        dirFromHitLocToBonePos = besthitloc - HitLocation;
        dirFromHitLocToBonePos *= 0.6000000;
        HitLocation += dirFromHitLocToBonePos;
        P.Mesh.TransformToBoneSpace(BoneName, HitLocation, Rotation, boneSpacePos, boneSpaceRot);
        Proj.bIsManuallyAttached = true;
        // End:0x1DB
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PKPC)
        {
            PKPC.ClientAttachStakeToPawn(P, BoneName, HitLocation, Rotation, Mesh.StaticMesh);            
        }        
    }
    //return;    
}

simulated function ProcessPostTouch(EvilPawn P, Vector HitLocation, EvilProjectile_Pinnable_Base Proj)
{
    ServerAttachProjectileToPawn(P, HitLocation, Proj);
    //return;    
}

reliable server function ServerCreateStakeVirtualProjectile(Vector HitLocation, Controller StakeOwner)
{
    local PKPlayerController PKPC;

    // End:0x6F
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PKPC)
    {
        PKPC.ClientCreateStakeVirtualProjectile(HitLocation, Velocity, StakeOwner);        
    }    
    //return;    
}

simulated function ProcessPostDeathTouch(EvilPawn P, name BoneName, Vector HitLocation)
{
    local PKPawn PKP;
    local Actor GoodActor;
    local float TraceDistance;

    PKP = PKPawn(P);
    // End:0x42
    if(!PKP.bCanBePinned)
    {
        return;
    }
    TraceDistance = 560.0000000;
    // End:0x82
    if(PKP.bPinned)
    {
        TraceDistance = 70.0000000;
    }
    GoodActor = Class'PKStakeVirtualProjectile'.static.FindStaticActor(PKP, BoneName, HitLocation, HitLocation + (Normal(Velocity) * TraceDistance));
    // End:0x115
    if(GoodActor == none)
    {
        ServerAttachProjectileToPawn(P, HitLocation, self);
        return;
    }
    ServerCreateStakeVirtualProjectile(HitLocation, Instigator.Controller);
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    EvilDissolvingStaticMeshComponent(Mesh).SetupDissolving();
    EvilDissolvingStaticMeshComponent(Mesh).StartDissolving();
    EvilDissolvingStaticMeshComponent(Mesh).SetTranslation(vect(-35.0000000, 0.0000000, 0.0000000));
    super.HitWall(HitNormal, Wall, WallComp);
    //return;    
}

function InformMyWeaponOwnerIKilledSomeone()
{
    // End:0x2E
    if(WeaponFireOwner != none)
    {
        WeaponFireOwner.FiredProjectileKillSomeone();
    }
    //return;    
}

defaultproperties
{
    ComboCkeckInterval=0.0100000
    ComboCheckDistance=50.0000000
    // Reference: EvilDissolvingStaticMeshComponent'Default__PKProjectile_Bolt_Base.StaticMesh'
    // Archetype: EvilDissolvingStaticMeshComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    Speed=10640.0000000
    MaxSpeed=10640.0000000
    bRotationFollowsVelocity=false
    MyDamageType=Class'PKDmgType_Bolt'
    // Reference: CylinderComponent'Default__PKProjectile_Bolt_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    Physics=EPhysics.PHYS_Projectile
    CollisionComponent=CollisionCylinder
}