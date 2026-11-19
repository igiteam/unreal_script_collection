class EvilComboEvent_Base extends Object
    abstract
    editinlinenew
    hidecategories(Object)
    classgroup(Combos)
    autoexpandcategories(Event);

var name EventID;
var(Event) float TimeOut;
var(Event) bool bOrNextOne;
var(Event) name StepName;

function bool check(name EventType, EvilPawn Instigator, EvilPawn Other, EvilPawn FirstOther, Vector Location, class<DamageType> dmgType, EvilTypes.EBodyParts BodyPart, bool directHit)
{
    return (EventType == EventID) && Other.IsAliveAndWell();
    //return ReturnValue;    
}

defaultproperties
{
    TimeOut=2.0000000
}