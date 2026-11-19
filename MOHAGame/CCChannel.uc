class CCChannel extends Object
    native
    editinlinenew
    hidecategories(Object);

var transient bool bKeysValidated;
var transient float ChannelDuration_sec;

// Export UCCChannel::execIsEmpty(FFrame&, void* const)
native function bool IsEmpty();

// Export UCCChannel::execValidateKeys(FFrame&, void* const)
native final function float ValidateKeys(array<CCKey> keys);

function DumpKeys(array<CCKey> keys)
{
    local int KeyIndex;

    KeyIndex = 0;
    J0x07:

    // End:0x35 [Loop If]
    if(KeyIndex < keys.Length)
    {
        // End:0x2B
        if(none != keys[KeyIndex])
        {
            // [Explicit Continue]
        }
        ++KeyIndex;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function bool GetKeys(out array<CCKey> OutKeys, out float OutChannelDuration_sec)
{
    return false;
    //return ReturnValue;    
}
