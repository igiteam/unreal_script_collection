class SeqAct_WaitForPlayer extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    ObjName="Wait For Player"
}