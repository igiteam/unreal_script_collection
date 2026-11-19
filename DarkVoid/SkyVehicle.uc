class SkyVehicle extends SkyGameVehicle
    native
    nativereplication
    config(Game);

enum EMaterialVehicleParams
{
    MVP_Health,                     // 0
    MVP_Boost1,                     // 1
    MVP_Boost2,                     // 2
    MVP_Boost3,                     // 3
    MVP_MuzzleFlash1,               // 4
    MVP_MuzzleFlash2,               // 5
    MVP_MuzzleFlash3,               // 6
    MVP_MAX                         // 7
};

struct native SkyVehicleSeat
{
    var deprecated class<SkyVehicleWeapon> SecondaryGunClass;
    var() SkyVWeap PrimarySeatGunArchetype;
    var() SkyVWeap PrimarySeatGunArchetypeForPlayer;
    var() SkyVWeap SecondarySeatGunArchetype;
    var() SkyVWeap SecondarySeatGunArchetypeForPlayer;
    var SkyVehicleWeapon GunForPlayer;
    var SkyVehicleWeapon SecondaryGunForPlayer;
    var SkyVehicleWeapon GunForAI;
    var SkyVehicleWeapon SecondaryGunForAI;
    var SkyVehicleWeapon SecondaryGun;
    var() array<name> SecondaryGunSocket;
    var int SecondaryGunBarrelIndex;
    var name SecondaryFlashLocationName;
    var name SecondaryFlashCountName;
    var() bool bUseRocketpackMeshForGunSockets;

    structdefaultproperties
    {
        PrimarySeatGunArchetype=none
        PrimarySeatGunArchetypeForPlayer=none
        SecondarySeatGunArchetype=none
        SecondarySeatGunArchetypeForPlayer=none
        GunForPlayer=none
        SecondaryGunForPlayer=none
        GunForAI=none
        SecondaryGunForAI=none
        SecondaryGun=none
        SecondaryGunSocket=none
        SecondaryGunBarrelIndex=0
        SecondaryFlashLocationName="None"
        SecondaryFlashCountName="None"
        bUseRocketpackMeshForGunSockets=false
    }
};

struct native FDamageEffectTargets
{
    var() name EffectTriggerName;
    var VehicleEffect EffectEntry;
    var() name LinkedEffectTriggerName;
    var() int LinkedEffectIndex;
    var() int Health;
    var() bool bKillLinkingEffect;
    var() bool bKillWhenLinking;
    var() bool bOnlyAffectedAsLink;

    structdefaultproperties
    {
        EffectTriggerName="None"
        EffectEntry=(EffectStartTags=none,EffectEndTags=none,EffectTemplate=none,PlayerEffectTemplate=none,EffectSocket="None",EffectRef=none,TurbulenceEmitterInstance=none)
        LinkedEffectTriggerName="None"
        LinkedEffectIndex=0
        Health=0
        bKillLinkingEffect=false
        bKillWhenLinking=false
        bOnlyAffectedAsLink=false
    }
};

struct native VehicleDamageTrigger
{
    var() name TriggerName;
    var() float Health;

    structdefaultproperties
    {
        TriggerName="None"
        Health=0.0000000
    }
};

struct native VehicleEffectExtended
{
    var() array<name> EffectTriggerNames;
    var() SoundCue SoundEffect;
    var() float BaseDamage;
    var() float DamageRadius;
    var() class<DamageType> DamageType;
    var() float Momentum;
    var() bool AttachSound;

    structdefaultproperties
    {
        EffectTriggerNames=none
        SoundEffect=none
        BaseDamage=0.0000000
        DamageRadius=1.0000000
        DamageType=none
        Momentum=0.0000000
        AttachSound=false
    }
};

struct native CollisionEffect
{
    var() name Material;
    var() ParticleSystem Effect;
    var() SoundCue Sound;

    structdefaultproperties
    {
        Material="None"
        Effect=none
        Sound=none
    }
};

struct native DeathImpactEffect
{
    var name Material;
    var ParticleSystem Effect;
    var MaterialInterface Decal;
    var float DecalWidth;
    var float DecalHeight;
    var float DecalDepth;

    structdefaultproperties
    {
        Material="None"
        Effect=none
        Decal=none
        DecalWidth=500.0000000
        DecalHeight=500.0000000
        DecalDepth=100.0000000
    }
};

