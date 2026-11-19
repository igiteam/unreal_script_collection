class SeqAct_FinishEnemies extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    ObjName="Finish Enemies Mode"
}