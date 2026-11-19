class CCChannelOutputStim extends CCChannel
    native
    editinlinenew
    hidecategories(Object,Object);

var(OutputStimChannel) export editinline array<export editinline CCKeyOutputStim> keys;

// Export UCCChannelOutputStim::execIsEmpty(FFrame&, void* const)
native function bool IsEmpty();

function bool GetKeys(out array<CCKey> OutKeys, out float OutChannelDuration_sec)
{
    // End:0x1C
    if(!bKeysValidated)
    {
        ChannelDuration_sec = ValidateKeys(keys);
    }
    OutKeys = keys;
    OutChannelDuration_sec = ChannelDuration_sec;
    return true;
    //return ReturnValue;    
}
