class AdvPlayerPawn extends AdvPawn
    config(Pawn)
    hidecategories(Navigation)
    implements(EvilPlayer_interface);

var() config float AutoRecoveryDelay;
var float LowHealthAmbientThreshold;
var delegate<OnArmAnimEnd> OnLeftArmAnimEndDelegate;
var delegate<OnArmAnimEnd> OnRightArmAnimEndDelegate;
var SkelControlSingleBone LeanController;
var() config float DamageScalingRange;
var() config float DamageScalingFactor;
var() config int AutoRecoveryHealthDivider;
var AdvInventoryItem_Torch MyTorch;
var SoundCue ElectroHitSnd;
var SoundCue FireHitSnd;
var float AbsoluteDamageReductionFactor;
var float JumpStamina;
var bool bRegenerateJumpStamina;
var() config bool bUseJumpStamina;
var repnotify bool bIsAiming;
var bool bBlendGettingUpCamera;
var bool bAfterStand;
var repnotify bool bFlashlightOn;
var repnotify bool bFlashlightBeamActive;
var bool bStopHealthRegenByDamage;
var() config bool bForceStopHealthRegen;
var bool bGodModeInLastBreath;
var() config float JumpStaminaRegenDelay;
var() config float JumpStaminaRegenAmount;
var() config float ExplosionStunDefaultTime;
var() config float ExplosionStunMinTime;
var() config float ExplosionStunDelay;
var transient float ExplosionStunLastStrength;
var float JumpStaminaCost;
var float SlideCamXoffset;
var float SlideCamZoffset;
var repnotify float PowerDrainRate;
var repnotify float PowerRecoveryRate;
var repnotify float PowerBlinkChance;
var() config float TimeBeforeHealthRegen;
var float TimeElapsedForHealthRegen;
var float TimeElapsedInHealthRegen;
var() config float AutoRecoveryHealthFactor;
var float AutoRecoveryIntervalTime;
var() SoundCue DeathJingle;
//var delegate<OnArmAnimEnd> __OnArmAnimEnd__Delegate;

replication
{
    // Pos:0x000
    if(bNetDirty
        JumpStamina, bFlashlightBeamActive, 
        bFlashlightOn, bUseJumpStamina;

    // Pos:0x00A
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        MyTorch, PowerBlinkChance, 
        PowerDrainRate, PowerRecoveryRate, 
        bIsAiming;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x1F
        case 'bFlashlightOn':
        // End:0x38
        case 'bFlashlightBeamActive':
            UpdateFlashlightAttachment();
            // End:0x187
            break;
        // End:0x44
        case 'PowerDrainRate':
        // End:0x50
        case 'PowerRecoveryRate':
        // End:0x14E
        case 'PowerBlinkChance':
            // End:0x14B
            if(MyTorch != none)
            {
                MyTorch.TorchParts.PowerDrainRate = self.PowerDrainRate;
                MyTorch.TorchParts.PowerRecoveryRate = self.PowerRecoveryRate;
                MyTorch.TorchParts.PowerBlinkChance = int(self.PowerBlinkChance);
            }
            // End:0x187
            break;
        // End:0x171
        case 'bIsAiming':
            SetAimBlend(bIsAiming);
            // End:0x187
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

simulated function ChangeTorchPowerFromVolume(bool bEntering, optional float InPower, optional float InDrainRate, optional float InRecoveryRate, optional float InBlinkChance, optional bool bInfiniteBattery, optional bool InLookForGlowableElements)
{
    // End:0xBF
    if(bEntering)
    {
        // End:0x50
        if(bInfiniteBattery)
        {
            PowerDrainRate = 0.0000000;
            PowerRecoveryRate = 0.0000000;
            PowerBlinkChance = 0.0000000;            
        }
        else
        {
            // End:0x74
            if(InDrainRate != float(0))
            {
                PowerDrainRate = InDrainRate;
            }
            // End:0x98
            if(InRecoveryRate != float(0))
            {
                PowerRecoveryRate = InRecoveryRate;
            }
            // End:0xBC
            if(InBlinkChance != float(0))
            {
                PowerBlinkChance = InBlinkChance;
            }
        }        
    }
    else
    {
        PowerDrainRate = Class'AdvInventoryTorchParts'.default.PowerDrainRate;
        PowerRecoveryRate = Class'AdvInventoryTorchParts'.default.PowerRecoveryRate;
        PowerBlinkChance = float(Class'AdvInventoryTorchParts'.default.PowerBlinkChance);
    }
    // End:0x2C5
    if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).bIsSurvivalGame)
    {
        // End:0x24C
        if(AdvAttachment_Weap_Base(self.CurrentWeaponAttachment) != none)
        {
            AdvAttachment_Weap_Base(self.CurrentWeaponAttachment).ChangeTorchPowerFromVolume(true,, PowerDrainRate, PowerRecoveryRate, PowerBlinkChance);
        }
        // End:0x2C5
        if(AdvAttachment_Weap_Base(self.CurrentWeaponLeftAttachment) != none)
        {
            AdvAttachment_Weap_Base(self.CurrentWeaponLeftAttachment).ChangeTorchPowerFromVolume(true,, PowerDrainRate, PowerRecoveryRate, PowerBlinkChance);
        }
    }
    //return;    
}

