class SeqAct_HurtRadius extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor Locator;
var() float Radius;
var() float Momentum;
var() class<EvilDmgType_Base> dmgType;
var() int DamageAmount;

event Activated()
{
    Class'Engine.WorldInfo'.static.GetWorldInfo().HurtRadius(float(DamageAmount), Radius, dmgType, Momentum, Locator.Location, none, none, true);
    //return;    
}

defaultproperties
{
    ObjName="Hurt Radius"
}