class R6BreakableCar extends R6BreakableActor
    native
    notplaceable
    hidecategories(Material);

var RB_ConstraintActor m_apWheelConstraint[4];
var R6BreakableCarConstrainedPart m_apWheel[4];
var float m_afWheelHP[4];
var RB_ConstraintActor m_apDoorConstraint[4];
var R6BreakableCarConstrainedPart m_apDoor[4];
var float m_afDoorHP[4];
var float m_fChassisHP;
var bool m_bAddDestroyChassisSpeed;
var bool m_bIsChassis;
var bool m_bIsCarDoor;
var R6BreakableCar m_pChassisParent;
var float m_fLastTimeCarImpactSoundTriggered;
var float m_fLastTimeShockAbsorberSoundTriggered;
var RB_ConstraintActor m_pLocationConstraint;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_afWheelHP, m_apWheel, 
        m_bAddDestroyChassisSpeed, m_bIsChassis, 
        m_pChassisParent;
}

// Export UR6BreakableCar::execPartTakeDamage(FFrame&, void* const)
native final function PartTakeDamage(R6BreakableCarConstrainedPart pPart, int Damage, Controller pInstigatedBy, Class pDamageType);

// Export UR6BreakableCar::execCarTakeDamage(FFrame&, void* const)
native final function bool CarTakeDamage(int iDamage, PrimitiveComponent pHitComponent, Vector vMomentum, float fDamageImpulse, Controller pInstigatedBy, Class pDamageType);