simulated function UpdateFlashlightAttachment()
{
    // End:0x218
    if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).bIsSurvivalGame)
    {
        // End:0x159
        if(AdvAttachment_Weap_Base(self.CurrentWeaponAttachment) != none)
        {
            AdvAttachment_Weap_Base(self.CurrentWeaponAttachment).bFlashlightOn = self.bFlashlightOn;
            AdvAttachment_Weap_Base(self.CurrentWeaponAttachment).bFlashlightBeamActive = self.bFlashlightBeamActive;
        }
        // End:0x218
        if(AdvAttachment_Weap_Base(self.CurrentWeaponLeftAttachment) != none)
        {
            AdvAttachment_Weap_Base(self.CurrentWeaponLeftAttachment).bFlashlightOn = self.bFlashlightOn;
            AdvAttachment_Weap_Base(self.CurrentWeaponLeftAttachment).bFlashlightBeamActive = self.bFlashlightBeamActive;
        }
    }
    //return;    
}

function EvilPawn GetPlayerPawn()
{
    return self;
    //return ReturnValue;    
}

function EvilPlayerController GetPC()
{
    return EvilPlayerController(Controller);
    //return ReturnValue;    
}

delegate OnArmAnimEnd(bool RightHand, optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    //return;    
}

function SetOnArmAnimEndDelegate(delegate<OnArmAnimEnd> InDelegate, bool bLeftArm)
{
    // End:0x6A
    if(bLeftArm)
    {
        // End:0x54
        if(InDelegate != OnLeftArmAnimEndDelegate && OnLeftArmAnimEndDelegate != none)
        {
            OnArmAnimEnd(true, none, 0.0000000, 0.0000000);
        }
        OnLeftArmAnimEndDelegate = InDelegate;        
    }
    else
    {
        // End:0xB1
        if(InDelegate != OnRightArmAnimEndDelegate && OnRightArmAnimEndDelegate != none)
        {
            OnArmAnimEnd(true, none, 0.0000000, 0.0000000);
        }
        OnRightArmAnimEndDelegate = InDelegate;
    }
    //return;    
}

function bool IsAiming()
{
    return bIsAiming;
    //return ReturnValue;    
}

function ResetOnArmAnimEndDelegate(bool bLeftHand)
{
    // End:0x2B
    if(bLeftHand)
    {
        OnLeftArmAnimEndDelegate = None;        
    }
    else
    {
        OnRightArmAnimEndDelegate = None;
    }
    //return;    
}

function Weapon GetWeaponLeft()
{
    return WeaponLeft;
    //return ReturnValue;    
}

function Weapon GetWeapon()
{
    return Weapon;
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    local AdvPlayerController PC;

    super.PossessedBy(C, bVehicleTransition);
    PC = AdvPlayerController(C);
    // End:0x6A
    if(PC != none)
    {
        PC.ApplyTreasurePerk(false, 0);
    }
    //return;    
}

reliable server function ServerSetAimBlend(bool bShouldAim)
{
    bIsAiming = bShouldAim;
    bForceNetUpdate = true;
    super(EvilPawn).ServerSetAimBlend(bShouldAim);
    //return;    
}

simulated function StartReload()
{
    // End:0x25
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(21,,, GetReloadAnimPackedIndex());
    }
    //return;    
}

simulated function StopReload()
{
    // End:0x19
    if(IsLocallyControlled())
    {
        LocalEndPawnAction(21);
    }
    //return;    
}

simulated function StartEquipWeapon()
{
    // End:0x25
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(22,,, GetEquipAnimIndex());
    }
    //return;    
}

simulated function StartHideWeapon()
{
    // End:0x25
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(23,,, GetHideAnimIndex());
    }
    //return;    
}

simulated function DoMelee()
{
    super(EvilPawn).DoMelee();
    // End:0x2F
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(24,,, GetMeleeAnimIndex());
    }
    //return;    
}

simulated function DoMeleeKick()
{
    super(EvilPawn).DoMeleeKick();
    // End:0x2F
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(6,,, GetKickAnimIndex());
    }
    //return;    
}

function int GetEquipAnimIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x85
    if(CurrentWeaponAttachment != none)
    {
        switch(CurrentWeaponAttachment.WeapAnimType)
        {
            // End:0x4B
            case 0:
                AST = 63;
                // End:0x71
                break;
            // End:0x5F
            case 1:
                AST = 64;
                // End:0x71
                break;
            // End:0xFFFF
            default:
                AST = 63;
                // End:0x71
                break;
                break;
        }
        return PackRandomAnimInfo(AST);
    }
    return 0;
    //return ReturnValue;    
}

function int GetHideAnimIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x85
    if(CurrentWeaponAttachment != none)
    {
        switch(CurrentWeaponAttachment.WeapAnimType)
        {
            // End:0x4B
            case 0:
                AST = 65;
                // End:0x71
                break;
            // End:0x5F
            case 1:
                AST = 66;
                // End:0x71
                break;
            // End:0xFFFF
            default:
                AST = 65;
                // End:0x71
                break;
                break;
        }
        return PackRandomAnimInfo(AST);
    }
    return 0;
    //return ReturnValue;    
}

function int GetReloadAnimPackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;
    local EvilWeap_Base Weap;
    local int AnimIndex;
    local EvilAnimInfo AnimInfo;
    local EvilPlayerController PC;

    // End:0x1F2
    if(CurrentWeaponAttachment != none)
    {
        switch(CurrentWeaponAttachment.WeapAnimType)
        {
            // End:0x4B
            case 1:
                AST = 62;
                // End:0x9F
                break;
            // End:0xFFFF
            default:
                switch(CurrentWeaponAttachment.EvilWeapAnimType)
                {
                    // End:0x8A
                    case 12:
                        AST = 189;
                        // End:0x9C
                        break;
                    // End:0xFFFF
                    default:
                        AST = 55;
                        // End:0x9C
                        break;
                        break;
                }
                // End:0x9F
                break;
                break;
        }
        Weap = EvilWeap_Base(Weapon);
        AnimIndex = AST_GetRandomAnimIndex(AST);
        // End:0x17B
        if((Weap != none) && AST_GetAnimInfo(AST, AnimIndex, AnimInfo))
        {
            Weapon3PPReloadRateModifier = Mesh.GetAnimLength(AnimInfo.AnimName) / Weap.GetReloadTime();            
        }
        else
        {
            Weapon3PPReloadRateModifier = 1.0000000;
        }
        PC = GetPC();
        // End:0x1D5
        if(PC != none)
        {
            PC.ClientToServerSetWeapon3PPReloadRateModifier(Weapon3PPReloadRateModifier);
        }
        return PackAnimInfo(AST, AnimIndex);
    }
    return 0;
    //return ReturnValue;    
}

