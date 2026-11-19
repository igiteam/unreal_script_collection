class PKPawn_Boss_Alastor_Base extends PKPawn_Boss_Base
    abstract
    config(Pawn)
    hidecategories(Navigation);

const MapCenter = vect(0,0,0);

var bool bReadyToDie;
var bool bVulnurable;
var bool bPreciseMove;
var repnotify bool bBreathActive;
var ParticleSystem ParticlesOnStomp;
var ParticleSystem ParticlesOnStrike;
var ParticleSystem ParticlesOnBreath;
var ParticleSystem ParticlesOnFall;
var ParticleSystem ParticlesOnHeal;
var EvilExplosion StompArchetype;
var EvilExplosion StrikeArchetype;
var EvilExplosion DestroyFloorArchetype;
var export editinline ParticleSystemComponent Particles;
var export editinline ParticleSystemComponent BoneSocketActorPSC;
var SoundCue MeleeStrikeFlyingSwish;
var SoundCue MeleeStrikeFlyingScream;
var SoundCue FireStrikeFlyingScream;
var export editinline AudioComponent HealingSoundLoop;
var export editinline LightComponent HealLight;
var() name HealLightSocket;
var() name BreathSocket;
var export editinline LightComponent BreathLight;
var() name BreathLightSocket;
var() name BurnSocket;
var name HeadBoneName;
var name NeckBoneName;
var class<Projectile> ProjectileClass;
var class<PKItem_Boss_Alastor_Meteor_Base> MeteorActorClass;
var Vector SpawnLocation;
var array<PKItem_Boss_Alastor_Statue_Base> MonkList;
var repnotify name FullBodySlotAnimName;
var repnotify ParticleSystem BoneSocketActorEffectType;
var config int StrikeDamage;
var config int StrikeRadius;
var config float BreathDamageChance;
var config int BreathDamageBase;
var config int BreathDamageRand;
var config int FireballDamage;
var config int FireballMomentumTransfer;
var config int StompAndPoundDamage;
var config int StompAndPoundDamageRadius;
var config int MeteorDamage;
var config int MeteorDamageRadius;
var float lastBumpDamage;

