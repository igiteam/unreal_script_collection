class PKWeap_SoulReaper_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

struct TEyeEffectInfo
{
    var name SocketName;
    var export editinline UTParticleSystemComponent EyePSC;

    structdefaultproperties
    {
        SocketName="None"
        EyePSC=none
    }
};

struct TEyeLightInfo
{
    var name SocketName;
    var EvilLightActor EyeLightActor;

    structdefaultproperties
    {
        SocketName="None"
        EyeLightActor=none
    }
};

var export editinline UDKSkeletalMeshComponent SkeletonFirstPersonMesh;
var() float BeamDamageInterval;
var() ParticleSystem BeamTemplate;
var export editinline ParticleSystemComponent BeamEmitter;
var() name BeamSocket;
var() name EndPointParamName;
var() ParticleSystem BeamEndTemplate;
var export editinline ParticleSystemComponent BeamEndEmitter;
var() ParticleSystem BeamOnSoulTemplate;
var export editinline ParticleSystemComponent BeamOnSoulEmitter;
var PKSoulBeamLightActor BeamLight;
var Actor LinkedTo;
var() config float LinkFlexibility;
var() config float LinkBreakDelay;
var float ReaccquireTimer;
var() config float BobParam;
var float BobTime;
var Vector Bob;
var transient bool bBlockSawShoting;
var transient bool IsFryingFadeOut;
var bool bSawLoopSoundWasPlaying;
var export editinline AudioComponent FryingSoundLoopComp;
var export editinline AudioComponent BeamSoundLoopComp;
var SoundCue BeamSoundLoopCue1p;
var export editinline AudioComponent BeamSoundEndComp;
var SoundCue BeamSoundEndCue1p;
var export editinline AudioComponent SawCutSoundLoopComp;
var SoundCue SawCutSoundLoopCue1p;
var export editinline AudioComponent SawCutSoundEndComp;
var SoundCue SawCutSoundEndCue1p;
var export editinline AudioComponent SawSoundLoopComp;
var SoundCue SawSoundLoopCue1p;
var() config float MeleeRange;
var() int SoulComboMeter;
var() ParticleSystem EyeEffectTemplate;
var array<TEyeEffectInfo> EyesEffects;
var EvilLightActor EyeEffectLightArchetype;
var array<TEyeLightInfo> EyesLights;
var class<PKFollowerActor> AdditionalSoulTakingActorClass;
var float AdditionalSoulTakingEffectsInterval;

