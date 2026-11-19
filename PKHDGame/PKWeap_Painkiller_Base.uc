class PKWeap_Painkiller_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var(Animations) name WeaponFireStartAnim;
var(Animations) name ArmFireStartAnim;
var(Animations) name WeaponFireEndAnim;
var(Animations) name ArmFireEndAnim;
var(Animations) name WeaponAltFireEndAnim;
var(Animations) name ArmAltFireEndAnim;
var transient bool bIsRecoveringFromFire;
var transient bool bBladesFired;
var export editinline AudioComponent BladesSoundLoopComp;
var SoundCue BladesSoundLoopCue1p;
var export editinline AudioComponent BladesSoundStartComp;
var SoundCue BladesSoundStartCue1p;
var export editinline AudioComponent BladesSoundEndComp;
var SoundCue BladesSoundEndCue1p;
var export editinline AudioComponent BeamSoundLoopComp;
var SoundCue BladeReturnSound;
var SoundCue BladeReloadSound;
var SoundCue BladeReloadSound1p;
var repnotify PKProjectile_PainkillerBlades_Base Blades;
var() ParticleSystem BeamTemplate;
var export editinline ParticleSystemComponent BeamEmitter;
var() name BeamSocket;
var() name EndPointParamName;
var float ReaquireTimer;

replication
{
    // Pos:0x000
    if(bNetOwner)
        Blades, bBladesFired;
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    super.AttachWeaponTo(MeshCpnt, SocketName);
    // End:0x11D
    if(Instigator.IsFirstPerson())
    {
        BladesSoundLoopComp.SoundCue = BladesSoundLoopCue1p;
        BladesSoundLoopComp.bAllowSpatialization = false;
        BladesSoundStartComp.SoundCue = BladesSoundStartCue1p;
        BladesSoundStartComp.bAllowSpatialization = false;
        BladesSoundEndComp.SoundCue = BladesSoundEndCue1p;
        BladesSoundEndComp.bAllowSpatialization = false;        
    }
    else
    {
        // End:0x1F2
        if(Instigator.PlayerReplicationInfo == none)
        {
            DetachComponent(BladesSoundLoopComp);
            Instigator.AttachComponent(BladesSoundLoopComp);
            DetachComponent(BladesSoundStartComp);
            Instigator.AttachComponent(BladesSoundStartComp);
            DetachComponent(BladesSoundEndComp);
            Instigator.AttachComponent(BladesSoundEndComp);
        }
    }
    // End:0x287
    if((Instigator != none) && PKPlayerController(Instigator.Controller) != none)
    {
        BobDamping = ((PKPlayerController(Instigator.Controller).GlobalWeaponBobDamping - float(1)) * 0.3000000) + float(1);
    }
    //return;    
}

simulated function RefreshWeaponParamsFromPC(PKPlayerController PC)
{
    BobDamping = ((PC.GlobalWeaponBobDamping - float(1)) * 0.3000000) + float(1);
    //return;    
}

