class SkySeqEvent_FlagEvent extends SequenceEvent;

function Trigger(name EventType, Controller EventInstigator)
{
    local array<int> ActivateIndices;
    local int I;
    local SeqVar_Object ObjVar;

    I = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(I < OutputLinks.Length)
    {
        // End:0x4B
        if(EventType == name(OutputLinks[I].LinkDesc))
        {
            ActivateIndices[ActivateIndices.Length] = I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xBF
    if(ActivateIndices.Length == 0)
    {
        ScriptLog(((("Not activating" @ string(self)) @ "for event") @ string(EventType)) @ "because there are no matching outputs");        
    }
    else
    {
        // End:0x113
        if(CheckActivate(Originator, EventInstigator, false, ActivateIndices))
        {
            // End:0x112
            foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
            {
                ObjVar.SetObjectValue(EventInstigator);                
            }            
        }
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return 2;
    //return ReturnValue;    
}
