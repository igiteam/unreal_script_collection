class PKWeap_Chaingun_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var(Animations) name WeaponFireEndAnim;
var(Animations) name ArmFireEndAnim;
var transient bool bIsRecoveringFromFire;
var export editinline AudioComponent ChaingunSoundLoopComp;
var SoundCue ChaingunSoundLoopCue1p;
var export editinline AudioComponent ChaingunSoundEndComp;
var SoundCue ChaingunSoundEndCue1p;
var export editinline AudioComponent ShellsSoundLoopComp;
var SoundCue ShellsSoundLoopCue1p;

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    super.AttachWeaponTo(MeshCpnt, SocketName);
    // End:0x11D
    if(Instigator.IsFirstPerson())
    {
        ChaingunSoundLoopComp.SoundCue = ChaingunSoundLoopCue1p;
        ChaingunSoundLoopComp.bAllowSpatialization = false;
        ChaingunSoundEndComp.SoundCue = ChaingunSoundEndCue1p;
        ChaingunSoundEndComp.bAllowSpatialization = false;
        ShellsSoundLoopComp.SoundCue = ShellsSoundLoopCue1p;
        ShellsSoundLoopComp.bAllowSpatialization = false;        
    }
    else
    {
        // End:0x1F2
        if(Instigator.PlayerReplicationInfo == none)
        {
            DetachComponent(ChaingunSoundLoopComp);
            Instigator.AttachComponent(ChaingunSoundLoopComp);
            DetachComponent(ChaingunSoundEndComp);
            Instigator.AttachComponent(ChaingunSoundEndComp);
            DetachComponent(ShellsSoundLoopComp);
            Instigator.AttachComponent(ShellsSoundLoopComp);
        }
    }
    //return;    
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local float SavedDamage;

    SavedDamage = InstantHitDamage[1];
    // End:0x4B
    if((int(FiringMode) == int(0)) && HasWeaponModifier())
    {
        InstantHitDamage[1] *= 1.5000000;
    }
    super(EvilWeap_Base).ProcessInstantHit(FiringMode, Impact, NumHits);
    InstantHitDamage[1] = SavedDamage;
    //return;    
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    // End:0x33
    if(int(FireModeNum) == int(0))
    {
        super(EvilWeap_Base).PlayFireEffects(FireModeNum, HitLocation);
        return;
    }
    CauseMuzzleFlash();
    ShakeView();
    //return;    
}

simulated function HandleFinishedFiring()
{
    // End:0x105
    if(int(CurrentFireMode) == int(1))
    {
        // End:0x7E
        if(WeaponFireEndAnim != 'None')
        {
            PlayWeaponAnim(WeaponFireEndAnim, 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
        }
        // End:0xF9
        if((ArmFireEndAnim != 'None') && ArmsAnimSet != none)
        {
            PlayArmAnim(ArmFireEndAnim, 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
        }
        bIsRecoveringFromFire = true;
    }
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

function ConsumeAmmo(byte FireModeNum)
{
    local PainWeap_Base ShareWeap;

    super.ConsumeAmmo(FireModeNum);
    ShareWeap = PainWeap_Base(Instigator.InvManager.FindInventoryType(Class'PKWeap_Stakegun_Base', true));
    // End:0xD0
    if(((int(FireModeNum) == int(0)) && Instigator.Weapon == self) && ShareWeap != none)
    {
        ShareWeap.ConsumeAmmo(1);
    }
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x265
        if(int(CurrentFireMode) == int(1))
        {
            bIsRecoveringFromFire = false;
            // End:0xD1
            if((int(CurrentFireMode) < WeaponFireAnim.Length) && WeaponFireAnim[int(CurrentFireMode)] != 'None')
            {
                PlayWeaponAnim(WeaponFireAnim[int(CurrentFireMode)], 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut, true, true);
            }
            // End:0x180
            if(((int(CurrentFireMode) < ArmFireAnim.Length) && ArmFireAnim[int(CurrentFireMode)] != 'None') && ArmsAnimSet != none)
            {
                PlayArmAnim(ArmFireAnim[int(CurrentFireMode)], 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut, true, true);
            }
            // End:0x1CB
            if(ChaingunSoundEndComp.IsPlaying())
            {
                ChaingunSoundEndComp.FadeOut(0.1000000, 0.0000000);
            }
            // End:0x218
            if(!ShellsSoundLoopComp.IsPlaying())
            {
                ShellsSoundLoopComp.FadeIn(0.1000000, 1.0000000);
            }
            // End:0x265
            if(!ChaingunSoundLoopComp.IsPlaying())
            {
                ChaingunSoundLoopComp.FadeIn(0.1000000, 1.0000000);
            }
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        // End:0x4B
        if(ChaingunSoundLoopComp.IsPlaying())
        {
            ChaingunSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x96
        if(ShellsSoundLoopComp.IsPlaying())
        {
            ShellsSoundLoopComp.FadeOut(0.9000000, 0.0000000);
        }
        // End:0xE3
        if(!ChaingunSoundEndComp.IsPlaying())
        {
            ChaingunSoundEndComp.FadeIn(0.1000000, 1.0000000);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function RestartIdleAnim(optional bool bInstant = false)
    {
        // End:0x28
        if(!bIsRecoveringFromFire)
        {
            super.RestartIdleAnim(bInstant);
        }
        //return;        
    }

    simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        // End:0x19
        if(bIsRecoveringFromFire)
        {
            bIsRecoveringFromFire = false;
        }
        super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__PKWeap_Chaingun_Base.ChaingunSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ChaingunSoundLoop'
    begin object name="ChaingunSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    ChaingunSoundLoopComp=ChaingunSoundLoop
    // Reference: AudioComponent'Default__PKWeap_Chaingun_Base.ChaingunSoundEnd'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ChaingunSoundEnd'
    begin object name="ChaingunSoundEnd" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    ChaingunSoundEndComp=ChaingunSoundEnd
    // Reference: AudioComponent'Default__PKWeap_Chaingun_Base.ShellsSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ShellsSoundLoop'
    begin object name="ShellsSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    ShellsSoundLoopComp=ShellsSoundLoop
    bPurchasedWeaponDLC=true
    MaxAmmoAltCount=500
    LowAmmoCountWarningThreshold=5
    LowAmmoAltCountWarningThreshold=50
    bFastRepeater=true
    MaxAmmoCount=100
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Chaingun_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=4
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_Chaingun_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Chaingun_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Chaingun"
    CurrentRating=0.8000000
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    bInstantHit=true
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Chaingun_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Chaingun_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__PainWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    Components[2]=ChaingunSoundLoop
    Components[3]=ChaingunSoundEnd
    Components[4]=ShellsSoundLoop
}