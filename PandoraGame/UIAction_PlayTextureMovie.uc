class UIAction_PlayTextureMovie extends SeqAct_Latent
    native;

var transient float MovieDuration;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}