var(Input) deprecated class<PlayerInput> InputClass;
var(Input) string InputLayout;
var bool InvulnerableUntilDriven;
var bool bIsInvulnerable;
var bool bUsePlayerReducedDamage;
var(Damage) bool bUsePilotsHealth;
var(SkyAI) bool bAISmallVehicle;
var(Movement) bool bGroundVehicle;
var(Movement) bool bManualRoll;
var bool bSuspendRollCorrect;
var bool bTargeting;
var(Effects) bool bParentExplosions;
var(Ragdoll) bool bHideRagdoll;
var transient bool bTickMatEffectManager;
var transient bool bRememberCastShadow;
var bool bSetPhysicsOnEnter;
var private transient bool bStalled;
var bool bKismetDisabledPrimaryFire;
var bool bKismetDisabledSecondaryFire;
var bool bAllowShooting;
var() bool bSnapToGroundAfterFactorySpawn;
var(Vehicle_Exit) bool bInteruptEnterAnimForExit;
var(Vehicle_Exit) bool bUseFadeToBlackOnExit;
var(Vehicle_Exit) bool bSupressExitAnim;
var(Vehicle_Exit) bool bExitPositionRelativeToFacing;
var(Vehicle_Exit) bool bUseExitLocationActor;
var(Mesh) bool bIsFirstPersonVehicle;
var(DamageOnDeath) bool bCauseDamageOnDeath;
var bool bShouldEject;
var() bool bSaveAIController;
var() bool bUseConstantAutoAimSystem;
var(AutoAim) bool bUseDriverAutoAimSocket;
var(Health) float PilotHealthModifier;
var transient SPoisonData PoisonData;
var(Seats) array<SkyVehicleSeat> SkySeats;
var float SteeringAngleScalar;
var float LastCollisionEffectTime;
var(Effects) const float CollisionEffectIntervalSecs;
var(Effects) editinline SkyLocalEffectSettings StandardMovementLocalEffectSettings;
var deprecated SkyLocalEffect ThrottleLocalEffect;
var(Effects) editinline SkyLocalEffectSettings BoostLocalEffectSettings;
var editinline deprecated SkyLocalEffectSettings ThrottleLocalEffectSettings;
var(Effects) editinline SkyLocalEffectSettings BrakeLocalEffectSettings;
var(Movement) float RollAutoCorrectRate;
var(Movement) float RollOnTurn;
var float TurnRoll;
var float Roll;
var float OutputRoll;
var(Damage) Vector TargetOffset;
var float HudAlphaFade;
var(Sounds) const editconst export editinline AudioComponent WindSound;
var(Sounds) const editconst export editinline AudioComponent WheelSound;
var(Sounds) const editconst float WindSoundStartSpeed;
var(Sounds) const editconst float WindSoundCapSpeed;
var(Sounds) const editconst float WheelSoundStartSpeed;
var(Sounds) const editconst float WheelSoundCapSpeed;
var(Sounds) const editconst export editinline AudioComponent DamageLoop;
var(Sounds) float DamageLoopThresholdSpeed;
var float StartingHealth;
var(DamageViewShake) editinline ViewShakeInfo HitByGunViewShake;
var(DamageViewShake) editinline ViewShakeInfo HitByExplosionViewShake;
var(DamageViewShake) array< class<DamageType> > BulletDamageTypesViewShake;
var(DamageViewShake) array< class<DamageType> > ExplosionDamageTypesViewShake;
var name NativeID;
var(Death) name DeathReaction;
var(Effects) array<VehicleDamageTrigger> VehicleDamageTriggers;
var(Effects) array<VehicleEffectExtended> VehicleEffectsExtended;
var transient string ExtraHudInfo;
var transient float LastPMUpdate;
var name DisplayName;
var(Effects) CollisionEffect DefaultCollisionEffect;
var(Effects) array<CollisionEffect> CollisionEffects;
var export editinline ParticleSystemComponent CollisionPSC;
var(Effects) int VehicleMaterialIndex;
var MaterialInstanceConstant VehicleMaterialInst;
var(Effects) export editinline SkyMaterialEffectManager MaterialEffectManager;
var(Damage) int MinUnmannedHealth;
var(Damage) float UnmannedDeathTime;
var float ShadowCullDistance;
var int NumDeathExplosions;
var int DeathExplosionsMin;
var int DeathExplosionsMax;
var float DeathExplosionRadiusMin;
var float DeathExplosionRadiusMax;
var float DeathExplosionImpulseMin;
var float DeathExplosionImpulseMax;
var float DeathExplosionTimerMin;
var float DeathExplosionTimerMax;
var array<DeathImpactEffect> DeathImpactEffects;
var repnotify SkyVehicleWeapon SecondaryGun;
var deprecated float AIBrakeGovernor;
var transient array<AnimNodeSlot> SlotNodes;
var RigidBodyState OriginalRBState;
var Vector OriginalMeshLoc;
var Rotator OriginalMeshRot;
var int IsDormentRefCount;
var(GettingShotAt) float SecondaryAimOffsetRadius;
var(Camera) float FadeToBlackDeathDelayTime;
var(Camera) float FadeToBlackTime;
var float ReachedDesiredRotationSlop;
var Actor ExitLocationActor;
var(Vehicle_Exit) float TimeUntilFadeToBlack;
var(Vehicle_Exit) float TimeOfFadeToBlack;
var(Vehicle_Exit) float TimeOfBlack;
var(Vehicle_Exit) float TimeOfFadeFromBlack;
var(Mesh) export editinline SkeletalMeshComponent FirstPersonMesh;
var(ProgrammerDebug) float SteeringDeltaTimeMult;
var(DamageOnDeath) float DamageOnDeathAmount;
var(DamageOnDeath) float DamageOnDeathRadius;
var(DamageOnDeath) float DamageOnDeathInnerRadius;
var(DamageOnDeath) float DamageOnDeathImpulse;
var(DamageOnDeath) class<DamageType> DamageOnDeathType;
var(TechPoint) TechPointsInventory TechPointsInventoryArchetype;
var SkySeqAct_AIFactoryNew KismetAIFactory;
var transient SkyAIController SavedAIController;
var Vector CurrentAutoAimLocation;
var Actor CurrentAutoAimTarget;
var Actor CurrentFriendlyAutoAimTarget;
var() float MinCheckpointHealthPercent;
var SkyVehicleFactory LinkedVehicleFactoryLeft;
var SkyVehicleFactory LinkedVehicleFactoryRight;
var() SkyInteractor_AirVehicleToAAGun AirToAAGunInteractor;
var string ParentFactoryName;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        OutputRoll, Roll, 
        SecondaryGun;
}

// Export USkyVehicle::execSeatSecondaryFlashLocation(FFrame&, void* const)
native simulated function Vector SeatSecondaryFlashLocation(int SeatIndex, optional Vector NewLoc, optional bool bReadValue);

// Export USkyVehicle::execSeatSecondaryFlashCount(FFrame&, void* const)
native simulated function byte SeatSecondaryFlashCount(int SeatIndex, optional byte NewCount, optional bool bReadValue);

// Export USkyVehicle::execGetSecondaryGunBarrelIndex(FFrame&, void* const)
native simulated function int GetSecondaryGunBarrelIndex(int SeatIndex);

function Suicide()
{
    //return;    
}

// Export USkyVehicle::execSpawnImpactEffects(FFrame&, void* const)
native simulated function SpawnImpactEffects();

simulated function OnControlShooting(SkySeqAct_ControlShooting Action)
{
    bAllowShooting = Action.bAllowShooting;
    //return;    
}

simulated function OnIgnorePawn(SkySeqAct_IgnorePawn inAction)
{
    // End:0x2E
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).OnIgnorePawn(inAction);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;
    local MaterialInstanceConstant mic;

    VehicleMaterialInst = new (Outer) Class'Engine.MaterialInstanceConstant';
    VehicleMaterialInst.SetParent(Mesh.GetMaterial(VehicleMaterialIndex));
    Mesh.SetMaterial(VehicleMaterialIndex, VehicleMaterialInst);
    // End:0x14F
    if(MaterialEffectManager != none)
    {
        I = 0;
        J0x71:

        // End:0x124 [Loop If]
        if(I < Mesh.SkeletalMesh.Materials.Length)
        {
            // End:0x11A
            if(I != VehicleMaterialIndex)
            {
                mic = new (Outer) Class'Engine.MaterialInstanceConstant';
                mic.SetParent(Mesh.GetMaterial(I));
                Mesh.SetMaterial(I, mic);
                MaterialEffectManager.MaterialInstances.AddItem(mic);
            }
            ++I;
            // [Loop Continue]
            goto J0x71;
        }
        MaterialEffectManager.MaterialInstances.AddItem(VehicleMaterialInst);
        MaterialEffectManager.Initialize();
    }
    // End:0x163
    if(InvulnerableUntilDriven == true)
    {
        bIsInvulnerable = true;
    }
    StartingHealth = float(Health);
    super.PostBeginPlay();
    Mesh.AttachComponent(EngineSound, 'j_body');
    //return;    
}

event bool CanEnterVehicleEvent(Pawn P)
{
    return CanEnterVehicle(P);
    //return ReturnValue;    
}

event bool TryToDriveEvent(Pawn P)
{
    return TryToDrive(P);
    //return ReturnValue;    
}

function bool TryToDrive(Pawn P)
{
    local Vector X, Y, Z;
    local int Seat;

    // End:0x7B
    if(bIsInverted && bWasChassisTouchingGroundLastTick)
    {
        // End:0x79
        if(bCanFlip)
        {
            bIsUprighting = true;
            UprightStartTime = WorldInfo.TimeSeconds;
            GetAxes(Rotation, X, Y, Z);
            bFlipRight = ((P.Location - Location) Dot Y) > float(0);
        }
        return false;
    }
    // End:0x91
    if(!CanEnterVehicle(P))
    {
        return false;
    }
    // End:0x1D2
    if((!bTeamLocked || !WorldInfo.Game.bTeamGame) || WorldInfo.GRI.OnSameTeam(self, P))
    {
        // End:0x114
        if(bEnteringUnlocks)
        {
            bTeamLocked = false;
            // End:0x114
            if(ParentFactory != none)
            {
                ParentFactory.bHasLockedVehicle = false;
            }
        }
        Seat = GetClosestSeat(P);
        // End:0x147
        if(Seat == 0)
        {
            return DriverEnter(P);            
        }
        else
        {
            // End:0x1CF
            if(Driver == none)
            {
                // End:0x1CD
                if(DriverEnter(P))
                {
                    // End:0x1A2
                    if(Seat != -1)
                    {
                        return ChangeSeat(Seats[0].SeatPawn.Controller, Seat);                        
                    }
                    else
                    {
                        return ChangeSeat(Seats[0].SeatPawn.Controller, 0);
                    }                    
                }
                else
                {
                    return false;
                }
            }
        }        
    }
    else
    {
        VehicleLocked(P);
        return false;
    }
    //return ReturnValue;    
}

