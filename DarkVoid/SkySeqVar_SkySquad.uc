class SkySeqVar_SkySquad extends SeqVar_Object
    native;

var Object Squad;
var() name SquadName;

// Export USkySeqVar_SkySquad::execUpdateSquadRef(FFrame&, void* const)
native function UpdateSquadRef();

event Object GetObjectValue()
{
    UpdateSquadRef();
    return Squad;
    //return ReturnValue;    
}
