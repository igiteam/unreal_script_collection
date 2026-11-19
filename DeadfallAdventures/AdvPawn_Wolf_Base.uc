class AdvPawn_Wolf_Base extends AdvPawn
    abstract
    config(Pawn)
    hidecategories(Navigation);

const AddNextHitTime = 6.0;

function StartMeleeAttack()
{
    self.DoMeleeAttackDamage();
    self.PlayMeleeAttackVoice();
    self.ServerDoPawnAction(5,,, GetMeleeAnimIndex());
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
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Wolf_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_Wolf_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_Wolf_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPawn_Wolf_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bShouldPlayDeathAnimationToRagdoll=true
    DefaultInventory=/* Array type was not detected. */
    PawnActionClasses=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_Wolf_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_Wolf_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    CurrCharClassInfo=Class'AdvFamilyInfo_Wolf'
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_Wolf_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Wolf_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Wolf_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Wolf_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_Wolf_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_Wolf_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_Wolf_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_Wolf_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bCanStrafe=false
    HealthMax=200
    DamageScaling=5.0000000
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Wolf_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_Wolf_Base.MyLightEnvironment'
        Translation=(X=-40.0000000,Y=0.0000000,Z=-22.0000000)
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_Wolf_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=20.0000000
        CollisionRadius=30.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_Wolf_Base.FaceAudioComponent'
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