function ParticleSystem GetSpecificFootStepEffect(EvilPhysicalMaterialPropertyBase FootstepSounds, int FootDown)
{
    return none;
    //return ReturnValue;    
}

function HealthRecovery(float DeltaTime)
{
    HealDamage(int(FClamp(AutoRecoveryHealthFactor * DeltaTime, 1.0000000, 20.0000000)), Controller, none);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local EvilPlayerController PC;

    super.Tick(DeltaTime);
    // End:0x46
    if(int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        UpdateFlashlightAttachment();
    }
    PC = GetPlayerController();
    // End:0x13F
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && PC != none)
    {
        // End:0xFE
        if(float(Health) < (LowHealthAmbientThreshold * DefaultHealth))
        {
            // End:0xFB
            if(!PC.IsLowHealthAmbientPlaying())
            {
                PC.ClientPlayLowHealthAmbient();
            }            
        }
        else
        {
            // End:0x13F
            if(PC.IsLowHealthAmbientPlaying())
            {
                PC.ClientStopLowHealthAmbient();
            }
        }
    }
    // End:0x2E8
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x174
        if(bStopHealthRegenByDamage)
        {
            TimeElapsedForHealthRegen += DeltaTime;
        }
        // End:0x1A6
        if(TimeElapsedForHealthRegen >= TimeBeforeHealthRegen)
        {
            bStopHealthRegenByDamage = false;
            TimeElapsedForHealthRegen = 0.0000000;
        }
        // End:0x26A
        if((!bForceStopHealthRegen && !bStopHealthRegenByDamage) && Health < HealthMax)
        {
            TimeElapsedInHealthRegen += DeltaTime;
            // End:0x267
            if(TimeElapsedInHealthRegen >= AutoRecoveryIntervalTime)
            {
                AutoRecoveryIntervalTime -= (DeltaTime * 0.1000000);
                // End:0x245
                if(AutoRecoveryIntervalTime <= float(0))
                {
                    AutoRecoveryIntervalTime = 0.0010000;
                }
                TimeElapsedInHealthRegen = 0.0000000;
                HealthRecovery(DeltaTime);
            }            
        }
        else
        {
            AutoRecoveryIntervalTime = AutoRecoveryDelay;
        }
        // End:0x2E8
        if(((!bForceStopHealthRegen && !bStopHealthRegenByDamage) && Health < HealthMax) && !IsTimerActive('HealthRecovery_T'))
        {
            SetTimer(AutoRecoveryDelay, true, 'HealthRecovery_T');
        }
    }
    // End:0x3C7
    if(LeanController != none)
    {
        // End:0x356
        if(LeanController.ControlStrength ~= 0.0000000)
        {
            // End:0x353
            if(int(CurrentLeanState) != int(0))
            {
                LeanController.SetSkelControlActive(true);
            }            
        }
        else
        {
            // End:0x38A
            if(int(CurrentLeanState) == int(0))
            {
                LeanController.SetSkelControlActive(false);
            }
            LeanController.BoneRotation.Roll = int(CurrLeanRotVal);
        }
    }
    //return;    
}

simulated function WeaponAttachmentChanged()
{
    super(EvilPawn).WeaponAttachmentChanged();
    // End:0x23
    if(CurrentWeaponAttachment != none)
    {
        StartEquipWeapon();
    }
    //return;    
}

function HealthRecovery_T()
{
    // End:0x1C8
    if(Health < HealthMax)
    {
        // End:0x1C5
        if(AdvPlayerController(GetPlayerController()) != none)
        {
            // End:0x179
            if(float(Health) < (DefaultHealth * 0.5000000))
            {
                // End:0xFD
                if(!AdvPlayerController(GetPlayerController()).CheckAlienFx(3))
                {
                    AdvPlayerController(GetPlayerController()).SetAlienFxLight(0, 255, 0, 0, 3, 0, (float(Health) / DefaultHealth) + AdvPlayerController(GetPlayerController()).criticalHealthDurationModifier, -1);                    
                }
                else
                {
                    AdvPlayerController(GetPlayerController()).SetAlienFxTimerRate(3, 0, 'SetAlienFxLast', ((float(Health) / DefaultHealth) + AdvPlayerController(GetPlayerController()).criticalHealthDurationModifier) * float(2));
                }
            }
            // End:0x1C5
            if(float(Health) > (DefaultHealth * 0.5000000))
            {
                AdvPlayerController(GetPlayerController()).ClearAlienFx(3);
            }
        }        
    }
    else
    {
        ClearTimer('HealthRecovery_T');
    }
    //return;    
}

simulated function EvilPlayerController GetPlayerController()
{
    // End:0x25
    if(Controller != none)
    {
        return EvilPlayerController(Controller);        
    }
    else
    {
        // End:0x5C
        if(DrivenVehicle != none)
        {
            return EvilPlayerController(DrivenVehicle.Controller);
        }
    }
    return none;
    //return ReturnValue;    
}

reliable client simulated function PlayClientPulseEffects(float Damage)
{
    GetPlayerController().GetPlayerHitEffects().PlayPulseEffects(Damage);
    //return;    
}

