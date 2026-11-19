class SkySeqAct_TuneSkyObjectPool extends SequenceAction;

var() Actor NewPoolTemplate;

event Activated()
{
    local SkyGameReplicationInfo GRI;

    GRI = SkyGameReplicationInfo(GetWorldInfo().GRI);
    // End:0x10C
    if(GRI != none)
    {
        // End:0x77
        if(GRI.SOP != none)
        {
            // End:0x60
            if(GRI.SOP.ObjectArchetype == NewPoolTemplate)
            {
                return;
            }
            GRI.SOP.Destroy();
        }
        // End:0xD8
        if(NewPoolTemplate == none)
        {
            // End:0xD5
            if(GRI.SkyPoolTemplate != none)
            {
                GRI.SOP = GetWorldInfo().Spawn(Class'SkyObjectPool', GRI,,,, GRI.SkyPoolTemplate);
            }            
        }
        else
        {
            GRI.SOP = GetWorldInfo().Spawn(Class'SkyObjectPool', GRI,,,, NewPoolTemplate);
        }
    }
    //return;    
}
