class PKPlayerPawn extends PKPawn
    native(Pawn)
    config(Pawn)
    hidecategories(Navigation)
    implements(EvilPlayer_interface);

var repnotify int Armour;
var bool bFrozenArmour;
var transient bool bCanBunnyHop;
var transient bool bIsBunnyHop;
var const transient bool bDitch;
var transient bool bForwardRocketJump;
var transient bool bDoingQuickAction1;
var transient bool bDoingQuickAction2;
var repnotify bool RepSetTeamMaterial;
var bool bDissolveOnDeath;
var repnotify class<PainItem_Armour_Base> ArmourClass;
var delegate<OnArmAnimEnd> OnLeftArmAnimEndDelegate;
var delegate<OnArmAnimEnd> OnRightArmAnimEndDelegate;
var transient class<PKGame> GameClass;
var transient float LastJumpPressedTime;
var transient float LastJumpTime;
var transient float LastLandTime;
var transient float BunnyHopTimeAccumulator;
var transient Vector AccelAtJump;
var transient Vector LocalAccelAtJump;
var transient float SpeedAtLanding;
var const transient float LocalAccelDot;
var float SlipSpeedMultiplier;
var Material GhostMaterial;
var const MaterialInterface TeamRedMaterial;
var const MaterialInterface TeamBlueMaterial;
var export editinline AudioComponent WeapModAudioLoop;
var int LuciferComments;
var() export editinline SpotLightComponent Flashlight;
var private class<PainWeap_Base> OldWeaponClass;
var export editinline ParticleSystemComponent RespawnFromGhostPSC;
var ParticleSystem RespawnFromGhostPS;
var float HealthRemainder;
var float ArmourRemainder;
var array<MaterialInstanceConstant> DissolveMICs;
var float LastHitTime;
//var delegate<OnArmAnimEnd> __OnArmAnimEnd__Delegate;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner)
        Armour, ArmourClass;

    // Pos:0x019
    if(bNetDirty)
        RepSetTeamMaterial;
}

// Export UPKPlayerPawn::execCacheGameClass(FFrame&, void* const)
native final function bool CacheGameClass();

