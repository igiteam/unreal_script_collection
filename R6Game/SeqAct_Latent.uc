class SeqAct_Latent extends SequenceAction
    abstract
    native
    hidecategories(Object);

var array<Actor> LatentActors;
var bool bAborted;

// Export USeqAct_Latent::execAbortFor(FFrame&, void* const)
native function AbortFor(Actor latentActor);

defaultproperties
{
    bLatentExecution=true
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Undefined Latent"
    ObjColor=(R=128,G=128,B=0,A=255)
}