replication
{
    // Pos:0x000
    if(bNetOwner)
        LinkedTo;
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    super.AttachWeaponTo(MeshCpnt, SocketName);
    // End:0x1AF
    if(Instigator.IsFirstPerson())
    {
        BeamSoundLoopComp.SoundCue = BeamSoundLoopCue1p;
        BeamSoundLoopComp.bAllowSpatialization = false;
        BeamSoundEndComp.SoundCue = BeamSoundEndCue1p;
        BeamSoundEndComp.bAllowSpatialization = false;
        SawCutSoundLoopComp.SoundCue = SawCutSoundLoopCue1p;
        SawCutSoundLoopComp.bAllowSpatialization = false;
        SawCutSoundEndComp.SoundCue = SawCutSoundEndCue1p;
        SawCutSoundEndComp.bAllowSpatialization = false;
        SawSoundLoopComp.SoundCue = SawSoundLoopCue1p;
        SawSoundLoopComp.bAllowSpatialization = false;        
    }
    else
    {
        // End:0x2FA
        if(Instigator.PlayerReplicationInfo == none)
        {
            DetachComponent(BeamSoundLoopComp);
            Instigator.AttachComponent(BeamSoundLoopComp);
            DetachComponent(BeamSoundEndComp);
            Instigator.AttachComponent(BeamSoundEndComp);
            DetachComponent(SawCutSoundLoopComp);
            Instigator.AttachComponent(SawCutSoundLoopComp);
            DetachComponent(SawCutSoundEndComp);
            Instigator.AttachComponent(SawCutSoundEndComp);
            DetachComponent(SawSoundLoopComp);
            Instigator.AttachComponent(SawSoundLoopComp);
        }
    }
    // End:0x38F
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

function TakeSoulFromPawn(PKPawn P)
{
    local PainItem_Energy SoulToTake;

    SoulToTake = ((P.Soul != none) ? P.Soul : PainItem_Energy(P.ThrowSoul()));
    P.bThrowSoul = false;
    TakeSoul(SoulToTake);
    //return;    
}

function TakeSoul(PainItem_Energy SoulToTake)
{
    local bool bScoreSoul;

    // End:0x116
    if((SoulToTake != none) && !SoulToTake.ForceMoveToCatchingTarget)
    {
        SoulToTake.SetCatchingTarget(Instigator);
        SoulToTake.ForceMoveToCatchingTarget = true;
        AttemptLinkTo(SoulToTake, SoulToTake.Location);
        bScoreSoul = !SoulToTake.IsA('PainItem_SoulOfBoss');
        ClientNotifyTakeSoul(SoulToTake, bScoreSoul);
        SoulTaken(SoulToTake, bScoreSoul);
    }
    //return;    
}

reliable client simulated function ClientNotifyTakeSoul(PainItem_Energy SoulToTake, bool bScoreSoul)
{
    // End:0x31
    if(int(Role) < int(ROLE_Authority))
    {
        SoulTaken(SoulToTake, bScoreSoul);
    }
    //return;    
}

simulated function SoulTaken(PainItem_Energy SoulToTake, bool bScoreSoul)
{
    // End:0x18
    if(bScoreSoul)
    {
        SoulComboMeter++;
    }
    // End:0x32
    if(SoulComboMeter < 7)
    {
        ActivateEyesEffects();
    }
    // End:0x154
    if((BeamOnSoulEmitter == none) && SoulToTake != none)
    {
        // End:0x154
        if(BeamOnSoulTemplate != none)
        {
            BeamOnSoulEmitter = new (Outer) Class'EvilGame.UTParticleSystemComponent';
            BeamOnSoulEmitter.SetDepthPriorityGroup(2);
            BeamOnSoulEmitter.SetTemplate(BeamOnSoulTemplate);
            BeamOnSoulEmitter.SetHidden(true);
            BeamOnSoulEmitter.SetTickGroup(3);
            BeamOnSoulEmitter.bUpdateComponentInTick = true;
            SoulToTake.AttachComponent(BeamOnSoulEmitter);
        }
    }
    //return;    
}

simulated function ActivateEyesEffects()
{
    local Vector LightLoc;
    local int I;

    // End:0x46F
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        I = 0;
        J0x34:

        // End:0x46F [Loop If]
        if(I < SoulComboMeter)
        {
            // End:0x220
            if(EyesEffects[I].EyePSC == none)
            {
                // End:0x21D
                if(EyeEffectTemplate != none)
                {
                    EyesEffects[I].EyePSC = new (Outer) Class'EvilGame.UTParticleSystemComponent';
                    EyesEffects[I].EyePSC.SetDepthPriorityGroup(2);
                    EyesEffects[I].EyePSC.SetTemplate(EyeEffectTemplate);
                    EyesEffects[I].EyePSC.SetFOV(UDKSkeletalMeshComponent(Mesh).FOV);
                    SkeletalMeshComponent(Mesh).AttachComponentToSocket(EyesEffects[I].EyePSC, EyesEffects[I].SocketName);
                }                
            }
            else
            {
                // End:0x29E
                if(!EyesEffects[I].EyePSC.bIsActive)
                {
                    EyesEffects[I].EyePSC.ActivateSystem();
                }
            }
            // End:0x461
            if((I % 2) == 0)
            {
                // End:0x421
                if(EyesLights[I / 2].EyeLightActor == none)
                {
                    // End:0x41E
                    if(EyeEffectLightArchetype != none)
                    {
                        SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(EyesLights[I / 2].SocketName, LightLoc,, 0);
                        EyesLights[I / 2].EyeLightActor = Spawn(Class'EvilGame.EvilLightActor', self,, LightLoc,, EyeEffectLightArchetype);
                        EyesLights[I / 2].EyeLightActor.SetBase(self);
                        EyesLights[I / 2].EyeLightActor.Activate();
                    }                    
                }
                else
                {
                    EyesLights[I / 2].EyeLightActor.Activate();
                }
            }
            I++;
            // [Loop Continue]
            goto J0x34;
        }
    }
    //return;    
}