reliable client simulated function StopClientPulseEffects()
{
    GetPlayerController().GetPlayerHitEffects().StopPulseEffects();
    //return;    
}

reliable client simulated function PlayClientHitEffects(float Damage)
{
    GetPlayerController().GetPlayerHitEffects().ProcessHitEffects(Damage);
    //return;    
}

function IgnoreDamage_T()
{
    EndLastBreath();
    //return;    
}

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPlayerController());
    // End:0x67
    if(IsTimerActive('IgnoreDamage_T') && bGodModeInLastBreath)
    {
        InDamage = int(float(InDamage) * ReduceDamageFactor);
        return;
    }
    bStopHealthRegenByDamage = true;
    TimeElapsedForHealthRegen = 0.0000000;
    SetTimer(0.0000000, true, 'HealthRecovery_T');
    // End:0xC5
    if(Health > int(DefaultHealth * ReduceDamageReusePercentage))
    {
        bDamageCanBeIgnored = true;
    }
    // End:0x186
    if(float(Max(Health - InDamage, 0)) < (DefaultHealth * 0.3000000))
    {
        PC.SetAlienFxLight(0, 255, 0, 0, 3, 0, (float(Max(Health - InDamage, int(PC.minBlinkTime))) / DefaultHealth) + PC.criticalHealthDurationModifier, -1);
    }
    // End:0x248
    if(((float(InDamage) < DefaultHealth) && float(Max(Health - InDamage, 0)) < (DefaultHealth * ReduceDamagePercentage)) && bDamageCanBeIgnored)
    {
        // End:0x205
        if(!IsTimerActive('IgnoreDamage_T'))
        {
            StartLastBreath();
        }
        // End:0x248
        if(((Health - InDamage) <= 0) && bGodModeInLastBreath)
        {
            InDamage = Max(Health - 10, 0);
        }
    }
    super(EvilPawn).AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
    //return;    
}

function StartLastBreath()
{
    SetTimer(IgnoreDamageTimer, false, 'IgnoreDamage_T');
    ClientStartLastBreath();
    //return;    
}

reliable client simulated function ClientStartLastBreath()
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPlayerController());
    // End:0xF9
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && PC != none)
    {
        PC.ClientPlayLastBreathAmbient();
        AdvPostProcessManager(PC.GetPPManager()).LastBreathFlash();
        AdvPostProcessManager(PC.GetPPManager()).EnableVignette(true, 9.0000000);
    }
    //return;    
}

function EndLastBreath()
{
    bDamageCanBeIgnored = false;
    // End:0x37
    if(IsTimerActive('IgnoreDamage_T'))
    {
        ClearTimer('IgnoreDamage_T');
    }
    ClientEndLastBreath();
    //return;    
}

reliable client simulated function ClientEndLastBreath()
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPlayerController());
    // End:0xB7
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && PC != none)
    {
        PC.ClientStopLastBreathAmbient();
        AdvPostProcessManager(PC.GetPPManager()).EnableVignette(false);
    }
    //return;    
}

simulated function StartExplosionStun(float StunStrength)
{
    ExplosionStunLastStrength = StunStrength;
    SetTimer(ExplosionStunDelay, false, 'StartExplosionStun_T');
    //return;    
}

simulated function StartExplosionStun_T()
{
    local AdvPlayerController PC;
    local float StunLength;

    PC = AdvPlayerController(GetPlayerController());
    StunLength = FMax(ExplosionStunLastStrength * ExplosionStunDefaultTime, ExplosionStunMinTime);
    SetTimer(StunLength, false, 'EndExplosionStun');
    // End:0xCB
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && PC != none)
    {
        PC.ClientPlayExplosionStunAmbient(FClamp(ExplosionStunLastStrength, 0.0000000, 1.0000000));
    }
    //return;    
}

simulated function EndExplosionStun()
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPlayerController());
    // End:0x76
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && PC != none)
    {
        PC.ClientStopExplosionStunAmbient();
    }
    //return;    
}

simulated function PlayTakeHitEffects()
{
    local class<EvilDmgType_Base> UTDamage;
    local EvilPlayerController PC;
    local editinline AudioComponent CheckAC;
    local SoundCue ASound;
    local bool bSoundAlreadyPlaying;

    super(EvilPawn).PlayTakeHitEffects();
    UTDamage = class<EvilDmgType_Base>(LastTakeHitInfo.DamageType);
    PC = GetPlayerController();
    // End:0x19D
    if(UTDamage != none)
    {
        // End:0x19D
        if(PC != none)
        {
            bSoundAlreadyPlaying = false;
            // End:0xA2
            if(ClassIsChildOf(UTDamage, Class'AdvDmgType_Electro'))
            {
                ASound = ElectroHitSnd;
            }
            // End:0xCD
            if(ClassIsChildOf(UTDamage, Class'AdvDmgType_Fire'))
            {
                ASound = FireHitSnd;
            }
            // End:0x19D
            if(ASound != none)
            {
                // End:0x165
                foreach PC.HearSoundPoolComponents(CheckAC)
                {
                    // End:0x164
                    if((CheckAC.SoundCue == ASound) && CheckAC.IsPlaying())
                    {
                        bSoundAlreadyPlaying = true;
                    }                    
                }                
                // End:0x19D
                if(!bSoundAlreadyPlaying)
                {
                    PC.ClientPlaySound(ASound);
                }
            }
        }
    }
    //return;    
}

