class PkPawn_Boss_Giant_Base extends PKPawn_Boss_Base
    abstract
    config(Pawn)
    hidecategories(Navigation);

const maxZombies = 10;
const MaxMeteors = 5;

var Vector StrikeDirection;
var bool bHitAlready;
var repnotify bool bIsSucking;
var repnotify bool bBreathActive;
var array<EvilPawn> currentZombiesList;
var SoundCue HandHitSoundCue;
var name LeftChainBoneName;
var name RightChainBoneName;
var PKItem_Boss_Giant_Tornado_Base Twister;
var name StrikeHandBoneName;
var int SpawnedZombieCount;
var int NewZombies;
var class<PKPawn> ZombiePawnClass;
var class<PKItem_Boss_Giant_Spike_Base> SpikeActorClass;
var class<PKItem_Boss_Giant_Tornado_Base> TornadoActorClass;
var class<PKItem_Boss_Giant_Meteor_Base> MeteorActorClass;
var Vector BaseSpawnLocation;
var PKItem_Boss_Giant_Meteor_Base MeteorPawn;
var PKItem_Boss_Giant_Spike_Base SpikePawn;
var EvilExplosion StompArchetype;
var EvilExplosion BreakArchetype;
var EvilExplosion StrikeArchetype;
var EvilExplosion ZombieEmergeArchetype;
var array<EvilExplosion> HitGroundArchetypes;
var float DamageMultiplier;
var float lastBumpDamage;
var float AfterShockCounter;
var() name BreathSocket;
var ParticleSystem ParticlesOnBreath;
var export editinline ParticleSystemComponent Particles;
var config float BreakChainsDamageMultiplier;
var config int StrikeDamage;
var config int StrikeRadius;
var config int StrikeVelocity;
var config int StompAndPoundDamage;
var config int StompAndPoundDamageRadius;
var config int MeteorDamage;
var config int MeteorDamageRadius;
var config int TornadoDamage;
var config float TornadoDamageChance;
var config float TornadoSuckInterval;
var config float ZombieMovementRate;
var config int TornadoRadius;
var config int TornadoVelocity;
var config int SpikeDamage;
var config int SpikeVelocity;

replication
{
    // Pos:0x000
    if(bNetDirty)
        bBreathActive, bIsSucking;
}

function BreathStart()
{
    Particles = new (self) Class'EvilGame.UTParticleSystemComponent';
    Particles.SetTemplate(ParticlesOnBreath);
    self.Mesh.AttachComponentToSocket(Particles, BreathSocket);
    Particles.ActivateSystem();
    bBreathActive = true;
    //return;    
}

function BreathStop()
{
    // End:0x34
    if(Particles != none)
    {
        Particles.SetStopSpawning(-1, true);
    }
    bBreathActive = false;
    //return;    
}

function SetLowDamageMultiplier()
{
    DamageMultiplier = BreakChainsDamageMultiplier;
    //return;    
}

