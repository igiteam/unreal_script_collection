class SkySeqAct_SetVelocity extends SequenceAction;

var() Vector NewVelocity;

event Activated()
{
    local Actor A;

    A = Actor(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0x53
    if(A != none)
    {
        A.Velocity = NewVelocity;
    }
    //return;    
}