function int GetClosestSeat(Pawn P)
{
    local int I, Best;
    local float Distance, bestdistance;

    bestdistance = 90000000.0000000;
    Best = -1;
    I = 0;
    J0x1D:

    // End:0xB8 [Loop If]
    if(I < Seats.Length)
    {
        // End:0xAE
        if(SeatAvailable(I))
        {
            Distance = VSize(P.Location - (Location + Seats[I].SeatOffset));
            // End:0xAB
            if((Distance < bestdistance) || Best == -1)
            {
                Best = I;
                bestdistance = Distance;
            }
            // [Explicit Continue]
        }
        I++;
        // [Loop Continue]
        goto J0x1D;
    }
    return Best;
    //return ReturnValue;    
}

reliable client simulated function RestoreControls(Controller MyController)
{
    // End:0x29
    if(SkyPlayerController(MyController) != none)
    {
        SkyPlayerController(MyController).ResetControls();
    }
    //return;    
}

simulated function SetControls(Controller C)
{
    // End:0x5E
    if((PlayerController(C) != none) && SkyPlayerInput(PlayerController(C).PlayerInput) != none)
    {
        SkyPlayerInput(PlayerController(C).PlayerInput).SetLayout(InputLayout);
    }
    //return;    
}

reliable server function ServerSetRoll(float rollVal)
{
    // End:0x1F
    if(int(Role) == int(ROLE_Authority))
    {
        SetRoll(rollVal);
    }
    //return;    
}

simulated event SetRoll(float rollVal)
{
    Roll = rollVal;
    // End:0x2A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetRoll(rollVal);
    }
    //return;    
}

simulated event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local TechPointsInventory TPI;
    local bool bIsPlayerController;
    local PlayerController PC;
    local Pawn PlayerPawn;
    local SkyGameReplicationInfo GRI;
    local bool bIsSameTeamAsPlayer;

    bIsPlayerController = PlayerController(Controller) != none;
    // End:0x31
    if(bIsPlayerController)
    {
        RestoreControls(PlayerController(Controller));
    }
    // End:0x48
    if(IsInteracting())
    {
        AbortInteraction();
    }
    // End:0x80
    if((Driver != none) && Driver.IsInteracting())
    {
        Driver.AbortInteraction();
    }
    SetCollision(false);
    // End:0xBB
    if(bCauseDamageOnDeath)
    {
        HurtRadius(DamageOnDeathAmount, DamageOnDeathRadius, DamageOnDeathInnerRadius, DamageOnDeathType, DamageOnDeathImpulse, Location, self);
    }
    // End:0xE7
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        PlayerPawn = PC.Pawn;
        // End:0xE7
        break;        
    }    
    bIsSameTeamAsPlayer = false;
    // End:0x141
    if(PlayerPawn != none)
    {
        GRI = SkyGameReplicationInfo(WorldInfo.GRI);
        // End:0x141
        if(GRI != none)
        {
            bIsSameTeamAsPlayer = GRI.OnSameTeam(PlayerPawn, self);
        }
    }
    // End:0x1B8
    if(((TechPointsInventoryArchetype != none) && !bIsPlayerController) && !bIsSameTeamAsPlayer)
    {
        TPI = Spawn(TechPointsInventoryArchetype.Class, self,, Location,, TechPointsInventoryArchetype);
        // End:0x1B8
        if(TPI != none)
        {
            TPI.DropFrom(Location, Velocity);
        }
    }
    // End:0x1D8
    if(KismetAIFactory != none)
    {
        KismetAIFactory.TriggerDeath(self);
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

simulated function bool CanEnterVehicle(Pawn P)
{
    local int I;
    local bool bSeatAvailable, bIsHuman;

    // End:0x60
    if((Controller != none) && !WorldInfo.GRI.OnSameTeam(P, Controller) || (ParentFactory != none) && !ParentFactory.bAllowFriendlyUsurp)
    {
        return false;
    }
    // End:0xAE
    if(int(Role) < int(ROLE_Authority))
    {
        // End:0xAC
        if((P.bIsCrouched || P.DrivenVehicle != none) || Driver != none)
        {
            return false;            
        }
        else
        {
            return true;
        }
    }
    bIsHuman = P.IsHumanControlled();
    bSeatAvailable = false;
    I = 0;
    J0xD4:

    // End:0x207 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x1B3
        if(((Seats[I].SeatPawn == none) || Seats[I].SeatPawn.Controller == none) || (bIsHuman && SkyAIController(Seats[I].SeatPawn.Controller) != none) && WorldInfo.GRI.OnSameTeam(P, Seats[I].SeatPawn.Controller))
        {
            bSeatAvailable = true;
            // [Explicit Continue]
            goto J0x1FD;
        }
        // End:0x1FD
        if(!WorldInfo.GRI.OnSameTeam(P, Seats[I].SeatPawn.Controller))
        {
            return false;
        }
        J0x1FD:

        I++;
        // [Loop Continue]
        goto J0xD4;
    }
    // End:0x214
    if(!bSeatAvailable)
    {
        return false;
    }
    // End:0x27E
    if((((P.bIsCrouched || P.DrivenVehicle != none) || P.Controller == none) || P.IsA('Vehicle')) || Health <= 0)
    {
        return false;
    }
    return bSeatAvailable;
    //return ReturnValue;    
}