function ResetDamageMultiplier()
{
    DamageMultiplier = 1.0000000;
    //return;    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local float newDamage;

    newDamage = DamageMultiplier * float(Damage);
    super.TakeDamage(int(newDamage), InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function Vector FindVerticalPosition(Vector InLocation)
{
    local Vector HitLocation, HitNormal, TraceEnd, TraceStart, NewLocation;

    local Landscape HitLandscape;

    TraceStart = (vect(1.0000000, 1.0000000, 0.0000000) * InLocation) - (vect(0.0000000, 0.0000000, 1.0000000) * float(4000));
    TraceEnd = (vect(1.0000000, 1.0000000, 0.0000000) * InLocation) - (vect(0.0000000, 0.0000000, 1.0000000) * float(3200));
    // End:0xD4
    foreach TraceActors(Class'Engine.Landscape', HitLandscape, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        NewLocation = HitLocation;        
        return NewLocation;        
    }    
    return InLocation;
    //return ReturnValue;    
}

function createMeteor()
{
    local Vector MeteorSpawnLocation;

    MeteorSpawnLocation = Mesh.GetBoneLocation('Head') + (vect(0.0000000, 0.0000000, 1.0000000) * float(256));
    MeteorPawn = Spawn(MeteorActorClass,,, MeteorSpawnLocation);
    MeteorPawn.Boss = self;
    //return;    
}

function SpawnMeteors()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x33 [Loop If]
    if(I < 5)
    {
        createMeteor();
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super(PKPawn).PostBeginPlay();
    Twister = Spawn(TornadoActorClass,,, Location);
    Twister.SetBase(self,, Mesh, 'Mouth');
    Twister.MyTornadoMesh.SetHidden(true);
    Twister.SetHidden(true);
    Twister.Boss = self;
    //return;    
}

simulated function StartTwister()
{
    bIsSucking = true;
    Twister.PlayAttack();
    //return;    
}

simulated function StopTwister()
{
    bIsSucking = false;
    Twister.StopAttack();
    //return;    
}

function BreakChains()
{
    Mesh.HideBoneByName(LeftChainBoneName, 2);
    Mesh.HideBoneByName(RightChainBoneName, 2);
    PlayArchetypeEffect(BreakArchetype, Mesh.GetBoneLocation(RightHandBoneName), MakeRotator(0, Rotation.Yaw, int(float(90) * 182.0444000)));
    PlayArchetypeEffect(BreakArchetype, Mesh.GetBoneLocation(LeftHandBoneName), MakeRotator(0, Rotation.Yaw, int(float(-90) * 182.0444000)));
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    // End:0x145
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

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local PKItem_Boss_Base_Item Item;
    local PKPawn_ZombieSoldier_Base Zombie;

    // End:0x134
    if(Health <= 0)
    {
        PKPlayerController(GetALocalPlayerController()).StopViewShaking();
        // End:0x9A
        if(!Twister.bHidden)
        {
            StopTwister();
            Twister.Particles.DeactivateSystem();
        }
        Mesh.SetHidden(true);
        // End:0xEC
        foreach DynamicActors(Class'PKItem_Boss_Base_Item', Item)
        {
            Item.Destroy();            
        }        
        // End:0x11F
        foreach DynamicActors(Class'PKPawn_ZombieSoldier_Base', Zombie)
        {
            Zombie.Destroy();            
        }        
        CallKismetEvent(Class'SeqEvent_BossKilled', 0);
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function CreateSpike()
{
    local TraceHitInfo HitInfo;
    local PKPlayerPawn Enemy;
    local Vector HitLocation, HitNormal, SpikeLocation;

    // End:0x10C
    foreach DynamicActors(Class'PKPlayerPawn', Enemy)
    {
        SpikeLocation = Enemy.Location;
        Trace(HitLocation, HitNormal, SpikeLocation - (vect(0.0000000, 0.0000000, 1.0000000) * float(560)), SpikeLocation, false, vect(1.0000000, 1.0000000, 1.0000000), HitInfo);
        SpikePawn = Spawn(SpikeActorClass,,, HitLocation);
        SpikePawn.Boss = self;
        SpikePawn.Enemy = Enemy;        
    }    
    //return;    
}

function StrikeAttackLeftHand()
{
    StrikeAttack();
    //return;    
}

function StrikeAttackRightHand()
{
    StrikeAttack();
    //return;    
}

function StrikeAttack()
{
    local PKPlayerPawn Enemy;

    // End:0x2B6
    foreach DynamicActors(Class'PKPlayerPawn', Enemy)
    {
        // End:0x2B5
        if(VSize2D(Enemy.Location - Mesh.GetBoneLocation(StrikeHandBoneName)) < float(StrikeRadius))
        {
            // End:0xD7
            if(!bHitAlready)
            {
                PlaySound(HandHitSoundCue,,,, Mesh.GetBoneLocation(HeadBone));
                bHitAlready = true;
            }
            // End:0x1E2
            if((VSize2D(Enemy.Velocity) < float(StrikeVelocity / 2)) && int(Enemy.Physics) != int(2))
            {
                Enemy.TakeDamage(StrikeDamage, MyPKAI, Mesh.GetBoneLocation(StrikeHandBoneName), vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee',, self);
                Enemy.MoveSmooth(vect(0.0000000, 0.0000000, 0.2500000) * float(StrikeVelocity));
            }
            Enemy.AirControl = 0.0000000;
            Enemy.Velocity = (Normal(StrikeDirection * vect(1.0000000, 1.0000000, 0.0000000)) + vect(0.0000000, 0.0000000, 0.2500000)) * float(StrikeVelocity);
            Enemy.SetPhysics(2);
            Enemy.GetPC().PushState('ThrownByGiant');
        }        
    }    
    //return;    
}

function StrikeParticles()
{
    local Vector ParticleDirection, HandToGiantDirection;

    HandToGiantDirection = Normal((Location - Mesh.GetBoneLocation(StrikeHandBoneName)) * vect(1.0000000, 1.0000000, 0.0000000));
    ParticleDirection = Normal(((float(3) * Normal(StrikeDirection)) + HandToGiantDirection) * vect(1.0000000, 1.0000000, 0.0000000));
    PlayArchetypeEffect(StrikeArchetype, ((FindVerticalPosition(Mesh.GetBoneLocation(StrikeHandBoneName))) + (ParticleDirection * float(1024))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(128)), MakeRotator(0, int(float(Rotator(ParticleDirection).Yaw) - (float(90) * 182.0444000)), 0));
    //return;    
}

function SpawnAttack()
{
    PoundRightHand();
    BaseSpawnLocation = FindVerticalPosition(Mesh.GetBoneLocation(RightHandBoneName));
    SetTimer(0.5000000, false, 'SpawnZombies', self);
    //return;    
}

function CountZombies()
{
    local EvilPawn CurrentZombie;
    local array<EvilPawn> TempZombiesList;

    // End:0x76
    if(currentZombiesList.Length > 0)
    {
        // End:0x62
        foreach currentZombiesList(CurrentZombie)
        {
            // End:0x61
            if(CurrentZombie.Health > 0)
            {
                TempZombiesList.AddItem(CurrentZombie);
            }            
        }        
        currentZombiesList = TempZombiesList;
    }
    //return;    
}

function SpawnZombies()
{
    CountZombies();
    // End:0x1D
    if(currentZombiesList.Length >= 10)
    {
        return;
    }
    NewZombies = int(RandRange(3.0000000, 6.0000000));
    // End:0x82
    if((currentZombiesList.Length + NewZombies) > 10)
    {
        NewZombies = 10 - currentZombiesList.Length;
        // End:0x82
        if(NewZombies < 1)
        {
            return;
        }
    }
    SpawnedZombieCount = 0;
    SetTimer(0.5000000, false, 'SpawnNextZombie', self);
    //return;    
}

function SpawnNextZombie()
{
    local Vector CurrentSpawnLocation;
    local PKPawn CurrentZombie;

    CurrentSpawnLocation = MyPKAI.GetRandomLocation(4096.0000000, true, BaseSpawnLocation + ((VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(512)));
    CurrentZombie = Spawn(ZombiePawnClass,,, CurrentSpawnLocation, Rotator(CurrentSpawnLocation - Controller.Enemy.Location));
    // End:0x5AA
    if(CurrentZombie != none)
    {
        CurrentZombie.DressUp();
        CurrentZombie.SetRotation(Rotator(MyPKAI.Enemy.Location - CurrentZombie.Location));
        PlayArchetypeEffect(ZombieEmergeArchetype, CurrentSpawnLocation - vect(0.0000000, 0.0000000, 64.0000000), MakeRotator(int(float(90) * 182.0444000), 0, 0));
        CurrentZombie.ServerDoPawnAction(14, true,, Class'EvilGame.EPA_Emerge'.static.EncodeEmergeInfo(CurrentZombie.GetSpawnAnimation(0), 0, 1, 0));
        EPA_Emerge(CurrentZombie.PawnActions[14]).DoEmerge(,, false);
        CurrentZombie.SpawnDefaultController();
        CurrentZombie.bThrowSoul = false;
        CurrentZombie.bNotCountable = false;
        EvilAnim_AST(CurrentZombie.MoveModeNode.Children[2].Anim).AnimSeq.RateScale = ZombieMovementRate;
        CurrentZombie.GroundSpeed = CurrentZombie.default.GroundSpeed * ZombieMovementRate;
        EvilGame(WorldInfo.Game).ChangeTeam(CurrentZombie.Controller, int(GetTeamNum()), false);
        currentZombiesList.AddItem(CurrentZombie);
        SpawnedZombieCount++;
        CurrentZombie.SightRadius = SightRadius;
        CurrentZombie.MyPKAI.SightRadius = SightRadius;
        CurrentZombie.MyPKAI.SightSenseDistanceThreshold = SightRadius - 400.0000000;
        CurrentZombie.MyPKAI.SetMoveGoal(Controller.Enemy,, true);
        CurrentZombie.MyPKAI.SetEnemy(Controller.Enemy);
        CurrentZombie.MyPKAI.Focus = Controller.Enemy;        
    }
    // End:0x5D4
    if(SpawnedZombieCount < NewZombies)
    {
        SetTimer(0.1000000, false, 'SpawnNextZombie', self);
    }
    //return;    
}

function PoundRightHand()
{
    Stomp(RightHandBoneName);
    PlayArchetypeEffect(HitGroundArchetypes[Rand(HitGroundArchetypes.Length)], ((FindVerticalPosition(Mesh.GetBoneLocation(RightHandBoneName))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(128))) + ((Vector(Rotation) * vect(1.0000000, 1.0000000, 0.0000000)) * float(-256)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    AfterShockCounter = -1.0000000;
    AfterShock();
    //return;    
}

function PoundBothHands()
{
    Stomp(RightHandBoneName);
    Stomp(LeftHandBoneName);
    PlayArchetypeEffect(HitGroundArchetypes[Rand(HitGroundArchetypes.Length)], ((FindVerticalPosition(Mesh.GetBoneLocation(RightHandBoneName))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(128))) + ((Vector(Rotation) * vect(1.0000000, 1.0000000, 0.0000000)) * float(-256)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    PlayArchetypeEffect(HitGroundArchetypes[Rand(HitGroundArchetypes.Length)], ((FindVerticalPosition(Mesh.GetBoneLocation(LeftHandBoneName))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(128))) + ((Vector(Rotation) * vect(1.0000000, 1.0000000, 0.0000000)) * float(-256)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    AfterShockCounter = -1.0000000;
    AfterShock();
    //return;    
}

function StompRightFoot()
{
    Stomp(RightFootBoneName);
    PlayArchetypeEffect(StompArchetype, (FindVerticalPosition(Mesh.GetBoneLocation(RightFootBoneName))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(128)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    AfterShockCounter = 0.0000000;
    AfterShock();
    //return;    
}

function StompLeftFoot()
{
    Stomp(LeftFootBoneName);
    PlayArchetypeEffect(StompArchetype, (FindVerticalPosition(Mesh.GetBoneLocation(LeftFootBoneName))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(128)), MakeRotator(int(float(90) * 182.0444000), 0, 0));
    AfterShockCounter = 0.0000000;
    AfterShock();
    //return;    
}

function Stomp(name TargetBone)
{
    local PKPlayerPawn PlayerPawn;
    local EvilDestructibleObject Destructible;
    local Vector BoneLocation;

    BoneLocation = Mesh.GetBoneLocation(TargetBone);
    // End:0xC7
    foreach VisibleActors(Class'PKPlayerPawn', PlayerPawn, float(StompAndPoundDamageRadius), BoneLocation)
    {
        PlayerPawn.TakeDamage(StompAndPoundDamage, MyPKAI, PlayerPawn.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee');        
    }    
    // End:0x17C
    foreach VisibleCollidingActors(Class'EvilGame.EvilDestructibleObject', Destructible, float(StompAndPoundDamageRadius * 2), BoneLocation)
    {
        Destructible.TakeDamage(64, MyPKAI, Destructible.Location, Normal(Destructible.Location - BoneLocation), Class'EvilGame.EvilDmgType_Melee');        
    }    
    //return;    
}

function AfterShock()
{
    local PKPlayerPawn PlayerPawn;

    // End:0x6B
    foreach DynamicActors(Class'PKPlayerPawn', PlayerPawn)
    {
        PlayerPawn.GetPC().ClientPlayCameraShake(CameraShake'PP_Resources.PlayerHitCameraShake', 0.8000000 - AfterShockCounter);        
    }    
    AfterShockCounter += 0.2000000;
    // End:0xA2
    if(AfterShockCounter < 0.7000000)
    {
        SetTimer(0.1000000, false, 'AfterShock', self);
    }
    //return;    
}

simulated function ProcessHitByFreezer(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x70
        case 'bIsSucking':
            // End:0x4E
            if(bIsSucking)
            {
                Twister.PlayAttack();                
            }
            else
            {
                Twister.StopAttack();
            }
            // End:0x168
            break;
        // End:0x152
        case 'bBreathActive':
            // End:0x12A
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
            // End:0x168
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
    DamageMultiplier=1.0000000
    BreakChainsDamageMultiplier=0.1000000
    StrikeDamage=50
    StrikeRadius=1024
    StrikeVelocity=2048
    StompAndPoundDamage=20
    StompAndPoundDamageRadius=1024
    MeteorDamage=20
    MeteorDamageRadius=512
    TornadoDamage=25
    TornadoDamageChance=0.7500000
    TornadoSuckInterval=7.5000000
    ZombieMovementRate=1.5000000
    TornadoRadius=2048
    TornadoVelocity=2048
    SpikeDamage=30
    SpikeVelocity=512
    bIsBoss=true
    bThrowSoul=false
    bCanBeFrozen=false
    bHasTIPAnims45Deg=true
    bHasTIPAnims90Deg=true
    bCanBePinned=false
    KillScoreSV=3.0000000
    // Reference: StaticMeshComponent'Default__PkPawn_Boss_Giant_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn_Boss_Base.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PkPawn_Boss_Giant_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn_Boss_Base.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    bCanPinToThisActor=false
    bCanBeKnockedDown=false
    SupremeMoveMode=EMoveMode.EMM_Walk
    DefaultHealth=10000.0000000
    PawnActionClasses=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PkPawn_Boss_Giant_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PkPawn_Boss_Giant_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn_Boss_Base.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    bSmoothNetUpdates=false
    // Reference: UTAmbientSoundComponent'Default__PkPawn_Boss_Giant_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PkPawn_Boss_Giant_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PkPawn_Boss_Giant_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    MaxLeanRoll=0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PkPawn_Boss_Giant_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PkPawn_Boss_Giant_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PkPawn_Boss_Giant_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PkPawn_Boss_Giant_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    MaxStepHeight=1000.0000000
    bIsWalking=true
    bCanBeBaseForPawns=true
    SightRadius=102400.0000000
    Mass=10000.0000000
    MaxPitchLimit=0
    // Reference: SkeletalMeshComponent'Default__PkPawn_Boss_Giant_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PkPawn_Boss_Giant_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PkPawn_Boss_Giant_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn_Boss_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PkPawn_Boss_Giant_Base.FaceAudioComponent'
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
}