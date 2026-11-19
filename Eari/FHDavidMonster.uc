class FHDavidMonster extends UTPawn
	ClassGroup(ForeverHunted);

var() ParticleSystemComponent testParticle;

var AnimTree         defaultAnimTree;
var array<AnimSet>   defaultAnimSet;
var AnimNodeSequence defaultAnimSeq;

var SoundCue       CueMonsterDistance;
var SoundCue       CueMonsterSeesPlayer;
var AudioComponent AudioMonsterSeesPlayer;
var AudioComponent AudioMonsterDistance;

var FHPlayer       MyPlayer;
var bool           bMonsterSeesPlayer;
var float          DistanceToPlayer;
var float          PlayerAwarenessDistance; // I become aware of player at this distance
var float          PlayerDistanceCheckIntervalInSeconds; // how often to check
var float          MonsterDeathTouchRadius; // within this radius, player dies instantly

enum EPlayerDistance
    {
        PD_Far,             // too far for player to sense me
        PD_Near,            // close enough to alert player to my presence
        PD_UnknownDistance  // initial condition  
    };

var EPlayerDistance PlayerDistanceState;
var float           PlayerDistanceNear;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// System Overrides
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	InitializeMonster();
}


simulated function Tick (float deltaSeconds)
{
	MonsterTick (deltaSeconds);
}

//override to do nothing
simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
}


//////////////////////////////////////////////////////////////////////////////
// Monster Functionality

function InitializeMonster()
{
    AudioMonsterSeesPlayer = CreateAudioComponent (CueMonsterSeesPlayer);
    AudioMonsterDistance   = CreateAudioComponent (CueMonsterDistance);
    PlayerDistanceState    = EPlayerDistance.PD_UnknownDistance;
}

function SetPlayer (FHPlayer player)
{
    MyPlayer = player;
}

function MonsterTick (float deltaSeconds)
{
    local bool lbMonsterSawPlayer;
    if (MyPlayer == none) return;

    PlayerDistanceCheckIntervalInSeconds -= deltaSeconds;
    if (PlayerDistanceCheckIntervalInSeconds > 0.0) return;
    PlayerDistanceCheckIntervalInSeconds = Default.PlayerDistanceCheckIntervalInSeconds;

    DistanceToPlayer = VSize(self.Location - MyPlayer.Location);
  //  `log("FHMonster.MonsterTick() -- " $ DistanceToPlayer);

    lbMonsterSawPlayer = bMonsterSeesPlayer;
    bMonsterSeesPlayer = PlayerIsVisible ();
    if (lbMonsterSawPlayer != bMonsterSeesPlayer)
        {
        if (bMonsterSeesPlayer) MonsterSeesPlayer ();
        else                    MonsterNoLongerSeesPlayer ();
        }

    if (DistanceToPlayer <= MonsterDeathTouchRadius)
        {
        MyPlayer.Bump (self, none, self.Location);
        }
    else if (DistanceToPlayer <= PlayerDistanceNear)
        {
        if (PlayerDistanceState != EPlayerDistance.PD_Near)
            {
            PlayerIsNear ();
            }
        }
    else
        {
        if (PlayerDistanceState != EPlayerDistance.PD_Far)
            {
            PlayerIsFar ();
            }
        }
}

function MonsterSeesPlayer ()
    {
        LogInternal("FHMonster.MonsterSeesPlayer() ----");
    AudioMonsterSeesPlayer.Play ();
    }

function MonsterNoLongerSeesPlayer ()
    {
        LogInternal("FHMonster.MonsterNoLongerSeesPlayer() ----");
    AudioMonsterSeesPlayer.Stop ();
    }

function PlayerIsNear ()
    {
        LogInternal("FHMonster.PlayerIsNear() ----");
    PlayerDistanceState = EPlayerDistance.PD_Near;
    AudioMonsterDistance.Play ();
    }

function PlayerIsFar ()
    {
        LogInternal("FHMonster.PlayerIsFar() ----");
    PlayerDistanceState = EPlayerDistance.PD_Far;
    AudioMonsterDistance.Stop ();
    }

function bool PlayerIsVisible()
    {
    local FHPlayer lPlayer;

    foreach VisibleActors (class'FHPlayer', lPlayer)
        {
        return true;
        }
    return false;
    }

event Bump (Actor Other, PrimitiveComponent otherComp, Vector hitNormal)
    {
    local FHPlayer lPlayer;

    lPlayer = FHPlayer(Other);
    if (lPlayer != none) // ignore any actors except the player
        {
        // Bump him back. This will properly handle the case where Player is Invulnerable
	    LogInternal("FHSeekerMonsterPawn.Bump() -- Bumped into by " $ Other);
        Other.Bump (self, otherComp, hitNormal);
        }
    }


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: ParticleSystemComponent'Default__FHDavidMonster.ParticleSystemComponent1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ParticleSystemComponent1'
    begin object name="ParticleSystemComponent1" class=Class'Engine.ParticleSystemComponent'
        Template=ParticleSystem'FH_particle.Smoke.smoke_single_monster'
        ReplacementPrimitive=none
    end object
    testParticle=ParticleSystemComponent1
    CueMonsterDistance=SoundCue'FH_Sounds.A_lowbassambience_Que'
    CueMonsterSeesPlayer=SoundCue'FH_Sounds.monster.A_MonsterSeesPlayer_Cue'
    PlayerAwarenessDistance=5000.0000000
    PlayerDistanceCheckIntervalInSeconds=0.2000000
    MonsterDeathTouchRadius=100.0000000
    PlayerDistanceNear=5000.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__FHDavidMonster.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__FHDavidMonster.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__FHDavidMonster.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__FHDavidMonster.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__FHDavidMonster.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__FHDavidMonster.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__FHDavidMonster.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__FHDavidMonster.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__FHDavidMonster.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bCanCrouch=false
    bJumpCapable=false
    bCanJump=false
    ControllerClass=Class'FHDavidController'
    // Reference: SkeletalMeshComponent'Default__FHDavidMonster.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'ERIE_Greg.GoodMonster'
        AnimTreeTemplate=AnimTree'ERIE_Greg.MonsterAnimTree'
        AnimSets[0]=AnimSet'ERIE_Greg.monster_Anims1'
        ReplacementPrimitive=none
        bAcceptsDynamicDecals=true
    end object
    Mesh=SkeletalMeshComponent0
    // Reference: CylinderComponent'Default__FHDavidMonster.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UTGame.Default__UTPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionRadius=16.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__FHDavidMonster.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Arrow'
    // Archetype: ArrowComponent'UTGame.Default__UTPawn.Arrow'
    begin object name="Arrow"
        ReplacementPrimitive=none
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    // Reference: SkeletalMeshComponent'Default__FHDavidMonster.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__FHDavidMonster.MyLightEnvironment'
    end object
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=SkeletalMeshComponent0
    CollisionComponent=CollisionCylinder
}