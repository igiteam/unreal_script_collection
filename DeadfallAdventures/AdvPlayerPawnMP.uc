class AdvPlayerPawnMP extends AdvPlayerPawn
    config(Pawn)
    hidecategories(Navigation);

struct CustomAnimInfoStruct
{
    var name AnimName;
    var float Rate;
    var float Duration;
    var float BlendInTime;
    var float BlendOutTime;
    var bool bLooping;
    var bool bOverride;
    var float StartTime;
    var float EndTime;
    var int actionCase;
    var bool bReplicationSwitcher;

    structdefaultproperties
    {
        AnimName="None"
        Rate=0.0000000
        Duration=0.0000000
        BlendInTime=0.0000000
        BlendOutTime=0.0000000
        bLooping=false
        bOverride=false
        StartTime=0.0000000
        EndTime=0.0000000
        actionCase=0
        bReplicationSwitcher=false
    }
};

var export editinline SkeletalMeshComponent OccludedMesh;
var float KillingFallSpeed;
var bool bTimerUnlocked;
var repnotify bool bIsMummy;
var repnotify bool bIsDevastator;
var bool bKilledDuringWoundedState;
var bool bRescueStarted;
var bool bInitialPlayWoundedAnimation;
var bool bIsSecondChance;
var bool SurvivalWoundedDisabled;
var bool bIsTouchingLMSPawn;
var bool bHealingEnabled;
var bool bForceKilled;
var float ShoutHearDistance;
var config int DefaultSurvivalHealth;
var AnimNodeBlend BlendByTransform;
var() export editinline SkeletalMeshComponent MummyMesh;
var float MummyDissolveAmount;
var() export editinline SkeletalMeshComponent DevastatorMesh;
var int WoundedAnimationCounter;
var array<MaterialInstanceConstant> DissolveMICs;
var array<MaterialInstanceConstant> MummyDissolveMICs;
var float OldMeshScale;
var() float NewMeshScaleModifier;
var ParticleSystem MummyTransEffect;
var() export editinline AudioComponent DevastatorGasMaskComponent;
var array<AdvPlayerPawnMP> WoundedPawnsInRange;
var config int SecondChanceHealth;
var config int WoundedHealth;
var config int SurvivalWoundedHealth;
var Controller LMSKiller;
var const localized string LastMenStandingMessage;
var const localized string LastMenStandingMessageXbox;
var array<EvilWeap_Base> OldWeapons;
var repnotify transient CustomAnimInfoStruct CustomAnimParams;

