class PKWeap_Electrodriver_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var export editinline UDKSkeletalMeshComponent SkeletonFirstPersonMesh;
var() float ElectroDamageInterval;
var() ParticleSystem BeamTemplate;
var export editinline ParticleSystemComponent BeamEmitter;
var() name BeamSocket;
var() name EndPointParamName;
var() ParticleSystem BeamEndTemplate;
var export editinline ParticleSystemComponent BeamEndEmitter;
var PKElectroBeamLightActor BeamLight;
var Actor LinkedTo;
var() config float LinkFlexibility;
var() config float LinkBreakDelay;
var float ReaccquireTimer;
var() config float BobParam;
var float BobTime;
var Vector Bob;
var transient bool IsFryingFadeOut;
var export editinline AudioComponent FryingSoundLoopComp;
var export editinline AudioComponent ElectroSoundLoopComp;
var SoundCue ElectroSoundLoopCue1p;
var export editinline AudioComponent ElectroSoundStartComp;
var SoundCue ElectroSoundStartCue1p;
var export editinline AudioComponent ElectroSoundEndComp;
var SoundCue ElectroSoundEndCue1p;
var Rotator BeamLastAim;
var float OldBeamLeadMag[2];
var int OldBeamRotDiff[2];
var float OldBeamMaxDiff[2];
var() config float BeamMaxPitchLag;
var() config float BeamMaxYawLag;
var() config float BeamRotChgSpeed;
var() config float BeamReturnChgSpeed;
var() config float BeamLagBackSpeed;
var PKProjectile_ElectroSawVirtual_Base VirtualElectro;
var class<PKProjectile_ElectroSawVirtual_Base> VirtualElectroClass;

replication
{
    // Pos:0x000
    if(bNetOwner)
        LinkedTo, VirtualElectro;
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    super.AttachWeaponTo(MeshCpnt, SocketName);
    // End:0x11D
    if(Instigator.IsFirstPerson())
    {
        ElectroSoundLoopComp.SoundCue = ElectroSoundLoopCue1p;
        ElectroSoundLoopComp.bAllowSpatialization = false;
        ElectroSoundStartComp.SoundCue = ElectroSoundStartCue1p;
        ElectroSoundStartComp.bAllowSpatialization = false;
        ElectroSoundEndComp.SoundCue = ElectroSoundEndCue1p;
        ElectroSoundEndComp.bAllowSpatialization = false;        
    }
    else
    {
        // End:0x1F2
        if(Instigator.PlayerReplicationInfo == none)
        {
            DetachComponent(ElectroSoundLoopComp);
            Instigator.AttachComponent(ElectroSoundLoopComp);
            DetachComponent(ElectroSoundStartComp);
            Instigator.AttachComponent(ElectroSoundStartComp);
            DetachComponent(ElectroSoundEndComp);
            Instigator.AttachComponent(ElectroSoundEndComp);
        }
    }
    //return;    
}

simulated function CustomFire()
{
    // End:0x28
    if(int(CurrentFireMode) == int(1))
    {
        PlayFireEffects(CurrentFireMode);
    }
    //return;    
}

simulated function DoElectroDamage()
{
    local Vector HitNormal;

    // End:0x202
    if(LinkedTo != none)
    {
        CheckAndUpdateHitEnemyIndicator(LinkedTo);
        LinkedTo.TakeDamage(int(InstantHitDamage[1]), Instigator.Controller, GetLinkedToLocation(), HitNormal, InstantHitDamageTypes[1],, self);
        // End:0x1FF
        if(HasWeaponModifier())
        {
            // End:0x170
            if(VirtualElectro == none)
            {
                // End:0x16D
                if(int(Role) == int(ROLE_Authority))
                {
                    VirtualElectro = Spawn(VirtualElectroClass,,, GetLinkedToLocation());
                    // End:0x16D
                    if((VirtualElectro != none) && !VirtualElectro.bDeleteMe)
                    {
                        VirtualElectro.Init(vect(0.0000000, 0.0000000, 0.0000000));
                        VirtualElectro.SetBase(LinkedTo);
                    }
                }                
            }
            else
            {
                // End:0x1FF
                if(!VirtualElectro.IsBasedOn(LinkedTo))
                {
                    VirtualElectro.SetBase(none);
                    VirtualElectro.SetLocation(GetLinkedToLocation());
                    VirtualElectro.SetBase(LinkedTo);
                }
            }
        }        
    }
    else
    {
        // End:0x23B
        if(VirtualElectro != none)
        {
            VirtualElectro.ShutdownNoFX();
            VirtualElectro = none;
        }
    }
    //return;    
}

