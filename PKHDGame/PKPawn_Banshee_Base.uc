class PKPawn_Banshee_Base extends PKPawn
    config(Pawn)
    hidecategories(Navigation);

var export editinline ParticleSystemComponent BlackVomitEffectPSC;
var name BlackVomitSocket;
var class<PKPawn> RavenClass;
var int SpawnedRavens;
var int MaxSpawnedRavens;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x63
    if((BlackVomitEffectPSC != none) && BlackVomitSocket != 'None')
    {
        Mesh.AttachComponentToSocket(BlackVomitEffectPSC, BlackVomitSocket);
    }
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    super.PlayDying(DamageType, HitLoc);
    //return;    
}

function SpawnRavens()
{
    // End:0x48
    if(SpawnedRavens++ < MaxSpawnedRavens)
    {
        SpawnRaven();
        SetTimer(RandRange(0.1000000, 0.2000000), false, 'SpawnRavens');        
    }
    else
    {
        PainGRI(WorldInfo.GRI).BansheeSpawnRavensCount--;
    }
    //return;    
}

function SpawnRaven()
{
    local PKPawn PP;
    local int Num;

    // End:0x3A
    if(Controller != none)
    {
        Num = int(Controller.GetTeamNum());
    }
    PP = Spawn(RavenClass,,, Location, Rotation,, true);
    PP.bNoEncroachCheck = true;
    // End:0x164
    if(PP != none)
    {
        PP.AIFactory = AIFactory;
        PP.SpawnDefaultController();
        // End:0x164
        if(PP.Controller != none)
        {
            WorldInfo.Game.ChangeTeam(PP.Controller, Num, false);
        }
    }
    //return;    
}

simulated function OnScreamAttack()
{
    super.OnScreamAttack();
    // End:0x39
    if(BlackVomitEffectPSC != none)
    {
        BlackVomitEffectPSC.ActivateSystem();
    }
    // End:0x8A
    if(PKAI_Banshee(MyPKAI) != none)
    {
        PKAI_Banshee(MyPKAI).SetTimer(0.5000000, false, 'Fade', MyPKAI);
    }
    //return;    
}

simulated function OnScreamAttackEnd()
{
    super.OnScreamAttackEnd();
    // End:0x38
    if(BlackVomitEffectPSC != none)
    {
        BlackVomitEffectPSC.DeactivateSystem();
    }
    // End:0x89
    if(PKAI_Banshee(MyPKAI) != none)
    {
        PKAI_Banshee(MyPKAI).SetTimer(0.5000000, false, 'Unfade', MyPKAI);
    }
    //return;    
}

simulated state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0xBD
        if((int(WorldInfo.NetMode) != int(NM_Client)) && PainGRI(WorldInfo.GRI).BansheeSpawnRavensCount > 0)
        {
            TimeToBodyDisappear += (1.5000000 * float(PainGRI(WorldInfo.GRI).BansheeSpawnRavensCount));
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    event Timer()
    {
        super.Timer();
        // End:0x7B
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            PainGRI(WorldInfo.GRI).BansheeSpawnRavensCount++;
            SpawnRavens();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    MaxSpawnedRavens=5
    EnableGibWhenHPBelowFactor=-69.0000000
    // Reference: StaticMeshComponent'Default__PKPawn_Banshee_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Banshee_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    CharacterFootStepType=ECharacterFootStepType.CFST_Banshee
    DefaultHealth=80.0000000
    TimeToBodyDisappear=2.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Banshee_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Banshee_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Banshee_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Banshee_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Banshee_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Banshee_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Banshee_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Banshee_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Banshee_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bIsWalking=true
    Mass=80.0000000
    // Reference: SkeletalMeshComponent'Default__PKPawn_Banshee_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Banshee_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Banshee_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Banshee_Base.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPawn.FaceAudioComponent'
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
    RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
}