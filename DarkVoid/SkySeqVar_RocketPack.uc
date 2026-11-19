class SkySeqVar_RocketPack extends SeqVar_Object
    native;

var Object RocketPack;

// Export USkySeqVar_RocketPack::execUpdateRPRef(FFrame&, void* const)
native function UpdateRPRef();

event Object GetObjectValue()
{
    UpdateRPRef();
    return RocketPack;
    //return ReturnValue;    
}
