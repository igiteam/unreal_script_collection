class SkySeqAct_FireExternalEventToBehTree extends SequenceAction;

var() string EventName;

event Activated()
{
    local SeqVar_Object ObjVar;
    local Pawn P;
    local SkyBot SBC;
    local array<SkyBot> BotArray;
    local int Idx;

    // End:0xA2
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
    {
        SBC = SkyBot(ObjVar.GetObjectValue());
        // End:0x89
        if(SBC == none)
        {
            P = Pawn(ObjVar.GetObjectValue());
            // End:0x89
            if(P != none)
            {
                SBC = SkyBot(P.Controller);
            }
        }
        // End:0xA1
        if(SBC != none)
        {
            BotArray.AddItem(SBC);
        }        
    }    
    // End:0xDC
    if(BotArray.Length <= 0)
    {
        // End:0xDB
        foreach GetWorldInfo().AllControllers(Class'SkyBot', SBC)
        {
            BotArray.AddItem(SBC);            
        }        
    }
    Idx = 0;
    J0xE3:

    // End:0x12E [Loop If]
    if(Idx < BotArray.Length)
    {
        SBC = BotArray[Idx];
        // End:0x124
        if(SBC != none)
        {
            SBC.FireExternalEvent(EventName);
        }
        ++Idx;
        // [Loop Continue]
        goto J0xE3;
    }
    //return;    
}
