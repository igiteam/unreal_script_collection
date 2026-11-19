class SPDamageImpulsePulse extends Actor
    native
    notplaceable;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(Pulse) export editinline SPConeImpulseComponent m_ImpulseComponent;
var(Pulse) float m_delay;
var(Pulse) int m_damage;
var(Pulse) float m_startRadius;
var(Pulse) float m_damageRadius;
var(Pulse) float m_expansionRate;
var(Pulse) class<DamageType> m_damageType;
var float m_currentRadius;
var(Pulse) bool m_showDebug;
var(Pulse) bool m_selfDestruct;
var(Pulse) bool m_selfStart;
var(Pulse) bool m_bDoFullDamage;
var bool m_bActive;
var export editinline array<export editinline PrimitiveComponent> m_primitivesTouched;
var array<Actor> m_actorsDamaged;
var float m_activeTime;
var float m_lifeTime;

static function Rotator GetPulseFireRotation(Actor firedBy)
{
    return firedBy.Rotation;
    //return ReturnValue;    
}

static function SPDamageImpulsePulse Fire(Actor firedBy, Vector relativePos, float Radius, float Damage, optional float ImpulseStrength = 9000.0000000, optional float expansionRate = 1000.0000000)
{
    local SPDamageImpulsePulse Pulse;
    local Vector fireOrigin;
    local Rotator fireRotation;

    // End:0x174
    if(firedBy != none)
    {
        fireOrigin = (relativePos >> firedBy.Rotation) + firedBy.Location;
        fireRotation = GetPulseFireRotation(firedBy);
        Pulse = firedBy.Spawn(default.Class, firedBy,, fireOrigin, fireRotation,, true);
        // End:0x171
        if(Pulse != none)
        {
            // End:0xB2
            if(Radius <= float(0))
            {
                Radius = 1.0000000;
            }
            // End:0xD1
            if(expansionRate <= float(0))
            {
                expansionRate = Radius / 0.1000000;
            }
            // End:0xEA
            if(Damage <= float(2))
            {
                Damage = 2.0000000;
            }
            Pulse.m_damage = int(Damage);
            Pulse.m_damageRadius = Radius;
            Pulse.m_expansionRate = expansionRate;
            Pulse.m_selfDestruct = true;
            Pulse.m_selfStart = true;
            Pulse.m_ImpulseComponent.ImpulseStrength = ImpulseStrength;            
        }        
    }
    else
    {
        Pulse = none;
    }
    return Pulse;
    //return ReturnValue;    
}

