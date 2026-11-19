class SeqAct_AdvAIFactory extends SeqAct_AIFactory
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

var(AIFactory) AdvTypes.EAITypes AdvAIType;

static event int GetObjClassVersion()
{
    return super.GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    CharacterClothArray=/* Array type was not detected. */
    SpawnInfo=/* Array type was not detected. */
    ObjName="AdvAI Factory"
}