replication
{
    // Pos:0x000
    if(bNetDirty)
        BoneSocketActorEffectType, FullBodySlotAnimName, 
        bBreathActive;
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x58
    if(bVulnurable)
    {
        super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    //return;    
}

simulated function PlayBoneSocketActorEffects(ParticleSystem EffectType)
{
    local ParticleSystem PS;
    local editinline ParticleSystemComponent PSC;

    PS = EffectType;
    PSC = BoneSocketActorPSC;
    // End:0x10C
    if(PSC == none)
    {
        PSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(PS);
        AttachComponent(PSC);
        PSC.SetActorParameter('BoneSocketActor', self);
        PSC.ActivateSystem();
        BoneSocketActorPSC = PSC;        
    }
    else
    {
        // End:0x150
        if(!PSC.bIsActive)
        {
            PSC.ActivateSystem();
        }
    }
    //return;    
}

simulated function StopBoneSocketActorEffects()
{
    // End:0x39
    if(BoneSocketActorPSC != none)
    {
        BoneSocketActorPSC.DeactivateSystem();
        BoneSocketActorPSC = none;
    }
    //return;    
}

simulated function ShowFullBodyHealEffect()
{
    HealLight.SetEnabled(true);
    BoneSocketActorEffectType = ParticlesOnHeal;
    PlayBoneSocketActorEffects(ParticlesOnHeal);
    //return;    
}

simulated function HideFullBodyHealEffect()
{
    HealLight.SetEnabled(false);
    BoneSocketActorEffectType = none;
    StopBoneSocketActorEffects();
    //return;    
}

simulated function BurnStart()
{
    BoneSocketActorEffectType = ParticlesOnFall;
    PlayBoneSocketActorEffects(ParticlesOnFall);
    //return;    
}

simulated function BurnStop()
{
    BoneSocketActorEffectType = none;
    StopBoneSocketActorEffects();
    //return;    
}

function PlayFullbodySlotAnim(name AnimName)
{
    FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
    FullBodySlotAnimName = AnimName;
    FullBodyAnimSlot.PlayCustomAnim(FullBodySlotAnimName, 1.0000000, 1.0000000, 1.0000000, true);
    //return;    
}

function StopFullbodySlotAnim()
{
    FullBodyAnimSlot.SetRootBoneAxisOption(0, 0, 0);
    FullBodySlotAnimName = 'None';
    FullBodyAnimSlot.StopCustomAnim(1.0000000);
    //return;    
}

function bool ReachedDestination(Actor InGoal)
{
    // End:0x50
    if(bPreciseMove)
    {
        // End:0x4B
        if(VSize2D(InGoal.Location - Location) < float(16))
        {
            return true;
        }
        return false;        
    }
    else
    {
        return super(Pawn).ReachedDestination(InGoal);
    }
    //return ReturnValue;    
}

function bool ReachedPoint(Vector InPoint, Actor NewAnchor)
{
    // End:0x3B
    if(bPreciseMove)
    {
        // End:0x36
        if(VSize2D(InPoint - Location) < float(16))
        {
            return true;
        }
        return false;        
    }
    else
    {
        return super(Pawn).ReachedPoint(InPoint, NewAnchor);
    }
    //return ReturnValue;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local PKItem_Boss_Base_Item Item;

    // End:0x87
    if(bReadyToDie)
    {
        // End:0x3F
        foreach DynamicActors(Class'PKItem_Boss_Base_Item', Item)
        {
            Item.Destroy();            
        }        
        BreathStop();
        CallKismetEvent(Class'SeqEvent_BossKilled', 0);
        return super.Died(Killer, DamageType, HitLocation);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function BreathStart()
{
    Particles = new (self) Class'EvilGame.UTParticleSystemComponent';
    Particles.SetTemplate(ParticlesOnBreath);
    self.Mesh.AttachComponentToSocket(Particles, BreathSocket);
    Particles.ActivateSystem();
    SetTimer(0.3000000, false, 'BreathDamage', self);
    bBreathActive = true;
    BreathLight.SetEnabled(true);
    //return;    
}

function BreathDamage()
{
    local int Distance, I;
    local PKPlayerPawn Enemy;
    local Vector V, vc, Loc;
    local Rotator Rot;

    // End:0x24
    if(RandRange(0.0000000, 1.0000000) > BreathDamageChance)
    {
        return;
    }
    Mesh.GetSocketWorldLocationAndRotation(BreathSocket, Loc, Rot, 0);
    V = Vector(Rot);
    I = 0;
    // End:0x1C6
    foreach DynamicActors(Class'PKPlayerPawn', Enemy)
    {
        // End:0x1C5
        if(Enemy != none)
        {
            J0xA7:

            // End:0x1C5 [Loop If]
            if(I < 2048)
            {
                vc = Loc + (V * float(I));
                I += 128;
                Distance = int(VSize(Enemy.Location - vc));
                // End:0x1C2
                if(Distance < ((I / 8) + 256))
                {
                    Enemy.TakeDamage(BreathDamageBase + Rand(BreathDamageRand), MyPKAI, Enemy.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_AlastorFlames');
                    // End:0x1C5
                    continue;
                }
                // [Loop Continue]
                goto J0xA7;
            }
        }        
    }    
    SetTimer(0.2000000, true, 'BreathDamage', self);
    //return;    
}

function BreathStop()
{
    // End:0x34
    if(Particles != none)
    {
        Particles.SetStopSpawning(-1, true);
    }
    ClearTimer('BreathDamage', self);
    bBreathActive = false;
    BreathLight.SetEnabled(false);
    //return;    
}

function Throw()
{
    local Projectile SpawnedProjectile;

    SpawnedProjectile = Spawn(ProjectileClass,,, Mesh.GetBoneLocation(HeadBoneName) + (Vector(Rotation) * float(128)));
    // End:0x14D
    if(SpawnedProjectile != none)
    {
        SpawnedProjectile.Init(Normal((PKAI_Boss_Alastor(MyPKAI).Target.Location - SpawnedProjectile.Location) - vect(0.0000000, 0.0000000, 64.0000000)));
        SpawnedProjectile.Damage = float(FireballDamage);
        SpawnedProjectile.MomentumTransfer = float(FireballMomentumTransfer);
    }
    //return;    
}

function StrikeGround()
{
    local Vector ParticlesLocation;

    ParticlesLocation = Mesh.GetBoneLocation(RightHandBoneName);
    ParticlesLocation.Z = Location.Z;
    Stomp(RightHandBoneName);
    Stomp(LeftHandBoneName);
    PlayArchetypeEffect(StrikeArchetype, ParticlesLocation + (vect(0.0000000, 0.0000000, 1.0000000) * float(64)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    //return;    
}

function JumpPound()
{
    Stomp(RightHandBoneName);
    Stomp(LeftHandBoneName);
    Stomp(RightFootBoneName);
    Stomp(LeftFootBoneName);
    PlayArchetypeEffect(StompArchetype, Mesh.GetBoneLocation(RightHandBoneName) + (vect(0.0000000, 0.0000000, 1.0000000) * float(64)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    PlayArchetypeEffect(StompArchetype, Mesh.GetBoneLocation(LeftHandBoneName) + (vect(0.0000000, 0.0000000, 1.0000000) * float(64)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    PlayArchetypeEffect(StompArchetype, Mesh.GetBoneLocation(RightFootBoneName) + (vect(0.0000000, 0.0000000, 1.0000000) * float(64)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    PlayArchetypeEffect(StompArchetype, Mesh.GetBoneLocation(LeftFootBoneName) + (vect(0.0000000, 0.0000000, 1.0000000) * float(64)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    //return;    
}

function StompRightFoot()
{
    Stomp(RightFootBoneName);
    PlayArchetypeEffect(StompArchetype, Mesh.GetBoneLocation(RightFootBoneName) + (vect(0.0000000, 0.0000000, 1.0000000) * float(64)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    //return;    
}

function StompLeftFoot()
{
    Stomp(LeftFootBoneName);
    PlayArchetypeEffect(StompArchetype, Mesh.GetBoneLocation(LeftFootBoneName) + (vect(0.0000000, 0.0000000, 1.0000000) * float(64)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    //return;    
}

function Stomp(name TargetBone)
{
    local int Distance;
    local PKPlayerPawn PlayerPawn;
    local Vector BoneLocation;

    BoneLocation = Mesh.GetBoneLocation(TargetBone);
    // End:0x106
    foreach VisibleActors(Class'PKPlayerPawn', PlayerPawn, 4096.0000000, BoneLocation)
    {
        Distance = int(VSize2D(PlayerPawn.Location - BoneLocation));
        PlayerPawn.GetPC().ClientPlayCameraShake(CameraShake'PP_Resources.PlayerHitCameraShake', FClamp(0.5000000 + float((2048 - Distance) / 4096), 0.0000000, 1.0000000));        
    }    
    // End:0x1A0
    foreach VisibleCollidingActors(Class'PKPlayerPawn', PlayerPawn, float(StompAndPoundDamageRadius), BoneLocation)
    {
        PlayerPawn.TakeDamage(StompAndPoundDamage, MyPKAI, PlayerPawn.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee');        
    }    
    //return;    
}

function DestroyFloor()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local array<int> EventOutLinks;
    local Vector ParticlesLocation;

    Stomp(RightHandBoneName);
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x106
    if(GameSeq != none)
    {
        EventOutLinks[0] = PKAI_Boss_Alastor(Controller).Stage;
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_PKDestroyFloor', true, ExecutionEvents);
        // End:0x105
        foreach ExecutionEvents(ExecutionEvent)
        {
            SeqEvent_PKDestroyFloor(ExecutionEvent).CheckActivate(WorldInfo, none, false, EventOutLinks);            
        }        
    }
    ParticlesLocation = Mesh.GetBoneLocation(RightHandBoneName);
    ParticlesLocation.Z = Location.Z;
    Stomp(RightHandBoneName);
    PlayArchetypeEffect(DestroyFloorArchetype, ParticlesLocation + (vect(0.0000000, 0.0000000, 1.0000000) * float(64)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    //return;    
}

function SpawnMonks()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x97 [Loop If]
    if(I < 8)
    {
        Spawn(Class'PKItem_Boss_Alastor_Statue_Base',,, (vect(0.0000000, 0.0000000, 0.0000000) + (Vector(MakeRotator(0, int(float(I * 45) * 182.0444000), 0)) * float(3800))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(2200)));
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function AddMonksToList()
{
    local PKItem_Boss_Alastor_Statue_Base currentMonk;

    // End:0x5E
    foreach VisibleCollidingActors(Class'PKItem_Boss_Alastor_Statue_Base', currentMonk, 8192.0000000, vect(0.0000000, 0.0000000, 0.0000000) + (vect(0.0000000, 0.0000000, 1.0000000) * float(2200)))
    {
        MonkList.AddItem(currentMonk);        
    }    
    //return;    
}

simulated event PostBeginPlay()
{
    super(PKPawn).PostBeginPlay();
    SpawnLocation = Location;
    SetTimer(0.0500000, true, 'TouchingDestructible_T');
    self.Mesh.AttachComponentToSocket(BreathLight, BreathLightSocket);
    self.Mesh.AttachComponentToSocket(HealLight, HealLightSocket);
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x7C
    if(Other.Class == Class'PKDestructibleObject')
    {
        Other.TakeDamage(64, MyPKAI, HitLocation, Velocity / float(2), Class'PKDmgType_BumpAlastor');        
    }
    else
    {
        super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    }
    //return;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    // End:0x91
    if(Wall.Class == Class'PKDestructibleObject')
    {
        Wall.TakeDamage(64, MyPKAI, Wall.Location, Velocity / float(2), Class'PKDmgType_BumpAlastor');        
    }
    else
    {
        super(EvilPawn).HitWall(HitNormal, Wall, WallComp);
    }
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    // End:0x7B
    if(Other.Class == Class'PKDestructibleObject')
    {
        Other.TakeDamage(64, MyPKAI, Location, Velocity / float(2), Class'PKDmgType_BumpAlastor');
        return;
    }
    // End:0x1C0
    if(Other.IsA('PKPlayerPawn') && WorldInfo.TimeSeconds > (lastBumpDamage + 1.0000000))
    {
        lastBumpDamage = WorldInfo.TimeSeconds;
        PKPlayerPawn(Other).TakeDamage(StompAndPoundDamage / 2, MyPKAI, Other.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee');
        PKPlayerPawn(Other).GetPC().ClientPlayCameraShake(CameraShake'PP_Resources.PlayerHitCameraShake', 0.5000000);
        return;
    }
    super(PKPawn).Bump(Other, OtherComp, HitNormal);
    //return;    
}

function TouchingDestructible_T()
{
    local PKDestructibleObject staticDest;

    // End:0x8A
    foreach CollidingActors(Class'PKDestructibleObject', staticDest, 256.0000000, Location + (Vector(Rotation) * float(128)), true)
    {
        staticDest.TakeDamage(64, MyPKAI, Location, Velocity / float(2), Class'PKDmgType_BumpAlastor');        
    }    
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x9B
        case 'FullBodySlotAnimName':
            // End:0x74
            if(FullBodySlotAnimName != 'None')
            {
                FullBodyAnimSlot.PlayCustomAnim(FullBodySlotAnimName, 1.0000000, 1.0000000, 1.0000000, true);                
            }
            else
            {
                FullBodyAnimSlot.StopCustomAnim(1.0000000);
            }
            // End:0x228
            break;
        // End:0x130
        case 'BoneSocketActorEffectType':
            // End:0x103
            if(BoneSocketActorEffectType != none)
            {
                PlayBoneSocketActorEffects(BoneSocketActorEffectType);
                // End:0x100
                if(BoneSocketActorEffectType == ParticlesOnHeal)
                {
                    HealLight.SetEnabled(true);
                }                
            }
            else
            {
                StopBoneSocketActorEffects();
                HealLight.SetEnabled(false);
            }
            // End:0x228
            break;
        // End:0x212
        case 'bBreathActive':
            // End:0x1EA
            if(bBreathActive)
            {
                Particles = new (self) Class'EvilGame.UTParticleSystemComponent';
                Particles.SetTemplate(ParticlesOnBreath);
                self.Mesh.AttachComponentToSocket(Particles, BreathSocket);
                Particles.ActivateSystem();                
            }
            else
            {
                Particles.SetStopSpawning(-1, true);
            }
            // End:0x228
            break;
        // End:0xFFFF
        default:
            super(PKPawn).ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

defaultproperties
{
    bVulnurable=true
    StrikeDamage=20
    StrikeRadius=512
    BreathDamageChance=1.0000000
    BreathDamageBase=5
    BreathDamageRand=5
    FireballDamage=20
    FireballMomentumTransfer=32
    StompAndPoundDamage=10
    StompAndPoundDamageRadius=512
    MeteorDamage=10
    MeteorDamageRadius=256
    bIsBoss=true
    bThrowSoul=false
    bCanBeFrozen=false
    bHasTIPAnims45Deg=true
    bHasTIPAnims90Deg=true
    bCanBePinned=false
    // Reference: StaticMeshComponent'Default__PKPawn_Boss_Alastor_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn_Boss_Base.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Boss_Alastor_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn_Boss_Base.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    bCanPinToThisActor=false
    bCanBeKnockedDown=false
    DefaultHealth=500.0000000
    PawnActionClasses=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Alastor_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Boss_Alastor_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn_Boss_Base.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    HeadBone="Hips"
    bSmoothNetUpdates=false
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Boss_Alastor_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Boss_Alastor_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Boss_Alastor_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    MaxLeanRoll=0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Alastor_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Boss_Alastor_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Alastor_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Boss_Alastor_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    MaxStepHeight=256.0000000
    GroundSpeed=1536.0000000
    AirSpeed=8192.0000000
    // Reference: SkeletalMeshComponent'Default__PKPawn_Boss_Alastor_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Alastor_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Boss_Alastor_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn_Boss_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Boss_Alastor_Base.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPawn_Boss_Base.FaceAudioComponent'
    begin object name="FaceAudioComponent"
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=0,Yaw=30000,Roll=0)
}