simulated function bool CanLockOnTo(Actor TA)
{
    // End:0xE1
    if((((((TA == none) || (PKPawn(TA) == none) || !PKPawn(TA).IsAliveAndWell()) || !TA.bProjTarget) || TA.bDeleteMe) || TA == Instigator) || TA.bWorldGeometry)
    {
        return false;
    }
    return (((WorldInfo.Game == none) || !WorldInfo.Game.bTeamGame) || WorldInfo.GRI == none) || !WorldInfo.GRI.OnSameTeam(Instigator, TA);
    //return ReturnValue;    
}

simulated function ProcessBeamHit(Vector StartTrace, Vector AimDir, Actor HitActor, out ImpactInfo TestImpact, float DeltaTime)
{
    local Actor Victim;

    Victim = HitActor;
    // End:0x8E
    if(int(Role) == int(ROLE_Authority))
    {
        AttemptLinkTo(Victim, TestImpact.HitLocation);
        // End:0x8B
        if(LinkedTo == none)
        {
            SetFlashLocation(TestImpact.HitLocation);
        }        
    }
    else
    {
        // End:0xC3
        if(LinkedTo == none)
        {
            SetFlashLocation(TestImpact.HitLocation);
        }
    }
    // End:0x12E
    if(LinkedTo != none)
    {
        // End:0x12B
        if(!FryingSoundLoopComp.IsPlaying())
        {
            IsFryingFadeOut = false;
            FryingSoundLoopComp.FadeIn(0.1000000, 1.0000000);
        }        
    }
    else
    {
        // End:0x196
        if(FryingSoundLoopComp.IsPlaying() && !IsFryingFadeOut)
        {
            IsFryingFadeOut = true;
            FryingSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
    }
    //return;    
}

simulated function UpdateBeam(float DeltaTime)
{
    local Actor BestTarget, HitActor, TA;
    local UDKBot BotController;
    local Vector StartTrace, EndTrace, AimDir, HitLocation, HitNormal;

    local Rotator AimRot, FinalAimRot;
    local ImpactInfo RealImpact;
    local float bestAim, bestDist, Speed2D;
    local Vector X, Y, Z;

    GetAxes(Owner.Rotation, X, Y, Z);
    Speed2D = VSize(Owner.Velocity);
    // End:0x95
    if(Speed2D < float(10))
    {
        BobTime += (0.5000000 * DeltaTime);        
    }
    else
    {
        BobTime += (DeltaTime * (0.1000000 + ((0.5000000 * Speed2D) / Pawn(Owner).GroundSpeed)));
    }
    Bob.Z = RandRange(BobParam * 0.9000000, BobParam * 1.1000000) * Sin(10.0000000 * BobTime);
    StartTrace = Instigator.GetWeaponStartTraceLocation();
    AimRot = GetAdjustedAim(StartTrace);
    FinalAimRot.Yaw = BeamLag(AimRot.Yaw, BeamLastAim.Yaw, BeamMaxYawLag, DeltaTime, 0);
    FinalAimRot.Pitch = BeamLag(AimRot.Pitch, BeamLastAim.Pitch, BeamMaxPitchLag, DeltaTime, 1);
    FinalAimRot.Roll = AimRot.Roll;
    BeamLastAim = AimRot;
    AimDir = Vector(FinalAimRot);
    EndTrace = StartTrace + (AimDir * (GetTraceRange()));
    RealImpact = CalcWeaponFire(StartTrace, EndTrace);
    bUsingAimingHelp = false;
    BestTarget = none;
    BotController = UDKBot(Instigator.Controller);
    // End:0x53A
    if(BotController != none)
    {
        // End:0x537
        if((BotController.Focus != none) && CanLockOnTo(BotController.Focus))
        {
            BotController.GetPlayerViewPoint(StartTrace, AimRot);
            AimDir = Vector(AimRot);
            // End:0x537
            if((AimDir Dot Normal(BotController.Focus.Location - StartTrace)) > 0.5000000)
            {
                HitActor = Trace(HitLocation, HitNormal, BotController.Focus.Location, StartTrace, true,,, 1);
                // End:0x537
                if((HitActor == none) || HitActor == BotController.Focus)
                {
                    BestTarget = BotController.Focus;
                    bUsingAimingHelp = true;
                }
            }
        }        
    }
    else
    {
        // End:0x70E
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x6E8
            if((RealImpact.HitActor == none) || !CanLockOnTo(RealImpact.HitActor))
            {
                bestAim = (((UDKPlayerController(Instigator.Controller) != none) && UDKPlayerController(Instigator.Controller).bConsolePlayer) ? 0.9400000 : 0.9900000);
                bestDist = 0.0000000;
                TA = Instigator.Controller.PickTarget(Class'PKPawn', bestAim, bestDist, AimDir, StartTrace, GetTraceRange());
                // End:0x6E5
                if((TA != none) && CanLockOnTo(TA))
                {
                    BestTarget = TA;
                    bUsingAimingHelp = true;
                }                
            }
            else
            {
                BestTarget = RealImpact.HitActor;
            }
        }
    }
    // End:0x837
    if((BestTarget == none) || !BestTarget.bProjTarget)
    {
        // End:0x78C
        if(RealImpact.HitActor == none)
        {
            RealImpact.HitLocation += Bob;
        }
        ProcessBeamHit(StartTrace, AimDir, RealImpact.HitActor, RealImpact, DeltaTime);
        UpdateBeamEmitter(RealImpact.HitLocation, RealImpact.HitNormal, RealImpact.HitActor);        
    }
    else
    {
        ProcessBeamHit(StartTrace, AimDir, BestTarget, RealImpact, DeltaTime);
        UpdateBeamEmitter(RealImpact.HitLocation, RealImpact.HitNormal, BestTarget);
    }
    //return;    
}

