class R6BreakableCarConstrainedPart extends R6SpawnableKActor
    native
    placeable
    hidecategories(lighting);

var R6BreakableCar m_pCar;
var RB_ConstraintActor m_pConstraint;

defaultproperties
{
    bBlockActors=false
}