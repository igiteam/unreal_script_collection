class FHseqact_SetPostProcess extends sequenceaction;

var ()	postprocesschain ppasset;
var LocalPlayer FHPlayer;

event activated()
{	
	FHPlayer = LocalPlayer(FHPlayerController(Targets[0]).Player);
	FHPlayer.RemoveAllPostProcessingChains();
	FHPlayer.InsertPostProcessingChain(ppasset, INDEX_NONE, true);
}


// Decompiled with UE Explorer.
defaultproperties
{
    ObjName="Assign Post Process"
    ObjCategory="Forever Hunted"
}