replication
{
    // Pos:0x000
    if(bNetDirty
        bIsDevastator, bIsMummy, 
        bIsSecondChance, bIsTouchingLMSPawn;

    // Pos:0x00A
    if(bNetDirty && bNetInitial
        bInitialPlayWoundedAnimation;

    // Pos:0x023
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        CustomAnimParams;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x36
        case 'bIsMummy':
            TransformToMummy(bIsMummy);
            // End:0x91
            break;
        // End:0x59
        case 'bIsDevastator':
            TransformToDevastator(bIsDevastator);
            // End:0x91
            break;
        // End:0x7B
        case 'CustomAnimParams':
            RepPlayCustomAnim(CustomAnimParams);
            // End:0x91
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

simulated function bool CanCrouch()
{
    local EvilWalkingVolume WV;

    // End:0x62
    foreach TouchingActors(Class'EvilGame.EvilWalkingVolume', WV)
    {
        // End:0x61
        if(WV.bEnabled && WV.bBlockCrouch)
        {            
            return false;
        }        
    }    
    // End:0x75
    if(bIsWounded)
    {
        return false;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
    // End:0xC4
    if((!InFreeCam() && !bIsWounded) && !bIsSecondChance)
    {
        // End:0x70
        if(int(Physics) == int(9))
        {
            NewRotation = OnLadder.WallDir;            
        }
        else
        {
            // End:0xB8
            if((int(Physics) == int(1)) || int(Physics) == int(2))
            {
                NewRotation.Pitch = 0;
            }
        }
        SetRotation(NewRotation);
    }
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super(AdvPawn).PostInitAnimTree(SkelComp);
    // End:0xB3
    if(SkelComp == Mesh)
    {
        BlendByTransform = AnimNodeBlend(Mesh.FindAnimNode('BlendByTransform'));
        // End:0x97
        if(bIsMummy && !IsLocallyControlled())
        {
            TransformToMummy(bIsMummy);
        }
        // End:0xB3
        if(bInitialPlayWoundedAnimation)
        {
            DoPawnAction(38, true);
        }
    }
    //return;    
}

function InitDefaultHealth()
{
    // End:0x6B
    if(AdvGameSurvivalBase(WorldInfo.Game) != none)
    {
        DefaultHealth = float(DefaultSurvivalHealth);
        HealthMax = DefaultSurvivalHealth;
        Health = DefaultSurvivalHealth;        
    }
    else
    {
        Health = int(DefaultHealth);
        HealthMax = int(DefaultHealth);
    }
    //return;    
}

reliable server function PlayShoutSound(array<SoundCue> ShoutSounds)
{
    local AdvPlayerPawnMP P;

    // End:0xEB
    if(ShoutSounds.Length > 0)
    {
        // End:0xEA
        foreach WorldInfo.AllPawns(Class'AdvPlayerPawnMP', P, Location, ShoutHearDistance)
        {
            // End:0xE9
            if(P.IsSameTeam(self) && P != self)
            {
                AdvPlayerControllerMP(P.Controller).ClientHearSound(ShoutSounds[Rand(ShoutSounds.Length)], self, Location, false);
            }            
        }        
    }
    //return;    
}

simulated function StartReload()
{
    super.StartReload();
    PlayShoutSound(class<AdvFamilyInfo_MP_Hero_Base>(AdvPRI(Controller.PlayerReplicationInfo).static.GetCharClassInfo()).default.ReloadShouts);
    //return;    
}

simulated function SetMeshVisibility(bool bVisible)
{
    super(UTPawn).SetMeshVisibility(bVisible);
    // End:0x74
    if(bIsMummy && bVisible)
    {
        ArmsMesh[0].SetHidden(true);
        ArmsMesh[1].SetHidden(true);
    }
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    UpdateFlags();
    //return;    
}

simulated function UpdateFlags()
{
    local AdvPlayerPawnMP Pmp;
    local EvilCarriedObject Flag;

    // End:0x8E
    foreach WorldInfo.AllPawns(Class'AdvPlayerPawnMP', Pmp)
    {
        // End:0x8C
        foreach Pmp.BasedActors(Class'EvilGame.EvilCarriedObject', Flag)
        {
            Pmp.HoldGameObject(Flag);            
        }                
    }    
    //return;    
}

simulated function EquipHandsWeapon()
{
    //return;    
}

simulated function bool CanPlayHitSounds()
{
    return true;
    //return ReturnValue;    
}

simulated function bool CanPlayHitImpactEffects()
{
    return true;
    //return ReturnValue;    
}

simulated function bool CanLeaveBloodDecals()
{
    return true;
    //return ReturnValue;    
}

function ThrowWeaponOnDeath()
{
    ThrowActiveWeapon();
    //return;    
}

simulated function TakeFallingDamage()
{
    local float TakenDamage;

    // End:0x113
    if(Velocity.Z < (-0.5000000 * MaxFallSpeed))
    {
        MakeNoise(1.0000000);
        // End:0x110
        if((int(Role) == int(ROLE_Authority)) && Velocity.Z < (float(-1) * MaxFallSpeed))
        {
            TakenDamage = (float(HealthMax) * (-Velocity.Z - MaxFallSpeed)) / (KillingFallSpeed - MaxFallSpeed);
            TakeDamage(int(TakenDamage), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
        }        
    }
    else
    {
        // End:0x150
        if(Velocity.Z < (-1.4000000 * JumpZ))
        {
            MakeNoise(0.5000000);            
        }
        else
        {
            // End:0x18A
            if(Velocity.Z < (-0.8000000 * JumpZ))
            {
                MakeNoise(0.2000000);
            }
        }
    }
    //return;    
}

reliable client simulated function StartBurn()
{
    SetTimer(0.0100000, true, 'Burning');
    //return;    
}

reliable client simulated function Burning()
{
    local MaterialInstance MI, MI2, MI3;
    local float Emmisivepower;

    MI = self.ArmsMesh[0].CreateAndSetMaterialInstanceConstant(0);
    MI2 = self.ArmsMesh[0].CreateAndSetMaterialInstanceConstant(1);
    MI3 = self.ArmsMesh[0].CreateAndSetMaterialInstanceConstant(2);
    MI.GetScalarParameterValue('DissolveAmount', Emmisivepower);
    // End:0x10B
    if((Emmisivepower > float(0)) && !bTimerUnlocked)
    {
        bTimerUnlocked = true;
    }
    // End:0x149
    if((Emmisivepower < float(0)) && bTimerUnlocked)
    {
        ClearTimer('Burning');
        ServerKillPawn();
    }
    MI.SetScalarParameterValue('DissolveAmount', Emmisivepower - 0.0060000);
    MI2.SetScalarParameterValue('DissolveAmount', Emmisivepower - 0.0060000);
    MI3.SetScalarParameterValue('DissolveAmount', Emmisivepower - 0.0060000);
    //return;    
}

reliable server function ServerKillPawn()
{
    self.TakeDamage(250, self.Controller, self.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'AdvDmgType_Dynamite');
    //return;    
}

function bool CanBeDamagedBy(Controller EventInstigator, class<DamageType> DamageType)
{
    // End:0x1A
    if(class<AdvDmgType_Trap_Base>(DamageType) != none)
    {
        return true;
    }
    // End:0x106
    if((EvilGame(WorldInfo.Game) != none) && !EvilGame(WorldInfo.Game).bAllowFriendlyFire)
    {
        // End:0x106
        if((((EventInstigator != none) && EventInstigator.IsPlayerOwned()) && IsSameTeam(EventInstigator.Pawn)) && Controller != EventInstigator)
        {
            return false;
        }
    }
    return super.CanBeDamagedBy(EventInstigator, DamageType);
    //return ReturnValue;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0xDD
    if((((AdvGameSurvivalBase(WorldInfo.Game) != none) && EventInstigator != none) && EventInstigator.Pawn != none) && EvilPawn(EventInstigator.Pawn) != none)
    {
        Damage *= EvilPawn(EventInstigator.Pawn).SurvivalGivenDamageModifier();
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x23E
    if((((Health > 0) && (GetPlayerController()) != none) && !(EventInstigator.Pawn != none) && int(GetTeamNum()) == int(EventInstigator.Pawn.GetTeamNum())) && AdvPlayerControllerMP(Controller).AssistingPlayers.Find(AdvPlayerControllerMP(EventInstigator)) == )
    {        
        AdvPlayerControllerMP(Controller).AssistingPlayers.AddItem(AdvPlayerControllerMP(EventInstigator));        
    }
    //return;    
}

function HealthRecovery_T()
{
    // End:0x11
    if(!bHealingEnabled)
    {
        return;
    }
    super.HealthRecovery_T();
    // End:0xC5
    if(((Controller != none) && Health == HealthMax) && AdvPlayerControllerMP(Controller).AssistingPlayers.Length != 0)
    {
        AdvPlayerControllerMP(Controller).AssistingPlayers.Remove(0, AdvPlayerControllerMP(Controller).AssistingPlayers.Length);        
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local AdvPlayerControllerMP PCmp;

    LMSKiller = Killer;
    PCmp = AdvPlayerControllerMP(Controller);
    // End:0x4FB
    if(PCmp != none)
    {
        // End:0xE0
        if((((PCmp.bSecondChanceEnabled && !bIsMummy) && !bIsDevastator) && class<KillZDamageType>(DamageType) == none) && class<AdvDmgType_Trap_Base>(DamageType) == none)
        {
            PCmp.ServerGoToState('SecondChance');
            return false;
        }
        J0xE0:

        // End:0x13E [Loop If]
        if(PCmp.ActiveBlessings.Length > 0)
        {
            PCmp.ActiveBlessings[0].Deactivate();
            // [Loop Continue]
            goto J0xE0;
        }
        // End:0x2CA
        if(class<AdvGameLastMenStandingBase>(WorldInfo.GetGameClass()) != none)
        {
            // End:0x26B
            if(PCmp.IsInState('Wounded') || bForceKilled)
            {
                bKilledDuringWoundedState = true;
                PCmp.KillerLocation = (((Killer != none) && Killer.Pawn != none) ? Killer.Pawn.Location : vect(0.0000000, 0.0000000, 0.0000000));
                return super.Died(Killer, DamageType, HitLocation);                
            }
            else
            {
                // End:0x2C7
                if((class<KillZDamageType>(DamageType) == none) && class<AdvDmgType_Trap_Base>(DamageType) == none)
                {
                    PCmp.ServerGoToState('Wounded');
                    return false;
                }
            }            
        }
        else
        {
            // End:0x465
            if(class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
            {
                // End:0x406
                if((PCmp.IsInState('SurvivalWounded') || bForceKilled) || SurvivalWoundedDisabled)
                {
                    bKilledDuringWoundedState = true;
                    PCmp.KillerLocation = (((Killer != none) && Killer.Pawn != none) ? Killer.Pawn.Location : vect(0.0000000, 0.0000000, 0.0000000));
                    return super.Died(Killer, DamageType, HitLocation);                    
                }
                else
                {
                    // End:0x462
                    if((class<KillZDamageType>(DamageType) == none) && class<AdvDmgType_Trap_Base>(DamageType) == none)
                    {
                        PCmp.ServerGoToState('SurvivalWounded');
                        return false;
                    }
                }                
            }
            else
            {
                PCmp.KillerLocation = (((Killer != none) && Killer.Pawn != none) ? Killer.Pawn.Location : vect(0.0000000, 0.0000000, 0.0000000));
            }
        }
    }
    // End:0x55A
    if((ThrowWeapon != none) && ThrowWeapon.IsInState('WeaponFiring'))
    {
        EvilWeap_Throw_Base(ThrowWeapon).SpawnProjectile(true);
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

simulated function ShowSpecialMesh(optional bool bVisible = false)
{
    // End:0x3B
    if(bIsMummy)
    {
        MummyMesh.SetOwnerNoSee(bVisible);
    }
    // End:0x71
    if(bIsDevastator)
    {
        DevastatorMesh.SetOwnerNoSee(bVisible);
    }
    ClientShowSpecialMesh(bVisible);
    //return;    
}

reliable client simulated function ClientShowSpecialMesh(optional bool bVisible = false)
{
    // End:0x3B
    if(bIsMummy)
    {
        MummyMesh.SetOwnerNoSee(bVisible);
    }
    // End:0x71
    if(bIsDevastator)
    {
        DevastatorMesh.SetOwnerNoSee(bVisible);
    }
    //return;    
}

simulated function RescueStart()
{
    DoPawnAction(39, true);
    //return;    
}

reliable server function RescueFinished()
{
    local AdvPlayerControllerMP PC;

    PC = AdvPlayerControllerMP(Controller);
    // End:0x4A
    if(PC != none)
    {
        PC.FinishRescue();
    }
    //return;    
}

simulated event LMSTriggerTouch(Actor Other)
{
    //return;    
}

simulated event LMSTriggerUnTouch(Actor Other)
{
    //return;    
}

simulated function ForceKillPawn()
{
    bKilledDuringWoundedState = true;
    bForceKilled = true;
    Died(LMSKiller, Class'Engine.DamageType', Location);
    //return;    
}

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
    local int I;

    Mesh.SetSkeletalMesh(SkelMesh);
    Mesh.SetHidden(false);
    MummyMesh.SetHidden(true);
    // End:0x94
    if(IsTimerActive('MummyDissolve_T'))
    {
        ClearTimer('MummyDissolve_T');
    }
    // End:0x164
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh != none)
    {
        I = 0;
        J0xD9:

        // End:0x164 [Loop If]
        if(I < Mesh.GetNumElements())
        {
            Mesh.SetMaterial(I, SkelMesh.Materials[I]);
            I++;
            // [Loop Continue]
            goto J0xD9;
        }
    }
    //return;    
}

simulated function bool VerifyBodyMaterialInstance()
{
    return BodyMaterialInstances.Length > 0;
    //return ReturnValue;    
}

function bool CanPlayShotGunDeathAnim()
{
    return !bIsCrouched;
    //return ReturnValue;    
}

protected function EvilTypesNative.EAnimationSetType GetDefaultAnimIndex(class<EvilDmgType_Base> DamageType, Vector HitLoc, EvilTypes.EHitDirectionType HitDir)
{
    local EvilTypesNative.EAnimationSetType AST;

    AST = 1;
    switch(HitDir)
    {
        // End:0x44
        case 1:
            AST = ((IsRealSprinting()) ? 11 : 7);
            // End:0xD3
            break;
        // End:0x69
        case 2:
            AST = ((IsRealSprinting()) ? 12 : 8);
            // End:0xD3
            break;
        // End:0x8E
        case 3:
            AST = ((IsRealSprinting()) ? 13 : 9);
            // End:0xD3
            break;
        // End:0xB3
        case 4:
            AST = ((IsRealSprinting()) ? 14 : 10);
            // End:0xD3
            break;
        // End:0xFFFF
        default:
            AST = ((IsRealSprinting()) ? 2 : 1);
            break;
    }
    // End:0xEF
    if(bIsCrouched)
    {
        AST = 194;        
    }
    else
    {
        // End:0x116
        if(ClassIsChildOf(DamageType, Class'AdvDmgType_TrapGas'))
        {
            AST = 199;            
        }
        else
        {
            // End:0x13A
            if(ClassIsChildOf(DamageType, Class'AdvDmgType_TrapFire'))
            {
                AST = 200;
            }
        }
    }
    // End:0x1A0
    if((AST_GetAnimCount(AST)) < 1)
    {
        // End:0x194
        if(IsRealSprinting())
        {
            AST = 2;
            // End:0x191
            if((AST_GetAnimCount(AST)) < 1)
            {
                AST = 1;
            }            
        }
        else
        {
            AST = 1;
        }
    }
    return AST;
    //return ReturnValue;    
}

function EvilTypesNative.EAnimationSetType OverrideGetDeathAnimIndex(EvilTypesNative.EAnimationSetType InAST, class<EvilDmgType_Base> DamageType, Vector HitLoc)
{
    // End:0x10
    if(bKilledDuringWoundedState)
    {
        return 201;
    }
    return InAST;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    local AdvPlayerControllerMP PC;
    local array<AdvPlayerPawnMP> NewWoundedPawnsInRange;

    super.Tick(DeltaTime);
    // End:0x145
    if((int(Role) == int(ROLE_Authority)) && AdvPlayerControllerMP(Controller) != none)
    {
        PC = AdvPlayerControllerMP(Controller);
        PC.CanRescueSomeone(NewWoundedPawnsInRange, PC.IsThisPawnInUsableAngle);
        // End:0xF0
        if((WoundedPawnsInRange.Length == 0) && NewWoundedPawnsInRange.Length > 0)
        {
            PC.SetRescueMessage();            
        }
        else
        {
            // End:0x132
            if((WoundedPawnsInRange.Length > 0) && NewWoundedPawnsInRange.Length == 0)
            {
                PC.SetRescueMessage(true);
            }
        }
        WoundedPawnsInRange = NewWoundedPawnsInRange;
    }
    //return;    
}

simulated function TransformToMummy(bool bEnabled)
{
    local AdvPRI PRI;

    TransformToDevastator(false);
    bIsDevastator = false;
    // End:0x45
    if(DevastatorGasMaskComponent != none)
    {
        DevastatorGasMaskComponent.Stop();
    }
    // End:0x79
    if(IsLocallyControlled() && bEnabled)
    {
        LocalDoPawnAction(33, true,, GetScreamPackedIndex());
    }
    // End:0xC5
    if(BlendByTransform != none)
    {
        BlendByTransform.SetBlendTarget(((bEnabled) ? 1.0000000 : 0.0000000), 0.1000000);
    }
    // End:0x1B9
    if(!bEnabled)
    {
        PRI = AdvPRI(PlayerReplicationInfo);
        SoundGroupClass = PRI.static.GetCharClassInfo().default.SoundGroupClass;
        SetFirstPersonArmsInfo(PRI.static.GetCharClassInfo().GetFirstPersonArms(), PRI.static.GetCharClassInfo().GetFirstPersonArms().Materials[0]);
    }
    // End:0x21B
    if(!IsFirstPerson() && bEnabled)
    {
        ArmsMesh[0].SetHidden(true);
        ArmsMesh[1].SetHidden(true);
    }
    //return;    
}

simulated function TransformToDevastator(bool bEnabled)
{
    local AdvPRI PRI;
    local MaterialInterface MI;
    local int I;

    // End:0x1AF
    if(bEnabled)
    {
        PRI = AdvPRI(PlayerReplicationInfo);
        Mesh.SetSkeletalMesh(PRI.DevastatorCharClassInfo.default.CharacterMesh);
        // End:0x140
        foreach Mesh.SkeletalMesh.Materials(MI, I)
        {
            Mesh.SetMaterial(I, PRI.DevastatorCharClassInfo.default.CharacterMesh.Materials[I]);            
        }        
        SoundGroupClass = PRI.DevastatorCharClassInfo.default.SoundGroupClass;
        // End:0x1AC
        if(DevastatorGasMaskComponent != none)
        {
            DevastatorGasMaskComponent.Play();
        }        
    }
    else
    {
        PRI = AdvPRI(PlayerReplicationInfo);
        Mesh.SetSkeletalMesh(PRI.static.GetCharClassInfo().default.CharacterMesh);
        // End:0x2E4
        foreach Mesh.SkeletalMesh.Materials(MI, I)
        {
            Mesh.SetMaterial(I, PRI.static.GetCharClassInfo().default.CharacterMesh.Materials[I]);            
        }        
        SoundGroupClass = PRI.static.GetCharClassInfo().default.SoundGroupClass;
        // End:0x351
        if(DevastatorGasMaskComponent != none)
        {
            DevastatorGasMaskComponent.Stop();
        }
    }
    //return;    
}

simulated function StartHideWeapon()
{
    // End:0x36
    if(IsLocallyControlled() && !bIsMummy)
    {
        LocalDoPawnAction(23,,, GetHideAnimIndex());
    }
    //return;    
}

simulated function StartEquipWeapon()
{
    // End:0x36
    if(IsLocallyControlled() && !bIsMummy)
    {
        LocalDoPawnAction(22,,, GetEquipAnimIndex());
    }
    //return;    
}

simulated function OnStartMummyDissolve()
{
    local AdvPRI PRI;
    local MaterialInstanceConstant MI;
    local int I;

    PRI = AdvPRI(PlayerReplicationInfo);
    MummyMesh.AnimSets = Mesh.AnimSets;
    MummyMesh.SetParentAnimComponent(Mesh);
    MummyMesh.SetSkeletalMesh(PRI.MummyCharClassInfo.default.CharacterMesh);
    MummyMesh.SetHidden(false);
    AddMICsToArray(Mesh, DissolveMICs);
    // End:0x199
    foreach DissolveMICs(MI, I)
    {
        MI.SetParent(PRI.MummyCharClassInfo.default.CharacterMesh.Materials[0]);        
    }    
    SoundGroupClass = PRI.MummyCharClassInfo.default.SoundGroupClass;
    AddMICsToArray(MummyMesh, MummyDissolveMICs);
    MummyDissolveAmount = 0.0000000;
    MummyDissolve_T(true);
    // End:0x2C7
    if(bIsMummy)
    {
        ArmsMesh[0].SetSkeletalMesh(PRI.MummyCharClassInfo.default.ArmMesh, true);
        ArmsMesh[1].SetSkeletalMesh(PRI.MummyCharClassInfo.default.ArmMesh, true);        
    }
    else
    {
        ArmsMesh[0].SetSkeletalMesh(self.default.ArmsMesh[0].SkeletalMesh, true);
        ArmsMesh[1].SetSkeletalMesh(self.default.ArmsMesh[1].SkeletalMesh, true);
    }
    //return;    
}

simulated function MummyDissolve_T(optional bool bStart)
{
    local MaterialInstanceConstant MIC;
    local editinline ParticleSystemComponent DissolvePSC;

    // End:0xAA
    if(bStart)
    {
        DissolvePSC = new (self) Class'Engine.ParticleSystemComponent';
        DissolvePSC.SetTemplate(MummyTransEffect);
        AttachComponent(DissolvePSC);
        DissolvePSC.SetActorParameter('BoneSocketActor', self);
        DissolvePSC.ActivateSystem();
    }
    // End:0xE4
    if(MummyDissolveAmount < 1.0000000)
    {
        MummyDissolveAmount += 0.0250000;
        SetTimer(0.0500000, false, GetFuncName());        
    }
    else
    {
        Mesh.SetHidden(true);
        MummyDissolveAmount = 1.0000000;
    }
    // End:0x15C
    foreach MummyDissolveMICs(MIC)
    {
        MIC.SetScalarParameterValue('DissolveAmount', MummyDissolveAmount);        
    }    
    // End:0x1D6
    foreach DissolveMICs(MIC)
    {
        MIC.SetScalarParameterValue('DissolveAmount', ((Mesh.HiddenGame) ? 1.0000000 : 1.0000000 - MummyDissolveAmount));        
    }    
    //return;    
}

function StartMeleeAttack()
{
    // End:0x25
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(5,,, GetMeleeAnimIndex());
    }
    //return;    
}

simulated function AddMICsToArray(MeshComponent MC, out array<MaterialInstanceConstant> MICs)
{
    local int I;
    local editinline MeshComponent Child;
    local MaterialInterface MI;
    local MaterialInstanceConstant MIC;

    // End:0x7E
    if(MC.IsA('SkeletalMeshComponent'))
    {
        // End:0x7D
        foreach SkeletalMeshComponent(MC).AttachedComponents(Class'Engine.MeshComponent', Child)
        {
            AddMICsToArray(Child, MICs);            
        }        
    }
    I = 0;
    J0x89:

    // End:0x1B3 [Loop If]
    if(I < MC.GetNumElements())
    {
        MI = MC.GetMaterial(I);
        // End:0x14E
        if((MaterialInstanceConstant(MI) != none) && MI.GetPackageName() == 'Transient')
        {
            MIC = MaterialInstanceConstant(MI);            
        }
        else
        {
            MIC = MC.CreateAndSetMaterialInstanceConstant(I);
        }
        // End:0x1A5
        if(MIC != none)
        {
            MICs.AddItem(MIC);            
        }
        ++I;
        // [Loop Continue]
        goto J0x89;
    }
    //return;    
}

simulated function DoMelee()
{
    // End:0x0F
    if(bIsMummy)
    {
        return;
    }
    super.DoMelee();
    //return;    
}

simulated event NotifyWeapQuickHideDone(EvilWeap_Base Weap)
{
    //return;    
}

simulated function class<EvilFamilyInfoBase> GetDefaultFamilyInfo()
{
    return Class'AdvFamilyInfo_MP_Hero_Base';
    //return ReturnValue;    
}

simulated function bool IsMummy()
{
    return bIsMummy;
    //return ReturnValue;    
}

simulated function OnPlayCustomAnimDLC1(SeqAct_PlayCustomAnim inAction)
{
    CustomAnimParams.actionCase = inAction.actionCase;
    CustomAnimParams.AnimName = inAction.AnimName;
    CustomAnimParams.Rate = inAction.Rate;
    CustomAnimParams.Duration = inAction.Duration;
    CustomAnimParams.BlendInTime = inAction.BlendInTime;
    CustomAnimParams.BlendOutTime = inAction.BlendOutTime;
    CustomAnimParams.bLooping = inAction.bLooping;
    CustomAnimParams.bOverride = inAction.bOverride;
    CustomAnimParams.StartTime = inAction.StartTime;
    CustomAnimParams.EndTime = inAction.EndTime;
    CustomAnimParams.bReplicationSwitcher = !CustomAnimParams.bReplicationSwitcher;
    //return;    
}

simulated function RepPlayCustomAnim(CustomAnimInfoStruct Cap)
{
    local float PlayBackLength;

    // End:0x269
    if(Cap.actionCase == 0)
    {
        // End:0x17E
        if((Cap.StartTime >= 0.0000000) || Cap.EndTime >= 0.0000000)
        {
            PlayBackLength = FullBodyAnimSlot.PlayCustomAnim(Cap.AnimName, Cap.Rate, Cap.BlendInTime, Cap.BlendOutTime, Cap.bLooping, Cap.bOverride, Cap.StartTime, Cap.EndTime);            
        }
        else
        {
            PlayBackLength = FullBodyAnimSlot.PlayCustomAnim(Cap.AnimName, Cap.Rate, Cap.BlendInTime, Cap.BlendOutTime, Cap.bLooping, Cap.bOverride);
        }
        // End:0x266
        if(PlayBackLength <= float(0))
        {
            return;
        }        
    }
    else
    {
        // End:0x35E
        if(Cap.actionCase == 1)
        {
            // End:0x35B
            if(!FullBodyAnimSlot.PlayCustomAnimByDuration(Cap.AnimName, Cap.Duration, Cap.BlendInTime, Cap.BlendOutTime, Cap.bLooping, Cap.bOverride))
            {
                return;
            }            
        }
        else
        {
            FullBodyAnimSlot.StopCustomAnim(Cap.BlendOutTime);
        }
    }
    //return;    
}

simulated function SetCharacterClassFromInfo(class<EvilFamilyInfoBase> Info, optional bool bForceSetInfo = false)
{
    super.SetCharacterClassFromInfo(Info, bForceSetInfo);
    // End:0x82
    if(Mesh.AnimSets.Find(AnimSet'DF_InGameCutscenes_DLC1.as_ch_SV1_DLC1_Button') == )
    {        
        Mesh.AnimSets.AddItem(AnimSet'DF_InGameCutscenes_DLC1.as_ch_SV1_DLC1_Button');        
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvPlayerPawnMP.OPawnSkeletalMeshComponent'
    begin object name=OPawnSkeletalMeshComponent class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPlayerPawnMP.WPawnSkeletalMeshComponent'
        MinDistFactorForKinematicUpdate=0.2000000
        bUpdateSkelWhenNotRendered=false
        bIgnoreControllersWhenNotRendered=true
        bHasPhysicsAssetInstance=true
        bPerBoneMotionBlur=true
        bOverrideAttachmentOwnerVisibility=true
        bChartDistanceFactor=true
        bCacheAnimSequenceNodes=false
        Materials=/* Array type was not detected. */
        ShadowParent=SkeletalMeshComponent'Default__AdvPlayerPawnMP.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPlayerPawnMP.MyLightEnvironment'
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_Foreground
        RBChannel=ERBCollisionChannel.RBCC_Untitled3
        RBDominanceGroup=20
        bOwnerNoSee=true
        CastShadow=false
        bCastDynamicShadow=false
        bUseOnePassLightingOnTranslucency=true
        BlockRigidBody=true
        RBCollideWithChannels=(Untitled3=true)
    end object
    OccludedMesh=OPawnSkeletalMeshComponent
    KillingFallSpeed=1700.0000000
    bHealingEnabled=true
    ShoutHearDistance=600.0000000
    DefaultSurvivalHealth=350
    // Reference: SkeletalMeshComponent'Default__AdvPlayerPawnMP.WPawnSkeletalMeshComponent_Mummy'
    begin object name=WPawnSkeletalMeshComponent_Mummy class=Class'Engine.SkeletalMeshComponent'
        MinDistFactorForKinematicUpdate=0.2000000
        bUpdateSkelWhenNotRendered=false
        bIgnoreControllersWhenNotRendered=true
        bPerBoneMotionBlur=true
        bOverrideAttachmentOwnerVisibility=true
        bChartDistanceFactor=true
        bCacheAnimSequenceNodes=false
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPlayerPawnMP.MyLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_Untitled3
        RBDominanceGroup=20
        HiddenGame=true
        bOwnerNoSee=true
        bUseOnePassLightingOnTranslucency=true
        RBCollideWithChannels=(Untitled3=true)
    end object
    MummyMesh=WPawnSkeletalMeshComponent_Mummy
    MummyTransEffect=ParticleSystem'adv_ps_en_DM_all.Effects.ps_ch_MummyTrans'
    // Reference: AudioComponent'Default__AdvPlayerPawnMP.DevastatorGasMaskComponent0'
    begin object name=DevastatorGasMaskComponent0 class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'a_Multiplayer_Devastator.cues.a_GasmaskLoop_01'
    end object
    DevastatorGasMaskComponent=DevastatorGasMaskComponent0
    SecondChanceHealth=200
    WoundedHealth=200
    SurvivalWoundedHealth=80000
    LastMenStandingMessage="Press {USE} to rescue"
    LastMenStandingMessageXbox="Press {A} to rescue"
    AutoRecoveryHealthDivider=25
    DeathJingle=none
    // Reference: SkeletalMeshComponent'Default__AdvPlayerPawnMP.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPlayerPawnMP.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPlayerPawnMP.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPlayerPawnMP.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    MovementSpeedChangeRate=20.0000000
    BackwardMovementSpeedModifier=0.5500000
    SidewaysMovementSpeedModifier=0.7500000
    ReduceDamagePercentage=0.0000000
    MeleeKickWeapClass=none
    DefaultHealth=100.0000000
    SprintSpeedModifier=1.5000000
    SprintFOV=85.0000000
    GoreSettings=EvilPawnGoreSettings'ar_GoreSettings.Archetypes.GenericPlayerMP'
    PawnActionClasses=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPlayerPawnMP.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPlayerPawnMP.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPlayerPawnMP.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    RagdollLifespan=10.0000000
    CamOffset=(X=23.0000000,Y=40.0000000,Z=-20.0000000)
    // Reference: UTAmbientSoundComponent'Default__AdvPlayerPawnMP.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPlayerPawnMP.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPlayerPawnMP.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPlayerPawnMP.FirstPersonArms'
    begin object name=FirstPersonArms
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPlayerPawnMP.FirstPersonArms2'
    begin object name=FirstPersonArms2
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    GroundSpeed=320.0000000
    AccelRate=750.0000000
    JumpZ=360.0000000
    CrouchedPct=0.5000000
    MaxFallSpeed=1250.0000000
    // Reference: SkeletalMeshComponent'Default__AdvPlayerPawnMP.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPlayerPawnMP.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPlayerPawnMP.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPlayerPawnMP.FaceAudioComponent'
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
    Components[9]=OPawnSkeletalMeshComponent
    Components[10]=WPawnSkeletalMeshComponent_Mummy
    Components[11]=DevastatorGasMaskComponent0
    CollisionComponent=CollisionCylinder
}