simulated function bool DriverEnter(Pawn P)
{
    local bool bSuccess;
    local int I;
    local SkySeqEvent_EnterExitVehicle Event;
    local SkyPawn SP;
    local float EndPoisonTimeLeft, DoPoisonDamageTimeLeft;
    local SkyPlayerController SPC;

    // End:0x43
    if((SkyAIController(Controller) != none) && bSaveAIController)
    {
        SavedAIController = SkyAIController(Controller);
        SavedAIController.GotoState('Frozen');
    }
    SPC = SkyPlayerController(P.Controller);
    // End:0x8F
    if(SPC != none)
    {
        SetControls(P.Controller);
        // End:0x8F
        if(bSetPhysicsOnEnter)
        {
            SetPhysics(10);
        }
    }
    // End:0x178
    if(P.Controller != none)
    {
        // End:0x13F
        if(P.bMatineeCharacter)
        {
            // End:0xF6
            if(SkyAirVehicle(self) != none)
            {
                SkyAirVehicle(self).SetVehicleLocationAndRotationRB(P.Location, P.Rotation);
            }
            P.bMatineeCharacter = false;
            bMatineeCharacter = true;
            // End:0x13F
            if(SPC != none)
            {
                P.SetPhysics(0);
                SPC.SavedMatineePhysics = Physics;
            }
        }
        // End:0x178
        if((SPC != none) && SkyAirVehicle(self) != none)
        {
            SkyAirVehicle(self).MovementDisabledRefCount = SPC.CinemaDisableInputMoveRefCount;
        }
    }
    // End:0x1BB
    if(SkySeats[0].SecondaryGun != none)
    {
        SkyVehicleInventoryManager(InvManager).SetCurrentSecondaryWeapon(SkySeats[0].SecondaryGun);
    }
    // End:0x1CF
    if(InvulnerableUntilDriven == true)
    {
        bIsInvulnerable = false;
    }
    // End:0x308
    if(bUsePilotsHealth)
    {
        SP = SkyPawn(P);
        // End:0x308
        if(SP != none)
        {
            Health = SP.Health;
            // End:0x308
            if(SP.FindWeaponEffect(4))
            {
                PoisonData.DamageAmount = SP.PoisonData.DamageAmount;
                PoisonData.DamageInterval = SP.PoisonData.DamageInterval;
                EndPoisonTimeLeft = SP.GetRemainingTimeForTimer('EndEffectPoison');
                SetTimer(EndPoisonTimeLeft, false, 'EndEffectPoison');
                DoPoisonDamageTimeLeft = SP.GetRemainingTimeForTimer('TakePoisonDamage');
                SetTimer(DoPoisonDamageTimeLeft, false, 'TakePoisonDamage');
                PoisonData.TotalDuration = SP.PoisonData.TotalDuration;
            }
        }
    }
    bSuccess = super.DriverEnter(P);
    // End:0x4D3
    if(bSuccess)
    {
        I = 0;
        J0x32A:

        // End:0x390 [Loop If]
        if(I < P.GeneratedEvents.Length)
        {
            Event = SkySeqEvent_EnterExitVehicle(P.GeneratedEvents[I]);
            // End:0x386
            if(Event != none)
            {
                Event.CheckEnterActivate(self, P, false);
            }
            ++I;
            // [Loop Continue]
            goto J0x32A;
        }
        // End:0x3CC
        if((P != none) && P.Mesh != none)
        {
            P.Mesh.DisablePhysics();
        }
        // End:0x3F0
        if(MovingLevel != none)
        {
            P.SetMovingLevel(MovingLevel);
        }
        SP = SkyPawn(P);
        // End:0x441
        if((SP != none) && SkyAirVehicle_RocketPackThrust(self) == none)
        {
            SP.SetRocketPackState(0);
            SP.NotifyRocketPacking = false;
        }
        // End:0x4D3
        if(bUsePilotsHealth && PilotHealthModifier != 0.0000000)
        {
            SP.Health *= PilotHealthModifier;
            SP.HealthMax *= PilotHealthModifier;
            // End:0x4D3
            if((SPC != none) && SkyHUD(SPC.myHUD) != none)
            {
                SkyHUD(SPC.myHUD).HudLastHealthValue *= PilotHealthModifier;
            }
        }
    }
    I = 0;
    J0x4DA:

    // End:0x535 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x52B
        if(Seats[I].Gun != none)
        {
            Seats[I].Gun.SetUpMuzzleFlash();
        }
        I++;
        // [Loop Continue]
        goto J0x4DA;
    }
    I = 0;
    J0x53C:

    // End:0x619 [Loop If]
    if(I < SkySeats.Length)
    {
        // End:0x58D
        if(SkySeats[I].GunForPlayer != none)
        {
            SkySeats[I].GunForPlayer.SetUpMuzzleFlash();
        }
        // End:0x5CE
        if(SkySeats[I].SecondaryGun != none)
        {
            SkySeats[I].SecondaryGun.SetUpMuzzleFlash();
        }
        // End:0x60F
        if(SkySeats[I].SecondaryGunForPlayer != none)
        {
            SkySeats[I].SecondaryGunForPlayer.SetUpMuzzleFlash();
        }
        I++;
        // [Loop Continue]
        goto J0x53C;
    }
    return bSuccess;
    //return ReturnValue;    
}

function TakePoisonDamage()
{
    TakeDamage(PoisonData.DamageAmount, Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'SkyDmgType_SmallBallistics');
    SetTimer(PoisonData.DamageInterval, false, 'TakePoisonDamage');
    //return;    
}

function EndEffectPoison()
{
    local SkyPawn SP;

    SP = SkyPawn(Driver);
    // End:0x2F
    if(SP != none)
    {
        SP.EndEffectPoison();
    }
    ClearTimer('TakePoisonDamage');
    //return;    
}

simulated function AttachDriver(Pawn P)
{
    local SkyPawnBase UTP;

    // End:0x0D
    if(!bAttachDriver)
    {
        return;
    }
    UTP = SkyPawnBase(P);
    // End:0xFD
    if(UTP != none)
    {
        UTP.SetPreventComponentUpdate(true);
        UTP.SetCollision(false, false, false, UTP.bForceTriggerTouch);
        UTP.bCollideWorld = false;
        UTP.SetHardAttach(true);
        UTP.SetLocation(Location);
        UTP.SetPhysics(0);
        // End:0xCC
        if(UTP.Mesh != none)
        {
            UTP.Mesh.DisablePhysics();
        }
        SitDriver(UTP, 0);
        UTP.SetPreventComponentUpdate(false);
        UTP.ScriptConditionalUpdateComponents();
    }
    //return;    
}

simulated function DrivingStatusChanged()
{
    super.DrivingStatusChanged();
    // End:0x38
    if((int(Role) < int(ROLE_Authority)) && bDriving)
    {
        SetPhysics(10);
        SetControls(Controller);        
    }
    else
    {
        // End:0x6E
        if((int(Role) < int(ROLE_Authority)) && PlayerController(Controller) != none)
        {
            RestoreControls(PlayerController(Controller));
        }
    }
    //return;    
}

