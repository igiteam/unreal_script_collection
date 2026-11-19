class R6CableLink extends R6InteractiveActor
    native
    config(Game)
    editinlinenew
    placeable
    hidecategories(lighting,Object);

var array<R6SBActorCable> m_Cables;
var Vector sm_vLocation;
var Rotator sm_rRotation;

function PostBeginPlay()
{
    PostBeginPlay();
    ClearTimer('Timer');
    return;
}

function SaveOriginalData()
{
    sm_vLocation = Location;
    sm_rRotation = Rotation;
    SaveOriginalData();
    return;
}

function ResetOriginalData()
{
    GoPhysics(false);
    SetLocation(sm_vLocation);
    SetRotation(sm_rRotation);
    ResetOriginalData();
    return;
}

defaultproperties
{
    m_bCanBeUsed=false
    m_fRadius=0.0000000
    bStatic=true
    bAlwaysRelevant=false
    TickGroup=1
}