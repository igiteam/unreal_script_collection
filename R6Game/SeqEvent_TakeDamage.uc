class SeqEvent_TakeDamage extends SequenceEvent
    native
    hidecategories(Object);

var() float MinDamageAmount;
var() float DamageThreshold;
var() array< class<DamageType> > DamageTypes;
var() array< class<DamageType> > IgnoreDamageTypes;
var() bool m_bResetTriggerCountOfDuplicatedEvents;
var float CurrentDamage;

// Export USeqEvent_TakeDamage::execIsValidDamageType(FFrame&, void* const)
native final function bool IsValidDamageType(class<DamageType> inDamageType);

// Export USeqEvent_TakeDamage::execHandleDamage(FFrame&, void* const)
native final function HandleDamage(Actor InOriginator, Actor InInstigator, class<DamageType> inDamageType, int inAmount);

defaultproperties
{
    DamageThreshold=1.0000000
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Damage Taken",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Take Damage"
    ObjCategory="Actor"
}