simulated event bool DriverLeave(bool bForceLeave)
{
    local SkyPawn SPDriver;
    local bool Result;
    local SkyPlayerController SPC;
    local int I;
    local SkySeqEvent_EnterExitVehicle Event;
    local Rotator Facing;
    local Vector aVector;

    SPDriver = SkyPawn(Driver);
    SPC = SkyPlayerController(Controller);
    // End:0x61
    if(SPC != none)
    {
        SPC.bNearestTargetCam = false;
        SPC.bFreeLookCam = false;
        SPC.QuickLookCam = 0;
    }
    StopWeaponFiring();
    bTargeting = false;
    // End:0x1C5
    if(SPDriver != none)
    {
        // End:0xEB
        if(SPDriver.VehicleBoostLocalEffectComponent != none)
        {
            SPDriver.SetKillOnDeactivate(SPDriver.VehicleBoostLocalEffectComponent, true);
            SPDriver.RemoveLocalEffect(SPDriver.VehicleBoostLocalEffectComponent);
            SPDriver.VehicleBoostLocalEffectComponent = none;
        }
        // End:0x158
        if(SPDriver.VehicleBrakeLocalEffectComponent != none)
        {
            SPDriver.SetKillOnDeactivate(SPDriver.VehicleBrakeLocalEffectComponent, true);
            SPDriver.RemoveLocalEffect(SPDriver.VehicleBrakeLocalEffectComponent);
            SPDriver.VehicleBrakeLocalEffectComponent = none;
        }
        // End:0x1C5
        if(SPDriver.VehicleStandardMovementLocalEffectComponent != none)
        {
            SPDriver.SetKillOnDeactivate(SPDriver.VehicleStandardMovementLocalEffectComponent, true);
            SPDriver.RemoveLocalEffect(SPDriver.VehicleStandardMovementLocalEffectComponent);
            SPDriver.VehicleStandardMovementLocalEffectComponent = none;
        }
    }
    // End:0x227
    if(((SPC != none) && SkyHUD(SPC.myHUD) != none) && Driver != none)
    {
        SkyHUD(SPC.myHUD).HudLastHealthValue = Driver.Health;
    }
    // End:0x2C1
    if((!bForceLeave && SPDriver != none) && SPDriver.ExitingVehicle == none)
    {
        // End:0x272
        if(!bSupressExitAnim)
        {
            SPDriver.ExitingVehicle = self;
        }
        // End:0x2B6
        if(bUseFadeToBlackOnExit && SPC != none)
        {
            SPC.ExitVehicleFadeToBlack(TimeUntilFadeToBlack, TimeOfFadeToBlack, TimeOfBlack, TimeOfFadeFromBlack, bSupressExitAnim);
        }
        Result = false;        
    }
    else
    {
        Result = super.DriverLeave(bForceLeave);
        // End:0x2F9
        if(Result && SPC != none)
        {
            RestoreControls(SPC);
        }
        // End:0x3BF
        if(bUseExitLocationActor)
        {
            // End:0x32C
            if(ExitLocationActor != none)
            {
                SPDriver.SetLocation(ExitLocationActor.Location);                
            }
            else
            {
                // End:0x3A6
                if(bExitPositionRelativeToFacing)
                {
                    Facing = Rotator(Vector(SPDriver.Rotation));
                    Facing.Pitch = 0;
                    aVector.Z = 10.0000000;
                    SPDriver.SetLocation((Location + (-Vector(Facing) * VSize(ExitPositions))) + aVector);                    
                }
                else
                {
                    SPDriver.SetLocation(Location + ExitPositions);
                }
            }
        }
    }
    // End:0x4C7
    if(Result)
    {
        I = 0;
        J0x3CF:

        // End:0x435 [Loop If]
        if(I < SPDriver.GeneratedEvents.Length)
        {
            Event = SkySeqEvent_EnterExitVehicle(SPDriver.GeneratedEvents[I]);
            // End:0x42B
            if(Event != none)
            {
                Event.CheckExitActivate(self, SPDriver, false);
            }
            ++I;
            // [Loop Continue]
            goto J0x3CF;
        }
        // End:0x4C7
        if(bUsePilotsHealth && PilotHealthModifier != 0.0000000)
        {
            SPDriver.Health /= PilotHealthModifier;
            SPDriver.HealthMax /= PilotHealthModifier;
            // End:0x4C7
            if((SPC != none) && SkyHUD(SPC.myHUD) != none)
            {
                SkyHUD(SPC.myHUD).HudLastHealthValue /= PilotHealthModifier;
            }
        }
    }
    // End:0x528
    if((((!bSupressExitAnim && SPDriver != none) && int(SPDriver.AnimDrivingState) == int(2)) && bInteruptEnterAnimForExit == true) && !Result)
    {
        SPDriver.AnimDrivingState = 4;
    }
    // End:0x5E8
    if(SPDriver != none)
    {
        // End:0x55F
        if(SPDriver.Health <= 0)
        {
            SPDriver.InitRagdoll();            
        }
        else
        {
            SPDriver.Mesh.SetPhysicsAsset(SPDriver.Mesh.PhysicsAsset);
            SPDriver.Mesh.PhysicsWeight = 0.0000000;
            SPDriver.Mesh.SetHasPhysicsAssetInstance(true);
            SPDriver.Mesh.SetComponentRBFixed(true);
        }
    }
    // End:0x6B3
    if(((Controller == none) && SavedAIController != none) && bSaveAIController)
    {
        // End:0x653
        if((SPC != none) && SkyPlayerInput(SPC.PlayerInput) != none)
        {
            SkyPlayerInput(SPC.PlayerInput).bSprint = 0;
        }
        Driver = none;
        SavedAIController.Possess(self, true);
        // End:0x69B
        if(SkyBotControllerPilot(SavedAIController) != none)
        {
            SavedAIController.GotoState('FlyingStakeOut');            
        }
        else
        {
            SavedAIController.GotoState('Start_State');
        }
    }
    // End:0x6F0
    if(Result && SkyAirVehicle_RocketPackThrust(self) == none)
    {
        SPDriver.TurnOffRocketPack();
        SPDriver.bGliding = false;
    }
    return Result;
    //return ReturnValue;    
}

simulated function DriverLeft()
{
    // End:0x25
    if((Controller != none) || (SavedAIController != none) && bSaveAIController)
    {
        return;
    }
    // End:0x40
    if(bShouldEject)
    {
        EjectDriver();
        bShouldEject = false;
    }
    StopFiringWeapon();
    super.DriverLeft();
    ResetTime = WorldInfo.TimeSeconds - float(1);
    //return;    
}

simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    //return;    
}