function bool CanBeDamagedBy(Controller EventInstigator, class<DamageType> DamageType)
{
    // End:0x5F
    if(ClassIsChildOf(EventInstigator.Class, Class'AdvAI_Ally') && IsSameTeam(EventInstigator.Pawn))
    {
        return false;        
    }
    else
    {
        return super.CanBeDamagedBy(EventInstigator, DamageType);
    }
    //return ReturnValue;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local class<EvilDmgType_Base> EvilDamageType;
    local float Distance, ScalingFactor;

    Damage *= AbsoluteDamageReductionFactor;
    // End:0x38F
    if(((GetPlayerController()) != none) && CanBeDamagedBy(EventInstigator, DamageType))
    {
        PlayClientHitEffects(float(Damage));
        // End:0xB2
        if(!AdvPlayerController(Controller).bCinematicMode)
        {
            GetPlayerController().ClientSpawnCameraLensEffect(Class'AdvEmitterCamera_Blood');
        }
        // End:0xF2
        if(float(Health - Damage) < (DefaultHealth * 0.7500000))
        {
            PlayClientPulseEffects(float(Damage));
        }
        EvilDamageType = class<EvilDmgType_Base>(DamageType);
        // End:0x264
        if(EvilDamageType != none)
        {
            // End:0x264
            if((int(EvilDamageType.default.ImpactTypeBallisticID) != int(0)) && DamageScalingRange > float(0))
            {
                Distance = VSize(EventInstigator.Pawn.Location - Location);
                ScalingFactor = FClamp(1.0000000 - (Distance / DamageScalingRange), 0.0000000, 1.0000000);
                Damage = int(float(Damage) + (float(Damage) * (ScalingFactor * DamageScalingFactor)));
                // End:0x264
                if(!AdvPlayerController(Controller).bCinematicMode)
                {
                    GetPlayerController().ClientSpawnCameraLensEffect(Class'AdvEmitterCamera_Blood');
                }
            }
        }
        // End:0x346
        if(!WorldInfo.GRI.IsMultiplayerGame() || AdvGRI(WorldInfo.GRI).IsSurvivalGame())
        {
            Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(AdvPlayerController(GetPlayerController()).GetFightDifficultyLevel()).ModifyDamage(Damage);
        }
        super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    //return;    
}

function OnDoPawnAction(SeqAct_DoPawnAction Action)
{
    //return;    
}

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    //return;    
}

simulated function bool CanBeKnockedDown()
{
    return false;
    //return ReturnValue;    
}

simulated function PlayMeleeImpacts(Vector HitLocation)
{
    // End:0x22
    if(!IsLocallyControlled())
    {
        super(EvilPawn).PlayMeleeImpacts(HitLocation);
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPlayerController());
    // End:0x5F
    if(EvilPlayerController(Controller) != none)
    {
        EvilPlayerController(Controller).SetButtonFilter(false);
    }
    // End:0x8E
    if(BaseSkeletalMeshComp != none)
    {
        BaseSkeletalMeshComp.SetOwnerNoSee(false);
    }
    PC.SetAlienFxLight(0, 255, 0, 0, 3, 0, PC.afterDeathDuration);
    // End:0x1E8
    if(((AdvPawn(Killer.Pawn) != self) && AdvGRI(WorldInfo.GRI).IsMultiplayerGame()) && !AdvGRI(WorldInfo.GRI).IsSurvivalGame())
    {
        AdvPlayerController(Killer).SetAlienFxLight(0, 0, 255, 0, 4, 0, AdvPlayerController(Killer).killDuration, 5);
    }
    // End:0x22B
    if((DeathJingle != none) && !ClassIsChildOf(DamageType, Class'EvilGame.EvilDmgType_Water'))
    {
        PlaySound(DeathJingle);
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function ThrowWeaponOnDeath()
{
    //return;    
}

function DamagedSomeone(int InDamage, Pawn InVictim)
{
    //return;    
}

simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    // End:0x56
    if(ArmsMesh[0] == SeqNode.SkelComponent)
    {
        OnRightHandAnimEnd(SeqNode, PlayedTime, ExcessTime);        
    }
    else
    {
        // End:0xAC
        if(ArmsMesh[1] == SeqNode.SkelComponent)
        {
            OnLeftHandAnimEnd(SeqNode, PlayedTime, ExcessTime);            
        }
        else
        {
            super(EvilPawn).OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
        }
    }
    //return;    
}

simulated event OnRightHandAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    // End:0x52
    if(OnRightArmAnimEndDelegate != none && SeqNode != none)
    {
        OnArmAnimEnd(true, SeqNode, PlayedTime, ExcessTime);
    }
    //return;    
}

simulated event OnLeftHandAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    // End:0x41
    if(OnLeftArmAnimEndDelegate != none)
    {
        OnArmAnimEnd(false, SeqNode, PlayedTime, ExcessTime);
    }
    //return;    
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
    // End:0x40
    if(EquipHandsAction != none)
    {
        EquipHandsAction.NotifyChangedWeapon(PrevWeapon, NewWeapon);
    }
    // End:0xF2
    if(((((MyTorch != none) && AdvInventoryItem_Torch(PrevWeapon) != none) && NewWeapon == none) && EvilWeap_Base(Weapon) != none) && EvilWeap_Base(Weapon).BothHandWeapon)
    {
        MyTorch.AttachToWeapon(EvilWeap_Base(Weapon));
    }
    //return;    
}

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
    Mesh.SetSkeletalMesh(SkelMesh);
    //return;    
}

function HandleStamina()
{
    super(EvilPawn).HandleStamina();
    // End:0x61
    if((bUseJumpStamina && !bIsJumping) && bRegenerateJumpStamina)
    {
        JumpStamina = FClamp(JumpStamina + JumpStaminaRegenAmount, 0.0000000, 1.0000000);
    }
    //return;    
}

