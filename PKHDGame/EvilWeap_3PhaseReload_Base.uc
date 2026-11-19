class EvilWeap_3PhaseReload_Base extends EvilWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

enum EReloadPhase
{
    ERP_None,                       // 0
    ERP_Start,                      // 1
    ERP_Loop,                       // 2
    ERP_End,                        // 3
    ERP_MAX                         // 4
};

var CameraAnim ReloadLoopCameraAnim;
var CameraAnim ReloadEndCameraAnim;
var export editinline AudioComponent ReloadSoundLoop;
var export editinline AudioComponent ReloadSoundEnd;
var export editinline UDKSkeletalMeshComponent SkeletonFirstPersonMesh;
var EvilWeap_3PhaseReload_Base.EReloadPhase ReloadPhase;

function ReloadOneAmmo()
{
    MagazineAmmoCount = Clamp(MagazineAmmoCount + 1, 0, MagazineMaxAmmoCount);
    //return;    
}

simulated event OnReloadStart(bool bResuming)
{
    local EvilPlayerController PC;
    local EvilPawn P;

    P = EvilPawn(Owner);
    PC = EvilPlayerController(P.Controller);
    // End:0x1F8
    if(P != none)
    {
        P.NotifyWeapReloadStart(self);
        // End:0xD2
        if((PC != none) && ReloadCameraAnim != none)
        {
            PC.PlayCameraAnim(ReloadCameraAnim,,, 0.2000000, 0.2000000);
        }
        P.AttachComponent(ReloadSoundComp);
        ReloadSoundComp.Play();
        PlayWeaponAnim('WeaponReload_1', 0.0000000, ReloadAnimBlendTimes.BlendIn);
        // End:0x198
        if(ArmsAnimSet != none)
        {
            PlayArmAnim('WeaponReload_1', 0.0000000, ReloadAnimBlendTimes.BlendIn);
        }
        SetTimer(SkeletonFirstPersonMesh.GetAnimLength('WeaponReload_1') / DefaultAnimSpeed, false, 'ReloadTimer');
        P.StartReload();
    }
    //return;    
}

simulated event OnReloadEnd(bool bInterrupted)
{
    super.OnReloadEnd(bInterrupted);
    // End:0x9D
    if(bInterrupted)
    {
        ReloadSoundLoop.Stop();
        ReloadSoundLoop.DetachFromAny();
        ReloadSoundEnd.Stop();
        ReloadSoundEnd.DetachFromAny();
    }
    //return;    
}

simulated event OnReloadLoop()
{
    local EvilPlayerController PC;
    local EvilPawn P;
    local float DesiredRate;

    ReloadOneAmmo();
    NeedReload = false;
    P = EvilPawn(Owner);
    PC = EvilPlayerController(P.Controller);
    // End:0x1C6
    if(P != none)
    {
        // End:0x104
        if((PC != none) && ReloadLoopCameraAnim != none)
        {
            DesiredRate = ReloadLoopCameraAnim.AnimLength / (GetReloadTime());
            PC.PlayCameraAnim(ReloadLoopCameraAnim,, DesiredRate, 0.2000000, 0.2000000);
        }
        P.AttachComponent(ReloadSoundLoop);
        ReloadSoundLoop.Play();
        PlayWeaponAnim('WeaponReload_2', GetReloadTime(), 0.0000000, 0.0000000,, true);
        // End:0x1AE
        if(ArmsAnimSet != none)
        {
            PlayArmAnim('WeaponReload_2', GetReloadTime(), 0.0000000, 0.0000000,, true);
        }
        SetTimer(GetReloadTime(), false, 'ReloadTimer');
    }
    //return;    
}

simulated event OnReloadEnding(bool bInterrupted)
{
    local EvilPlayerController PC;
    local EvilPawn P;

    P = EvilPawn(Owner);
    PC = EvilPlayerController(P.Controller);
    // End:0x225
    if(P != none)
    {
        // End:0xAA
        if(bInterrupted)
        {
            ReloadSoundLoop.Stop();
            ReloadSoundLoop.DetachFromAny();            
        }
        else
        {
            ReloadOneAmmo();
            NeedReload = false;
        }
        // End:0x116
        if((PC != none) && ReloadEndCameraAnim != none)
        {
            PC.PlayCameraAnim(ReloadEndCameraAnim,,, 0.2000000, 0.2000000);
        }
        P.AttachComponent(ReloadSoundEnd);
        ReloadSoundEnd.Play();
        PlayWeaponAnim('WeaponReload_3', 0.0000000, 0.0000000, ReloadAnimBlendTimes.BlendOut);
        // End:0x1E4
        if(ArmsAnimSet != none)
        {
            PlayArmAnim('WeaponReload_3', 0.0000000, 0.0000000, ReloadAnimBlendTimes.BlendOut);
        }
        SetTimer(SkeletonFirstPersonMesh.GetAnimLength('WeaponReload_3') / DefaultAnimSpeed, false, 'ReloadTimer');
    }
    //return;    
}

