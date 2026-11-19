class SeqAct_CauseDamage extends SequenceAction
    native
    hidecategories(Object);

var() class<DamageType> DamageType;
var() float Momentum;
var() Rotator rMomentumDir;
var() bool bUseActorRotation;
var() float DamageAmount;
var Actor Instigator;

defaultproperties
{
    Momentum=500.0000000
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Amount",LinkVar="None",PropertyName="DamageAmount",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Cause Damage"
    ObjCategory="Actor"
}