simulated function UpdateBeamEmitter(Vector FlashLocation, Vector HitNormal, Actor HitActor)
{
    // End:0x59
    if((PKPawn(LinkedTo) != none) && PKPawn(LinkedTo).IsAliveAndWell())
    {
        FlashLocation = GetLinkedToLocation();
    }
    // End:0xCD
    if(BeamEmitter != none)
    {
        SetBeamEmitterHidden(!PKPawn(Instigator).IsFirstPerson());
        BeamEmitter.SetVectorParameter(EndPointParamName, FlashLocation);
    }
    // End:0x1AB
    if(BeamLight != none)
    {
        // End:0x14A
        if(HitNormal == vect(0.0000000, 0.0000000, 0.0000000))
        {
            // End:0x126
            if(BeamEndEmitter != none)
            {
                BeamEndEmitter.SetHidden(false);
            }
            BeamLight.SetLocation(FlashLocation);            
        }
        else
        {
            // End:0x179
            if(BeamEndEmitter != none)
            {
                BeamEndEmitter.SetHidden(true);
            }
            BeamLight.SetLocation(FlashLocation + (float(16) * HitNormal));
        }
    }
    //return;    
}

simulated function AddBeamEmitter()
{
    // End:0x3A0
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x16F
        if(BeamEmitter == none)
        {
            // End:0x16C
            if(BeamTemplate != none)
            {
                BeamEmitter = new (Outer) Class'EvilGame.UTParticleSystemComponent';
                BeamEmitter.SetDepthPriorityGroup(2);
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
        // End:0x1E5
        if((BeamLight == none) || BeamLight.bDeleteMe)
        {
            BeamLight = Spawn(Class'PKElectroBeamLightActor');
        }
        // End:0x3A0
        if(BeamLight != none)
        {
            // End:0x24C
            if(WorldInfo.IsConsoleBuild())
            {
                BeamLight.BeamLight.SetEnabled(false);
            }
            // End:0x380
            if(BeamEndEmitter == none)
            {
                // End:0x37D
                if(BeamEndTemplate != none)
                {
                    BeamEndEmitter = new (Outer) Class'EvilGame.UTParticleSystemComponent';
                    BeamEndEmitter.SetDepthPriorityGroup(2);
                    BeamEndEmitter.SetTemplate(BeamEndTemplate);
                    BeamEndEmitter.SetHidden(true);
                    BeamEndEmitter.SetTickGroup(3);
                    BeamEndEmitter.bUpdateComponentInTick = true;
                    BeamEndEmitter.SetIgnoreOwnerHidden(true);
                    BeamLight.AttachComponent(BeamEndEmitter);
                }                
            }
            else
            {
                BeamEndEmitter.ActivateSystem();
            }
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
    // End:0xCE
    if(BeamLight != none)
    {
        // End:0xAB
        if(BeamEndEmitter != none)
        {
            BeamEndEmitter.SetHidden(true);
            BeamEndEmitter.DeactivateSystem();
        }
        BeamLight.Destroy();
        BeamEndEmitter = none;
    }
    //return;    
}

simulated function Vector GetLinkedToLocation()
{
    local Vector TargetLocation;
    local float Height;

    // End:0x19
    if(LinkedTo == none)
    {
        return TargetLocation;
    }
    TargetLocation = LinkedTo.GetTargetLocation(Instigator);
    // End:0x178
    if(PKPawn(LinkedTo) != none)
    {
        // End:0x10B
        if(PKPawn(LinkedTo).HeadBone != 'None')
        {
            TargetLocation = PKPawn(LinkedTo).Mesh.GetBoneLocation(PKPawn(LinkedTo).HeadBone);            
        }
        else
        {
            Height = Pawn(LinkedTo).GetCollisionHeight();
            TargetLocation.Z += (0.7000000 * Height);
        }
        return TargetLocation;        
    }
    else
    {
        return TargetLocation;
    }
    //return ReturnValue;    
}

function AttemptLinkTo(Actor Who, Vector HitLoc)
{
    local Vector StartTrace, EndTrace, V, HitLocation, HitNormal;

    local Actor HitActor;

    // End:0x44
    if(Who != none)
    {
        // End:0x44
        if(LinkedTo != Who)
        {
            UnLink();
            LinkedTo = Who;
        }
    }
    // End:0x242
    if(LinkedTo != none)
    {
        // End:0x82
        if(LinkedTo.bDeleteMe)
        {
            UnLink();
            return;
        }
        // End:0x1D3
        if(LinkedTo != Who)
        {
            StartTrace = Instigator.GetWeaponStartTraceLocation();
            EndTrace = GetLinkedToLocation();
            V = Normal(EndTrace - StartTrace);
            // End:0x16B
            if(((V Dot Vector(Instigator.GetViewRotation())) < LinkFlexibility) || VSize(EndTrace - StartTrace) > (1.5000000 * WeaponRange))
            {
                UnLink();
                return;
            }
            HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
            // End:0x1D3
            if((HitActor != none) && HitActor != LinkedTo)
            {
                UnLink(true);
            }
        }
        // End:0x22F
        if((PKPawn(LinkedTo) != none) && PKPawn(LinkedTo).IsAliveAndWell())
        {
            SetFlashLocation(GetLinkedToLocation());            
        }
        else
        {
            SetFlashLocation(HitLoc);
        }
    }
    //return;    
}

function UnLink(optional bool bDelayed)
{
    // End:0x1E
    if(!bDelayed)
    {
        LinkedTo = none;        
    }
    else
    {
        // End:0x42
        if(ReaccquireTimer <= float(0))
        {
            ReaccquireTimer = LinkBreakDelay;
        }
    }
    //return;    
}

simulated event Destroyed()
{
    super(EvilWeap_Base).Destroyed();
    UnLink();
    // End:0x3C
    if(BeamLight != none)
    {
        BeamLight.Destroy();
    }
    //return;    
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    // End:0x53
    if(int(FireModeNum) == int(1))
    {
        // End:0x32
        if(HitLocation != vect(0.0000000, 0.0000000, 0.0000000))
        {
            return;
        }
        super(EvilWeap_Base).PlayFireEffects(FireModeNum, HitLocation);
        return;        
    }
    else
    {
        // End:0x85
        if(int(FireModeNum) == int(2))
        {
            super(EvilWeap_Base).PlayFireEffects(FireModeNum, HitLocation);
            return;
        }
    }
    ShakeView();
    //return;    
}

simulated function StartElectroLoopSound()
{
    // End:0x4B
    if(ElectroSoundStartComp.IsPlaying())
    {
        ElectroSoundStartComp.FadeOut(0.1000000, 0.0000000);
    }
    // End:0x96
    if(ElectroSoundEndComp.IsPlaying())
    {
        ElectroSoundEndComp.FadeOut(0.1000000, 0.0000000);
    }
    // End:0xE3
    if(!ElectroSoundLoopComp.IsPlaying())
    {
        ElectroSoundLoopComp.FadeIn(0.1000000, 1.0000000);
    }
    //return;    
}

simulated function int BeamLag(int NewValue, int LastValue, float MaxDiff, float DeltaTime, int Index)
{
    local int RotDiff;
    local float LeadMag;

    // End:0x4F
    if((PKPawn(LinkedTo) != none) && PKPawn(LinkedTo).IsAliveAndWell())
    {
        return NewValue;
    }
    // End:0x98
    if(ClockwiseFrom_IntInt(NewValue, LastValue))
    {
        // End:0x95
        if(LastValue > NewValue)
        {
            LastValue -= 65536;
        }        
    }
    else
    {
        // End:0xBF
        if(NewValue > LastValue)
        {
            NewValue -= 65536;
        }
    }
    RotDiff = NewValue - LastValue;
    // End:0x16A
    if((RotDiff == 0) || OldBeamRotDiff[Index] == 0)
    {
        LeadMag = OldBeamLeadMag[Index];
        // End:0x167
        if((RotDiff == 0) && OldBeamRotDiff[Index] == 0)
        {
            OldBeamMaxDiff[Index] = 0.0000000;
        }        
    }
    else
    {
        // End:0x2B5
        if((RotDiff > 0) == (OldBeamRotDiff[Index] > 0))
        {
            MaxDiff = FMin(1.0000000, Abs(float(RotDiff)) / (float(12000) * DeltaTime)) * MaxDiff;
            OldBeamMaxDiff[Index] = MaxDiff;
            LeadMag = ((NewValue > LastValue) ? float(-1) * MaxDiff : MaxDiff);
            // End:0x2A3
            if(DeltaTime < (float(1) / BeamRotChgSpeed))
            {
                LeadMag = ((1.0000000 - (BeamRotChgSpeed * DeltaTime)) * OldBeamLeadMag[Index]) + ((BeamRotChgSpeed * DeltaTime) * LeadMag);                
            }
            else
            {
                LeadMag = 0.0000000;
            }            
        }
        else
        {
            LeadMag = 0.0000000;
            OldBeamMaxDiff[Index] = 0.0000000;
            // End:0x333
            if(DeltaTime < (float(1) / BeamReturnChgSpeed))
            {
                LeadMag = (1.0000000 - (BeamReturnChgSpeed * DeltaTime)) * OldBeamLeadMag[Index];
            }
        }
    }
    // End:0x3B1
    if((LeadMag * (LeadMag - ((BeamLagBackSpeed * DeltaTime) * OldBeamLeadMag[Index]))) > float(0))
    {
        LeadMag -= ((BeamLagBackSpeed * DeltaTime) * OldBeamLeadMag[Index]);        
    }
    else
    {
        LeadMag = 0.0000000;
    }
    OldBeamLeadMag[Index] = LeadMag;
    OldBeamRotDiff[Index] = RotDiff;
    return int(float(NewValue) + LeadMag);
    //return ReturnValue;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x70
        if(((int(FireModeNum) == int(0)) && int(CurrentFireMode) == int(1)) && HasAmmo(2))
        {
            FireModeNum = 2;
            super.BeginFire(FireModeNum);
            StopFire(CurrentFireMode);
            return;
        }
        super.BeginFire(FireModeNum);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local PKPawn POwner;

        super.BeginState(PreviousStateName);
        // End:0x177
        if(int(CurrentFireMode) == int(0))
        {
            // End:0xC5
            if((int(CurrentFireMode) < WeaponFireAnim.Length) && WeaponFireAnim[int(CurrentFireMode)] != 'None')
            {
                PlayWeaponAnim(WeaponFireAnim[int(CurrentFireMode)], 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut, true, true);
            }
            // End:0x174
            if(((int(CurrentFireMode) < ArmFireAnim.Length) && ArmFireAnim[int(CurrentFireMode)] != 'None') && ArmsAnimSet != none)
            {
                PlayArmAnim(ArmFireAnim[int(CurrentFireMode)], 0.0000000, FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut, true, true);
            }            
        }
        else
        {
            RecoilMax = 0.0000000;
            BobTime = 0.0000000;
            Bob = vect(0.0000000, 0.0000000, 0.0000000);
            // End:0x1F7
            if(ElectroSoundLoopComp.IsPlaying())
            {
                ElectroSoundLoopComp.FadeOut(0.1000000, 0.0000000);
            }
            // End:0x242
            if(ElectroSoundEndComp.IsPlaying())
            {
                ElectroSoundEndComp.FadeOut(0.1000000, 0.0000000);
            }
            // End:0x28F
            if(!ElectroSoundStartComp.IsPlaying())
            {
                ElectroSoundStartComp.FadeIn(0.1000000, 1.0000000);
            }
            SetTimer(ElectroSoundStartComp.SoundCue.Duration - 0.1000000, false, 'StartElectroLoopSound');
            POwner = PKPawn(Instigator);
            // End:0x30C
            if(POwner != none)
            {
                AddBeamEmitter();
            }
            SetTimer(ElectroDamageInterval, true, 'DoElectroDamage');
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        RecoilMax = default.RecoilMax;
        ClearTimer('StartElectroLoopSound');
        ClearTimer('DoElectroDamage');
        // End:0xA3
        if(FryingSoundLoopComp.IsPlaying() && !IsFryingFadeOut)
        {
            IsFryingFadeOut = true;
            FryingSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0xEE
        if(ElectroSoundLoopComp.IsPlaying())
        {
            ElectroSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x139
        if(ElectroSoundStartComp.IsPlaying())
        {
            ElectroSoundStartComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x186
        if(!ElectroSoundEndComp.IsPlaying())
        {
            ElectroSoundEndComp.FadeIn(0.1000000, 1.0000000);
        }
        ReaccquireTimer = 0.0000000;
        UnLink();
        KillBeamEmitter();
        // End:0x1E3
        if(VirtualElectro != none)
        {
            VirtualElectro.ShutdownNoFX();
            VirtualElectro = none;
        }
        super.EndState(NextStateName);
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        UnLink();
        super(EvilWeap_Base).EndFire(FireModeNum);
        // End:0x52
        if((int(CurrentFireMode) > int(0)) && int(FireModeNum) == int(1))
        {
            RefireCheckTimer();
        }
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        // End:0x77
        if(int(CurrentFireMode) == int(1))
        {
            // End:0x64
            if(ReaccquireTimer > float(0))
            {
                ReaccquireTimer -= DeltaTime;
                // End:0x64
                if(ReaccquireTimer <= float(0))
                {
                    ReaccquireTimer = 0.0000000;
                    UnLink();
                }
            }
            UpdateBeam(DeltaTime);
        }
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        ReaccquireTimer = 0.0000000;
        UnLink();
        KillBeamEmitter();
        super.WeaponIsDown();
        //return;        
    }
    stop;    
}

defaultproperties
{
    ElectroDamageInterval=0.0660000
    LinkFlexibility=0.9000000
    LinkBreakDelay=0.5000000
    BobParam=20.0000000
    // Reference: AudioComponent'Default__PKWeap_Electrodriver_Base.FryingSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'FryingSoundLoop'
    begin object name="FryingSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    FryingSoundLoopComp=FryingSoundLoop
    // Reference: AudioComponent'Default__PKWeap_Electrodriver_Base.ElectroSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ElectroSoundLoop'
    begin object name="ElectroSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    ElectroSoundLoopComp=ElectroSoundLoop
    // Reference: AudioComponent'Default__PKWeap_Electrodriver_Base.ElectroSoundStart'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ElectroSoundStart'
    begin object name="ElectroSoundStart" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    ElectroSoundStartComp=ElectroSoundStart
    // Reference: AudioComponent'Default__PKWeap_Electrodriver_Base.ElectroSoundEnd'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ElectroSoundEnd'
    begin object name="ElectroSoundEnd" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    ElectroSoundEndComp=ElectroSoundEnd
    BeamMaxPitchLag=10000.0000000
    BeamMaxYawLag=10000.0000000
    BeamRotChgSpeed=3.0000000
    BeamReturnChgSpeed=2.5000000
    BeamLagBackSpeed=5.0000000
    bPurchasedWeaponDLC=true
    MaxAmmoAltCount=500
    LowAmmoCountWarningThreshold=20
    LowAmmoAltCountWarningThreshold=5
    SplitScreenPlayerViewOffset=(X=-3.0000000,Y=0.0000000,Z=-10.0000000)
    bFastRepeater=true
    MaxAmmoCount=250
    WeaponHitRange=500.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Electrodriver_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=5
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_Electrodriver_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Electrodriver_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Electrodriver"
    CurrentRating=0.8000000
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    FireOffset=(X=10.0000000,Y=0.0000000,Z=-7.0000000)
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Electrodriver_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Electrodriver_Base.PickupMesh'
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
    Components[2]=FryingSoundLoop
    Components[3]=ElectroSoundEnd
    Components[4]=ElectroSoundStart
    Components[5]=ElectroSoundLoop
}