function bool IsValidActorType(Actor Actor)
{
    // End:0x0D
    if(Actor == self)
    {
        return false;
    }
    // End:0x1E
    if(Actor == Owner)
    {
        return false;
    }
    // End:0x30
    if(PlayerPawn(Actor) != none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event bool ShouldEffect(PrimitiveComponent primitive)
{
    // End:0x20
    if(!IsValidActorType(primitive.Owner))
    {
        return false;
    }
    // End:0x35
    if(m_primitivesTouched.Find(primitive) >= 0)
    {
        return false;
    }
    m_primitivesTouched.AddItem(primitive);
    return true;
    //return ReturnValue;    
}

function HandleSpecialDamage(Actor Victim)
{
    //return;    
}

event bool CanDamage(Actor Actor)
{
    // End:0x16
    if(!IsValidActorType(Actor))
    {
        return false;
    }
    // End:0x2B
    if(m_actorsDamaged.Find(Actor) >= 0)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool ApplyImpulseEvent(Actor Victim, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage = true)
{
    local SPPawn SPPawn;
    local float normalizedStrength, Dist;
    local bool bCausedDamage;

    bCausedDamage = false;
    // End:0x1C4
    if(((!Victim.bWorldGeometry && Victim != self) && Victim != IgnoredActor) && Victim.bProjTarget || NavigationPoint(Victim) == none)
    {
        SPPawn = SPPawn(Victim);
        // End:0xDB
        if(SPPawn != none)
        {
            Dist = VSize(SPPawn.Location - Location);
            normalizedStrength = 1.0000000 - (Dist / m_damageRadius);
        }
        // End:0x196
        if(CanDamage(Victim))
        {
            Victim.TakeRadiusDamage(InstigatedByController, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, Owner);
            HandleSpecialDamage(Victim);
            bCausedDamage = bCausedDamage || Victim.bProjTarget;
            m_actorsDamaged.AddItem(Victim);
            // End:0x196
            if(SPPawn != none)
            {
                SPPawn.HitByDamagePulse(Location, normalizedStrength, DamageType);
            }
        }
        // End:0x1C4
        if(SPPawn != none)
        {
            SPPawn.IsInsideDamagePulse(Location, normalizedStrength, DamageType);
        }
    }
    return bCausedDamage;
    //return ReturnValue;    
}

simulated function bool HurtRadiusPreviouslyUnDamaged(float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage = true)
{
    local Actor Victim;
    local SPNariPawnPersistent Victim2;
    local bool bCausedDamage1, bCausedDamage2;

    // End:0x32
    if(bHurtEntry)
    {
        return false;
    }
    bHurtEntry = true;
    bCausedDamage1 = false;
    bCausedDamage2 = false;
    // End:0xA5
    foreach VisibleCollidingActors(Class'Engine.Actor', Victim, DamageRadius, HurtOrigin)
    {
        bCausedDamage1 = ApplyImpulseEvent(Victim, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, IgnoredActor, InstigatedByController, bDoFullDamage);        
    }    
    // End:0x100
    foreach VisibleActors(Class'SPNariPawnPersistent', Victim2, DamageRadius, HurtOrigin)
    {
        bCausedDamage2 = ApplyImpulseEvent(Victim2, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, IgnoredActor, InstigatedByController, bDoFullDamage);        
    }    
    bHurtEntry = false;
    return bCausedDamage1 || bCausedDamage2;
    //return ReturnValue;    
}

function bool Expand(float DeltaTime)
{
    local float NewRadius;

    NewRadius = m_currentRadius + (DeltaTime * m_expansionRate);
    // End:0x38
    if(NewRadius >= m_damageRadius)
    {
        m_currentRadius = m_damageRadius;
        return false;        
    }
    else
    {
        m_currentRadius = NewRadius;
        return true;
    }
    //return ReturnValue;    
}

function DoImpulse()
{
    m_ImpulseComponent.ImpulseRadius = m_currentRadius;
    m_ImpulseComponent.FireImpulse(Location);
    //return;    
}

function DoDamage()
{
    local Controller Controller;
    local Pawn Pawn;

    // End:0x1E
    if(Owner != none)
    {
        Pawn = Pawn(Owner);        
    }
    else
    {
        Pawn = none;
    }
    // End:0x48
    if(Pawn != none)
    {
        Controller = Pawn.Controller;        
    }
    else
    {
        Controller = none;
    }
    HurtRadiusPreviouslyUnDamaged(float(m_damage), m_currentRadius, m_damageType, m_expansionRate, Location, Owner, Controller, m_bDoFullDamage);
    //return;    
}

function DoEffect()
{
    //return;    
}

function bool ReadyToDie()
{
    return false;
    //return ReturnValue;    
}

auto state Waiting
{
    simulated function OnToggle(SeqAct_Toggle Action)
    {
        // End:0x0B
        if(m_selfStart)
        {
            return;
        }
        // End:0x38
        if(Action.InputLinks[0].bHasImpulse)
        {
            StartDamage();            
        }
        else
        {
            // End:0x5B
            if(Action.InputLinks[1].bHasImpulse)
            {                
            }
            else
            {
                // End:0x86
                if(Action.InputLinks[2].bHasImpulse)
                {
                    StartDamage();
                }
            }
        }
        //return;        
    }

    function StartDamage()
    {
        GotoState('Active');
        //return;        
    }
Begin:

    // End:0x36
    if(m_selfStart)
    {
        // End:0x2C
        if(m_delay > float(0))
        {
            SetTimer(m_delay, false, 'StartDamage');            
        }
        else
        {
            StartDamage();
        }
    }
    stop;        
}

state Active
{
    function BeginState(name PreviousStateName)
    {
        m_primitivesTouched.Length = 0;
        m_actorsDamaged.Length = 0;
        m_currentRadius = 0.0000000;
        m_activeTime = 0.0000000;
        // End:0x3E
        if(m_expansionRate <= float(0))
        {
            m_expansionRate = 1000000.0000000;
        }
        m_bActive = true;
        m_currentRadius = m_startRadius;
        PulseContinue(0.0000000);
        //return;        
    }

    function PulseContinue(float DeltaTime)
    {
        // End:0x49
        if(m_bActive)
        {
            m_activeTime += DeltaTime;
            m_bActive = Expand(DeltaTime);
            DoDamage();
            DoImpulse();
            DoEffect();
        }
        //return;        
    }

    function Tick(float DeltaTime)
    {
        super(Actor).Tick(DeltaTime);
        PulseContinue(DeltaTime);
        //return;        
    }
    J0x00:
    // End:0x14 [Loop If]
    if(m_bActive)
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    GotoState('Finished');
    stop;        
}

state Finished
{
    function bool ReadyToDie()
    {
        return true;
        //return ReturnValue;        
    }
Begin:

    DoImpulse();
    Sleep(0.0100000);
    DoImpulse();
    m_currentRadius = m_startRadius;
    m_bActive = false;
    // End:0x58
    if(m_selfDestruct)
    {
        J0x38:

        // End:0x52 [Loop If]
        if(!ReadyToDie())
        {
            Sleep(0.0100000);
            // [Loop Continue]
            goto J0x38;
        }
        Destroy();        
    }
    else
    {
        GotoState('Waiting');
    }
    stop;        
}
