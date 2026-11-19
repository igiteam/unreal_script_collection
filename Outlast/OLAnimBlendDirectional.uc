class OLAnimBlendDirectional extends AnimNodeBlendBase
	native(Anim);

/** Scale up the playrates of child sequences for diagonals (so that e.g. 50%/50% fwd/right blends plays with an effective speed of 71%/71%) */
var() bool bTimescaleDiagonals;

/** Slow down the child sequences if the pawn speed is slower than expected */
var() bool bTimescaleBelowExpectedSpeed;

/** Speed up the child sequences if the pawn speed is faster than expected */
var() bool bTimescaleAboveExpectedSpeed;

/** Speed below which we can timescale the clips */
var() float ExpectedPawnSpeed;

/** Below this speed %, blend in the idle */
var() float BlendInIdleMaxSpeedPct; 

/** When going backwards, blend the reverse of the opposite side direction (i.e. instead of 50/50 back/left, play 50% back and 50% reverse right) */
var() bool bUseReversedSideForBackwards;

/** In degrees. Between -PI and PI. 0.0 is running the way we are looking. */
var float SliderDirAngle;

var transient bool bReversingBackward;

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
	
	virtual INT GetNumSliders() const { return 1; }
	virtual FLOAT GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual FString GetSliderDrawValue(INT SliderIndex);

	/** Workaround because OnBecomeRelevant/bJustBecameRelevant can be called a frame late, with idle weight */
	void SetFullForwardWeight();

private:
	enum 
	{ 
		IdxForward			= 0, 
		IdxBackward			= 1, 
		IdxLeft				= 2, 
		IdxRight				= 3, 
		IdxIdle				= 4,  
		IdxReverseLeft		= 5,
		IdxReverseRight	= 6,
	};
}

defaultproperties
{	
	BlendInIdleMaxSpeedPct=0.2
	ExpectedPawnSpeed=200.0

	CategoryDesc = "Outlast"
	Children(0)=(Name="Forward",Weight=1.0)
	Children(1)=(Name="Backward")
	Children(2)=(Name="Left")
	Children(3)=(Name="Right")
	Children(4)=(Name="Idle")
	Children(5)=(Name="Reverse Left")
	Children(6)=(Name="Reverse Right")
	bFixNumChildren=true
}