simulated function DeactivateEyesEffects()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x114 [Loop If]
    if(I < 6)
    {
        // End:0x83
        if(EyesEffects[I].EyePSC != none)
        {
            EyesEffects[I].EyePSC.DeactivateSystem();
        }
        // End:0x106
        if((I % 2) == 0)
        {
            // End:0x106
            if(EyesLights[I / 2].EyeLightActor != none)
            {
                EyesLights[I / 2].EyeLightActor.Deactivate();
            }
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function CustomFire()
{
    local Vector TraceStart, TraceEnd;
    local ImpactInfo Impact;

    // End:0x2B
    if(int(CurrentFireMode) == int(1))
    {
        PlayFireEffects(CurrentFireMode);        
    }
    else
    {
        // End:0x393
        if(CheckForMelee())
        {
            TraceStart = InstantFireStartTrace();
            TraceEnd = InstantFireEndTrace(TraceStart);
            Impact = CalcWeaponFire(TraceStart, TraceEnd);
            // End:0x390
            if(Impact.HitActor != none)
            {
                CheckAndUpdateHitEnemyIndicator(Impact.HitActor);
                Impact.HitActor.TakeDamage(int(InstantHitDamage[4]), Instigator.Controller, Impact.HitLocation, InstantHitMomentum[4] * Impact.HitNormal, InstantHitDamageTypes[4], Impact.HitInfo, self);
                // End:0x2F6
                if(PKPawn(Impact.HitActor) != none)
                {
                    SetFlashLocation(Impact.HitLocation);
                    // End:0x244
                    if(!SawCutSoundLoopComp.IsPlaying())
                    {
                        SawCutSoundLoopComp.FadeIn(0.1000000, 1.0000000);
                    }
                    // End:0x2F3
                    if((PKPawn(Impact.HitActor).Health <= 0) && PKPawn(Impact.HitActor).bThrowSoul)
                    {
                        TakeSoulFromPawn(PKPawn(Impact.HitActor));
                    }                    
                }
                else
                {
                    // End:0x390
                    if(SawCutSoundLoopComp.IsPlaying() && !SawCutSoundLoopComp.IsFadingOut())
                    {
                        SawCutSoundLoopComp.FadeOut(0.1000000, 0.0000000);
                        SawCutSoundEndComp.FadeIn(0.1000000, 1.0000000);
                    }
                }
            }            
        }
        else
        {
            // End:0x42D
            if(SawCutSoundLoopComp.IsPlaying() && !SawCutSoundLoopComp.IsFadingOut())
            {
                SawCutSoundLoopComp.FadeOut(0.1000000, 0.0000000);
                SawCutSoundEndComp.FadeIn(0.1000000, 1.0000000);
            }
        }
    }
    //return;    
}

simulated function bool CheckForMelee()
{
    local Vector StartTrace, EndTrace;
    local array<ImpactInfo> ImpactList;
    local ImpactInfo RealImpact;

    StartTrace = InstantFireStartTrace();
    EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * MeleeRange);
    RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
    // End:0xD0
    if(RealImpact.HitActor != none)
    {
        // End:0xCE
        if(int(CurrentFireMode) != int(4))
        {
            StopFire(CurrentFireMode);
            StartFire(4);
        }
        return true;
    }
    // End:0x103
    if(int(CurrentFireMode) != int(1))
    {
        StopFire(CurrentFireMode);
        StartFire(1);
    }
    return false;
    //return ReturnValue;    
}

simulated function SpawnAdditionalSoulTakingEffect()
{
    local PKFollowerActor MiniSoul;

    // End:0x141
    if((PKPawn(LinkedTo) != none) && PKPawn(LinkedTo).IsAliveAndWell())
    {
        MiniSoul = Spawn(AdditionalSoulTakingActorClass, LinkedTo,, GetLinkedToLocation());
        // End:0xF1
        if(((int(Role) == int(ROLE_Authority)) && int(WorldInfo.NetMode) == int(NM_Standalone)) || int(Role) == int(ROLE_AutonomousProxy))
        {
            MiniSoul.SetFollowedActor(self);            
        }
        else
        {
            MiniSoul.SetFollowedActor(Instigator);
        }
        MiniSoul.SetOtherTouchDestroyActor(Instigator);
    }
    //return;    
}

simulated function DoBeamDamage()
{
    local Vector HitNormal;

    // End:0x12D
    if(!CheckForMelee() && LinkedTo != none)
    {
        CheckAndUpdateHitEnemyIndicator(LinkedTo);
        LinkedTo.TakeDamage(int(InstantHitDamage[1]), Instigator.Controller, GetLinkedToLocation(), HitNormal, InstantHitDamageTypes[1],, self);
        // End:0x12D
        if(((PKPawn(LinkedTo) != none) && PKPawn(LinkedTo).Health <= 0) && PKPawn(LinkedTo).bThrowSoul)
        {
            TakeSoulFromPawn(PKPawn(LinkedTo));
        }
    }
    //return;    
}

function bool CanLockOnTo(Actor TA)
{
    // End:0x176
    if((((((TA == none) || (((((PKPawn(TA) == none) || !PKPawn(TA).IsAliveAndWell()) || PKPawn(TA).bAmbientCreature) && PainItem_Energy(TA) == none) && EvilDestructibleObject(TA) == none) && EvilDynamicDestructibleObject(TA) == none) || !TA.bProjTarget && PainItem_Energy(TA) == none) || TA.bDeleteMe) || TA == Instigator) || TA.bWorldGeometry)
    {
        return false;
    }
    return (((WorldInfo.Game == none) || !WorldInfo.Game.bTeamGame) || WorldInfo.GRI == none) || !WorldInfo.GRI.OnSameTeam(Instigator, TA);
    //return ReturnValue;    
}

simulated function ProcessBeamHit(Vector StartTrace, Vector AimDir, Actor HitActor, out ImpactInfo TestImpact, float DeltaTime)
{
    local Actor Victim;
    local PainItem_Energy LevelSoul;

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
        // End:0x2A9
        foreach Instigator.OverlappingActors(Class'PainItem_Energy', LevelSoul, (GetTraceRange()) * float(2),, true)
        {
            // End:0x2A8
            if((!LevelSoul.ForceMoveToCatchingTarget || LevelSoul.CatchingTarget.IsA('PKPawn_Boss_Reaper_Base')) && (Normal(LevelSoul.Location - Instigator.Location) Dot AimDir) > LinkFlexibility)
            {
                TakeSoul(LevelSoul);
            }            
        }        
    }
    //return;    
}

