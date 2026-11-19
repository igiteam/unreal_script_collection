class SkySeqAct_SetGangInfo extends SequenceAction;

var() name GangName;

event Activated()
{
    local Actor Target;
    local SeqVar_Object ObjVar;

    // End:0xB6
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Gang Member")
    {
        Target = Actor(ObjVar.GetObjectValue());
        // End:0xB5
        if(Target != none)
        {
            // End:0x74
            if(Controller(Target) != none)
            {
                Target = Controller(Target).Pawn;
            }
            // End:0xA0
            if((Pawn(Target) != none) && Pawn(Target).Controller != none)
            {
            }
            Target.GangName = GangName;
        }        
    }    
    super(SequenceOp).Activated();
    //return;    
}
