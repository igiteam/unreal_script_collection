class SeqAct_AddMOHAAffordanceAID extends SeqAct_AddAffordanceAIDBase
    hidecategories(Object);

var() ScriptedAID AddScriptedAID;

function AffordanceAIDComponentBase CreateAIDComponent()
{
    return new Class'MOHAAffordanceAIDComponent';
    //return ReturnValue;    
}

defaultproperties
{
    ObjName="Add Affordance AID"
    ObjCategory="MOHA CC/AID"
}