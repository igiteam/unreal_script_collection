class OLAnimPeeking extends AnimNodeBlendBase
	native(Anim);                                         

var transient int ActiveChildIdx;
var transient float CurrentRatio;
var transient float TargetRatio;

var() array<quat> CornerToHandQuats;
var() array<vector> CornerToHandVecs;

cpptext
{
	void StartPeeking(FLOAT initialRatio);
	void SetPeekingType(UBOOL bFromLeft, UBOOL bRounded);
	void GetHandEffectorMtx(FMatrix& out_HandMtx, const FMatrix& cornerMtx, UBOOL bFromLeft, UBOOL bRounded);
	virtual void TickAnim(FLOAT deltaTime);

private:
	enum { IdxLeftHard = 0, IdxLeftSoft = 1, IdxRightHard = 2, IdxRightSoft = 3 };
}

defaultproperties
{
	CategoryDesc="Outlast"

	bFixNumChildren=TRUE
	Children(0)=(Name="FromLeft_Hard")
	Children(1)=(Name="FromLeft_Soft")
	Children(2)=(Name="FromRight_Hard")	
	Children(3)=(Name="FromRight_Soft")

	CornerToHandQuats(0)=(X=-0.218, Y=0.116, Z=-0.684, W=-0.687)
	CornerToHandQuats(1)=(X=0.048, Y=-0.107, Z=0.575, W=0.809)
	CornerToHandQuats(2)=(X=-0.513, Y=0.423, Z=-0.510, W=-0.545)
	CornerToHandQuats(3)=(X=0.619, Y=-0.329, Z=0.603, W=0.381)
	CornerToHandVecs(0)=(X=-2.512, Y=-11.611, Z=149.887)
	CornerToHandVecs(1)=(X=-2.748, Y=-11.803, Z=148.909)
	CornerToHandVecs(2)=(X=-2.511, Y=4.494, Z=143.751)
	CornerToHandVecs(3)=(X=0.105, Y=2.272, Z=144.572)
}