simulated event bool HasWheelsOnGround()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3C [Loop If]
    if(I < Wheels.Length)
    {
        // End:0x32
        if(Wheels[I].bWheelOnGround)
        {
            return true;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
    return true;
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local float XPos, YPos;
    local SkyPawn SP;

    SP = SkyPawn(HUD.PlayerOwner.Pawn);
    // End:0x62
    if(SP == none)
    {
        SP = SkyPawn(SkyVehicle(HUD.PlayerOwner.Pawn).Driver);
    }
    // End:0x11F
    if(SP != none)
    {
        // End:0xD7
        if(HUD.ShouldDisplayDebug('Anim') || HUD.ShouldDisplayDebug('AnimTree'))
        {
            SP.ShowAnimDebug(Mesh, HUD.Canvas);
        }
        // End:0x11F
        if(HUD.ShouldDisplayDebug('Transition'))
        {
            SP.ShowTransitionDebug(Mesh, HUD.Canvas);
        }
    }
    XPos = 640.0000000;
    YPos = 50.0000000;
    DisplaySupplementalDebug(HUD, XPos, out_YL, YPos);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    super(SVehicle).DisplayDebug(HUD, out_YL, out_YPos);
    //return;    
}

// Export USkyVehicle::execDisplaySupplementalDebug(FFrame&, void* const)
native function DisplaySupplementalDebug(HUD HUD, out float out_XPos, out float out_YL, out float out_YPos);

// Export USkyVehicle::execGetEffectSocketName(FFrame&, void* const)
native simulated function name GetEffectSocketName(int SeatIndex);

// Export USkyVehicle::execGetSecondaryEffectSocketName(FFrame&, void* const)
native simulated function name GetSecondaryEffectSocketName(int SeatIndex);

// Export USkyVehicle::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(Actor RequestedBy, optional bool bRequestAlternateLoc);

simulated function InitializeEffects()
{
    super.InitializeEffects();
    //return;    
}

// Export USkyVehicle::execTriggerVehicleEffect(FFrame&, void* const)
native simulated function TriggerVehicleEffect(name TriggerName);

// Export USkyVehicle::execApplyEffectDamage(FFrame&, void* const)
native event ApplyEffectDamage(Vector HitLocation, int Damage);

// Export USkyVehicle::execTakeDamage(FFrame&, void* const)
native simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyVehicle::execReducedDamageByDifficulty(FFrame&, void* const)
native function int ReducedDamageByDifficulty(int Damage);

// Export USkyVehicle::execGetAutoAimByDifficulty(FFrame&, void* const)
native function float GetAutoAimByDifficulty(SkyVWeap VWeapon);

// Export USkyVehicle::execUpdateAutoAim(FFrame&, void* const)
native function UpdateAutoAim(SkyVWeap VWeapon);

// Export USkyVehicle::execFireDamageTriggers(FFrame&, void* const)
native simulated function FireDamageTriggers(float prevHealth, float curHealth);

function UpdateControllerOnPossess(bool bVehicleTransition)
{
    //return;    
}

event Vector GetCameraLocation()
{
    return Location;
    //return ReturnValue;    
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    local int Damage;
    local Controller InstigatorController;

    // End:0x22
    if((WorldInfo.TimeSeconds - SpawnTime) < 2.0000000)
    {
        return;
    }
    // End:0x137
    if(LastCollisionDamageTime != WorldInfo.TimeSeconds)
    {
        super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
        Damage = int(VSizeSq(Mesh.GetRootBodyInstance().PreviousVelocity) * (GetCollisionDamageModifier(RigidCollisionData.ContactInfos)));
        // End:0x137
        if(Damage > 1)
        {
            // End:0xBD
            if(Controller != none)
            {
                InstigatorController = Controller;                
            }
            else
            {
                // End:0xDD
                if(Instigator != none)
                {
                    InstigatorController = Instigator.Controller;
                }
            }
            TakeDamage(Damage, InstigatorController, RigidCollisionData.ContactInfos[0].ContactPosition, vect(0.0000000, 0.0000000, 0.0000000), Class'SkyDmgType_Collision');
            LastCollisionDamageTime = WorldInfo.TimeSeconds;
        }
    }
    //return;    
}

event NewGroundMaterial(name MaterialType)
{
    //return;    
}

function bool StopWeaponFiring()
{
    local Inventory Item;
    local SkyVWeap SW;

    Item = InvManager.InventoryChain;
    J0x15:

    // End:0xAD [Loop If]
    if(Item != none)
    {
        SW = SkyVWeap(Item);
        // End:0x95
        if(SW != none)
        {
            SW.StopFire(0);
            SW.StopFire(1);
            SW.ClearTimer('RefireCheckTimer');
            SW.PutDownWeapon();
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x15;
    }
    return true;
    //return ReturnValue;    
}

event SelectEngineSoundByGear(int oldGear, int newGear)
{
    //return;    
}

simulated function OnSetSpeed(SkySeqAct_SetSpeed inAction)
{
    //return;    
}

event ReinitializeSeats()
{
    InvManager.DiscardInventory();
    InitializeSeats();
    //return;    
}

function InitializeSeats()
{
    local int I;

    // End:0x11
    if(Seats.Length == 0)
    {
        Destroy();
        return;
    }
    I = 0;
    J0x18:

    // End:0x112 [Loop If]
    if(I < Seats.Length)
    {
        // End:0x36
        if(I > 0)
        {            
        }
        else
        {
            Seats[I].SeatPawn = self;
            // End:0xD1
            if(SkySeats[I].PrimarySeatGunArchetype != none)
            {
                Seats[I].Gun = SkyVehicleWeapon(InvManager.CreateInventory(SkySeats[I].PrimarySeatGunArchetype.Class, false, SkySeats[I].PrimarySeatGunArchetype));
            }
        }
        Seats[I].SeatPawn.DriverDamageMult = Seats[I].DriverDamageMult;
        I++;
        // [Loop Continue]
        goto J0x18;
    }
    // End:0x123
    if(SkySeats.Length == 0)
    {
        Destroy();
        return;
    }
    I = 0;
    J0x12A:

    // End:0x2DB [Loop If]
    if(I < SkySeats.Length)
    {
        // End:0x148
        if(I > 0)
        {
            // [Explicit Continue]
            goto J0x2D1;
        }
        // End:0x1CB
        if(SkySeats[I].PrimarySeatGunArchetypeForPlayer != none)
        {
            SkySeats[I].GunForPlayer = SkyVehicleWeapon(InvManager.CreateInventory(SkySeats[I].PrimarySeatGunArchetypeForPlayer.Class, false, SkySeats[I].PrimarySeatGunArchetypeForPlayer));
        }
        // End:0x24E
        if(SkySeats[I].SecondarySeatGunArchetype != none)
        {
            SkySeats[I].SecondaryGun = SkyVehicleWeapon(InvManager.CreateInventory(SkySeats[I].SecondarySeatGunArchetype.Class, false, SkySeats[I].SecondarySeatGunArchetype));
        }
        // End:0x2D1
        if(SkySeats[I].SecondarySeatGunArchetypeForPlayer != none)
        {
            SkySeats[I].SecondaryGunForPlayer = SkyVehicleWeapon(InvManager.CreateInventory(SkySeats[I].SecondarySeatGunArchetypeForPlayer.Class, false, SkySeats[I].SecondarySeatGunArchetypeForPlayer));
        }
        J0x2D1:

        I++;
        // [Loop Continue]
        goto J0x12A;
    }
    PostInitSeats();
    //return;    
}

// Export USkyVehicle::execPostInitSeats(FFrame&, void* const)
native function PostInitSeats();

simulated function PreCacheSeatNames()
{
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local string VarString;
    local int SeatIndex;

    VarString = "" $ string(VarName);
    // End:0xC8
    if(Right(VarString, 19) ~= "secondaryflashcount")
    {
        SeatIndex = GetSeatIndexFromPrefix(Left(VarString, Len(VarString) - 19));
        // End:0xC5
        if(SeatIndex >= 0)
        {
            SkySeats[SeatIndex].SecondaryGunBarrelIndex++;
            // End:0xB5
            if(int(SeatSecondaryFlashCount(SeatIndex,, true)) > int(0))
            {
                VehicleSecondaryWeaponFired(true, vect(0.0000000, 0.0000000, 0.0000000), SeatIndex);                
            }
            else
            {
                VehicleSecondaryWeaponStoppedFiring(true, SeatIndex);
            }
        }        
    }
    else
    {
        // End:0x183
        if(Right(VarString, 22) ~= "secondaryflashlocation")
        {
            SeatIndex = GetSeatIndexFromPrefix(Left(VarString, Len(VarString) - 22));
            // End:0x180
            if(SeatIndex >= 0)
            {
                SkySeats[SeatIndex].SecondaryGunBarrelIndex++;
                // End:0x170
                if(!IsZero(SeatSecondaryFlashLocation(SeatIndex,, true)))
                {
                    VehicleSecondaryWeaponFired(true, SeatSecondaryFlashLocation(SeatIndex,, true), SeatIndex);                    
                }
                else
                {
                    VehicleSecondaryWeaponStoppedFiring(true, SeatIndex);
                }
            }            
        }
        else
        {
            // End:0x1DA
            if(VarName == 'SecondaryGun')
            {
                SkySeats[0].SecondaryGun = SecondaryGun;
                // End:0x1D7
                if(SecondaryGun != none)
                {
                    SkySeats[0].SecondaryGun.SetBase(self);
                }                
            }
            else
            {
                super.ReplicatedEvent(VarName);
            }
        }
    }
    //return;    
}

// Export USkyVehicle::execVehicleAdjustSecondaryFlashCount(FFrame&, void* const)
native simulated function VehicleAdjustSecondaryFlashCount(int SeatIndex, byte FireModeNum, optional bool bClear);

// Export USkyVehicle::execVehicleAdjustSecondaryFlashLocation(FFrame&, void* const)
native simulated function VehicleAdjustSecondaryFlashLocation(int SeatIndex, byte FireModeNum, Vector NewLocation, optional bool bClear);

function PossessedBy(Controller C, bool bVehicleTransition)
{
    local int I;

    super.PossessedBy(C, bVehicleTransition);
    // End:0x108
    if(PlayerController(C) != none)
    {
        // End:0x8F
        if((SkySeats[0].GunForPlayer != none) && Seats[0].Gun != SkySeats[0].GunForPlayer)
        {
            SkyVehicleInventoryManager(InvManager).SetCurrentWeapon(SkySeats[0].GunForPlayer);
        }
        // End:0xFD
        if((SkySeats[0].SecondaryGunForPlayer != none) && SkySeats[0].SecondaryGun != SkySeats[0].SecondaryGunForPlayer)
        {
            SkyVehicleInventoryManager(InvManager).SetCurrentSecondaryWeapon(SkySeats[0].SecondaryGunForPlayer);
        }
        bNoEncroachCheck = true;        
    }
    else
    {
        // End:0x15C
        if(Seats[0].Gun != SkySeats[0].GunForAI)
        {
            SkyVehicleInventoryManager(InvManager).SetCurrentWeapon(SkySeats[0].GunForAI);
        }
        // End:0x1B0
        if(SkySeats[0].SecondaryGun != SkySeats[0].SecondaryGunForAI)
        {
            SkyVehicleInventoryManager(InvManager).SetCurrentSecondaryWeapon(SkySeats[0].SecondaryGunForAI);
        }
        bNoEncroachCheck = true;
    }
    // End:0x1F3
    if(SkySeats[0].SecondaryGun != none)
    {
        SkySeats[0].SecondaryGun.ClientWeaponSet(false);
    }
    // End:0x20D
    if(PlayerController(C) != none)
    {
        NotifyTeamClearEnemy();
    }
    I = 0;
    J0x214:

    // End:0x26F [Loop If]
    if(I < Seats.Length)
    {
        // End:0x265
        if(Seats[I].Gun != none)
        {
            Seats[I].Gun.SetUpMuzzleFlash();
        }
        I++;
        // [Loop Continue]
        goto J0x214;
    }
    I = 0;
    J0x276:

    // End:0x353 [Loop If]
    if(I < SkySeats.Length)
    {
        // End:0x2C7
        if(SkySeats[I].GunForPlayer != none)
        {
            SkySeats[I].GunForPlayer.SetUpMuzzleFlash();
        }
        // End:0x308
        if(SkySeats[I].SecondaryGun != none)
        {
            SkySeats[I].SecondaryGun.SetUpMuzzleFlash();
        }
        // End:0x349
        if(SkySeats[I].SecondaryGunForPlayer != none)
        {
            SkySeats[I].SecondaryGunForPlayer.SetUpMuzzleFlash();
        }
        I++;
        // [Loop Continue]
        goto J0x276;
    }
    //return;    
}

simulated function NotifyTeamClearEnemy()
{
    local SkyTeamInfo BotTeam;
    local SkySquadAI S;

    // End:0xCE
    if(Controller != none)
    {
        BotTeam = SkyGame(WorldInfo.Game).GetBotTeam(Controller.PlayerReplicationInfo.Team.TeamIndex);
        // End:0xCE
        if(BotTeam != none)
        {
            // End:0xCE
            if(BotTeam.AI != none)
            {
                S = BotTeam.AI.Squads;
                J0x96:

                // End:0xCE [Loop If]
                if(S != none)
                {
                    S.RemoveEnemy(self);
                    S = S.NextSquad;
                    // [Loop Continue]
                    goto J0x96;
                }
            }
        }
    }
    //return;    
}

simulated function ClearFlashCount(Weapon Who)
{
    //return;    
}

// Export USkyVehicle::execIncrementFlashCount(FFrame&, void* const)
native simulated function IncrementFlashCount(Weapon Who, byte FireModeNum);

// Export USkyVehicle::execSetFlashLocation(FFrame&, void* const)
native function SetFlashLocation(Weapon Who, byte FireModeNum, Vector NewLoc);

function ClearFlashLocation(Weapon Who)
{
    local SkyVWeap VWeap;

    VWeap = SkyVWeap(Who);
    // End:0xB5
    if(VWeap != none)
    {
        // End:0x73
        if(VWeap.bIsPrimaryWeapon)
        {
            VehicleAdjustFlashLocation(VWeap.SeatIndex, SeatFiringMode(VWeap.SeatIndex,, true), vect(0.0000000, 0.0000000, 0.0000000), true);            
        }
        else
        {
            VehicleAdjustSecondaryFlashLocation(VWeap.SeatIndex, SeatFiringMode(VWeap.SeatIndex,, true), vect(0.0000000, 0.0000000, 0.0000000), true);
        }
    }
    //return;    
}

simulated function VehicleWeaponFired(bool bViaReplication, Vector HitLocation, int SeatIndex)
{
    super.VehicleWeaponFired(bViaReplication, HitLocation, SeatIndex);
    // End:0x37
    if(MaterialEffectManager != none)
    {
        MaterialEffectManager.ActivateEffect(3);
    }
    //return;    
}

simulated function VehicleWeaponStoppedFiring(bool bViaReplication, int SeatIndex)
{
    super.VehicleWeaponStoppedFiring(bViaReplication, SeatIndex);
    // End:0x32
    if(MaterialEffectManager != none)
    {
        MaterialEffectManager.ActivateEffect(4);
    }
    //return;    
}

// Export USkyVehicle::execVehicleSecondaryWeaponFired(FFrame&, void* const)
native simulated function VehicleSecondaryWeaponFired(bool bViaReplication, Vector HitLocation, int SeatIndex);

// Export USkyVehicle::execVehicleSecondaryWeaponStoppedFiring(FFrame&, void* const)
native simulated function VehicleSecondaryWeaponStoppedFiring(bool bViaReplication, int SeatIndex);

simulated function StartFire(byte FireModeNum)
{
    // End:0x17
    if(bKismetDisabledPrimaryFire == false)
    {
        super(Pawn).StartFire(FireModeNum);
    }
    //return;    
}

// Export USkyVehicle::execStartSecondaryFire(FFrame&, void* const)
native final function StartSecondaryFire(byte FireModeNum);

function bool StopFiring()
{
    // End:0x2E
    if(Weapon != none)
    {
        Weapon.StopFire(Weapon.CurrentFireMode);
    }
    StopSecondaryFire(0);
    return true;
    //return ReturnValue;    
}

// Export USkyVehicle::execStopSecondaryFire(FFrame&, void* const)
native final function StopSecondaryFire(byte FireModeNum);

// Export USkyVehicle::execGetPhysicalFireStartLoc(FFrame&, void* const)
native simulated function Vector GetPhysicalFireStartLoc(SkyWeaponBase ForWeapon);

// Export USkyVehicle::execGetSecondaryEffectLocation(FFrame&, void* const)
native simulated function Vector GetSecondaryEffectLocation(int SeatIndex);

// Export USkyVehicle::execGetSecondaryGunBarrelLocationAndRotation(FFrame&, void* const)
native simulated function GetSecondaryGunBarrelLocationAndRotation(int SeatIndex, out Vector SocketLocation, optional out Rotator SocketRotation);

// Export USkyVehicle::execGetWeaponAim(FFrame&, void* const)
native function Rotator GetWeaponAim(SkyVehicleWeapon VWeapon);

function float GetDamageScaling()
{
    // End:0x2B
    if(Driver != none)
    {
        return Driver.GetDamageScaling() * super(Pawn).GetDamageScaling();        
    }
    else
    {
        return super(Pawn).GetDamageScaling();
    }
    //return ReturnValue;    
}

function byte ChooseFireMode()
{
    return 0;
    //return ReturnValue;    
}

function bool BotFire(bool bFinished)
{
    local SkyBotControllerBase Bot;

    Bot = SkyBotControllerBase(Controller);
    // End:0x53
    if((Bot != none) && int(Bot.ScriptedFireMode) != int(255))
    {
        StartFire(Bot.ScriptedFireMode);        
    }
    else
    {
        StartFire(ChooseFireMode());
    }
    return true;
    //return ReturnValue;    
}

function bool NeedToTurn(Vector targ)
{
    local SkyVehicleWeapon VWeapon;

    VWeapon = SkyVehicleWeapon(Weapon);
    // End:0x35
    if(VWeapon != none)
    {
        return !VWeapon.IsAimCorrect();        
    }
    else
    {
        return super(Pawn).NeedToTurn(targ);
    }
    //return ReturnValue;    
}

function OnSetInvulnerability(SkySeqAct_SetInvulnerability inAction)
{
    bIsInvulnerable = inAction.bIsInvulnerable;
    //return;    
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local array<Object> objVars;
    local int Idx;
    local Actor destActor;

    Action.GetObjectVars(objVars, "Destination");
    Idx = 0;
    J0x29:

    // End:0x66 [Loop If]
    if((Idx < objVars.Length) && destActor == none)
    {
        destActor = Actor(objVars[Idx]);
        Idx++;
        // [Loop Continue]
        goto J0x29;
    }
    // End:0xC8
    if(destActor != none)
    {
        // End:0xC8
        if(Mesh != none)
        {
            Mesh.SetRBPosition(destActor.Location);
            Mesh.SetRBRotation(destActor.Rotation);
            PlayTeleportEffect(false, true);
        }
    }
    //return;    
}

simulated function OnLockEnemy(SkySeqAct_LockEnemy Action)
{
    // End:0x2E
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).OnLockEnemy(Action);
    }
    //return;    
}