simulated function UpdateBeam(float DeltaTime)
{
    local Actor BestTarget, HitActor, TA;
    local UDKBot BotController;
    local Vector StartTrace, EndTrace, AimDir, HitLocation, HitNormal;

    local Rotator AimRot;
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
    Bob = (Y * RandRange(BobParam * 0.5000000, BobParam * 1.5000000)) * Sin(14.0000000 * BobTime);
    Bob.Z = Bob.Z + ((0.7500000 * RandRange(BobParam * 0.9000000, BobParam * 1.1000000)) * Sin(10.0000000 * BobTime));
    StartTrace = Instigator.GetWeaponStartTraceLocation();
    AimRot = GetAdjustedAim(StartTrace);
    AimDir = Vector(AimRot);
    EndTrace = StartTrace + (AimDir * (GetTraceRange()));
    RealImpact = CalcWeaponFire(StartTrace, EndTrace);
    bUsingAimingHelp = false;
    BestTarget = none;
    BotController = UDKBot(Instigator.Controller);
    // End:0x482
    if(BotController != none)
    {
        // End:0x47F
        if((BotController.Focus != none) && CanLockOnTo(BotController.Focus))
        {
            BotController.GetPlayerViewPoint(StartTrace, AimRot);
            AimDir = Vector(AimRot);
            // End:0x47F
            if((AimDir Dot Normal(BotController.Focus.Location - StartTrace)) > 0.5000000)
            {
                HitActor = Trace(HitLocation, HitNormal, BotController.Focus.Location, StartTrace, true,,, 1);
                // End:0x47F
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
        // End:0x656
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x630
            if((RealImpact.HitActor == none) || !CanLockOnTo(RealImpact.HitActor))
            {
                bestAim = (((UDKPlayerController(Instigator.Controller) != none) && UDKPlayerController(Instigator.Controller).bConsolePlayer) ? 0.9400000 : 0.9900000);
                bestDist = 0.0000000;
                TA = Instigator.Controller.PickTarget(Class'PKPawn', bestAim, bestDist, AimDir, StartTrace, GetTraceRange());
                // End:0x62D
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
    // End:0x77F
    if((BestTarget == none) || !BestTarget.bProjTarget)
    {
        // End:0x6D4
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
    // End:0x73
    if(((PKPawn(LinkedTo) != none) && PKPawn(LinkedTo).IsAliveAndWell()) || PainItem_Energy(LinkedTo) != none)
    {
        FlashLocation = GetLinkedToLocation();
    }
    // End:0xE7
    if(BeamEmitter != none)
    {
        SetBeamEmitterHidden(!PKPawn(Instigator).IsFirstPerson());
        BeamEmitter.SetVectorParameter(EndPointParamName, FlashLocation);
    }
    // End:0x21A
    if(BeamLight != none)
    {
        // End:0x1B9
        if((HitNormal == vect(0.0000000, 0.0000000, 0.0000000)) || PainItem_Energy(LinkedTo) != none)
        {
            // End:0x195
            if(BeamEndEmitter != none)
            {
                // End:0x175
                if(PainItem_Energy(LinkedTo) != none)
                {
                    BeamEndEmitter.SetHidden(true);                    
                }
                else
                {
                    BeamEndEmitter.SetHidden(false);
                }
            }
            BeamLight.SetLocation(FlashLocation);            
        }
        else
        {
            // End:0x1E8
            if(BeamEndEmitter != none)
            {
                BeamEndEmitter.SetHidden(true);
            }
            BeamLight.SetLocation(FlashLocation + (float(16) * HitNormal));
        }
    }
    // End:0x264
    if(PainItem_Energy(LinkedTo) != none)
    {
        // End:0x261
        if(BeamOnSoulEmitter != none)
        {
            BeamOnSoulEmitter.SetHidden(false);
        }        
    }
    else
    {
        // End:0x2BD
        if(BeamOnSoulEmitter != none)
        {
            BeamOnSoulEmitter.SetHidden(true);
            BeamOnSoulEmitter.DetachFromAny();
            BeamOnSoulEmitter = none;
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
            BeamLight = Spawn(Class'PKSoulBeamLightActor');
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
    // End:0x127
    if(BeamLight != none)
    {
        // End:0xAB
        if(BeamEndEmitter != none)
        {
            BeamEndEmitter.SetHidden(true);
            BeamEndEmitter.DeactivateSystem();
        }
        // End:0x104
        if(BeamOnSoulEmitter != none)
        {
            BeamOnSoulEmitter.SetHidden(true);
            BeamOnSoulEmitter.DetachFromAny();
            BeamOnSoulEmitter = none;
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

    // End:0x5C
    if((Who != none) && CanLockOnTo(Who))
    {
        // End:0x5C
        if(LinkedTo != Who)
        {
            UnLink();
            LinkedTo = Who;
        }
    }
    // End:0x2AC
    if(LinkedTo != none)
    {
        // End:0x9A
        if(LinkedTo.bDeleteMe)
        {
            UnLink();
            return;
        }
        // End:0x223
        if(LinkedTo != Who)
        {
            StartTrace = Instigator.GetWeaponStartTraceLocation();
            EndTrace = GetLinkedToLocation();
            V = Normal(EndTrace - StartTrace);
            // End:0x1A3
            if(((V Dot Vector(Instigator.GetViewRotation())) < LinkFlexibility) || VSize(EndTrace - StartTrace) > (((PainItem_Energy(LinkedTo) != none) ? 2.5000000 : 1.5000000) * (GetTraceRange())))
            {
                UnLink();
                return;
            }
            // End:0x223
            if(PainItem_Energy(LinkedTo) == none)
            {
                HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
                // End:0x223
                if((HitActor != none) && HitActor != LinkedTo)
                {
                    UnLink(true);
                }
            }
        }
        // End:0x299
        if(((PKPawn(LinkedTo) != none) && PKPawn(LinkedTo).IsAliveAndWell()) || PainItem_Energy(LinkedTo) != none)
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
    // End:0x1E
    if(HitLocation != vect(0.0000000, 0.0000000, 0.0000000))
    {
        return;
    }
    // End:0x52
    if((int(CurrentFireMode) == int(0)) || int(CurrentFireMode) == int(2))
    {
        HideSaw();
    }
    // End:0x72
    if(int(CurrentFireMode) == int(4))
    {
        ShakeView();
        return;
    }
    // End:0x11E
    if((int(FireModeNum) < WeaponFireAnim.Length) && WeaponFireAnim[int(FireModeNum)] != 'None')
    {
        PlayWeaponAnim(WeaponFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
    }
    // End:0x1DB
    if(((int(FireModeNum) < ArmFireAnim.Length) && ArmFireAnim[int(FireModeNum)] != 'None') && ArmsAnimSet != none)
    {
        PlayArmAnim(ArmFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
    }
    // End:0x1F9
    if(int(CurrentFireMode) == int(1))
    {
        CauseMuzzleFlash();
    }
    ShakeView();
    //return;    
}

simulated function StartSawLoopSound()
{
    //return;    
}

simulated function StopSawLoopSound()
{
    //return;    
}

simulated function UnblockSawShoting()
{
    bBlockSawShoting = false;
    //return;    
}

simulated function BeginFire(byte FireModeNum)
{
    // End:0x25
    if((int(FireModeNum) == int(0)) && bBlockSawShoting)
    {
        return;
    }
    super(Weapon).BeginFire(FireModeNum);
    //return;    
}

simulated function ShowSaw()
{
    local SkelControlSingleBone SkelControl;

    SkelControl = SkelControlSingleBone(SkeletalMeshComponent(Mesh).FindSkelControl('Pila'));
    // End:0x8E
    if((SkelControl != none) && AmmoCount > 0)
    {
        SkelControl.SetSkelControlActive(false);
        StartSawLoopSound();
    }
    //return;    
}

simulated function HideSaw()
{
    local SkelControlSingleBone SkelControl;

    SkelControl = SkelControlSingleBone(SkeletalMeshComponent(Mesh).FindSkelControl('Pila'));
    // End:0x7D
    if(SkelControl != none)
    {
        SkelControl.SetSkelControlActive(true);
        StopSawLoopSound();
    }
    //return;    
}

function int AddAmmoForFireMode(byte FireModeNum, int Amount)
{
    local int OldAmmoCount, Result;

    OldAmmoCount = AmmoCount;
    Result = super.AddAmmoForFireMode(FireModeNum, Amount);
    // End:0x79
    if(((int(FireModeNum) == int(0)) && OldAmmoCount <= 0) && Amount > 0)
    {
        ShowSaw();
    }
    return Result;
    //return ReturnValue;    
}

simulated function bool CanCountShoots()
{
    return int(CurrentFireMode) == int(0);
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x37
    if((Instigator == none) || Instigator.Weapon != self)
    {
        return;
    }
    // End:0xF2
    if((PKPlayerController(Instigator.Controller) != none) && PKPlayerController(Instigator.Controller).bCinematicMode)
    {
        // End:0xEF
        if(SawSoundLoopComp.IsPlaying() && !bSawLoopSoundWasPlaying)
        {
            bSawLoopSoundWasPlaying = true;
            StopSawLoopSound();
        }        
    }
    else
    {
        // End:0x142
        if(PKPlayerController(Instigator.Controller) != none)
        {
            // End:0x136
            if(bSawLoopSoundWasPlaying)
            {
                StartSawLoopSound();
            }
            bSawLoopSoundWasPlaying = false;
        }
    }
    //return;    
}

simulated state ComboFire
{
    simulated function bool ShouldRefire()
    {
        local bool Result;

        Result = super.ShouldRefire();
        return Result;
        //return ReturnValue;        
    }

    simulated function HandleFinishedFiring()
    {
        super.HandleFinishedFiring();
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x97
        if((((int(FireModeNum) == int(0)) && int(CurrentFireMode) == int(1)) && HasAmmo(0)) && SoulComboMeter > 5)
        {
            FireModeNum = 2;
            SoulComboMeter = 0;
            DeactivateEyesEffects();
            super.BeginFire(FireModeNum);
            StopFire(CurrentFireMode);
            return;
        }
        super.BeginFire(FireModeNum);
        // End:0xDD
        if((int(FireModeNum) == int(0)) || int(FireModeNum) == int(CurrentFireMode))
        {
            return;
        }
        bBlockSawShoting = true;
        SetTimer(0.3000000, false, 'UnblockSawShoting');
        StopFire(CurrentFireMode);
        HandleFinishedFiring();
        //return;        
    }

    simulated function bool ShouldRefire()
    {
        local bool Result;

        Result = super(EvilWeap_Base).ShouldRefire();
        return Result;
        //return ReturnValue;        
    }

    simulated function HandleFinishedFiring()
    {
        super(EvilWeap_Base).HandleFinishedFiring();
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local PKPawn POwner;

        super.BeginState(PreviousStateName);
        // End:0x185
        if(int(CurrentFireMode) == int(4))
        {
            // End:0xCC
            if((int(CurrentFireMode) < WeaponFireAnim.Length) && WeaponFireAnim[int(CurrentFireMode)] != 'None')
            {
                PlayWeaponAnim(WeaponFireAnim[int(CurrentFireMode)], GetFireInterval(1), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut, true, true);
            }
            // End:0x182
            if(((int(CurrentFireMode) < ArmFireAnim.Length) && ArmFireAnim[int(CurrentFireMode)] != 'None') && ArmsAnimSet != none)
            {
                PlayArmAnim(ArmFireAnim[int(CurrentFireMode)], GetFireInterval(1), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut, true, true);
            }            
        }
        else
        {
            // End:0x2DA
            if((int(CurrentFireMode) == int(1)) && !CheckForMelee())
            {
                RecoilMax = 0.0000000;
                BobTime = 0.0000000;
                Bob = vect(0.0000000, 0.0000000, 0.0000000);
                // End:0x22A
                if(BeamSoundEndComp.IsPlaying())
                {
                    BeamSoundEndComp.FadeOut(0.1000000, 0.0000000);
                }
                // End:0x277
                if(!BeamSoundLoopComp.IsPlaying())
                {
                    BeamSoundLoopComp.FadeIn(0.1000000, 1.0000000);
                }
                POwner = PKPawn(Instigator);
                // End:0x2AC
                if(POwner != none)
                {
                    AddBeamEmitter();
                }
                SetTimer(BeamDamageInterval, true, 'DoBeamDamage');
                SetTimer(AdditionalSoulTakingEffectsInterval, true, 'SpawnAdditionalSoulTakingEffect');
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        RecoilMax = default.RecoilMax;
        ClearTimer('DoBeamDamage');
        ClearTimer('SpawnAdditionalSoulTakingEffect');
        // End:0xA3
        if(FryingSoundLoopComp.IsPlaying() && !IsFryingFadeOut)
        {
            IsFryingFadeOut = true;
            FryingSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x13D
        if(SawCutSoundLoopComp.IsPlaying() && !SawCutSoundLoopComp.IsFadingOut())
        {
            SawCutSoundLoopComp.FadeOut(0.1000000, 0.0000000);
            SawCutSoundEndComp.FadeIn(0.1000000, 1.0000000);
        }
        // End:0x188
        if(BeamSoundLoopComp.IsPlaying())
        {
            BeamSoundLoopComp.FadeOut(0.1000000, 0.0000000);
        }
        // End:0x1D5
        if(!BeamSoundEndComp.IsPlaying())
        {
            BeamSoundEndComp.FadeIn(0.1000000, 1.0000000);
        }
        ReaccquireTimer = 0.0000000;
        UnLink();
        KillBeamEmitter();
        super.EndState(NextStateName);
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        UnLink();
        super(EvilWeap_Base).EndFire(FireModeNum);
        // End:0x6D
        if((int(CurrentFireMode) > int(0)) && int(FireModeNum) == int(1))
        {
            // End:0x63
            if(PendingFire(4))
            {
                StopFire(4);
            }
            RefireCheckTimer();
        }
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        // End:0x8A
        if(int(CurrentFireMode) == int(1))
        {
            // End:0x77
            if(ReaccquireTimer > float(0))
            {
                ReaccquireTimer -= DeltaTime;
                // End:0x77
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

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ShowSaw();
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        StopSawLoopSound();
        //return;        
    }

    simulated function WeaponIsDown()
    {
        ReaccquireTimer = 0.0000000;
        UnLink();
        KillBeamEmitter();
        ClearPendingFire(4);
        super.WeaponIsDown();
        //return;        
    }
    stop;    
}

defaultproperties
{
    BeamDamageInterval=0.0660000
    LinkFlexibility=0.9000000
    LinkBreakDelay=0.5000000
    BobParam=20.0000000
    // Reference: AudioComponent'Default__PKWeap_SoulReaper_Base.FryingSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'FryingSoundLoop'
    begin object name="FryingSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    FryingSoundLoopComp=FryingSoundLoop
    // Reference: AudioComponent'Default__PKWeap_SoulReaper_Base.BeamSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BeamSoundLoop'
    begin object name="BeamSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    BeamSoundLoopComp=BeamSoundLoop
    // Reference: AudioComponent'Default__PKWeap_SoulReaper_Base.BeamSoundEnd'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BeamSoundEnd'
    begin object name="BeamSoundEnd" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    BeamSoundEndComp=BeamSoundEnd
    // Reference: AudioComponent'Default__PKWeap_SoulReaper_Base.SawCutSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SawCutSoundLoop'
    begin object name="SawCutSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    SawCutSoundLoopComp=SawCutSoundLoop
    // Reference: AudioComponent'Default__PKWeap_SoulReaper_Base.SawCutSoundEnd'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SawCutSoundEnd'
    begin object name="SawCutSoundEnd" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    SawCutSoundEndComp=SawCutSoundEnd
    // Reference: AudioComponent'Default__PKWeap_SoulReaper_Base.SawSoundLoop'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SawSoundLoop'
    begin object name="SawSoundLoop" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    SawSoundLoopComp=SawSoundLoop
    MeleeRange=100.0000000
    AdditionalSoulTakingEffectsInterval=0.2000000
    bPurchasedWeaponDLC=true
    AmmoAltCount=250
    MaxAmmoAltCount=500
    LowAmmoCountWarningThreshold=5
    LowAmmoAltCountWarningThreshold=0
    SplitScreenPlayerViewOffset=(X=-6.0000000,Y=0.0000000,Z=-10.0000000)
    bFastRepeater=true
    MaxAmmoCount=100
    WeaponHitRange=400.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_SoulReaper_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=8
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_SoulReaper_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_SoulReaper_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="SoulReaper"
    CurrentRating=0.8000000
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    FireOffset=(X=0.0000000,Y=0.0000000,Z=-10.0000000)
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_SoulReaper_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ShouldFireOnRelease=/* Array type was not detected. */
    AIRating=0.8000000
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_SoulReaper_Base.PickupMesh'
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
    Components[3]=BeamSoundEnd
    Components[4]=BeamSoundLoop
    Components[5]=SawCutSoundLoop
    Components[6]=SawCutSoundEnd
    Components[7]=SawSoundLoop
}