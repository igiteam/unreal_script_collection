class SPActorDestructComponent extends ActorDestructComponent
    native;

struct native DamageInfo
{
    var bool Valid;
    var float Damage;
    var Controller instigatedBy;
    var Vector HitLocation;
    var Vector Momentum;
    var class<DamageType> DamageType;

    structdefaultproperties
    {
        Valid=false
        Damage=0.0000000
        instigatedBy=none
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DamageType=none
    }
};

var DamageInfo SavedDamageInfo;
/** Imporatnt - Add all component data in this struct only. It is in struct so it can be copied with single assignment */
var() private SPDestructibleProperties Properties;
var() float MinCollisionVelocity;
var() float MaxCollisionVelocity;
var() int HitPoints;
var() bool OnlyDestroyedByKismet;
var() bool AutoTrigger;
var transient bool bDestroyed;
var transient bool bKismetDetroying;
var transient bool bDisable;
var float FloatDamageRemainder;
var const class<DamageType> DefaultDamageType;
var transient float FireLastDamageAmount;
var transient float FireLastDamageTime;
var transient float FireFractionalDamage;
var transient int OnFireCount;
var transient int OnFireMax;

// Export USPActorDestructComponent::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPActorDestructComponent::execSpeedToDamage(FFrame&, void* const)
native function int SpeedToDamage(float Speed);

// Export USPActorDestructComponent::execGetProperties(FFrame&, void* const)
native function SPDestructibleProperties GetProperties();

// Export USPActorDestructComponent::execSetProperties(FFrame&, void* const)
native function SetProperties(SPDestructibleProperties newProperties);

// Export USPActorDestructComponent::execSPSpawn(FFrame&, void* const)
native final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

// Export USPActorDestructComponent::execCanDoDamageType(FFrame&, void* const)
native function bool CanDoDamageType(class<DamageType> DamageType);

event HandleRigidBodyCollision(float velocityMag, Actor Instigator, Vector HitLocation, Vector ContactNormal)
{
    local int Damage;
    local Vector Momentum;
    local Pawn Pawn;
    local Controller Controller;

    // End:0x0B
    if(bDisable)
    {
        return;
    }
    Damage = int(velocityMag * (GetHitUnitsPerVelocityUnit()));
    Momentum = velocityMag * ContactNormal;
    Pawn = Pawn(Instigator);
    // End:0x69
    if(Pawn != none)
    {
        Controller = Pawn.Controller;        
    }
    else
    {
        Controller = none;
    }
    TakeDamageAndProcEffects(float(Damage), Controller, HitLocation, Momentum, Class'SPDamageTypeRigidBody',, Instigator);
    //return;    
}

function bool CanCatchOnFire()
{
    return OnFireCount < OnFireMax;
    //return ReturnValue;    
}

function bool IsOnFire()
{
    return OnFireCount > 0;
    //return ReturnValue;    
}

function int CatchOnFire()
{
    OnFireCount++;
    return OnFireCount;
    //return ReturnValue;    
}

function int UnCatchOnFire()
{
    OnFireCount = Max(0, OnFireCount - 1);
    return OnFireCount;
    //return ReturnValue;    
}

function Pawn GetPawnOwner()
{
    local Pawn Pawn;

    Pawn = Pawn(Owner);
    return Pawn;
    //return ReturnValue;    
}

function int FloatingPointAdjustDamage(float Damage)
{
    local int intDamage, extraDamage;

    intDamage = int(Damage);
    FloatDamageRemainder += (Damage - float(intDamage));
    extraDamage = int(FloatDamageRemainder);
    intDamage += extraDamage;
    FloatDamageRemainder = FloatDamageRemainder - float(extraDamage);
    return intDamage;
    //return ReturnValue;    
}

function DestroyedByKismet()
{
    bKismetDetroying = true;
    //return;    
}

event ProcEffects(float DamageAmount, Pawn DamageInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x0D
    if(bDisable)
    {
        return;
    }
    // End:0xC0
    if(int(Owner.Role) < int(ROLE_Authority))
    {
        SavedDamageInfo.Valid = true;
        SavedDamageInfo.Damage = DamageAmount;
        SavedDamageInfo.instigatedBy = ((DamageInstigator != none) ? DamageInstigator.Controller : none);
        SavedDamageInfo.HitLocation = HitLocation;
        SavedDamageInfo.Momentum = Momentum;
        SavedDamageInfo.DamageType = DamageType;
    }
    //return;    
}

