class EvilPhysicsHelpers extends Object
    native(Physics);

// Export UEvilPhysicsHelpers::execSetRBCCDThreshold(FFrame&, void* const)
native static final function SetRBCCDThreshold(PrimitiveComponent Comp, float newCCDThreshold, optional name BoneName);