simulated function OnSetSocketPreferenceChannel(SkySeqAct_SetSocketPreferenceChannel Action)
{
    // End:0x2E
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).OnSetSocketPreferenceChannel(Action);
    }
    //return;    
}

// Export USkyVehicle::execMAT_BeginAnimControl(FFrame&, void* const)
native function MAT_BeginAnimControl(array<AnimSet> InAnimSets);

// Export USkyVehicle::execMAT_SetAnimPosition(FFrame&, void* const)
native function AnimNodeSequence MAT_SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping);

// Export USkyVehicle::execMAT_SetAnimWeights(FFrame&, void* const)
native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos);

// Export USkyVehicle::execMAT_FinishAnimControl(FFrame&, void* const)
native function MAT_FinishAnimControl();

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    MAT_BeginAnimControl(InAnimSets);
    //return;    
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    MAT_SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
    //return;    
}

simulated event SetAnimWeights(array<AnimSlotInfo> SlotInfos)
{
    MAT_SetAnimWeights(SlotInfos);
    //return;    
}

simulated event FinishAnimControl()
{
    MAT_FinishAnimControl();
    //return;    
}

// Export USkyVehicle::execIsVehicleDead(FFrame&, void* const)
native final function bool IsVehicleDead();

// Export USkyVehicle::execIsStalled(FFrame&, void* const)
native function bool IsStalled();

