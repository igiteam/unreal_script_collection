class RB_ConstraintActor extends Actor
    abstract
    native
    placeable
    hidecategories(lighting);

var() Actor ConstraintActor1;
var() Actor ConstraintActor2;
var() noclear export editinline RB_ConstraintSetup ConstraintSetup;
var() noclear export editinline RB_ConstraintInstance ConstraintInstance;
var() const bool bDisableCollision;
var() bool bUpdateActor1RefFrame;
var() bool bUpdateActor2RefFrame;
var(Pulley) edfindable Actor PulleyPivotActor1;
var(Pulley) edfindable Actor PulleyPivotActor2;

// Export URB_ConstraintActor::execSetDisableCollision(FFrame&, void* const)
native final function SetDisableCollision(bool NewDisableCollision);

// Export URB_ConstraintActor::execInitConstraint(FFrame&, void* const)
native final function InitConstraint(Actor Actor1, Actor Actor2, name Actor1Bone, name Actor2Bone, float BreakThreshold);

defaultproperties
{
    // Reference: RB_ConstraintInstance'Default__RB_ConstraintActor.MyConstraintInstance'
    begin object name="MyConstraintInstance" class=Class'RB_ConstraintInstance'
    end object
    ConstraintInstance=MyConstraintInstance
    bUpdateActor1RefFrame=true
    bUpdateActor2RefFrame=true
    bHidden=true
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__RB_ConstraintActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: RB_ConstraintDrawComponent'Default__RB_ConstraintActor.MyConDrawComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MyConDrawComponent" class=Class'RB_ConstraintDrawComponent'
    end object
    Components[1]=MyConDrawComponent
    Physics=10
    DrawScale=0.5000000
    SupportedEvents[0]=Class'SeqEvent_Touch'
    SupportedEvents[1]=Class'SeqEvent_Destroyed'
    SupportedEvents[2]=Class'SeqEvent_TakeDamage'
    SupportedEvents[3]=Class'SeqEvent_R6LookedAt'
    SupportedEvents[4]=Class'SeqEvent_ConstraintBroken'
}