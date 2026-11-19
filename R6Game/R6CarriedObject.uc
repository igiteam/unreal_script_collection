class R6CarriedObject extends CarriedObject
    abstract
    native
    hidecategories(lighting);

var export editinline StaticMeshComponent m_pObjectMesh;
var R6Pawn m_pCarrier;
var float m_fMaxDropTime;
var const localized string m_szItemName;
var Vector m_vInitialLocation;
var Rotator m_vInitialRotation;
var bool m_bHidden;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bHidden;
}

// Export UR6CarriedObject::execDrop(FFrame&, void* const)
native function Drop(optional Vector vVelocity);

// Export UR6CarriedObject::execRespawn(FFrame&, void* const)
native function Respawn();

// Export UR6CarriedObject::execIsValidCarrier(FFrame&, void* const)
native function bool IsValidCarrier(Actor pCarrier);

// Export UR6CarriedObject::execSetCarrier(FFrame&, void* const)
native function SetCarrier(R6Pawn pCarrier);

// Export UR6CarriedObject::execAttachToCarrier(FFrame&, void* const)
native function AttachToCarrier();

// Export UR6CarriedObject::execDetachFromCarrier(FFrame&, void* const)
native function DetachFromCarrier(bool bDropped);

// Export UR6CarriedObject::execGetAttachmentSocketName(FFrame&, void* const)
native function name GetAttachmentSocketName();

// Export UR6CarriedObject::execSetObjectHidden(FFrame&, void* const)
native function SetObjectHidden(bool bHidden);

function PostBeginPlay()
{
    PostBeginPlay();
    m_vInitialLocation = Location;
    m_vInitialRotation = Rotation;
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    m_pCarrier = none;
    SetObjectHidden(false);
    GotoState('s_Started');
    return;
}

event FellOutOfWorld(class<DamageType> dmgType)
{
    SetPhysics(0);
    return;
}

function CheckTouching()
{
    return;
}

auto state s_Started
{
    function BeginState(name PreviousStateName)
    {
        // End:0x15
        if(m_bShutdown)
        {
            GotoState('s_Inactive');
            return;
        }
        Disable('Touch');
        bCollideWorld = false;
        SetCollision(false, false);
        SetLocation(m_vInitialLocation);
        SetRotation(m_vInitialRotation);
        bCollideWorld = true;
        SetCollision(true, false);
        SetObjectHidden(false);
        Enable('Touch');
        CheckTouching();
        return;
    }

    function CheckTouching()
    {
        local Pawn P;

        // End:0x3A
        foreach TouchingActors(Class'Engine.Pawn', P)
        {
            Touch(P, none, Location, Normal(Location - P.Location));            
        }        
        return;
    }
    stop;
}

state s_Inactive
{    stop;
}

state s_Carried
{
    function BeginState(name PreviousStateName)
    {
        AttachToCarrier();
        // End:0x47
        if((m_pCarrier != none) && m_pCarrier.PlayerReplicationInfo != none)
        {
            R6PlayerReplicationInfo(m_pCarrier.PlayerReplicationInfo).SetCarriedObject(self);
        }
        // End:0x95
        if((WorldInfo.Game != none) && R6GameInfo(WorldInfo.Game) != none)
        {
            R6GameInfo(WorldInfo.Game).taken(self);
        }
        return;
    }

    function EndState(name NextStateName)
    {
        local bool bDropped;

        bDropped = NextStateName == 's_Dropped';
        // End:0x6D
        if(bDropped)
        {
            // End:0x6A
            if((WorldInfo.Game != none) && R6GameInfo(WorldInfo.Game) != none)
            {
                R6GameInfo(WorldInfo.Game).Dropped(self);
            }            
        }
        else
        {
            // End:0xCA
            if(NextStateName == 's_Started')
            {
                // End:0xCA
                if((WorldInfo.Game != none) && R6GameInfo(WorldInfo.Game) != none)
                {
                    R6GameInfo(WorldInfo.Game).Respawned(self);
                }
            }
        }
        // End:0x10A
        if((m_pCarrier != none) && m_pCarrier.PlayerReplicationInfo != none)
        {
            R6PlayerReplicationInfo(m_pCarrier.PlayerReplicationInfo).SetCarriedObject(none);
        }
        DetachFromCarrier(bDropped);
        return;
    }
    stop;
}

state s_Dropped
{
    function BeginState(name PreviousStateName)
    {
        SetPhysics(2);
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
        // End:0x39
        if(m_fMaxDropTime > 0.0000000)
        {
            SetTimer(m_fMaxDropTime, false);
        }
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x5D
        if(NextStateName == 's_Started')
        {
            // End:0x5D
            if((WorldInfo.Game != none) && R6GameInfo(WorldInfo.Game) != none)
            {
                R6GameInfo(WorldInfo.Game).Respawned(self);
            }
        }
        SetPhysics(0);
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
        return;
    }

    function Timer()
    {
        Respawn();
        return;
    }
    stop;
}

defaultproperties
{
    bNoDelete=true
    bAlwaysRelevant=true
    bUpdateSimulatedPosition=true
    bCollideActors=true
    bCollideWorld=true
    m_bDeleteOnReset=false
    // Reference: SpriteComponent'Default__R6CarriedObject.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__CarriedObject.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__R6CarriedObject.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=10.0000000
        CollisionRadius=10.0000000
        CollideActors=true
    end object
    Components[1]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}