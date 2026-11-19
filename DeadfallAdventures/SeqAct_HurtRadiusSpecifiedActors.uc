class SeqAct_HurtRadiusSpecifiedActors extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor Locator;
var() float Radius;
var() float Momentum;
var() class<EvilDmgType_Base> dmgType;
var() int DamageAmount;

event Activated()
{
    local SeqVar_Object ObjVar;
    local Actor A;

    // End:0xD0
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
    {
        A = Actor(ObjVar.GetObjectValue());
        // End:0xCF
        if(A != none)
        {
            A.TakeRadiusDamage(none, float(DamageAmount), Radius, dmgType, Momentum, Locator.Location, false, none);
        }        
    }    
    //return;    
}

defaultproperties
{
    bCallHandler=false
    ObjName="Hurt Radius Specified Actors"
}