function bool DoJump(bool bUpdating)
{
    local bool ToReturn;

    // End:0x108
    if(bUseJumpStamina)
    {
        ToReturn = super(EvilPawn).DoJump(bUpdating);
        // End:0x82
        if(JumpStamina < (float(1) - JumpStaminaCost))
        {
            Velocity.Z *= FClamp(0.3000000 + JumpStamina, 0.6500000, 1.0000000);
        }
        JumpStamina = FClamp(JumpStamina - JumpStaminaCost, 0.0000000, 1.0000000);
        bRegenerateJumpStamina = false;
        // End:0xE3
        if(IsTimerActive('EnableJumpStaminaRegeneration'))
        {
            ClearTimer('EnableJumpStaminaRegeneration');
        }
        SetTimer(JumpStaminaRegenDelay, false, 'EnableJumpStaminaRegeneration');
        return ToReturn;        
    }
    else
    {
        return super(EvilPawn).DoJump(bUpdating);
    }
    //return ReturnValue;    
}

function EnableJumpStaminaRegeneration()
{
    bRegenerateJumpStamina = true;
    //return;    
}

simulated function bool CanJump()
{
    // End:0x28
    if(bUseJumpStamina && JumpStamina < JumpStaminaCost)
    {
        return false;
    }
    return super(EvilPawn).CanJump();
    //return ReturnValue;    
}

simulated function bool CanPlayHitSounds()
{
    return false;
    //return ReturnValue;    
}

simulated function bool CanPlayHitImpactEffects()
{
    return false;
    //return ReturnValue;    
}

simulated function bool CanLeaveBloodDecals()
{
    return false;
    //return ReturnValue;    
}

function RequestDefaultMovementMode()
{
    // End:0xAE
    if(int(SupremeMoveMode) == int(0))
    {
        // End:0x94
        if((MyEvilAI != none) && MyEvilAI.InLatentExecution(503) || MyEvilAI.InLatentExecution(501))
        {
            MyEvilAI.StopLatentExecution();
        }
        ZeroMovementVariables();
        ChangeMoveMode(0);        
    }
    else
    {
        // End:0xE0
        if(bIsWalking)
        {
            bShouldWalkFast = default.bShouldWalkFast;
            ChangeMoveMode(1);            
        }
        else
        {
            // End:0x119
            if((int(SupremeMoveMode) >= int(2)) && ReadyToRunInterval <= 0.0000000)
            {
                ChangeMoveMode(2);                
            }
            else
            {
                // End:0x13A
                if(int(SupremeMoveMode) >= int(1))
                {
                    ChangeMoveMode(1);
                }
            }
        }
    }
    //return;    
}

simulated event CacheAnimNodes()
{
    super.CacheAnimNodes();
    LeanController = SkelControlSingleBone(Mesh.FindSkelControl('LeanController'));
    //return;    
}

simulated function ClearAnimNodes()
{
    super.ClearAnimNodes();
    LeanController = none;
    //return;    
}

simulated function bool CanFocusFlashlight()
{
    return (MyTorch != none) && MyTorch.CanFocus();
    //return ReturnValue;    
}

simulated function FocusFlashlight(bool bNewFocused)
{
    // End:0x4E
    if(bNewFocused)
    {
        MyTorch.ActivateFlightBeam();
        MyTorch.ClientActivateFlightBeam();        
    }
    else
    {
        MyTorch.DeactivateFlightBeam();
        MyTorch.ClientDeactivateFlightBeam();
    }
    //return;    
}

simulated function ActuallyPlayFootstepSound(int FootDown)
{
    local AdvPlayerController AdvController;
    local Actor TraceActor;
    local TraceHitInfo LastFootStepTraceInfo;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local SoundCue SC;
    local bool bCrouching, bZoomingWeapon;

    // End:0x16
    if(int(Physics) == int(10))
    {
        return;
    }
    AdvController = AdvPlayerController(self.Controller);
    // End:0xA6
    if(!((AdvController != none) && !AdvController.IsInState('PlayerSlide')) || int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    MakeFootstepNoise();
    // End:0x14C
    if(FootDown == 0)
    {
        TraceStart = Mesh.GetBoneLocation(LeftFootBoneName, 0) + ((vect(0.0000000, 0.0000000, 1.0000000) * 0.3000000) * (GetCollisionHeight()));
        TraceDest = TraceStart - ((vect(0.0000000, 0.0000000, 1.0000000) * 1.8000000) * (GetCollisionHeight()));        
    }
    else
    {
        TraceStart = Mesh.GetBoneLocation(RightFootBoneName, 0) + ((vect(0.0000000, 0.0000000, 1.0000000) * 0.3000000) * (GetCollisionHeight()));
        TraceDest = TraceStart - ((vect(0.0000000, 0.0000000, 1.0000000) * 1.8000000) * (GetCollisionHeight()));
    }
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, LastFootStepTraceInfo, 1 | 2);
    // End:0x45B
    if(TraceActor != none)
    {
        // End:0x28A
        if(EvilWaterVolume(TraceActor) != none)
        {
            LastFootStepTraceInfo.PhysMaterial = EvilWaterVolume(TraceActor).WaterPhysMaterial;
        }
        bZoomingWeapon = (EvilWeap_Base(Weapon) != none) && int(EvilWeap_Base(Weapon).GetZoomedState()) > int(1);
        bCrouching = self.bIsCrouched || bZoomingWeapon;
        SC = Class'EvilGame.EvilPhysicalMaterialProperty'.static.DetermineFootStepSound(Class'EvilGame.EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(LastFootStepTraceInfo), self, WorldInfo, bCrouching);
        // End:0x3A4
        if(SC != none)
        {
            PlaySound(SC, true, true, false, out_HitLocation, true);
        }
        // End:0x3F2
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            ActuallyPlayFootParticleEffect(FootDown, LastFootStepTraceInfo, out_HitLocation);
        }
        // End:0x45B
        if((IsLocallyControlled() && EvilPlayerController(Controller) != none) && EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).PlayFootStepSound();
        }
    }
    //return;    
}

