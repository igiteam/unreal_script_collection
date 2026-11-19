class SeqAct_SpPlayFaceFXAnimNotify extends SeqAct_Latent
    native;

/** Reference to FaceFX AnimSet package the animation is in */
var() FaceFXAnimSet FaceFXAnimSetRef;
/** Name of group within the FaceFXAsset to find the animation in. Case sensitive. */
var() string FaceFXGroupName;
/** Name of FaceFX animation within the specified group to play. Case sensitive. */
var() string FaceFXAnimName;

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}
