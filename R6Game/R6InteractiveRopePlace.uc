class R6InteractiveRopePlace extends R6InteractiveActor
    native
    config(Game)
    placeable
    hidecategories(lighting);

const kRopePlace_PresetVolumes = 1;

struct AIInteractLoc
{
    var() float m_fRange;
    var() Vector m_vLocation;

    structdefaultproperties
    {
        m_fRange=0.0000000
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var(RopePlace) bool m_bSpawnRopeAtStart;
var(RopePlace) bool m_bNoFloorOnBottomRope;
var(RopePlace) bool m_bRappelToFastRope;
var(RopePlace) bool m_bNoSpin;
var(RopePlace) bool m_bPreferedForPlayer;
var(RopePlace) bool m_bTerroOnly;
var bool m_bChopperLike;
var bool m_bFastRope;
var(RopePlace) Vector m_vRopeAttach;
var(RopePlace) array<AIInteractLoc> m_aAIInteractLocations;
var(RopePlace) float m_fMaxLength;
var R6InteractiveRope m_pRope;
var array<R6InteractiveRopePlace> m_aGrouping;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_pRope, m_vRopeAttach;
}

// Export UR6InteractiveRopePlace::execPlantRope(FFrame&, void* const)
native final function bool PlantRope();

// Export UR6InteractiveRopePlace::execCanPlantRope(FFrame&, void* const)
native final function bool CanPlantRope();

// Export UR6InteractiveRopePlace::execInteractPlantingRope(FFrame&, void* const)
native final function InteractPlantingRope(Pawn pPawn);

event PostBeginPlay()
{
    PostBeginPlay();
    // End:0x42
    if(m_bSpawnRopeAtStart)
    {
        PlantRope();
        // End:0x3F
        if((m_pRope != none) && !m_bSpawned)
        {
            m_pRope.SetDeleteOnReset(false);
        }        
    }
    else
    {
        // End:0x88
        if(GetGameManager().IsMultiplayer())
        {
            m_pRope = __NFUN_278__(Class'R6InteractiveRope',,, Location, Rotation,, true);
            m_pRope.m_bFastRope = m_bFastRope;
        }
    }
    return;
}

simulated event SetDeleteOnReset(bool bVal)
{
    m_pRope.SetDeleteOnReset(bVal);
    SetDeleteOnReset(bVal);
    return;
}

function ResetOriginalData()
{
    // End:0x5B
    if(!m_bSpawnRopeAtStart)
    {
        // End:0x54
        if(GetGameManager().IsMultiplayer())
        {
            m_pRope = __NFUN_278__(Class'R6InteractiveRope',,, Location, Rotation,, true);
            m_pRope.m_bFastRope = m_bFastRope;            
        }
        else
        {
            m_pRope = none;
        }
    }
    ResetOriginalData();
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    InteractSuccesful(pInteractor);
    // End:0x43
    if((m_pRope != none) && m_pRope.m_bInitialized)
    {
        m_pRope.Interact(pInteractor);        
    }
    else
    {
        InteractPlantingRope(pInteractor);
    }
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    // End:0x0C
    if(m_bTerroOnly)
    {
        return false;
    }
    // End:0x20
    if(m_bFastRope)
    {
        eDesc = 15;        
    }
    else
    {
        eDesc = 25;
    }
    return true;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x29
    if(m_bTerroOnly || PC.Pawn.IsInTakeCover())
    {
        return false;
    }
    // End:0x80
    if((PC != none) && PC.Pawn != none)
    {
        // End:0x80
        if(Abs(PC.Pawn.Location.Z - Location.Z) > 200.0000000)
        {
            return false;
        }
    }
    return GetBusyInteractDesc(eDesc, PC);
    return;
}

defaultproperties
{
    m_vRopeAttach=(X=0.0000000,Y=0.0000000,Z=10.0000000)
    m_ActorName="Rope Place"
    m_bWalkAfterInteract=false
    m_bCanBeUsed=false
    m_bIgnoreForNavMesh=true
    // Reference: SpriteComponent'Default__R6InteractiveRopePlace.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerEditorMaterials.Rope_64'
        HiddenEditor=true
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__R6InteractiveRopePlace.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6InteractiveActor.InteractiveActorMesh'
    begin object name="InteractiveActorMesh"
    end object
    Components[1]=InteractiveActorMesh
    // Reference: CylinderComponent'Default__R6InteractiveRopePlace.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=48.0000000
        CollisionRadius=40.0000000
        CollideActors=true
        Translation=(X=-10.0000000,Y=0.0000000,Z=20.0000000)
    end object
    Components[2]=CollisionCylinder
    // Reference: ArrowComponent'Default__R6InteractiveRopePlace.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=100,B=150,A=255)
        ArrowSize=5.0000000
    end object
    Components[3]=Arrow
    m_eExplosionCollisionOverride=2
    TickGroup=1
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}