// Export USkyVehicle::execSetStalled(FFrame&, void* const)
native function SetStalled(bool bOn);

// Export USkyVehicle::execSetDorment(FFrame&, void* const)
native function SetDorment(bool newDorment);

function OnVehicleInvulnerability(SkySeqAct_VehicleInvulnerability Action)
{
    bIsInvulnerable = Action.bInvulnerable;
    //return;    
}

// Export USkyVehicle::execSnapToGround(FFrame&, void* const)
native function SnapToGround();

// Export USkyVehicle::execRepair(FFrame&, void* const)
native function Repair();

// Export USkyVehicle::execRearm(FFrame&, void* const)
native function Rearm();

simulated function EjectDriver()
{
    local Rotator ExitRotation;

    // End:0x59
    if(PlayerController(Driver.Controller) != none)
    {
        ExitRotation = Rotator(Velocity);
        ExitRotation.Pitch = -8192;
        Driver.Controller.SetRotation(ExitRotation);
    }
    // End:0x80
    if(SkyPawnBase(Driver) != none)
    {
        SkyPawnBase(Driver).bNotifyStopFalling = true;
    }
    //return;    
}

simulated function StopFiringWeapon()
{
    local SkyWeaponBase Weap;

    Weap = SkyWeaponBase(Weapon);
    // End:0x2F
    if(Weap != none)
    {
        Weap.ForceEndFire();
    }
    //return;    
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    // End:0x34
    if(Action.bAttachToDriverNotVehicle)
    {
        Driver.DoKismetAttachment(Attachment, Action);        
    }
    else
    {
        super(Pawn).DoKismetAttachment(Attachment, Action);
    }
    //return;    
}

// Export USkyVehicle::execGetCollisionEffect(FFrame&, void* const)
native function int GetCollisionEffect(PhysicalMaterial HitMaterial);

// Export USkyVehicle::execPlayCollisionEffect(FFrame&, void* const)
native function PlayCollisionEffect(int EffectIdx, Vector Loc, Vector Normal);

event SetCurrVOTimeRemaining(float Time)
{
    Driver.SetCurrVOTimeRemaining(Time);
    //return;    
}

simulated state DyingVehicle
{
    simulated function InitialVehicleExplosion()
    {
        local Emitter ProjExplosion;
        local editinline SkyExplosionLight L;
        local array<name> BoneNames;
        local Vector explodeLocation;
        local float explodeRadius, explodeImpulse, explodeTimer;

        // End:0x1BD
        if(NumDeathExplosions > 0)
        {
            Mesh.GetBoneNames(BoneNames);
            explodeLocation = Mesh.GetBoneLocation(BoneNames[Rand(BoneNames.Length)]);
            // End:0x113
            if(EffectIsRelevant(explodeLocation, false))
            {
                ProjExplosion = Spawn(Class'SkyEmitter', self,, explodeLocation, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
                // End:0x113
                if(ProjExplosion != none)
                {
                    ProjExplosion.SetTemplate(BigExplosionTemplate, true);
                    // End:0x113
                    if(((ExplosionLightClass != none) && !WorldInfo.bDropDetail) && ShouldSpawnExplosionLight(explodeLocation, vect(0.0000000, 0.0000000, 1.0000000)))
                    {
                        L = new (Outer) ExplosionLightClass;
                        ProjExplosion.AttachComponent(L);
                    }
                }
            }
            // End:0x12E
            if(ExplosionSound != none)
            {
                PlaySound(ExplosionSound, true);
            }
            explodeRadius = DeathExplosionRadiusMin + (FRand() * (DeathExplosionRadiusMax - DeathExplosionRadiusMin));
            explodeImpulse = DeathExplosionImpulseMin + (FRand() * (DeathExplosionImpulseMax - DeathExplosionImpulseMin));
            Mesh.AddRadialImpulse(explodeLocation, explodeRadius, explodeImpulse, 0);
            explodeTimer = DeathExplosionTimerMin + (FRand() * (DeathExplosionTimerMax - DeathExplosionTimerMin));
            SetTimer(explodeTimer, false, 'InitialVehicleExplosion');            
        }
        else
        {
            SetTimer(2.0000000, false, 'StopVehicleSounds');
        }
        NumDeathExplosions--;
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        NumDeathExplosions = DeathExplosionsMin + Rand(DeathExplosionsMax - DeathExplosionsMin);
        // End:0x32
        if(bNonViolentDeath)
        {
            LifeSpan = RagdollLifespan;            
        }
        else
        {
            // End:0x57
            if((RagdollMesh != none) && !bHideRagdoll)
            {
                SwitchToRagDoll();                
            }
            else
            {
                LifeSpan = RagdollLifespan;
                Mesh.SetHidden(true);
                // End:0xBF
                if(CollisionComponent != none)
                {
                    CollisionComponent.SetBlockRigidBody(false);
                    // End:0xBF
                    if(CollisionComponent.BodyInstance != none)
                    {
                        CollisionComponent.BodyInstance.SetBlockRigidBody(false);
                    }
                }
            }
        }
        // End:0xF6
        if(!bNonViolentDeath)
        {
            bBlockActors = false;
            bNoEncroachCheck = true;
            Mesh.CastShadow = false;
            InitialVehicleExplosion();
        }
        SetBurnOut();
        // End:0x139
        if(Controller != none)
        {
            // End:0x12C
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.Destroy();
            }
        }
        I = 0;
        J0x140:

        // End:0x185 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x17B
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x140;
        }
        // End:0x1B4
        if(!bNonViolentDeath && DeathReaction != 'None')
        {
            StartReaction(DeathReaction);
        }
        //return;        
    }
    stop;    
}
