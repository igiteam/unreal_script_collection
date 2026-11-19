class PhysicsAssetInstance extends Object
    native
    noexport
    hidecategories(Object);

var const transient Actor Owner;
var const transient int RootBodyIndex;
var const export editinline array<export editinline RB_BodyInstance> Bodies;
var const export editinline array<export editinline RB_ConstraintInstance> Constraints;
var native const Map_Mirror CollisionDisableTable;
