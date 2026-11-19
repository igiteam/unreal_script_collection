
class OLAnimLocomotion extends AnimNodeBlendBase
	native(Anim);

var() float MinMovingContribUnder90;
var() float MinMovingContribOver90;
var() float BlendTimePct;

var transient int ActiveChildIdx;
var transient float TransitionBlendTime;
var transient bool bIsTurning;
var transient bool bReachedHalfTurn;
var transient bool bMoveOnNextFrame;

var const float SliderPosition;

cpptext
{
	virtual void OnBecomeRelevant();
	virtual void TickAnim(FLOAT deltaTime);


	virtual INT GetNumSliders() const { return 1; }
	virtual FLOAT GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual FString GetSliderDrawValue(INT SliderIndex);

	UBOOL IsIdle() const { return ActiveChildIdx == IdxIdle; }
	UBOOL IsStarting() const { return ActiveChildIdx == IdxStart; }
	UBOOL IsStopping() const { return ActiveChildIdx == IdxStop; }
	UBOOL IsTurning() const { return bIsTurning; }

private:
	enum 
	{ 
		IdxIdle		= 0, 
		IdxMoving	= 1, 
		IdxStart		= 2, 
		IdxStop		= 3, 
		IdxLeft90	= 4, 
		IdxRight90	= 5,  
		IdxLeft180	= 6, 
		IdxRight180 = 7,  
	};

	void ResetAllSynchGroups();
};

defaultproperties
{
	NodeName="Locomotion"
	CategoryDesc="Outlast"

	bFixNumChildren=true
	Children(0)=(Name="Idle")
	Children(1)=(Name="Moving")
	Children(2)=(Name="Start")
	Children(3)=(Name="Stop")
	Children(4)=(Name="TurnLeft90")
	Children(5)=(Name="TurnRight90")
	Children(6)=(Name="TurnLeft180")
	Children(7)=(Name="TurnRight180")

	MinMovingContribUnder90=0.35f
	MinMovingContribOver90=0.35f
	BlendTimePct=0.35f
}
