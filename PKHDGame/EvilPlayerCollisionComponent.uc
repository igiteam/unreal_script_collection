class EvilPlayerCollisionComponent extends CylinderComponent
    native
    editinlinenew
    collapsecategories;

var const export editinline RB_BodySetup BodySetup;

defaultproperties
{
    // Reference: RB_BodySetup'Default__EvilPlayerCollisionComponent.BodySetup0'
    begin object name="BodySetup0" class=Class'Engine.RB_BodySetup'
        AggGeom=(SphylElems=/* Array type was not detected. */)
    end object
    BodySetup=BodySetup0
    CollisionHeight=50.0000000
    CollisionRadius=35.0000000
    ReplacementPrimitive=none
    RBChannel=ERBCollisionChannel.RBCC_Pawn
    CollideActors=true
    BlockActors=true
    BlockRigidBody=true
    RBCollideWithChannels=(Default=true,Pawn=true,GameplayPhysics=true,DeadPawn=true)
}