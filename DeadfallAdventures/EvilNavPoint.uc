class EvilNavPoint extends Actor
    placeable
    hidecategories(Navigation,Object)
    implements(EvilNavPointInterface);

struct NavPointAction
{
    var() export editinline EvilNavPointAction Action;
    var() float Chance;

    structdefaultproperties
    {
        Action=none
        Chance=1.0000000
    }
};

var() array<NavPointAction> NavPointActions;
var() EvilTypesNative.EMoveMode MoveMode;
var() EvilNavPoint NextNavPoint;
var() bool bCanSlowDown;
var() bool bPreciseDestination;
var() const editconst export editinline EvilCoverRadiusComponent CoverRadiusComponent;

function array<EvilNavPointAction> GetNavPointActions()
{
    local array<EvilNavPointAction> NavActs;
    local NavPointAction NavAct;

    // End:0x64
    foreach NavPointActions(NavAct)
    {
        // End:0x63
        if(FRand() < NavAct.Chance)
        {
            NavActs.AddItem(NavAct.Action);            
        }        
    }    
    return NavActs;
    //return ReturnValue;    
}

function EvilTypes.ENavPointMoveToGoalMode GetMoveToGoalMode()
{
    return 0;
    //return ReturnValue;    
}

function EvilTypesNative.EMoveMode GetMoveMode()
{
    return MoveMode;
    //return ReturnValue;    
}

function float GetCoverRadius()
{
    return CoverRadiusComponent.CoverRadius;
    //return ReturnValue;    
}

function bool UsePreciseDestination()
{
    return bPreciseDestination;
    //return ReturnValue;    
}

defaultproperties
{
    MoveMode=EMoveMode.None
    bCanSlowDown=true
    // Reference: EvilCoverRadiusComponent'Default__EvilNavPoint.CoverRadiusComponent0'
    begin object name=CoverRadiusComponent0 class=Class'EvilCoverRadiusComponent'
        ReplacementPrimitive=none
    end object
    CoverRadiusComponent=CoverRadiusComponent0
    // Reference: CylinderComponent'Default__EvilNavPoint.CollisionCylinder'
    begin object name=CollisionCylinder class=Class'Engine.CylinderComponent'
        CollisionHeight=50.0000000
        CollisionRadius=50.0000000
        ReplacementPrimitive=none
    end object
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=none
    Components[3]=none
    Components[4]=CoverRadiusComponent0
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    bStatic=true
    bNoDelete=true
    bCollideWhenPlacing=true
    bForceAllowKismetModification=true
    CollisionComponent=CollisionCylinder
}