class AdvPawn_PolarBear_Base extends AdvPawn
    abstract
    config(Pawn)
    hidecategories(Navigation);

const AddNextHitTime = 6.0;

var float Vel;

function StartMeleeAttack()
{
    DoMeleeAttackDamage();
    PlayMeleeAttackVoice();
    ServerDoPawnAction(5,,, GetMeleeAnimIndex());
    //return;    
}

function DoMeleeAttackDamage()
{
    local EvilWeap_Melee_Base Wpn;

    Wpn = EvilWeap_Melee_Base(MeleeWeapon);
    // End:0x47
    if(Wpn == none)
    {
        Wpn = EvilWeap_Melee_Base(Weapon);
    }
    // End:0x9D
    if(Wpn != none)
    {
        Wpn.DoMeleeDamage(DamageScaling, Controller.Enemy);
    }
    //return;    
}

function MoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    super(EvilPawn).MoveModeChanged(InNewMode, InOldMode);
    // End:0x42
    if(int(CurrentMoveMode) == int(2))
    {
        Vel = 3.5000000;        
    }
    else
    {
        // End:0x65
        if(int(CurrentMoveMode) == int(1))
        {
            Vel = 1.5000000;
        }
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    MoveSmooth((Acceleration * DeltaTime) * Vel);
    SetMovementPhysics();
    super.Tick(DeltaTime);
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    //return;    
}

function EvilAnimInfo MakeEvilAnimInfo(name AnimName)
{
    local EvilAnimInfo AnimInfo;

    AnimInfo.AnimName = AnimName;
    return AnimInfo;
    //return ReturnValue;    
}

function RecomputeNextHitTime()
{
    NextHitTime = (WorldInfo.TimeSeconds + 6.0000000) + (FRand() * float(4));
    //return;    
}

defaultproperties
{
    Vel=3.5000000
    // Reference: SkeletalMeshComponent'Default__AdvPawn_PolarBear_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_PolarBear_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_PolarBear_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPawn_PolarBear_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bShouldPlayDeathAnimationToRagdoll=true
    DefaultInventory=/* Array type was not detected. */
    PawnActionClasses=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_PolarBear_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_PolarBear_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    CurrCharClassInfo=Class'AdvFamilyInfo_PolarBear'
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_PolarBear_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_PolarBear_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_PolarBear_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_PolarBear_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_PolarBear_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_PolarBear_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_PolarBear_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_PolarBear_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bCanStrafe=false
    // Reference: SkeletalMeshComponent'Default__AdvPawn_PolarBear_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_PolarBear_Base.MyLightEnvironment'
        Translation=(X=-150.0000000,Y=0.0000000,Z=-90.0000000)
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_PolarBear_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=90.0000000
        CollisionRadius=160.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_PolarBear_Base.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=PawnBlocker0
    Components[7]=FaceAudioComponent
    Components[8]=SPawnSkeletalMeshComponent
    Components[9]=SizzleAudioComponent0
    CollisionComponent=CollisionCylinder
}