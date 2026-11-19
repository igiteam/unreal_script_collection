class SkySeqAct_SetTargetableActor extends SequenceAction;

var() bool bAddToList;

event Activated()
{
    local Actor Target;
    local SeqVar_Object ObjVar;
    local int I;
    local bool bFound;

    // End:0x191
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
    {
        Target = Actor(ObjVar.GetObjectValue());
        // End:0x5C
        if((Pawn(Target) != none) || Controller(Target) != none)
        {
        }
        // End:0x190
        if(Target != none)
        {
            // End:0x10C
            if(bAddToList)
            {
                I = 0;
                J0x77:

                // End:0xDB [Loop If]
                if(I < GetWorldInfo().Game.TargetableActors.Length)
                {
                    // End:0xD1
                    if(GetWorldInfo().Game.TargetableActors[I] == Target)
                    {
                        bFound = true;
                        // [Explicit Break]
                        goto J0xDB;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x77;
                }
                J0xDB:

                // End:0x109
                if(bFound == false)
                {
                    GetWorldInfo().Game.TargetableActors.AddItem(Target);
                }
                // End:0x190
                continue;
            }
            I = 0;
            J0x113:

            // End:0x190 [Loop If]
            if(I < GetWorldInfo().Game.TargetableActors.Length)
            {
                // End:0x186
                if(GetWorldInfo().Game.TargetableActors[I] == Target)
                {
                    GetWorldInfo().Game.TargetableActors.Remove(I, 1);
                    // End:0x190
                    continue;
                }
                I++;
                // [Loop Continue]
                goto J0x113;
            }
        }        
    }    
    //return;    
}
