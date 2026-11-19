class OLWaitPointComponent extends ActorComponent
	native;

struct native WaitPoint
{
	/** Offset from the center of the object. */
	var() vector Offset;

	/** Forward direction in degrees from facing the door. */
	var() float ForwardYaw;

	var() bool bForReversed;

	var transient bool bIsValid;
	var transient vector Point;
	var transient bool bInUse;
};

var() array<WaitPoint> WaitPoints; // Sorted by bForReversed then by Distance from Destination.

var matrix LocalToWorld; // Used for Creating the points from the offsets.

var const vector StartOffset;
var const vector AdditionalOffset;

var const int NumWaitPointsPerSide;

var() const bool bOneSideOnly;
var() const bool bFlipOnYAxis;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	void SetLocalToWorld(const FMatrix& NewLocalToWorld);
	void GenerateWaitPoints(UBOOL InvertY);

	void ForceUpdateAllPoints();
	void UpdateWaitPoint(INT Idx, UBOOL bForce = FALSE);

	void DrawDebugPoints();
	void DrawDebugPointsEditor(FPrimitiveDrawInterface* PDI);
}

native function vector GetWaitPointForwardVector(WaitPoint Point);

native function WaitPoint GrabBestWaitPoint(bool bReversed);

native function ReturnWaitPoint(WaitPoint Point);

defaultproperties
{
	StartOffset=(X=110.0f,Y=60.0f,Z=0.0f)
	AdditionalOffset=(X=70.0f,Y=0.0f,Z=0.0f)

	NumWaitPointsPerSide=2
	bOneSideOnly=false
	bFlipOnYAxis=false
}