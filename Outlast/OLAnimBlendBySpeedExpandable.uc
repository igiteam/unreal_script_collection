class OLAnimBlendBySpeedExpandable extends AnimNodeBlendBase
	native(Anim);  

/** speeds that each animation was animated at, should match the input animations */
var() editfixedsize array<float> AnimSpeeds;

/** Should we adjust the playrate if going slower than first child? (only works for direct AnimNodeSequence child) */
var() bool bTimeScaleDown;

/** Should we adjust the playrate if going faster than last child? (only works for direct AnimNodeSequence child) */
var() bool bTimeScaleUp;

var() float SmoothingCoefficient;

var transient float CurrentSpeed;

/** slider position, for animtree editor */
var const	float	SliderPosition;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	virtual void InitAnim( USkeletalMeshComponent* meshComp, UAnimNodeBlendBase* Parent );
	virtual void ResetAnimNodeToSource(UAnimNode *SourceNode);
	virtual void TickAnim(FLOAT deltaTime);

	virtual void OnBecomeRelevant();
	
	// AnimTree editor interface
	virtual INT GetNumSliders() const { return 1; }
	virtual FLOAT GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual FString GetSliderDrawValue(INT SliderIndex);

	// AnimNodeBlendBase interface
	virtual void OnAddChild(INT ChildNum);
	virtual void OnRemoveChild(INT ChildNum);

private:
	void SetWeightsFromSpeed(FLOAT Speed);
}

defaultproperties
{
	SmoothingCoefficient=0.9999f

	Children(0)=(Name="Child1")
	bFixNumChildren=FALSE

	AnimSpeeds(0)=125.0f

	CategoryDesc = "Outlast"
}