simulated function SetCharacterClassFromInfo(class<EvilFamilyInfoBase> Info, optional bool bForceSetInfo = false)
{
    local class<AdvFamilyInfo_MainHero> FIMH;
    local editinline SkeletalMeshComponent TorsoComponent;

    super(UTPawn).SetCharacterClassFromInfo(Info, bForceSetInfo);
    FIMH = class<AdvFamilyInfo_MainHero>(Info);
    // End:0x17F
    if(((FIMH != none) && FIMH.default.TorsoMesh != none) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        TorsoComponent = new Class'Engine.SkeletalMeshComponent' (Mesh);
        TorsoComponent.SetSkeletalMesh(FIMH.default.TorsoMesh);
        TorsoComponent.SetParentAnimComponent(Mesh);
        Mesh.AttachComponent(TorsoComponent, 'Root');
        ShowMaterialSectionOnAllLods(3, false);
        ShowMaterialSectionOnAllLods(4, false);
        ShowMaterialSectionOnAllLods(5, false);
    }
    //return;    
}

simulated function SetEvilWeapAnimTypeByWeaponName(name InWeaponName)
{
    super(EvilPawn).SetEvilWeapAnimTypeByWeaponName(((CurrentWeaponLeftAttachmentClass != none) ? 'SinglePistol' : InWeaponName));
    //return;    
}

simulated function StartFire(byte FireModeNum)
{
    // End:0xED
    if(((((((Weapon != none) && WeaponLeft != none) && int(FireModeNum) == int(0)) && WaitingForDualReload) && Weapon.IsInState('ReloadState')) && WeaponLeft.IsInState('QuickHide')) && !Weapon.IsTimerActive('ReloadAmmoTimer'))
    {
        EvilWeap_Base(WeaponLeft).NeedReload = false;
    }
    super(EvilPawn).StartFire(FireModeNum);
    //return;    
}

