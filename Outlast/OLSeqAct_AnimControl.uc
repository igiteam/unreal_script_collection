
class OLSeqAct_AnimControl extends SeqAct_Latent
	native(Sequence);

struct native AnimParams
{
	var() name AnimName;
	var() bool bLooping;
	var() float BlendInTime;
	var() float BlendOutTime;

	structdefaultproperties
	{
		BlendInTime=0.25;
		BlendOutTime=0.25;
	}
};

var() name BaseAnimName;
var() array<AnimParams> ExtraAnims;
var name SlotName;
var name BaseAnimNodeName;

var transient int PlayingIdx; // Index in ExtraAnims, -1 if base is playing

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
	virtual void DeActivated() {}

	void StartBaseAnim(ASkeletalMeshActor* sma);
	void StartNewAnim(ASkeletalMeshActor* sma, const FAnimParams& params);

	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

private:
	void CheckAnimEnd();
}

defaultproperties
{
	ObjName="Anim Control"
	ObjCategory="Outlast - Gameplay"

	SlotName=AnimSlot
	BaseAnimNodeName=BaseAnim
	PlayingIdx=-1

	bCallHandler=false

	InputLinks(0)=(LinkDesc="Play Base")	
	OutputLinks.Empty
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="SkelMeshActor", PropertyName=None)
}