simulated state ReloadState
{
    simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
    {
        ReloadPhase = 0;
        return super.DoQuickHide(HideTime);
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xBB
        if((PC != none) && int(GetZoomedState()) == int(3))
        {
            EndZoom(PC);
            // End:0x9B
            if(int(Role) < int(ROLE_Authority))
            {
                ServerEndZoom(PC);
            }
            // End:0xBB
            if(int(ZoomedFireModeNum) < int(255))
            {
                ZoomedFireModeNum = 255;
            }
        }
        StopFireEffects(CurrentFireMode);
        // End:0xF9
        if(int(ReloadPhase) == int(0))
        {
            OnReloadStart(false);
            ReloadPhase = 1;
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2A
        if(NeedReload && MagazineAmmoCount > 0)
        {
            NeedReload = false;
        }
        super.EndState(NextStateName);
        //return;        
    }

    simulated function ReloadTimer()
    {
        switch(ReloadPhase)
        {
            // End:0x31
            case 1:
                OnReloadLoop();
                ReloadPhase = 2;
                // End:0xA4
                break;
            // End:0x74
            case 2:
                // End:0x5A
                if(MagazineAmmoCount < MagazineMaxAmmoCount)
                {
                    OnReloadLoop();                    
                }
                else
                {
                    OnReloadEnding(false);
                    ReloadPhase = 3;
                }
                // End:0xA4
                break;
            // End:0xA1
            case 3:
                ReloadPhase = 0;
                OnReloadEnd(false);
                GotoState('Active');
                // End:0xA4
                break;
            // End:0xFFFF
            default:
                break;
        }
        //return;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        super.StartFire(FireModeNum);
        // End:0x62
        if((int(FireModeNum) >= bZoomedFireMode.Length) || int(bZoomedFireMode[int(FireModeNum)]) == int(0))
        {
            global.StartFire(FireModeNum);
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        global.BeginFire(FireModeNum);
        // End:0x101
        if(!bDeleteMe && Instigator != none)
        {
            // End:0x101
            if((PendingFire(int(FireModeNum)) && HasAmmo(FireModeNum)) && MagazineAmmoCount > 0)
            {
                // End:0xC2
                if(int(ReloadPhase) == int(1))
                {
                    OnReloadEnd(true);
                    ReloadPhase = 0;
                    NeedReload = false;
                    SendToFiringState(FireModeNum);                    
                }
                else
                {
                    // End:0x101
                    if(int(ReloadPhase) == int(2))
                    {
                        ClearTimer('ReloadTimer');
                        OnReloadEnding(true);
                        ReloadPhase = 3;
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

simulated state SprintState
{
    simulated function BeginState(name PreviousStateName)
    {
        local AnimTree Tree;
        local EvilPlayerController PC;
        local editinline SkeletalMeshComponent ArmMeshComp;

        BobDamping = 1.0000000;
        JumpDamping = 1.0000000;
        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xBE
        if((int(GetZoomedState()) != int(0)) && int(ZoomedFireModeNum) < int(255))
        {
            EndZoom(PC);
            // End:0xBE
            if(int(Role) < int(ROLE_Authority))
            {
                ServerEndZoom(PC);
            }
        }
        Tree = AnimTree(SkeletalMeshComponent(Mesh).Animations);
        // End:0x177
        if((Tree != none) && CustomAnimNode == none)
        {
            AnimNodeBlend(Tree.Children[0].Anim).SetBlendTarget(1.0000000, 0.2000000);            
        }
        else
        {
            PlayWeaponAnim(WeaponSprintAnim, 0.0000000, SprintAnimBlendTimes.BlendIn, SprintAnimBlendTimes.BlendOut, true,, ((UsesOffhand) ? (SkeletalMeshComponent(Mesh).GetAnimLength(WeaponSprintAnim) / DefaultAnimSpeed) * SprintAnimOffHandOffset : 0.0000000));
        }
        // End:0x269
        if(!UsesOffhand)
        {
            ArmMeshComp = EvilPawn(Owner).ArmsMesh[0];            
        }
        else
        {
            ArmMeshComp = EvilPawn(Owner).ArmsMesh[1];
        }
        // End:0x408
        if(ArmMeshComp != none)
        {
            Tree = AnimTree(ArmMeshComp.Animations);
            // End:0x35B
            if((Tree != none) && CustomArmAnimNode == none)
            {
                AnimNodeBlend(Tree.Children[0].Anim).SetBlendTarget(1.0000000, 0.2000000);                
            }
            else
            {
                PlayArmAnim(ArmSprintAnim, 0.0000000, SprintAnimBlendTimes.BlendIn, SprintAnimBlendTimes.BlendOut, true,, ((UsesOffhand) ? (SkeletalMeshComponent(Mesh).GetAnimLength(ArmSprintAnim) / DefaultAnimSpeed) * SprintAnimOffHandOffset : 0.0000000));
            }
        }
        SprintAnimOffHandOffset = default.SprintAnimOffHandOffset;
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        ReloadPhase = 0;
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__EvilWeap_3PhaseReload_Base.ReloadSoundLoopComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSoundLoopComp'
    begin object name="ReloadSoundLoopComp" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    ReloadSoundLoop=ReloadSoundLoopComp
    // Reference: AudioComponent'Default__EvilWeap_3PhaseReload_Base.ReloadSoundEndComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSoundEndComp'
    begin object name="ReloadSoundEndComp" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    ReloadSoundEnd=ReloadSoundEndComp
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_3PhaseReload_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__EvilWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__EvilWeap_3PhaseReload_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__EvilWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_3PhaseReload_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: UDKSkeletalMeshComponent'Default__EvilWeap_3PhaseReload_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__EvilWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__EvilWeap_3PhaseReload_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__EvilWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    Components[2]=ReloadSoundLoopComp
    Components[3]=ReloadSoundEndComp
}