simulated function CustomFire()
{
    local Vector RealStartLoc, StoredHitLoc, TraceStart, TraceEnd;
    local ImpactInfo Impact;
    local int I, J;
    local Rotator DefRayDirRot, CurrRayDirRot;
    local bool bHitPawn;

    // End:0x167
    if(int(CurrentFireMode) > int(0))
    {
        IncrementFlashCountEvil();
        // End:0x164
        if(int(Role) == int(ROLE_Authority))
        {
            RealStartLoc = GetPhysicalFireStartLoc();
            Blades = PKProjectile_PainkillerBlades_Base(Spawn(GetProjectileClass(),,, RealStartLoc));
            // End:0x164
            if((Blades != none) && !Blades.bDeleteMe)
            {
                bBladesFired = true;
                Blades.Damage = WeaponDamage[int(CurrentFireMode)];
                Blades.MomentumTransfer = WeaponMomentum[int(CurrentFireMode)];
                Blades.Init(Vector(GetAdjustedAim(RealStartLoc)));
                SetupBlades();
            }
        }        
    }
    else
    {
        bHitPawn = false;
        PlayFireEffects(CurrentFireMode);
        TraceStart = InstantFireStartTrace();
        TraceEnd = InstantFireEndTrace(TraceStart);
        DefRayDirRot = Rotator(Normal(TraceEnd - TraceStart));
        Impact = CalcWeaponFire(TraceStart, TraceEnd);
        StoredHitLoc = Impact.HitLocation;
        // End:0x3AD
        if(Impact.HitActor != none)
        {
            CheckAndUpdateHitEnemyIndicator(Impact.HitActor);
            Impact.HitActor.TakeDamage(int(InstantHitDamage[0]), Instigator.Controller, Impact.HitLocation, Impact.HitLocation - Instigator.Location, InstantHitDamageTypes[0], Impact.HitInfo, self);
            SetFlashLocation(Impact.HitLocation);
            // End:0x3AA
            if(Pawn(Impact.HitActor) != none)
            {
                bHitPawn = true;
            }            
        }
        else
        {
            I = -1;
            J0x3BC:

            // End:0x717 [Loop If]
            if(I < 2)
            {
                // End:0x3DE
                if(I == 0)
                {                    
                }
                else
                {
                    J = -1;
                    J0x3ED:

                    // End:0x709 [Loop If]
                    if(J < 2)
                    {
                        // End:0x40F
                        if(J == 0)
                        {                            
                        }
                        else
                        {
                            TraceStart = InstantFireStartTrace();
                            CurrRayDirRot = DefRayDirRot;
                            CurrRayDirRot.Pitch = int(float(DefRayDirRot.Pitch) + (float(I * 10) * 182.0444000));
                            CurrRayDirRot.Yaw = int(float(DefRayDirRot.Yaw) + (float(J * 10) * 182.0444000));
                            TraceEnd = TraceStart + (Vector(CurrRayDirRot) * (GetTraceRange()));
                            Impact = CalcWeaponFire(TraceStart, TraceEnd);
                            // End:0x6FB
                            if(Impact.HitActor != none)
                            {
                                CheckAndUpdateHitEnemyIndicator(Impact.HitActor);
                                Impact.HitActor.TakeDamage(int(InstantHitDamage[0]), Instigator.Controller, Impact.HitLocation, Impact.HitLocation - Instigator.Location, InstantHitDamageTypes[0], Impact.HitInfo, self);
                                SetFlashLocation(Impact.HitLocation);
                                // End:0x6F9
                                if(Pawn(Impact.HitActor) != none)
                                {
                                    PKPlayerPawn(Instigator).GetPC().ClientPlayCameraShake(CameraShake'PP_Resources.PlayerHitCameraShake', 0.5000000, false);
                                }
                                return;
                            }
                        }
                        J++;
                        // [Loop Continue]
                        goto J0x3ED;
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x3BC;
            }
            SetFlashLocation(StoredHitLoc);
        }
        // End:0x786
        if(bHitPawn)
        {
            PKPlayerPawn(Instigator).GetPC().ClientPlayCameraShake(CameraShake'PP_Resources.PlayerHitCameraShake', 0.5000000, false);
        }
    }
    //return;    
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local float SavedDamage;

    SavedDamage = InstantHitDamage[0];
    // End:0x4A
    if((int(FiringMode) == int(0)) && HasWeaponModifier())
    {
        InstantHitDamage[0] *= float(2);
    }
    super(EvilWeap_Base).ProcessInstantHit(FiringMode, Impact, NumHits);
    InstantHitDamage[0] = SavedDamage;
    //return;    
}

simulated function SetupBlades()
{
    // End:0x2F
    if(Blades != none)
    {
        Blades.PainkillerWeap = self;
    }
    //return;    
}

reliable client simulated function ClientNotifyBladeReturn()
{
    // End:0x6C
    if(int(Role) < int(ROLE_Authority))
    {
        bBladesFired = false;
        // End:0x6C
        if(IsFiring())
        {
            StopFire(CurrentFireMode);
            ClearPendingFire(0);
            ClearPendingFire(1);
            ClearPendingFire(2);
            HandleFinishedFiring();
        }
    }
    WeaponPlaySound(BladeReloadSound, BladeReloadSound1p);
    //return;    
}

function NotifyBladeReturn()
{
    bBladesFired = false;
    ClientNotifyBladeReturn();
    // End:0x62
    if(IsFiring())
    {
        StopFire(CurrentFireMode);
        ClearPendingFire(0);
        ClearPendingFire(1);
        ClearPendingFire(2);
        HandleFinishedFiring();
    }
    //return;    
}

reliable client simulated function ClientNotifyBladeDestroyed()
{
    // End:0x8A
    if(int(Role) < int(ROLE_Authority))
    {
        // End:0x7E
        if((IsFiring()) && bBladesFired)
        {
            bBladesFired = false;
            StopFire(CurrentFireMode);
            ClearPendingFire(0);
            ClearPendingFire(1);
            ClearPendingFire(2);
            HandleFinishedFiring();            
        }
        else
        {
            bBladesFired = false;
        }
    }
    //return;    
}

function NotifyBladeDestroyed()
{
    ClientNotifyBladeDestroyed();
    // End:0x74
    if((IsFiring()) && bBladesFired)
    {
        bBladesFired = false;
        StopFire(CurrentFireMode);
        ClearPendingFire(0);
        ClearPendingFire(1);
        ClearPendingFire(2);
        HandleFinishedFiring();        
    }
    else
    {
        bBladesFired = false;
    }
    //return;    
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    // End:0x1E
    if(HitLocation != vect(0.0000000, 0.0000000, 0.0000000))
    {
        return;
    }
    // End:0x1C5
    if(int(FireModeNum) > int(0))
    {
        // End:0xDE
        if((int(FireModeNum) < WeaponFireAnim.Length) && WeaponFireAnim[int(FireModeNum)] != 'None')
        {
            PlayWeaponAnim(WeaponFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
        }
        // End:0x19B
        if(((int(FireModeNum) < ArmFireAnim.Length) && ArmFireAnim[int(FireModeNum)] != 'None') && ArmsAnimSet != none)
        {
            PlayArmAnim(ArmFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
        }
        // End:0x1B9
        if(int(FireModeNum) == int(1))
        {
            CauseMuzzleFlash();
        }
        ShakeView();
        return;
    }
    // End:0x1DC
    if(HasWeaponModifier())
    {
        CauseMuzzleFlash();
    }
    ShakeView();
    //return;    
}

simulated function HandleFinishedFiring()
{
    // End:0x46
    if(bBladesFired || (Blades != none) && !Blades.bShuttingDown)
    {
        return;
    }
    // End:0x14E
    if(int(CurrentFireMode) == int(0))
    {
        // End:0xC4
        if(WeaponFireEndAnim != 'None')
        {
            PlayWeaponAnim(WeaponFireEndAnim, 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
        }
        // End:0x13F
        if((ArmFireEndAnim != 'None') && ArmsAnimSet != none)
        {
            PlayArmAnim(ArmFireEndAnim, 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
        }
        bIsRecoveringFromFire = true;        
    }
    else
    {
        StopFire(CurrentFireMode);
    }
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated function bool ShouldRefire()
{
    // End:0x22
    if(int(CurrentFireMode) == int(0))
    {
        return super(EvilWeap_Base).ShouldRefire();        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function StartBladesLoopSound()
{
    // End:0x4B
    if(BladesSoundStartComp.IsPlaying())
    {
        BladesSoundStartComp.FadeOut(0.1000000, 0.0000000);
    }
    // End:0x96
    if(BladesSoundEndComp.IsPlaying())
    {
        BladesSoundEndComp.FadeOut(0.1000000, 0.0000000);
    }
    // End:0xE3
    if(!BladesSoundLoopComp.IsPlaying())
    {
        BladesSoundLoopComp.FadeIn(0.1000000, 1.0000000);
    }
    //return;    
}

simulated function AddBeamEmitter()
{
    // End:0x16E
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x14E
        if(BeamEmitter == none)
        {
            // End:0x14B
            if(BeamTemplate != none)
            {
                BeamEmitter = new (Outer) Class'EvilGame.UTParticleSystemComponent';
                BeamEmitter.SetTemplate(BeamTemplate);
                BeamEmitter.SetHidden(true);
                BeamEmitter.SetTickGroup(3);
                BeamEmitter.bUpdateComponentInTick = true;
                BeamEmitter.SetIgnoreOwnerHidden(true);
                SkeletalMeshComponent(Mesh).AttachComponentToSocket(BeamEmitter, BeamSocket);
            }            
        }
        else
        {
            BeamEmitter.ActivateSystem();
        }
    }
    //return;    
}

simulated function SetBeamEmitterHidden(bool bHide)
{
    // End:0x38
    if(BeamEmitter != none)
    {
        BeamEmitter.SetHidden(bHide);
    }
    //return;    
}

simulated function KillBeamEmitter()
{
    // End:0x4E
    if(BeamEmitter != none)
    {
        BeamEmitter.SetHidden(true);
        BeamEmitter.DeactivateSystem();
    }
    //return;    
}

simulated function UpdateBeam(float DeltaTime)
{
    local Vector StartTrace, EndTrace, AimDir;
    local bool bAimTest;
    local float Distance, AimRange;

    // End:0x2D7
    if(bBladesFired && Blades != none)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        AimDir = Vector(GetAdjustedAim(StartTrace));
        EndTrace = Blades.Location;
        Distance = VSize(EndTrace - StartTrace);
        AimRange = FClamp(1.5000000 * (Distance / float(600)), 0.7500000, 0.9830000);
        bAimTest = (AimDir Dot Normal(EndTrace - StartTrace)) > ((HasWeaponModifier()) ? 0.5000000 : AimRange);
        // End:0x21F
        if(bAimTest && FastTrace(EndTrace, StartTrace))
        {
            // End:0x184
            if(!IsTimerActive('DoBeamDamage'))
            {
                SetTimer(FireInterval[0], true, 'DoBeamDamage');
            }
            SetBeamEmitterHidden(false);
            BeamEmitter.SetVectorParameter(EndPointParamName, EndTrace);
            // End:0x20D
            if(!BeamSoundLoopComp.IsPlaying())
            {
                BeamSoundLoopComp.FadeIn(0.1000000, 1.0000000);
            }
            ReaquireTimer = 0.2000000;            
        }
        else
        {
            ReaquireTimer -= DeltaTime;
            // End:0x2D4
            if(ReaquireTimer <= float(0))
            {
                ClearTimer('DoBeamDamage');
                SetBeamEmitterHidden(true);
                // End:0x2D4
                if(BeamSoundLoopComp.IsPlaying() && !BeamSoundLoopComp.IsFadingOut())
                {
                    BeamSoundLoopComp.FadeOut(0.1000000, 0.0000000);
                }
            }
        }        
    }
    else
    {
        SetBeamEmitterHidden(true);
    }
    //return;    
}

simulated function DoBeamDamage()
{
    local Vector StartTrace, EndTrace;
    local ImpactInfo RealImpact;

    // End:0x1A6
    if(Blades != none)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        EndTrace = Blades.Location;
        RealImpact = CalcWeaponFire(StartTrace, EndTrace);
        // End:0x1A6
        if(RealImpact.HitActor != none)
        {
            CheckAndUpdateHitEnemyIndicator(RealImpact.HitActor);
            RealImpact.HitActor.TakeDamage(int(InstantHitDamage[1]), Instigator.Controller, RealImpact.HitLocation, RealImpact.HitNormal * InstantHitMomentum[1], InstantHitDamageTypes[1],, self);
            SetFlashLocation(RealImpact.HitLocation);
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'Blades')
    {
        SetupBlades();        
    }
    else
    {
        super(EvilWeap_Base).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function DoQuickAction(bool bAltFire)
{
    // End:0xA4
    if(((bAltFire && int(Role) < int(ROLE_Authority)) && PKPlayerPawn(Instigator) != none) && PKPlayerPawn(Instigator).SavedWeapon == none)
    {
        ClearPendingFire(0);
        // End:0x96
        if(IsInState('Active'))
        {
            StartFire(1);            
        }
        else
        {
            SetPendingFire(1);
        }        
    }
    else
    {
        super.DoQuickAction(bAltFire);
    }
    //return;    
}

simulated function EndQuickAction(bool bAltFire)
{
    // End:0x19
    if(bAltFire)
    {
        StartFire(1);
    }
    super.EndQuickAction(bAltFire);
    //return;    
}

simulated function bool CanCountShoots()
{
    return false;
    //return ReturnValue;    
}

simulated state ComboFire
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x52
        if((Blades != none) && int(FireModeNum) == int(1))
        {
            Blades.ReturnToInstigator();
            StopFire(1);
            return;
        }
        // End:0x68
        if(int(FireModeNum) != int(1))
        {
            return;
        }
        super(WeaponFiring).BeginFire(FireModeNum);
        //return;        
    }

    simulated function HandleFinishedFiring()
    {
        StopFire(CurrentFireMode);
        bIsRecoveringFromFire = false;
        global.HandleFinishedFiring();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x45
        if(Blades != none)
        {
            Blades.ReturnToInstigator();
            Blades = none;
            bBladesFired = false;
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x48
        if(((int(FireModeNum) == int(1)) && int(CurrentFireMode) == int(0)) && HasAmmo(2))
        {
            FireModeNum = 2;
        }
        // End:0x9A
        if((Blades != none) && int(FireModeNum) == int(1))
        {
            Blades.ReturnToInstigator();
            StopFire(1);
            return;
        }
        // End:0xC6
        if((int(FireModeNum) != int(1)) && int(CurrentFireMode) == int(1))
        {
            return;
        }
        super.BeginFire(FireModeNum);
        StopFire(CurrentFireMode);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bIsRecoveringFromFire = false;
        // End:0x246
        if(int(CurrentFireMode) == int(0))
        {
            // End:0x9D
            if(WeaponFireStartAnim != 'None')
            {
                PlayWeaponAnim(WeaponFireStartAnim, 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
            }
            // End:0x118
            if((ArmFireStartAnim != 'None') && ArmsAnimSet != none)
            {
                PlayArmAnim(ArmFireStartAnim, 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
            }
            // End:0x163
            if(BladesSoundLoopComp.IsPlaying())
            {
                BladesSoundLoopComp.FadeOut(0.1000000, 0.0000000);
            }
            // End:0x1AE
            if(BladesSoundEndComp.IsPlaying())
            {
                BladesSoundEndComp.FadeOut(0.1000000, 0.0000000);
            }
            // End:0x1FB
            if(!BladesSoundStartComp.IsPlaying())
            {
                BladesSoundStartComp.FadeIn(0.1000000, 1.0000000);
            }
            SetTimer(BladesSoundStartComp.SoundCue.Duration - 0.1000000, false, 'StartBladesLoopSound');            
        }
        else
        {
            // End:0x264
            if(int(CurrentFireMode) == int(1))
            {
                AddBeamEmitter();
            }
        }
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        // End:0x27
        if(int(CurrentFireMode) == int(1))
        {
            UpdateBeam(DeltaTime);
        }
        //return;        
    }

    simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        // End:0x1A0
        if(((SeqNode.AnimSeqName == WeaponFireStartAnim) && !bIsRecoveringFromFire) && int(CurrentFireMode) == int(0))
        {
            // End:0xF1
            if((int(CurrentFireMode) < WeaponFireAnim.Length) && WeaponFireAnim[int(CurrentFireMode)] != 'None')
            {
                PlayWeaponAnim(WeaponFireAnim[int(CurrentFireMode)], 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut, true, true);
            }
            // End:0x1A0
            if(((int(CurrentFireMode) < ArmFireAnim.Length) && ArmFireAnim[int(CurrentFireMode)] != 'None') && ArmsAnimSet != none)
            {
                PlayArmAnim(ArmFireAnim[int(CurrentFireMode)], 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut, true, true);
            }
        }
        super(Actor).OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('StartBladesLoopSound');
        // End:0x5F
        if(BladesSoundLoopComp.IsPlaying())
        {
            BladesSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0xAA
        if(BladesSoundStartComp.IsPlaying())
        {
            BladesSoundStartComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0xF5
        if(BeamSoundLoopComp.IsPlaying())
        {
            BeamSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x159
        if(int(CurrentFireMode) == int(0))
        {
            // End:0x156
            if(!BladesSoundEndComp.IsPlaying())
            {
                BladesSoundEndComp.FadeIn(0.1000000, 1.0000000);
            }            
        }
        else
        {
            // End:0x1A4
            if(BladesSoundEndComp.IsPlaying())
            {
                BladesSoundEndComp.FadeOut(0.1000000, 0.0000000);
            }
            // End:0x1E9
            if(Blades != none)
            {
                Blades.ReturnToInstigator();
                Blades = none;
                bBladesFired = false;
            }
        }
        KillBeamEmitter();
        ClearTimer('DoBeamDamage');
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
    // Reference: AudioComponent'Default__PKWeap_Painkiller_Base.BladesSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BladesSoundLoop'
    begin object name="BladesSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    BladesSoundLoopComp=BladesSoundLoop
    // Reference: AudioComponent'Default__PKWeap_Painkiller_Base.BladesSoundStart'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BladesSoundStart'
    begin object name="BladesSoundStart" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    BladesSoundStartComp=BladesSoundStart
    // Reference: AudioComponent'Default__PKWeap_Painkiller_Base.BladesSoundEnd'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BladesSoundEnd'
    begin object name="BladesSoundEnd" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    BladesSoundEndComp=BladesSoundEnd
    // Reference: AudioComponent'Default__PKWeap_Painkiller_Base.BeamSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BeamSoundLoop'
    begin object name="BeamSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    BeamSoundLoopComp=BeamSoundLoop
    bPurchasedWeaponDLC=true
    AmmoAltCount=999
    MaxAmmoAltCount=999
    LowAmmoCountWarningThreshold=0
    LowAmmoAltCountWarningThreshold=0
    SplitScreenPlayerViewOffset=(X=3.0000000,Y=0.0000000,Z=-9.0000000)
    MaxAmmoCount=999
    WeaponHitRange=100.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Painkiller_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=1
    GroupWeight=0.3000000
    FireAnimBlendTimes=(BlendIn=0.1000000)
    // Reference: AudioComponent'Default__PKWeap_Painkiller_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Painkiller_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Painkiller"
    CurrentRating=0.8000000
    AmmoCount=999
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    bInstantHit=true
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Painkiller_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Painkiller_Base.PickupMesh'
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
    Components[2]=BladesSoundEnd
    Components[3]=BladesSoundStart
    Components[4]=BladesSoundLoop
    Components[5]=BeamSoundLoop
}