function InitDefaultHealth()
{
    Health = PKGame(WorldInfo.Game).InitialPlayerHealth;
    HealthMax = PKGame(WorldInfo.Game).PlayerHealthCapacity;
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

simulated function PostBeginPlay()
{
    local EvilInventoryManager invmng;
    local PKGameSP SPGame;

    super.PostBeginPlay();
    invmng = EvilInventoryManager(InvManager);
    // End:0x56
    if(invmng != none)
    {
        invmng.bInfiniteAmmo = false;
    }
    // End:0xE5
    if((WorldInfo.GRI != none) && WorldInfo.GRI.GameClass == Class'PKGameSurvival')
    {
        DemonModeMaterial = Class'PKPawn'.default.DemonModeMaterial;
    }
    SetupPlayerPhysics();
    UpdateQuadDamageVisionMaterial(GetALocalPlayerController());
    SPGame = PKGameSP(WorldInfo.Game);
    // End:0x1AD
    if(SPGame != none)
    {
        // End:0x178
        if(SPGame.bHealthRegenEnabled)
        {
            SetTimer(1.0000000, true, 'HealthRegenTimer');
        }
        // End:0x1AD
        if(SPGame.bArmorRegenEnabled)
        {
            SetTimer(1.0000000, true, 'ArmorRegenTimer');
        }
    }
    //return;    
}

function HealthRegenTimer()
{
    local PKGameSP SPGame;

    SPGame = PKGameSP(WorldInfo.Game);
    // End:0xAD
    if((SPGame != none) && SPGame.bHealthRegenEnabled)
    {
        HealDamage(int(SPGame.HealthRegenSpeed), self.Controller, Class'Engine.DamageType');
    }
    //return;    
}

function ArmorRegenTimer()
{
    local PKGameSP SPGame;

    SPGame = PKGameSP(WorldInfo.Game);
    // End:0xFA
    if(((SPGame != none) && SPGame.bArmorRegenEnabled) && (WorldInfo.TimeSeconds - LastHitTime) > float(10))
    {
        // End:0xFA
        if(ArmourClass != Class'PainItem_Armour_None')
        {
            // End:0xFA
            if(Armour < 75)
            {
                Armour = Min(int(float(Armour) + SPGame.ArmorRegenSpeed), 75);
            }
        }
    }
    //return;    
}

function bool CanBePoisoned()
{
    return true;
    //return ReturnValue;    
}

function gibbedBy(Actor Other)
{
    local Pawn P;
    local PainGRI GRI;

    // End:0x16
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    P = PKPlayerPawn(Other);
    GRI = PainGRI(WorldInfo.GRI);
    // End:0x102
    if(((P != none) && GRI.IsMultiplayerGame()) && !GRI.IsCoopMultiplayerGame())
    {
        Died(Pawn(Other).Controller, Class'PKDmgType_Telefragged', Location);        
    }
    //return;    
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

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    return GetPawnViewLocation();
    //return ReturnValue;    
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

reliable client simulated function PlayClientBloodEffects(float Damage)
{
    GetPC().GetPlayerHitEffects().PlayBloodEffects(Damage);
    //return;    
}

reliable client simulated function StopClientBloodEffects()
{
    GetPC().GetPlayerHitEffects().StopBloodEffects();
    //return;    
}

reliable client simulated function PlayClientHitEffects(float Damage, class<DamageType> DamageType)
{
    GetPC().GetPlayerHitEffects().ProcessHitEffects(Damage, false, DamageType);
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local PainPRI PRI;
    local float vrcDmg;
    local int oldHP;
    local PKPlayerController PC;

    // End:0x118
    if(((GetPC()) != none) && ((Damage > 0) || DamageType == Class'PKDmgType_PoisonSlowdown') || DamageType == Class'PKDmgType_NunSpell')
    {
        // End:0x118
        if(!GetPC().bCinematicMode)
        {
            vrcDmg = (1.5000000 * float(Damage)) - (((25.0000000 * FRand()) * float(Health)) / DefaultHealth);
            // End:0x118
            if((class<EvilDmgType_Base>(DamageType) == none) || class<EvilDmgType_Base>(DamageType).default.bCausesBlood)
            {
                PlayClientBloodEffects(0.1750000 * vrcDmg);
            }
        }
    }
    // End:0x3A3
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x16E
        if(PKGame(WorldInfo.Game).bPlayerNoDamage)
        {
            return;
        }
        // End:0x260
        if(!WorldInfo.GRI.IsMultiplayerGame())
        {
            Damage = FCeil(float(Damage) * PKGame(WorldInfo.Game).PlayerDamageFactor);
            PRI = PainPRI(PlayerReplicationInfo);
            PRI.Difficulty.static.ModifyDamage(Damage);            
        }
        else
        {
            // End:0x2DA
            if((PainPRI(Controller.PlayerReplicationInfo) != none) && PainPRI(Controller.PlayerReplicationInfo).bPentagram)
            {
                Damage = 0;
            }
            // End:0x37B
            if((PKPlayerController_MP(EventInstigator) != none) && PainPRI(EventInstigator.PlayerReplicationInfo).bQuadDamage)
            {
                Damage *= PKGameMP_Base(WorldInfo.Game).QuadDamageModifier;
            }
        }
        LastHitTime = WorldInfo.TimeSeconds;
    }
    oldHP = Health;
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    PC = PKPlayerController(Controller);
    // End:0x488
    if((PC != none) && (oldHP != Health) || PC.bGodMode)
    {
        PC.bPlayerGotSomeDamage = true;
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local PKPlayerController PC;
    local Actor A;

    PC = PKPlayerController(Controller);
    // End:0x8D
    if(PC != none)
    {
        StopClientBloodEffects();
        PC.bDeathLocationNotValid = PC.bDeathLocationNotValid || DamageType == Class'PKDmgType_LavaPit';
    }
    // End:0x12F
    if(WorldInfo.GRI.IsMultiplayerGame() && int(Role) == int(ROLE_Authority))
    {
        // End:0x124
        if(PKGameMP_Base(WorldInfo.Game).bPowerUpDrop)
        {
            SpawnPowerUp();
        }
        CommentDeath();
    }
    // End:0x1B4
    if(PKGameSP(WorldInfo.Game) != none)
    {
        PKGameSP(WorldInfo.Game).StartAchievementCheck(PKPlayerController(Controller), Killer);
    }
    // End:0x220
    if(Controller != none)
    {
        // End:0x21F
        foreach Children(A)
        {
            // End:0x21E
            if(A.IsA('PainItemBase'))
            {
                A.SetOwner(Controller);
            }            
        }        
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    local PlayerController PC;
    local Actor A;

    super.PlayDying(DamageType, HitLoc);
    // End:0xE4
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        // End:0x6B
        if(Controller == none)
        {
            PC = GetALocalPlayerController();            
        }
        else
        {
            PC = PlayerController(Controller);
        }
        // End:0xE3
        foreach Children(A)
        {
            // End:0xE2
            if(A.IsA('PainItemBase'))
            {
                A.SetOwner(PC);
            }            
        }        
    }
    //return;    
}

function CommentDeath(optional int Points = 10)
{
    local PainPRI PRI;

    PRI = PainPRI(Controller.PlayerReplicationInfo);
    // End:0x48
    if(PRI == none)
    {
        return;
    }
    // End:0x8C
    if(PRI.LuciferComments > 0)
    {
        PRI.LuciferComments = 0;
    }
    PRI.LuciferComments = PRI.LuciferComments - Points;
    // End:0x12B
    if(PRI.LuciferComments == -50)
    {
        PlaySound(Class'PKGameMP_Base'.default.LuciferBadSound[0]);
    }
    // End:0x1A6
    if(PRI.LuciferComments == -100)
    {
        PlaySound(Class'PKGameMP_Base'.default.LuciferVeryBadSound[0]);
        PRI.LuciferComments = -50;
    }
    //return;    
}

function CommentKill(optional int Points = 10)
{
    local PainPRI PRI;

    PRI = PainPRI(Controller.PlayerReplicationInfo);
    // End:0x48
    if(PRI == none)
    {
        return;
    }
    // End:0x8C
    if(PRI.LuciferComments < 0)
    {
        PRI.LuciferComments = 0;
    }
    PRI.LuciferComments = PRI.LuciferComments + Points;
    // End:0x128
    if(PRI.LuciferComments == 50)
    {
        PlaySound(Class'PKGameMP_Base'.default.LuciferGoodSound[0]);
    }
    // End:0x19D
    if(PRI.LuciferComments == 100)
    {
        PlaySound(Class'PKGameMP_Base'.default.LuciferExcellentSound[0]);
        PRI.LuciferComments = 50;
    }
    //return;    
}

function SpawnPowerUp()
{
    local PainItemBase pup;

    // End:0x8B
    if(PainPRI(Controller.PlayerReplicationInfo).bQuadDamage)
    {
        pup = Spawn(Class'PKQuadDamage',,, Location);
        pup.MaxPickCount = 1;
    }
    // End:0x116
    if(PainPRI(Controller.PlayerReplicationInfo).bPentagram)
    {
        pup = Spawn(Class'PKPentagram',,, Location);
        pup.MaxPickCount = 1;
    }
    // End:0x1A1
    if(PainPRI(Controller.PlayerReplicationInfo).bHasWeaponModifier)
    {
        pup = Spawn(Class'PainItemWeaponModifier',,, Location);
        pup.MaxPickCount = 1;
    }
    //return;    
}

function StartHealthDecrease()
{
    SetTimer(1.0000000, true, 'HealthDecrease');
    //return;    
}

function HealthDecrease()
{
    // End:0x28
    if(float(Health) > DefaultHealth)
    {
        Health -= 1;        
    }
    else
    {
        ClearTimer('HealthDecrease');
    }
    //return;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);
    SetTeamMaterial();
    RepSetTeamMaterial = true;
    //return;    
}

event bool HealDamageLimit(int Amount, int MaxLimit)
{
    // End:0x56
    if((Health > 0) && Health < MaxLimit)
    {
        Health = Min(MaxLimit, Health + Amount);
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function DoQuickCustom1()
{
    local PKPlayerController PC;
    local int I;

    PC = PKPlayerController(Controller);
    I = 0;
    J0x27:

    // End:0xD9 [Loop If]
    if(I < PC.QuickActionCustom1.Length)
    {
        // End:0xCB
        if(DoQuickActionSwitchWorker(class<PainWeap_Base>(PC.CustomWeaponMapping[int(PC.QuickActionCustom1[I])].WeaponClass)))
        {
            // [Explicit Break]
            goto J0xD9;
        }
        I++;
        // [Loop Continue]
        goto J0x27;
    }
    J0xD9:

    //return;    
}

simulated function DoQuickCustom2()
{
    local PKPlayerController PC;
    local int I;

    PC = PKPlayerController(Controller);
    I = 0;
    J0x27:

    // End:0xD9 [Loop If]
    if(I < PC.QuickActionCustom2.Length)
    {
        // End:0xCB
        if(DoQuickActionSwitchWorker(class<PainWeap_Base>(PC.CustomWeaponMapping[int(PC.QuickActionCustom2[I])].WeaponClass)))
        {
            // [Explicit Break]
            goto J0xD9;
        }
        I++;
        // [Loop Continue]
        goto J0x27;
    }
    J0xD9:

    //return;    
}

simulated function DoQuickCustom1Fire(bool bEnable)
{
    local PKPlayerController PC;
    local int I;

    // End:0x2D
    if(bEnable && bDoingQuickAction1 || bDoingQuickAction2)
    {
        return;
    }
    // End:0x4F
    if(!bEnable && !bDoingQuickAction1)
    {
        return;
    }
    PC = PKPlayerController(Controller);
    I = 0;
    J0x76:

    // End:0x1A2 [Loop If]
    if(I < PC.QuickActionCustom1.Length)
    {
        // End:0x194
        if(DoQuickActionWorker(bEnable, class<PainWeap_Base>(PC.CustomWeaponMapping[int(PC.QuickActionCustom1[I])].WeaponClass), PC.CustomWeaponMapping[int(PC.QuickActionCustom1[I])].bAltMode))
        {
            bDoingQuickAction1 = bEnable;
            // [Explicit Break]
            goto J0x1A2;
        }
        I++;
        // [Loop Continue]
        goto J0x76;
    }
    J0x1A2:

    //return;    
}

simulated function DoQuickCustom2Fire(bool bEnable)
{
    local PKPlayerController PC;
    local int I;

    // End:0x2D
    if(bEnable && bDoingQuickAction1 || bDoingQuickAction2)
    {
        return;
    }
    // End:0x4F
    if(!bEnable && !bDoingQuickAction2)
    {
        return;
    }
    PC = PKPlayerController(Controller);
    I = 0;
    J0x76:

    // End:0x1A2 [Loop If]
    if(I < PC.QuickActionCustom2.Length)
    {
        // End:0x194
        if(DoQuickActionWorker(bEnable, class<PainWeap_Base>(PC.CustomWeaponMapping[int(PC.QuickActionCustom2[I])].WeaponClass), PC.CustomWeaponMapping[int(PC.QuickActionCustom2[I])].bAltMode))
        {
            bDoingQuickAction2 = bEnable;
            // [Explicit Break]
            goto J0x1A2;
        }
        I++;
        // [Loop Continue]
        goto J0x76;
    }
    J0x1A2:

    //return;    
}

simulated function DoRocketJump(bool bEnable)
{
    // End:0x31
    if(EvilInvManager.FindInventoryType(Class'PKWeap_Chaingun_Base', true) == none)
    {
        return;
    }
    // End:0x49
    if(bEnable)
    {
        DoJump(false);
    }
    DoQuickActionWorker(bEnable, Class'PKWeap_Chaingun_Base', false);
    //return;    
}

simulated function DoForwardRocketJump(bool bEnable)
{
    // End:0x31
    if(EvilInvManager.FindInventoryType(Class'PKWeap_Chaingun_Base', true) == none)
    {
        return;
    }
    // End:0x49
    if(bEnable)
    {
        DoJump(false);
    }
    bForwardRocketJump = bEnable;
    DoQuickActionWorker(bEnable, Class'PKWeap_Chaingun_Base', false);
    //return;    
}

simulated function bool DoQuickActionSwitchWorker(class<PainWeap_Base> WeapClass, optional out PainWeap_Base QuickActionWeap, optional out PainWeap_Base OldWeapon)
{
    local PainWeap_Base Weap;

    Weap = PainWeap_Base(EvilInvManager.FindInventoryType(WeapClass, true));
    // End:0x4F
    if(Weap == none)
    {
        return false;
    }
    // End:0x75
    if(EvilInvManager.PendingWeapon != none)
    {
        return false;
    }
    // End:0xE1
    if((Weapon == none) || Weapon != Weap)
    {
        OldWeapon = PainWeap_Base(Weapon);
        EvilInvManager.ForceWeapon(Weap);
    }
    QuickActionWeap = Weap;
    return true;
    //return ReturnValue;    
}

simulated function bool DoQuickActionWorker(bool bEnable, class<PainWeap_Base> WeapClass, bool bAltFire)
{
    local PainWeap_Base Weap, OldWeap;
    local bool bResult;

    // End:0xBE
    if(bEnable)
    {
        bResult = DoQuickActionSwitchWorker(WeapClass, Weap, OldWeap);
        // End:0xBB
        if(bResult)
        {
            // End:0x92
            if((SavedWeapon == none) && OldWeap != none)
            {
                SavedWeapon = OldWeap.Class;
            }
            Weap.DoQuickAction(bAltFire);
        }        
    }
    else
    {
        // End:0x16B
        if((Weapon != none) && ClassIsChildOf(Weapon.Class, WeapClass))
        {
            PainWeap_Base(Weapon).EndQuickAction(bAltFire);
            // End:0x15C
            if(SavedWeapon != none)
            {
                SetCurrentWeaponClass(SavedWeapon);
                SavedWeapon = none;
            }
            bResult = true;            
        }
        else
        {
            bResult = false;
        }
    }
    return bResult;
    //return ReturnValue;    
}

singular simulated event Rotator GetBaseAimRotation()
{
    local Vector POVLoc;
    local Rotator POVRot;

    // End:0x8B
    if((Controller != none) && !InFreeCam())
    {
        Controller.GetPlayerViewPoint(POVLoc, POVRot);
        // End:0x81
        if(bForwardRocketJump)
        {
            POVRot.Yaw += 32768;
        }
        return POVRot;
    }
    POVRot = Rotation;
    // End:0xEE
    if(POVRot.Pitch == 0)
    {
        POVRot.Pitch = int(RemoteViewPitch) << int(8);
    }
    // End:0x11E
    if(bForwardRocketJump)
    {
        POVRot.Yaw += 32768;
    }
    return POVRot;
    //return ReturnValue;    
}

function RemoveArmour()
{
    ArmourClass = Class'PainItem_Armour_None';
    //return;    
}

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    // End:0x70
    if(((Controller != none) && InstigatedBy == Controller) && WorldInfo.GRI.IsMultiplayerGame())
    {
        InDamage /= float(2);
    }
    // End:0xD1
    if(!bFrozenArmour && ArmourClass.static.ReduceDamage(InDamage, HealthRemainder, Armour, ArmourRemainder))
    {
        RemoveArmour();
    }
    super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
    //return;    
}

simulated function SetupPlayerPhysics()
{
    // End:0x11
    if(!CacheGameClass())
    {
        return;
    }
    AccelRate = GameClass.default.PlayerAccelRate;
    GroundSpeed = GameClass.default.PlayerSpeed;
    AirSpeed = GameClass.default.PlayerSpeed;
    JumpZ = GameClass.default.PlayerSpeed;
    WaterSpeed = GameClass.default.UnderwaterSpeed;
    CustomGravityScaling = Abs(GameClass.default.PlayerGravity / WorldInfo.GetGravityZ());
    bAllowLedgeOverhang = !GameClass.default.bPauseable;
    //return;    
}

reliable client simulated function ClientSetupPlayerPhysics()
{
    SetupPlayerPhysics();
    //return;    
}

function bool Dodge(Actor.EDoubleClickDir DoubleClickMove)
{
    return false;
    //return ReturnValue;    
}

function bool DoJump(bool bUpdating)
{
    local Vector Velocity2D;
    local float Speed;

    // End:0x68B
    if(bJumpCapable && (((int(Physics) == int(1)) || int(Physics) == int(9)) || int(Physics) == int(8)) || (int(Physics) == int(2)) && bDitch)
    {
        // End:0xA9
        if(int(Physics) == int(8))
        {
            Velocity = JumpZ * Floor;            
        }
        else
        {
            AccelAtJump = Acceleration;
            LocalAccelAtJump = Acceleration << Rotation;
            Velocity2D = Velocity;
            Velocity2D.Z = 0.0000000;
            bCanBunnyHop = ((PainGRI(WorldInfo.GRI).IsMultiplayerGame()) ? PainGRI(WorldInfo.GRI).bBunnyhopping : true);
            // End:0x2C9
            if(bCanBunnyHop && (WorldInfo.TimeSeconds - LastLandTime) <= GameClass.default.SecondsWhenYouCanBunnyHopAfterLanding)
            {
                Speed = FMax(SpeedAtLanding, GameClass.default.PlayerSpeed);
                GroundSpeed = FMin(Speed + ((GameClass.default.MaximalBunnyHopSpeed - Speed) * GameClass.default.BunnyHopAcceleration), GameClass.default.MaximalBunnyHopSpeed);
                Speed = GroundSpeed;
                bIsBunnyHop = true;                
            }
            else
            {
                Speed = VSize2D(Velocity2D);
                bIsBunnyHop = false;
            }
            Velocity.X = 0.0000000;
            Velocity.Y = 0.0000000;
            // End:0x3B7
            if(!IsZero(Acceleration))
            {
                // End:0x382
                if(Speed ~= 0.0000000)
                {
                    Speed = GameClass.default.PlayerSpeed;
                }
                Speed *= MovementSpeedModifier;
                Velocity += (Normal2D(Acceleration) * Speed);
            }
            // End:0x497
            if(int(Physics) == int(9))
            {
                // End:0x406
                if(Speed ~= 0.0000000)
                {
                    Speed = GameClass.default.PlayerSpeed;
                }
                Speed *= MovementSpeedModifier;
                AccelAtJump = -OnLadder.LookDir;
                LocalAccelAtJump = AccelAtJump << Rotation;
                Velocity = (AccelAtJump * Speed) * 0.2500000;
                bIsBunnyHop = false;                
            }
            else
            {
                Velocity.Z = GameClass.default.JumpStrength * JumpZ;
            }
        }
        // End:0x59E
        if(((Base != none) && !Base.bWorldGeometry) && Base.Velocity.Z > 0.0000000)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        LastJumpPressedTime = 0.0000000;
        LastJumpTime = WorldInfo.TimeSeconds;
        AirControl = DefaultAirControl;
        SetPhysics(2);
        // End:0x62D
        if(EvilPlayerController(Controller) != none)
        {
            EvilPlayerController(Controller).Jumped();
        }
        // End:0x66D
        if(EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).Jumped();
        }
        // End:0x686
        if(!bUpdating)
        {
            PlayJumpingSound();
        }
        return true;        
    }
    else
    {
        // End:0x6C7
        if(int(Physics) == int(2))
        {
            LastJumpPressedTime = WorldInfo.TimeSeconds;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    local Vector Impulse;
    local PKPlayerController PC;

    super(Pawn).Landed(HitNormal, FloorActor);
    Impulse.Z = Velocity.Z * 4.0000000;
    // End:0xC8
    if(EvilVehicle_Base(FloorActor) != none)
    {
        EvilVehicle_Base(FloorActor).Mesh.AddImpulse(Impulse, Location);        
    }
    else
    {
        // End:0x131
        if(DynamicSMActor(FloorActor) != none)
        {
            DynamicSMActor(FloorActor).StaticMeshComponent.AddImpulse(Impulse, Location);
        }
    }
    // End:0x1C9
    if(Velocity.Z < float(-200))
    {
        OldZ = Location.Z;
        bJustLanded = (bUpdateEyeheight && Controller != none) && Controller.LandingShake();
    }
    // End:0x200
    if(EvilInvManager != none)
    {
        EvilInvManager.OwnerEvent('Landed');
    }
    // End:0x243
    if(!bHidden && Velocity.Z < float(-200))
    {
        PlayLandingSound();
    }
    // End:0x2A7
    if(Velocity.Z < -GameClass.default.CollisionMinSpeed)
    {
        SoundGroupClass.static.PlayFallingDamageLandSound(self);        
    }
    else
    {
        // End:0x30F
        if(Velocity.Z < (-GameClass.default.CollisionMinSpeed * -0.5000000))
        {
            SoundGroupClass.static.PlayLandSound(self);
        }
    }
    SetBaseEyeheight();
    // End:0x36B
    if(EvilWeap_Base(Weapon) != none)
    {
        EvilWeap_Base(Weapon).Landed(HitNormal, FloorActor);
    }
    bIsJumping = false;
    LastLandTime = WorldInfo.TimeSeconds;
    SpeedAtLanding = VSize2D(Velocity);
    PC = PKPlayerController(Controller);
    // End:0x48A
    if(PC != none)
    {
        PC.Landed(HitNormal, FloorActor);
        // End:0x48A
        if(bIsBunnyHop)
        {
            BunnyHopTimeAccumulator += (LastLandTime - LastJumpTime);
            // End:0x48A
            if(BunnyHopTimeAccumulator >= 1.0000000)
            {
                PC.IncrementGlobalIntStat(119, 1);
                BunnyHopTimeAccumulator -= 1.0000000;
            }
        }
    }
    //return;    
}

simulated event PostLanded()
{
    // End:0x6F
    if((LastLandTime - LastJumpPressedTime) <= ((bCanBunnyHop) ? GameClass.default.SecondsWhenYouCanBunnyHopBeforeLanding : GameClass.default.SecondsWhenYouCanJumpBeforeLanding))
    {
        DoJump(false);
    }
    //return;    
}

simulated function TakeFallingDamage()
{
    local float EffectiveSpeed;
    local int Damage;

    // End:0x24B
    if(Velocity.Z < (-0.5000000 * GameClass.default.CollisionMinSpeed))
    {
        // End:0x248
        if(int(Role) == int(ROLE_Authority))
        {
            MakeNoise(1.0000000);
            // End:0x248
            if(Velocity.Z < -GameClass.default.CollisionMinSpeed)
            {
                EffectiveSpeed = Velocity.Z;
                // End:0xE6
                if(TouchingWaterVolume())
                {
                    EffectiveSpeed += float(100);
                }
                // End:0x248
                if(EffectiveSpeed < -GameClass.default.CollisionMinSpeed)
                {
                    Damage = int((float(-100) * (EffectiveSpeed + GameClass.default.CollisionMinSpeed)) / (GameClass.default.CollisionMaxSpeed - GameClass.default.CollisionMinSpeed));
                    // End:0x213
                    if((PainGRI_SP(WorldInfo.GRI) != none) && PainGRI_SP(WorldInfo.GRI).ChapterNum == 7)
                    {
                        Damage = Min(0, 10);
                    }
                    TakeDamage(Damage, none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
                }
            }
        }        
    }
    else
    {
        // End:0x288
        if(Velocity.Z < (-1.4000000 * AirSpeed))
        {
            MakeNoise(0.5000000);            
        }
        else
        {
            // End:0x2C2
            if(Velocity.Z < (-0.8000000 * AirSpeed))
            {
                MakeNoise(0.2000000);
            }
        }
    }
    //return;    
}

function bool CanTouchItems()
{
    return true;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    local float Speed;
    local Vector Loc;
    local Rotator Rot;
    local PKPlayerController PKPC;

    super.Tick(DeltaTime);
    // End:0x146
    if((int(Physics) == int(1)) && GameClass != none)
    {
        // End:0xAE
        if(bCanBunnyHop && (WorldInfo.TimeSeconds - LastLandTime) > GameClass.default.SecondsWhenYouCanBunnyHopAfterLanding)
        {
            bCanBunnyHop = false;
            bIsBunnyHop = false;            
        }
        else
        {
            // End:0x146
            if(GroundSpeed > GameClass.default.PlayerSpeed)
            {
                Speed = VSize(Velocity);
                GroundSpeed = FMax(GameClass.default.PlayerSpeed, Speed - (((2.0000000 * Speed) * DeltaTime) * 2.0000000));
            }
        }
    }
    PKPC = PKPlayerController(Controller);
    // End:0x2C2
    if(((PKPC != none) && Flashlight != none) && Flashlight.bEnabled)
    {
        PKPC.GetPlayerViewPoint(Loc, Rot);
        Rot -= Rotation;
        Rot += SpotLightComponent'fx_FlashLight.ar_FlashlightSpotLight'.Rotation;
        Loc -= Location;
        Loc += SpotLightComponent'fx_FlashLight.ar_FlashlightSpotLight'.Translation;
        Loc += (WeaponBob(0.5000000, 0.5000000));
        Flashlight.SetTranslation(Loc);
        Flashlight.SetRotation(Rot);
    }
    //return;    
}

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    //return;    
}

simulated function SetEvilWeapAnimType(EvilTypes.EEvilWeapAnimType EvilAnimType)
{
    //return;    
}

simulated function SetWeapAnimType(UTPawn.EWeapAnimType AnimType)
{
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local PainPRI PRI;
    local class<PKFamilyInfoBase> CCI;
    local UDKAnimNodeJumpLeanOffset JumpLeanNode;

    super.PostInitAnimTree(SkelComp);
    // End:0x1C8
    if(Mesh == SkelComp)
    {
        PRI = PainPRI(PlayerReplicationInfo);
        // End:0x1C8
        if(PRI != none)
        {
            CCI = class<PKFamilyInfoBase>(PRI.CharClassInfo);
            // End:0x1C8
            if(CCI != none)
            {
                // End:0xE1
                if(EvilAimNode != none)
                {
                    EvilAimNode.SetActiveProfileByName(CCI.default.AimOffsetProfile);
                }
                JumpLeanNode = UDKAnimNodeJumpLeanOffset(Mesh.FindAnimNode('JumpLeanOffsetNode'));
                // End:0x168
                if(JumpLeanNode != none)
                {
                    JumpLeanNode.SetActiveProfileByName(CCI.default.AimOffsetProfile);
                }
                // End:0x1C8
                if(!CCI.default.bUseTurnInPlace)
                {
                    // End:0x1BC
                    if(TurnInPlaceNode != none)
                    {
                        TurnInPlaceNode.RotTransitions.Length = 0;
                    }
                    bCanDoTurnInPlaceAnim = false;
                }
            }
        }
    }
    //return;    
}

function bool CanBeAttacked(EvilPawn InAttacker)
{
    // End:0x12
    if(IsInState('Ghost'))
    {
        return false;
    }
    return super(EvilPawn).CanBeAttacked(InAttacker);
    //return ReturnValue;    
}

event UpdateEyeHeight(float DeltaTime)
{
    local bool bBobOnUpsDowns;
    local float smooth, MaxEyeHeight, OldEyeHeight, Speed2D, OldBobTime;

    local Actor HitActor;
    local Vector HitLocation, HitNormal, X, Y, Z;

    local int M, N;

    // End:0x2E
    if(bTearOff)
    {
        EyeHeight = default.BaseEyeHeight;
        bUpdateEyeheight = false;
        return;
    }
    bBobOnUpsDowns = false;
    // End:0x84
    if(Abs(Location.Z - OldZ) > float(15))
    {
        bJustLanded = false;
        bLandRecovery = false;
    }
    // End:0xAB
    if(!bBobOnUpsDowns)
    {
        bJustLanded = false;
        bLandRecovery = false;
    }
    // End:0x22B
    if(!bJustLanded)
    {
        smooth = FMin(0.9000000, (10.0000000 * DeltaTime) / CustomTimeDilation);
        LandBob *= (float(1) - smooth);
        // End:0x1EF
        if(((int(Physics) == int(1)) || int(Physics) == int(8)) || Controller.IsInState('PlayerSwimming'))
        {
            OldEyeHeight = EyeHeight;
            EyeHeight = FMax((((EyeHeight - Location.Z) + OldZ) * (float(1) - smooth)) + (BaseEyeHeight * smooth), -0.5000000 * CylinderComponent.CollisionHeight);            
        }
        else
        {
            EyeHeight = (EyeHeight * (float(1) - smooth)) + (BaseEyeHeight * smooth);
        }        
    }
    else
    {
        // End:0x362
        if(bLandRecovery)
        {
            smooth = FMin(0.9000000, 9.0000000 * DeltaTime);
            OldEyeHeight = EyeHeight;
            LandBob *= (float(1) - smooth);
            // End:0x2D6
            if(EyeHeight > (0.9000000 * BaseEyeHeight))
            {
                EyeHeight = EyeHeight + ((0.1500000 * BaseEyeHeight) * smooth);                
            }
            else
            {
                EyeHeight = (EyeHeight * (float(1) - (0.6000000 * smooth))) + ((BaseEyeHeight * 0.6000000) * smooth);
            }
            // End:0x35F
            if(EyeHeight >= BaseEyeHeight)
            {
                bJustLanded = false;
                bLandRecovery = false;
                EyeHeight = BaseEyeHeight;
            }            
        }
        else
        {
            smooth = FMin(0.6500000, 8.0000000 * DeltaTime);
            OldEyeHeight = EyeHeight;
            EyeHeight = EyeHeight * (float(1) - (1.5000000 * smooth));
            LandBob += (0.0800000 * (OldEyeHeight - EyeHeight));
            // End:0x449
            if((EyeHeight < ((0.2500000 * BaseEyeHeight) + float(1))) || LandBob > 1.8500000)
            {
                bLandRecovery = true;
                EyeHeight = (0.2500000 * BaseEyeHeight) + float(1);
            }
        }
    }
    // End:0x490
    if(bJustLanded || !bUpdateEyeheight)
    {
        BobTime = 0.0000000;
        WalkBob = vect(0.0000000, 0.0000000, 0.0000000);        
    }
    else
    {
        // End:0x4B1
        if(!bBobOnUpsDowns)
        {
            JumpBob = 0.0000000;            
        }
        else
        {
            // End:0x529
            if(Velocity.Z > float(0))
            {
                JumpBob = FMax(-1.5000000, JumpBob - ((0.0300000 * DeltaTime) * FMin(Velocity.Z, 300.0000000)));                
            }
            else
            {
                JumpBob *= (float(1) - FMin(1.0000000, 8.0000000 * DeltaTime));
            }
        }
        OldBobTime = BobTime;
        Bob = FClamp(Bob, -0.0500000, 0.0500000);
        // End:0x74C
        if(int(Physics) == int(1))
        {
            GetAxes(Rotation, X, Y, Z);
            Speed2D = VSize(Velocity);
            // End:0x601
            if(Speed2D < float(10))
            {
                BobTime += (0.2000000 * DeltaTime);                
            }
            else
            {
                BobTime += (DeltaTime * (0.3000000 + ((0.7000000 * Speed2D) / GroundSpeed)));
            }
            WalkBob = ((Y * Bob) * Speed2D) * Sin(8.0000000 * BobTime);
            AppliedBob = AppliedBob * (float(1) - FMin(1.0000000, 16.0000000 * DeltaTime));
            WalkBob.Z = AppliedBob;
            // End:0x749
            if(Speed2D > float(10))
            {
                WalkBob.Z = WalkBob.Z + (((0.7500000 * Bob) * Speed2D) * Sin(16.0000000 * BobTime));
            }            
        }
        else
        {
            // End:0x8AF
            if(int(Physics) == int(3))
            {
                GetAxes(Rotation, X, Y, Z);
                BobTime += DeltaTime;
                Speed2D = Sqrt((Velocity.X * Velocity.X) + (Velocity.Y * Velocity.Y));
                WalkBob = (((Y * Bob) * 0.5000000) * Speed2D) * Sin(4.0000000 * BobTime);
                WalkBob.Z = ((Bob * 1.5000000) * Speed2D) * Sin(8.0000000 * BobTime);                
            }
            else
            {
                BobTime = 0.0000000;
                WalkBob = WalkBob * (float(1) - FMin(1.0000000, 8.0000000 * DeltaTime));
            }
        }
        // End:0x9CE
        if(((int(Physics) == int(1)) && VSizeSq(Velocity) > float(100)) && IsFirstPerson())
        {
            M = int((0.5000000 * 3.1415930) + ((6.0000000 * OldBobTime) / 3.1415930));
            N = int((0.5000000 * 3.1415930) + ((6.0000000 * BobTime) / 3.1415930));
            // End:0x9CE
            if(((M != N) && !bIsWalking) && !bIsCrouched)
            {
                ActuallyPlayFootstepSound(0);
            }
        }
        // End:0x9ED
        if(!bWeaponBob)
        {
            WalkBob *= 0.1000000;
        }
    }
    // End:0xB69
    if(((CylinderComponent.CollisionHeight - EyeHeight) < float(12)) && IsFirstPerson())
    {
        // End:0xB69
        if(bCollideWorld)
        {
            HitActor = Trace(HitLocation, HitNormal, (Location + WalkBob) + ((MaxStepHeight + CylinderComponent.CollisionHeight) * vect(0.0000000, 0.0000000, 1.0000000)), Location + WalkBob, true, vect(12.0000000, 12.0000000, 12.0000000),, 8);
            MaxEyeHeight = ((HitActor == none) ? CylinderComponent.CollisionHeight + MaxStepHeight : HitLocation.Z - Location.Z);
            EyeHeight = FMin(EyeHeight, MaxEyeHeight);
        }
    }
    //return;    
}

simulated function SetGhostMaterial()
{
    local int MatIdx;

    MatIdx = 0;
    J0x0B:

    // End:0x77 [Loop If]
    if(MatIdx < Mesh.Materials.Length)
    {
        Mesh.SetMaterial(MatIdx, GhostMaterial);
        ++MatIdx;
        // [Loop Continue]
        goto J0x0B;
    }
    // End:0x97
    if(int(Role) == int(ROLE_Authority))
    {
        MaterialOverride = 2;
    }
    //return;    
}

simulated function RestoreMaterial()
{
    local int MatIdx;

    MatIdx = 0;
    J0x0B:

    // End:0x96 [Loop If]
    if(MatIdx < Mesh.Materials.Length)
    {
        Mesh.SetMaterial(MatIdx, Mesh.default.Materials[MatIdx]);
        ++MatIdx;
        // [Loop Continue]
        goto J0x0B;
    }
    // End:0xB6
    if(int(Role) == int(ROLE_Authority))
    {
        MaterialOverride = 0;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x5E
        case 'MaterialOverride':
            // End:0x40
            if(int(MaterialOverride) == int(2))
            {
                SetGhostMaterial();                
            }
            else
            {
                // End:0x5E
                if(int(MaterialOverride) != int(1))
                {
                    RestoreMaterial();
                }
            }
        // End:0x80
        case 'RepSetTeamMaterial':
            SetTimer(1.0000000, false, 'SetTeamMaterial');
            // End:0x96
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local array<Object> objVars;
    local Actor spawnPt;
    local Sequence GameSeq;
    local array<SequenceObject> SeqEvents;
    local SequenceObject SeqObj;
    local SeqEvent_Touch TouchEvent;
    local Rotator SrcRotation;
    local int I, J;
    local float ZOffset;
    local Vector NewLocation;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x40D
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_Touch', true, SeqEvents);
        // End:0x40C
        foreach SeqEvents(SeqObj)
        {
            TouchEvent = SeqEvent_Touch(SeqObj);
            I = 0;
            J0xA8:

            // End:0x3DB [Loop If]
            if(I < TouchEvent.OutputLinks.Length)
            {
                J = 0;
                J0xE0:

                // End:0x380 [Loop If]
                if(J < TouchEvent.OutputLinks[I].Links.Length)
                {
                    // End:0x372
                    if(TouchEvent.OutputLinks[I].Links[J].LinkedOp == Action)
                    {
                        // End:0x36F
                        if(TouchEvent.Originator != none)
                        {
                            // End:0x2BD
                            if(TouchEvent.Originator.IsA('TriggerVolume'))
                            {
                                // End:0x2B9
                                foreach TouchEvent.Originator.Attached(spawnPt)
                                {
                                    SrcRotation = spawnPt.Rotation;
                                    ZOffset = FMax(0.0000000, Location.Z - spawnPt.Location.Z);
                                    goto J0x2B9;                                    
                                }
                                J0x2B9:
                                                                
                            }
                            else
                            {
                                SrcRotation = TouchEvent.Originator.Rotation;
                                ZOffset = FMax(0.0000000, Location.Z - TouchEvent.Originator.Location.Z);
                            }
                        }
                        // [Explicit Break]
                        goto J0x380;
                    }
                    ++J;
                    // [Loop Continue]
                    goto J0xE0;
                }
                J0x380:

                // End:0x3CD
                if(J < TouchEvent.OutputLinks[I].Links.Length)
                {
                    // [Explicit Break]
                    goto J0x3DB;
                }
                ++I;
                // [Loop Continue]
                goto J0xA8;
            }
            J0x3DB:

            // End:0x40B
            if(I < TouchEvent.OutputLinks.Length)
            {                
            }
            else
            {                
            }
        }        
    }
    // End:0x487
    if(WorldInfo.GRI.IsMultiplayerGame() && int(WorldInfo.NetMode) != int(NM_Client))
    {
        PlaySound(TeleportSound);
    }
    super(Pawn).OnTeleport(Action);
    Action.GetObjectVars(objVars, "Destination");
    // End:0x5B8
    if(objVars.Length > 0)
    {
        spawnPt = Actor(objVars[0]);
        Velocity = (Velocity >> SrcRotation) << spawnPt.Rotation;
        // End:0x5B8
        if(!ZOffset ~= 0.0000000)
        {
            NewLocation = Location;
            NewLocation.Z += ZOffset;
            // End:0x5B8
            if(FindSpot(GetCollisionExtent(), NewLocation))
            {
                SetLocation(NewLocation);
            }
        }
    }
    //return;    
}

function PlayDyingSound()
{
    // End:0x33
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        super(EvilPawn).PlayDyingSound();
    }
    //return;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    super(Actor).HitWall(HitNormal, Wall, WallComp);
    //return;    
}

simulated function WeaponChanged(EvilWeap_Base NewWeapon)
{
    super(EvilPawn).WeaponChanged(NewWeapon);
    // End:0x5F
    if(PKPlayerController(Controller) != none)
    {
        SetMeshLightAcceptance(!PKPlayerController(Controller).bFlashlightOn);
    }
    //return;    
}

simulated function SetFlashlight(bool bEnabled)
{
    local PKPlayerController PC;

    PC = PKPlayerController(Controller);
    // End:0x2D
    if(PC == none)
    {
        return;
    }
    // End:0x99
    if(!PC.IsLocalController())
    {
        // End:0x97
        if(int(Role) == int(ROLE_Authority))
        {
            PKPlayerController(Controller).ClientSetFlashlight(bEnabled);
        }
        return;
    }
    // End:0x13B
    if(bEnabled)
    {
        // End:0xF3
        if(Flashlight == none)
        {
            Flashlight = new (Outer) Class'Engine.SpotLightComponent' (SpotLightComponent'fx_FlashLight.ar_FlashlightSpotLight');
            AttachComponent(Flashlight);            
        }
        else
        {
            // End:0x117
            if(PC.bFlashlightOn)
            {
                return;
            }
        }
        PC.bFlashlightOn = true;        
    }
    else
    {
        // End:0x16E
        if(Flashlight != none)
        {
            PC.bFlashlightOn = false;            
        }
        else
        {
            return;
        }
    }
    Flashlight.SetEnabled(bEnabled);
    SetMeshLightAcceptance(!bEnabled);
    //return;    
}

protected simulated function SetMeshLightAcceptance(bool bNewEnabled)
{
    local int I;
    local LightingChannelContainer LCC;

    // End:0x129
    if((Weapon != none) && Weapon.Mesh != none)
    {
        LCC = Weapon.Mesh.LightingChannels;
        LCC.Dynamic = bNewEnabled;
        LCC.CompositeDynamic = bNewEnabled;
        LCC.Unnamed_6 = !bNewEnabled;
        Weapon.Mesh.SetLightingChannels(LCC);
    }
    I = 0;
    J0x134:

    // End:0x249 [Loop If]
    if(I < 2)
    {
        // End:0x23B
        if(ArmsMesh[I] != none)
        {
            LCC = ArmsMesh[I].LightingChannels;
            LCC.Dynamic = bNewEnabled;
            LCC.CompositeDynamic = bNewEnabled;
            LCC.Unnamed_6 = !bNewEnabled;
            ArmsMesh[I].SetLightingChannels(LCC);
        }
        ++I;
        // [Loop Continue]
        goto J0x134;
    }
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    PKPlayerController(Controller).bDeathLocationNotValid = true;
    super.FellOutOfWorld(dmgType);
    //return;    
}

function SpawnBonusTreasure(int numberofTreasures, optional bool bIgnoreTimeOfDeathAndFastTraceCondition = false)
{
    //return;    
}

simulated function bool HandleTeleport(array<Object> DestList, bool bUpdateRotation, bool bCheckOverlap, optional float TeleportDistance, optional array<Volume> TeleportVolumes, optional int PreferredDestIndex)
{
    local int Idx, Cnt;
    local Actor destActor, tempActor, A;
    local Controller C;
    local bool bOccupiedDest, bCollidingWorld, bCollidingActor;
    local Vector Extent, Diff;
    local PKPlayerPawn P;

    Extent = GetCollisionExtent();
    bOccupiedDest = false;
    // End:0x486
    if(DestList.Length > 0)
    {
        Idx = ((PreferredDestIndex >= 0) ? PreferredDestIndex : 0);
        // End:0x86
        if(Idx >= DestList.Length)
        {
            Idx = 0;
            PreferredDestIndex = 0;
        }
        Cnt = 0;
        J0x91:

        tempActor = Actor(DestList[Idx]);
        // End:0x419
        if(tempActor != none)
        {
            C = Controller(tempActor);
            // End:0x13F
            if((C != none) && C.Pawn != none)
            {
                tempActor = C.Pawn;
            }
            // End:0x3D2
            if(bCheckOverlap)
            {
                bCollidingActor = false;
                // End:0x23A
                foreach VisibleCollidingActors(Class'Engine.Actor', A, Extent.X * 2.0000000, tempActor.Location, false, Extent, true)
                {
                    // End:0x239
                    if(IsBlockedBy(A))
                    {
                        // End:0x205
                        if(A.bWorldGeometry)
                        {
                            bCollidingWorld = true;
                            // End:0x239
                            continue;
                        }
                        // End:0x239
                        if(!A.IsA('PKPlayerPawn'))
                        {
                            bCollidingActor = true;
                            // End:0x23A
                            break;
                        }
                    }                    
                }                
                // End:0x3BD
                if(!bCollidingActor)
                {
                    // End:0x3BC
                    foreach DynamicActors(Class'PKPlayerPawn', P)
                    {
                        // End:0x276
                        if(P == self)
                        {
                            continue;                            
                        }
                        Diff = P.Location - tempActor.Location;
                        // End:0x3BB
                        if(((IsBlockedBy(P) && Abs(Diff.X) <= (2.0000000 * Extent.X)) && Abs(Diff.Y) <= (2.0000000 * Extent.Y)) && Abs(Diff.Z) <= (2.0000000 * Extent.Z))
                        {
                            bCollidingActor = true;
                            // End:0x3BC
                            break;
                        }                        
                    }                    
                }
                bOccupiedDest = bCollidingActor;
            }
            destActor = tempActor;
            // End:0x419
            if((!bCheckOverlap || !bOccupiedDest) && destActor != none)
            {
                // [Explicit Continue]
                goto J0x483;
            }
        }
        ++Idx;
        // End:0x447
        if(Idx >= DestList.Length)
        {
            Idx = 0;
        }
        ++Cnt;
        // End:0x91
        if(!((Idx == PreferredDestIndex) || Cnt >= DestList.Length))
            goto J0x91;
        J0x483:
        
    }
    // End:0x69D
    if((destActor != none) && Class'Engine.SeqAct_Teleport'.static.ShouldTeleport(self, destActor.Location, TeleportDistance, TeleportVolumes))
    {
        Diff = destActor.Location;
        // End:0x53B
        if(bCollidingWorld)
        {
            FindSpot(Extent, Diff);
        }
        // End:0x69B
        if(SetLocation(Diff))
        {
            // End:0x5AD
            if(!IsLocallyControlled() && PlayerController(Controller) != none)
            {
                PlayerController(Controller).ClientSetLocation(Diff, Rotation);
            }
            PlayTeleportEffect(false, true);
            // End:0x66A
            if(bUpdateRotation)
            {
                SetRotation(destActor.Rotation);
                // End:0x66A
                if(Controller != none)
                {
                    Controller.SetRotation(destActor.Rotation);
                    Controller.ClientSetRotation(destActor.Rotation);
                }
            }
            // End:0x699
            if(Controller != none)
            {
                Controller.OnTeleport(none);
            }
            return true;
        }
        return false;
    }
    // End:0x6AE
    if(destActor == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function UpdateQuadDamageVisionMaterial(PlayerController Viewer)
{
    // End:0x8F
    if(((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || !WorldInfo.GRI.IsMultiplayerGame()) || !Viewer.IsInState('QuadDamage'))
    {
        return;
    }
    // End:0xFD
    if(!WorldInfo.GRI.OnSameTeam(Viewer, self))
    {
        DemonModeMaterial = Class'PKPawn'.default.DemonModeMaterial;        
    }
    else
    {
        SetDemonMaterial(false, true);
        return;
    }
    SetDemonMaterial(false, false);
    SetDemonMaterial(true, false);
    //return;    
}

simulated function NotifyTeamChanged()
{
    super(UTPawn).NotifyTeamChanged();
    UpdateQuadDamageVisionMaterial(GetALocalPlayerController());
    //return;    
}

simulated function SetTeamMaterial()
{
    local MaterialInterface Mat;

    // End:0x24B
    if(WorldInfo.GRI.IsMultiplayerGame())
    {
        // End:0x106
        if(PainGRI(WorldInfo.GRI).IsTeamMultiPlayerGame())
        {
            // End:0xDB
            if(PlayerReplicationInfo.Team.TeamIndex == 1)
            {
                Mat = Class'PKPlayerPawn'.default.TeamBlueMaterial;                
            }
            else
            {
                Mat = Class'PKPlayerPawn'.default.TeamRedMaterial;
            }            
        }
        else
        {
            // End:0x1FE
            if(PainGRI(WorldInfo.GRI).bBrightSkin)
            {
                // End:0x1D6
                if(((PlayerReplicationInfo.Team.TeamIndex == 0) && int(Role) == int(ROLE_Authority)) || int(Role) == int(ROLE_AutonomousProxy))
                {
                    Mat = Class'PKPlayerPawn'.default.TeamBlueMaterial;                    
                }
                else
                {
                    Mat = Class'PKPlayerPawn'.default.TeamRedMaterial;
                }
            }
        }
        // End:0x237
        if(Mat != none)
        {
            Class'PKPlayerOverlayComponent'.static.HighlightActor(self, Mat, true);
        }
        UpdateQuadDamageVisionMaterial(GetALocalPlayerController());
    }
    //return;    
}

simulated function SetDemonMaterial(bool bEnable, bool bSameTeam)
{
    local editinline PKPlayerOverlayComponent poc;

    super.SetDemonMaterial(bEnable, (((WorldInfo.GRI.GameClass != none) && WorldInfo.GRI.GameClass == Class'PKGameCooperative') ? false : bSameTeam));
    poc = Class'PKPlayerOverlayComponent'.static.GetForActor(self);
    // End:0xFF
    if(poc != none)
    {
        poc.SetQuickHide(bEnable);
    }
    //return;    
}

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    // End:0xC0
    if(bPlayHitSoundInPlayHit && (WorldInfo.TimeSeconds - LastPainSound) >= 0.4000000)
    {
        LastPainSound = WorldInfo.TimeSeconds;
        // End:0xC0
        if((Damage > float(0)) && Health > 0)
        {
            SoundGroupClass.static.PlayTakeHitSound(self, int(Damage), DamageType);
        }
    }
    super(EvilPawn).PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
    //return;    
}

simulated state Ghost
{
    ignores TakeDamage;

    simulated event PushedState()
    {
        SetGhostMaterial();
        QuickHideCurrentWeapon(true);
        //return;        
    }

    simulated event PoppedState()
    {
        RestoreMaterial();
        EndQuickHideCurrentWeapon(true);
        RespawnFromGhostPSC = new (self) Class'Engine.ParticleSystemComponent';
        RespawnFromGhostPSC.SetTemplate(RespawnFromGhostPS);
        AttachComponent(RespawnFromGhostPSC);
        RespawnFromGhostPSC.SetActorParameter('BoneSocketActor', self);
        RespawnFromGhostPSC.ActivateSystem();
        //return;        
    }
    stop;    
}

simulated state Demon
{
    simulated event PushedState()
    {
        // End:0x243
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x2C
            if(bDoingQuickAction1)
            {
                DoQuickCustom1Fire(false);
            }
            // End:0x44
            if(bDoingQuickAction2)
            {
                DoQuickCustom2Fire(false);
            }
            // End:0x5C
            if(bForwardRocketJump)
            {
                DoForwardRocketJump(false);
            }
            // End:0xAF
            if((SavedWeapon != none) && Weapon != none)
            {
                DoQuickActionWorker(false, class<PainWeap_Base>(Weapon.Class), false);
            }
            // End:0x170
            if(((EvilInvManager != none) && EvilInvManager.PendingWeapon != none) && EvilInvManager.PendingWeapon.Class != Class'PKWeap_Demon')
            {
                OldWeaponClass = class<PainWeap_Base>(EvilInvManager.PendingWeapon.Class);                
            }
            else
            {
                // End:0x1E1
                if((Weapon != none) && Weapon.Class != Class'PKWeap_Demon')
                {
                    OldWeaponClass = class<PainWeap_Base>(Weapon.Class);                    
                }
                else
                {
                    OldWeaponClass = none;
                }
            }
            // End:0x22F
            if(EvilInvManager.FindInventoryType(Class'PKWeap_Demon') == none)
            {
                CreateInventory(Class'PKWeap_Demon');
            }
            SetCurrentWeaponClass(Class'PKWeap_Demon', true);
        }
        //return;        
    }

    simulated event PoppedState()
    {
        local Inventory DemonGun;

        // End:0xBA
        if(int(Role) == int(ROLE_Authority))
        {
            DemonGun = EvilInvManager.FindInventoryType(Class'PKWeap_Demon');
            // End:0x7E
            if(DemonGun != none)
            {
                InvManager.RemoveFromInventory(DemonGun);
            }
            // End:0xBA
            if((OldWeaponClass != none) && OldWeaponClass != Class'PKWeap_Demon')
            {
                SetCurrentWeaponClass(OldWeaponClass, true);
            }
        }
        // End:0x10A
        if(WorldInfo.GRI.GameClass != Class'PKGameSurvival')
        {
            CustomTimeDilation = 1.0000000;
        }
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        // End:0x70
        if(WorldInfo.GRI.GameClass != Class'PKGameSurvival')
        {
            CustomTimeDilation = 1.0000000 / WorldInfo.TimeDilation;
        }
        global.Tick(DeltaTime);
        //return;        
    }
    stop;    
}

simulated state Dying
{
    simulated event BeginState(name PreviousStateName)
    {
        local editinline SkeletalMeshComponent SMC;

        bDissolveOnDeath = (Mesh != none) && string(Mesh.SkeletalMesh) == "sk_ch_mp_GrimReaper_01";
        // End:0xA6
        if(bDissolveOnDeath)
        {
            TimeToBodyDisappear = 1.5000000;
            // End:0xA5
            foreach ComponentList(Class'Engine.SkeletalMeshComponent', SMC)
            {
                AddMICsToArray(SMC);                
            }            
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function AddMICsToArray(MeshComponent MC)
    {
        local int I;
        local editinline MeshComponent Child;
        local MaterialInterface MI;
        local MaterialInstanceConstant MIC;

        // End:0x75
        if(MC.IsA('SkeletalMeshComponent'))
        {
            // End:0x74
            foreach SkeletalMeshComponent(MC).AttachedComponents(Class'Engine.MeshComponent', Child)
            {
                AddMICsToArray(Child);                
            }            
        }
        I = 0;
        J0x80:

        // End:0x1AA [Loop If]
        if(I < MC.GetNumElements())
        {
            MI = MC.GetMaterial(I);
            // End:0x145
            if((MaterialInstanceConstant(MI) != none) && MI.GetPackageName() == 'Transient')
            {
                MIC = MaterialInstanceConstant(MI);                
            }
            else
            {
                MIC = MC.CreateAndSetMaterialInstanceConstant(I);
            }
            // End:0x19C
            if(MIC != none)
            {
                DissolveMICs.AddItem(MIC);
            }
            ++I;
            // [Loop Continue]
            goto J0x80;
        }
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        local MaterialInstanceConstant MIC;
        local float DissolveAmount;

        global.Tick(DeltaTime);
        // End:0xD6
        if(bDissolveOnDeath)
        {
            DissolveAmount = 0.4000000 * FMax(0.0000000, 1.0000000 - ((WorldInfo.TimeSeconds - TimeOfDeath) / TimeToBodyDisappear));
            // End:0x8C
            if(DissolveAmount == 0.0000000)
            {
                Destroy();                
            }
            else
            {
                // End:0xD5
                foreach DissolveMICs(MIC)
                {
                    MIC.SetScalarParameterValue('DissolveAmount', DissolveAmount);                    
                }                
            }
        }
        //return;        
    }
    stop;    
}

state RidingRailCar
{
    simulated event PushedState()
    {
        local Inventory Inv;
        local PainWeap_Base Weap;

        super(Object).PushedState();
        Inv = InvManager.InventoryChain;
        J0x32:

        // End:0xBB [Loop If]
        if(Inv != none)
        {
            Weap = PainWeap_Base(Inv);
            // End:0x6F
            if(Weap == none)
            {                
            }
            else
            {
                Weap.SetTickGroup(3);
            }
            Inv = Inv.Inventory;
            // [Loop Continue]
            goto J0x32;
        }
        //return;        
    }

    simulated event PoppedState()
    {
        local Inventory Inv;
        local PainWeap_Base Weap;

        super(Object).PoppedState();
        Inv = InvManager.InventoryChain;
        J0x32:

        // End:0xD7 [Loop If]
        if(Inv != none)
        {
            Weap = PainWeap_Base(Inv);
            // End:0x6F
            if(Weap == none)
            {                
            }
            else
            {
                Weap.SetTickGroup(Weap.default.TickGroup);
            }
            Inv = Inv.Inventory;
            // [Loop Continue]
            goto J0x32;
        }
        //return;        
    }

    event BaseChange()
    {
        // End:0x5C
        if((PKRailCar_Rollercoaster_Base(ClampedBase) != none) && Base != ClampedBase)
        {
            PKRailCar_Rollercoaster_Base(ClampedBase).FixBasedPawn(self);
            return;
        }
        super(EvilPawn).BaseChange();
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        local Keypoint Seat;

        global.Tick(DeltaTime);
        // End:0xAF
        if(int(Role) < int(ROLE_Authority))
        {
            // End:0xAE
            foreach PKRailCar_Rollercoaster_Base(ClampedBase).AttachedKeyList(Seat)
            {
                // End:0xAD
                if(EvilRailCarSeat(Seat).Occupant == self)
                {
                    SetLocation(Seat.Location);                    
                }
                else
                {                    
                }
            }            
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    ArmourClass=Class'PainItem_Armour_None'
    SlipSpeedMultiplier=0.1500000
    GhostMaterial=Material'MaterialsBase_ch.Materials.m_CharacterBase_02_DeadMulti'
    TeamRedMaterial=MaterialInstanceConstant'MaterialsBase_ch.Materials.mi_CharacterMultiRed'
    TeamBlueMaterial=MaterialInstanceConstant'MaterialsBase_ch.Materials.mi_CharacterMultiBlue'
    RespawnFromGhostPS=ParticleSystem'ps_all_Levels.Effects.ps_ch_RespawnPlayer'
    LastHitTime=-999.0000000
    bThrowSoul=false
    bCanBeFrozen=false
    bGetAdjustedAimFromSocket=false
    DemonModeMaterial=MaterialInstanceConstant'PP_PKHD.Materials.DemonVisionPlayerMaterial'
    // Reference: StaticMeshComponent'Default__PKPlayerPawn.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPlayerPawn.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    bDisableEvilAnimWeaponAnims=false
    bPlayHitSoundInPlayHit=true
    bCanBeKnockedDown=false
    bCanDoTurnInPlaceAnim=true
    SupremeMoveMode=EMoveMode.EMM_Run
    DefaultInventory=/* Array type was not detected. */
    LeanLenght=30.0000000
    LeanRoll=3000.0000000
    PawnActionClasses=/* Array type was not detected. */
    AnimDefArchetype=EvilAnimDef'pk_AnimDefs.AnimDef_Player'
    // Reference: DynamicLightEnvironmentComponent'Default__PKPlayerPawn.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPlayerPawn.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    TeleportSound=SoundCue'a_MiscMP.Cue.Teleport'
    DefaultMeshScale=1.0000000
    // Reference: UTAmbientSoundComponent'Default__PKPlayerPawn.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPlayerPawn.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPlayerPawn.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    BaseTranslationOffset=0.0000000
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPlayerPawn.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPlayerPawn.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPlayerPawn.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPlayerPawn.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    MaxStepHeight=35.0000000
    LedgeCheckThreshold=30.0000000
    bCanCrouch=true
    bCanPickupInventory=true
    GroundSpeed=440.0000000
    AccelRate=2048.0000000
    JumpZ=400.0000000
    AirControl=1.0000000
    BaseEyeHeight=49.0000000
    EyeHeight=49.0000000
    // Reference: SkeletalMeshComponent'Default__PKPlayerPawn.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        AnimTreeTemplate=AnimTree'an_Hero_pk.AT_Human'
        SkipLodModel=0
        RootMotionMode=ERootMotionMode.RMM_Ignore
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPlayerPawn.MyLightEnvironment'
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPlayerPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionRadius=25.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPlayerPawn.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPawn.FaceAudioComponent'
    begin object name="FaceAudioComponent"
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    CollisionComponent=CollisionCylinder
}