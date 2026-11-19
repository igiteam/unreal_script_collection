class SeqAct_ToggleSPHud extends SequenceAction;

/** Variable Declaration */
var() float FadeTime;

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 2;
    //return ReturnValue;    
}