state GettingUp
{
    local Vector HeadLocation;
    local Rotator HeadRotation;
    local float HeadPitch;
    local Matrix HeadMatrix;

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        local Vector tmpOffset;
        local Rotator meshOffset;

        super(AdvPawn).CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
        // End:0x64
        if(bFixedView)
        {
            out_CamLoc = FixedViewLoc;
            out_CamRot = FixedViewRot;            
        }
        else
        {
            // End:0xA4
            if(!IsFirstPerson())
            {
                CalcThirdPersonCam(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);                
            }
            else
            {
                meshOffset.Yaw = out_CamRot.Yaw;
                GetSkeletalMeshComponent().SetRotation(meshOffset);
                SlideCamXoffset = 18.0000000;
                // End:0x151
                if(FullBodyAnimSlot.GetPlayedAnimation() != 'Slide_Fall')
                {
                    SlideCamZoffset = 35.0000000;
                }
                tmpOffset.X = SlideCamXoffset;
                tmpOffset = TransformVectorByRotation(self.Rotation, tmpOffset);
                // End:0x297
                if((FullBodyAnimSlot.GetPlayedAnimation() == 'Get_Up') || FullBodyAnimSlot.GetPlayedAnimation() == 'Slide_Fall')
                {
                    HeadMatrix = GetSkeletalMeshComponent().GetBoneMatrix(GetSkeletalMeshComponent().MatchRefBone(HeadBone));
                    HeadLocation = MatrixGetOrigin(HeadMatrix);
                    HeadRotation = MatrixGetRotator(HeadMatrix);                    
                }
                else
                {
                    GetActorEyesViewPoint(HeadLocation, HeadRotation);
                    HeadRotation.Pitch = 0;
                    HeadRotation.Roll = 0;
                    SetViewRotation(HeadRotation);
                }
                out_CamLoc = HeadLocation;
                out_CamLoc += tmpOffset;
                out_CamLoc.Z += SlideCamZoffset;
                // End:0x3FB
                if(FullBodyAnimSlot.GetPlayedAnimation() != 'Get_Up')
                {
                    HeadRotation.Pitch -= 9370;
                    HeadRotation.Yaw = meshOffset.Yaw;
                    out_CamRot = HeadRotation;
                    bAfterStand = true;                    
                }
                else
                {
                    HeadRotation = out_CamRot;
                    // End:0x4CB
                    if(bBlendGettingUpCamera)
                    {
                        // End:0x443
                        if(bAfterStand)
                        {
                            bAfterStand = false;
                            HeadPitch = -11370.0000000;
                        }
                        // End:0x466
                        if(HeadPitch >= float(0))
                        {
                            HeadPitch = 0.0000000;                            
                        }
                        else
                        {
                            HeadPitch += ((fDeltaTime * Abs(1.0000000 / (HeadPitch / float(4000)))) * float(4000));
                        }
                        HeadRotation.Pitch = int(HeadPitch);                        
                    }
                    else
                    {
                        HeadRotation.Pitch = -11370;
                    }
                    HeadRotation.Roll = 0;
                    out_CamRot = HeadRotation;
                }
            }
        }
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state Sliding
{    stop;    
}

state SlideBendForward extends Sliding
{
    local Matrix HeadMatrix;

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        local Vector tmpOffset, HeadLocation;

        // End:0x36
        if(bFixedView)
        {
            out_CamLoc = FixedViewLoc;
            out_CamRot = FixedViewRot;            
        }
        else
        {
            // End:0x76
            if(!IsFirstPerson())
            {
                CalcThirdPersonCam(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);                
            }
            else
            {
                SlideCamXoffset = 12.0000000;
                SlideCamZoffset = 20.0000000;
                HeadMatrix = GetSkeletalMeshComponent().GetBoneMatrix(GetSkeletalMeshComponent().MatchRefBone(HeadBone));
                HeadLocation = MatrixGetOrigin(HeadMatrix);
                out_CamLoc = HeadLocation;
                tmpOffset.X = SlideCamXoffset;
                tmpOffset = TransformVectorByRotation(self.Rotation, tmpOffset);
                out_CamLoc += tmpOffset;
                out_CamLoc.Z += SlideCamZoffset;
            }
        }
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state SlideBendBackward extends Sliding
{
    local Matrix HeadMatrix;

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        local Vector tmpOffset, HeadLocation;

        super(AdvPawn).CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
        // End:0x64
        if(bFixedView)
        {
            out_CamLoc = FixedViewLoc;
            out_CamRot = FixedViewRot;            
        }
        else
        {
            // End:0xA4
            if(!IsFirstPerson())
            {
                CalcThirdPersonCam(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);                
            }
            else
            {
                SlideCamXoffset = 12.0000000;
                SlideCamZoffset = 20.0000000;
                HeadMatrix = GetSkeletalMeshComponent().GetBoneMatrix(GetSkeletalMeshComponent().MatchRefBone(HeadBone));
                HeadLocation = MatrixGetOrigin(HeadMatrix);
                out_CamLoc = HeadLocation;
                tmpOffset.X = SlideCamXoffset;
                tmpOffset = TransformVectorByRotation(self.Rotation, tmpOffset);
                out_CamLoc += tmpOffset;
                out_CamLoc.Z += SlideCamZoffset;
            }
        }
        return true;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    AutoRecoveryDelay=0.1500000
    LowHealthAmbientThreshold=0.5000000
    DamageScalingFactor=1.0000000
    AutoRecoveryHealthDivider=35
    ElectroHitSnd=SoundCue'a_Player.Cue.a_ElectricityHit'
    AbsoluteDamageReductionFactor=1.0000000
    JumpStamina=1.0000000
    bRegenerateJumpStamina=true
    bGodModeInLastBreath=true
    JumpStaminaRegenDelay=1.5000000
    JumpStaminaRegenAmount=0.0200000
    ExplosionStunDefaultTime=8.0000000
    ExplosionStunMinTime=2.5000000
    ExplosionStunDelay=0.3000000
    JumpStaminaCost=0.2000000
    TimeBeforeHealthRegen=5.0000000
    AutoRecoveryHealthFactor=100.0000000
    DeathJingle=SoundCue'a_Accents.Cue.a_DeathAccent_01'
    HandsClasses[0]=Class'AdvWeap_MeleeHands'
    HandsClasses[1]=Class'AdvWeap_MeleeHands_Dynamite'
    bCheckAnimDef=false
    MaxEnemyCount=10
    // Reference: SkeletalMeshComponent'Default__AdvPlayerPawn.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPlayerPawn.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPlayerPawn.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPlayerPawn.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bDisableEvilAnimWeaponAnims=false
    bUseStamina=true
    bShouldPlayDeathAnimationToRagdoll=true
    bCanBeKnockedDown=false
    SupremeMoveMode=EMoveMode.EMM_Run
    BrakeRate=0.9500000
    IgnoreDamageTimer=5.0000000
    ReduceDamagePercentage=0.2000000
    ReduceDamageReusePercentage=0.4000000
    ReduceDamageFactor=0.1000000
    DefaultInventory=/* Array type was not detected. */
    DefaultHealth=250.0000000
    SprintSpeedModifier=2.1000000
    StaminaDecreaseAmount=0.0150000
    StaminaRegenAmount=0.0250000
    MeleeHitParticles=/* Array type was not detected. */
    PawnActionClasses=/* Array type was not detected. */
    AnimDefArchetype=EvilAnimDef'AnimDefs.AnimDef_Player'
    // Reference: EvilPawnBlockingComponent'Default__AdvPlayerPawn.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPlayerPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPlayerPawn.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    RagdollLifespan=0.1000000
    DefaultMeshScale=1.0000000
    // Reference: UTAmbientSoundComponent'Default__AdvPlayerPawn.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPlayerPawn.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPlayerPawn.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    BaseTranslationOffset=0.0000000
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPlayerPawn.FirstPersonArms'
    begin object name=FirstPersonArms
        AnimTreeTemplate=AnimTree'wp_all_hands.at_wp_all_hands'
        Animations=none
        ReplacementPrimitive=none
        LightingChannels=(Unnamed_1=true,Unnamed_6=true)
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPlayerPawn.FirstPersonArms2'
    begin object name=FirstPersonArms2
        AnimTreeTemplate=AnimTree'wp_all_hands.at_wp_all_hands'
        Animations=none
        ReplacementPrimitive=none
        LightingChannels=(Unnamed_1=true,Unnamed_6=true)
        Scale3D=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    ArmsMesh=FirstPersonArms2
    LedgeCheckThreshold=70.0000000
    bCanCrouch=true
    GroundSpeed=260.0000000
    AccelRate=2048.0000000
    JumpZ=322.0000000
    MaxFallSpeed=875.0000000
    // Reference: SkeletalMeshComponent'Default__AdvPlayerPawn.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        AnimTreeTemplate=AnimTree'an_MainHero.Anims.AT_Human'
        RootMotionMode=ERootMotionMode.RMM_Ignore
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPlayerPawn.MyLightEnvironment'
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPlayerPawn.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPlayerPawn.FaceAudioComponent'
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
    Components[8]=SizzleAudioComponent0
    CollisionComponent=CollisionCylinder
}