function ClientOnlyCauseDestruction()
{
    local int I, J;

    // End:0x0B
    if(bDisable)
    {
        return;
    }
    // End:0x23C
    if(int(Owner.Role) < int(ROLE_Authority))
    {
        // End:0x3C
        if(SavedDamageInfo.Valid)
        {            
        }
        else
        {
            // End:0x1CC
            if(Properties != none)
            {
                SavedDamageInfo.Damage = 0.0000000;
                SavedDamageInfo.instigatedBy = none;
                SavedDamageInfo.HitLocation = Owner.Location;
                SavedDamageInfo.Momentum = vect(0.0000000, 0.0000000, 0.0000000);
                // End:0xED
                if(Properties.CanHandleDamageType(none))
                {
                    SavedDamageInfo.Valid = true;
                    SavedDamageInfo.DamageType = none;                    
                }
                else
                {
                    I = 0;
                    J0xF4:

                    // End:0x1CC [Loop If]
                    if((I < Properties.OnBreakActionLists.Length) && !SavedDamageInfo.Valid)
                    {
                        J = 0;
                        J0x12D:

                        // End:0x1C2 [Loop If]
                        if((J < Properties.OnBreakActionLists[I].DamageTypes.Length) && !SavedDamageInfo.Valid)
                        {
                            SavedDamageInfo.Valid = true;
                            SavedDamageInfo.DamageType = Properties.OnBreakActionLists[I].DamageTypes[J];
                            J++;
                            // [Loop Continue]
                            goto J0x12D;
                        }
                        I++;
                        // [Loop Continue]
                        goto J0xF4;
                    }
                }
            }
        }
        // End:0x23C
        if(SavedDamageInfo.Valid)
        {
            CauseDestruction(SavedDamageInfo.Damage, SavedDamageInfo.instigatedBy, SavedDamageInfo.HitLocation, SavedDamageInfo.Momentum, SavedDamageInfo.DamageType);
        }
    }
    //return;    
}

function CauseDestruction(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local SPDProcessManager ProcessManager;

    // End:0x0D
    if(bDestroyed)
    {
        return;
    }
    // End:0x18
    if(bDisable)
    {
        return;
    }
    // End:0x25
    if(Properties == none)
    {
        return;
    }
    ProcessManager = Class'SPDProcessManager'.static.Get(Owner);
    // End:0x92
    if(ProcessManager != none)
    {
        ProcessManager.DoDestruct(Owner, Properties, int(Damage), instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    bDestroyed = true;
    HitPoints = -1;
    //return;    
}

event HandleTakeDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x0D
    if(bDisable)
    {
        return;
    }
    TakeDamageAndProcEffects(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

event PlayCollisionSound(float Damage)
{
    // End:0x55
    if((Properties != none) && Properties.CollisionSound[0] != none)
    {
        // End:0x55
        if(Owner != none)
        {
            Owner.PlaySound(Properties.CollisionSound[0]);
        }
    }
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int RemainingHitPoints;
    local Pawn Pawn;

    // End:0x0D
    if(bDisable)
    {
        return;
    }
    // End:0x18
    if(bDestroyed)
    {
        return;
    }
    // End:0x35
    if(OnlyDestroyedByKismet == true)
    {
        // End:0x32
        if(bKismetDetroying != true)
        {
            return;
        }        
    }
    else
    {
        // End:0x42
        if(!AutoTrigger)
        {
            return;
        }
    }
    // End:0x6D
    if(Properties != none)
    {
        // End:0x6D
        if(!Properties.CanHandleDamageType(DamageType))
        {
            return;
        }
    }
    // End:0xB1
    if(((DamageType != none) && Owner != none) && !DamageType.static.DoesDamageTypeHurtMyClass(Owner.Class))
    {
        return;
    }
    bKismetDetroying = false;
    Pawn = GetPawnOwner();
    DamageAmount = float(FloatingPointAdjustDamage(DamageAmount));
    // End:0x103
    if(Pawn != none)
    {
        RemainingHitPoints = Pawn.Health;        
    }
    else
    {
        RemainingHitPoints = int(float(HitPoints) - DamageAmount);
        HitPoints = RemainingHitPoints;
    }
    // End:0x16C
    if((RemainingHitPoints <= 0) && Properties != none)
    {
        CauseDestruction(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);        
    }
    else
    {
        PlayCollisionSound(DamageAmount);
    }
    super.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

event int GetHitPoints()
{
    local Pawn Pawn;

    Pawn = GetPawnOwner();
    // End:0x2E
    if(Pawn != none)
    {
        return Pawn.Health;        
    }
    else
    {
        return HitPoints;
    }
    //return ReturnValue;    
}

function SetHitPoints(int NewHitPointValue)
{
    HitPoints = NewHitPointValue;
    //return;    
}

function bool IsAPlayerTarget()
{
    // End:0x0D
    if(Properties == none)
    {
        return false;
    }
    return Properties.IsAPlayerTarget;
    //return ReturnValue;    
}

static function float GetHitUnitsPerVelocityUnit()
{
    local PandoraGameInfo spGameInfo;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x2C
    if(spGameInfo == none)
    {
        return 0.0000000;
    }
    return spGameInfo.HitUnitsPerVelocityUnit;
    //return ReturnValue;    
}

function PostBeginPlay()
{
    //return;    
}
