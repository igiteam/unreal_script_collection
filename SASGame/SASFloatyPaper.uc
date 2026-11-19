//=============================================================================
// SASDamageableMesh.uc
//
//=============================================================================

class SASFloatyPaper extends StaticMeshActor
native;

var vector mVel;
var float mVelMult;
var float mPitchVel,mRollVel ;
var(Floating) float mWeight;
var float mPitchDiv,mRollDiv,mYawAdd;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

event PostBeginPlay()
{	
	mVel.z = 0.5 + (FRand()*0.5);
	mVel.x = -0.15 + (FRand() * 0.3);
	mVel.y = -0.15 + (FRand() * 0.3);
	mVelMult = 1;
	
	mPitchDiv = 10 + (600*FRand());
	mRollDiv = 10 + (600*FRand());
	mYawAdd = 50 + (300*FRand());
	
	Super(Actor).PostBeginPlay();
}

function Tick(float DeltaTime)
{
	local vector tTempUp;
	local vector tTempMove1;
	local vector tTempMove2;
	local vector tTempCross;
	local vector tFinalMove;
	local Rotator tTempRot;
		
	tTempUp.x = 0;
	tTempUp.y = 0;
	tTempUp.z = -0.8;				
	
	tTempMove1 = tTempUp >> Rotation;	
	tTempMove2 = tTempMove1;
	
	tTempMove2.z = 0;
	
	tTempMove2 = Normal(tTempMove2);
	
	tTempCross = tTempMove1 cross tTempMove2;
	tTempMove2 = -(tTempMove1 cross tTempCross);

	if (tTempMove2.z >0)
		tTempMove2 = -tTempMove2;
			
	tTempMove2.z *= (Abs(tTempMove1.z)) * mWeight;
	mVel += tTempMove2 * 0.02;
	
	tTempRot = Rotation;	
		
	mPitchVel += (tTempRot.pitch / mPitchDiv);
	mRollVel += (tTempRot.roll / mRollDiv);

	
	tTempRot.pitch -= mPitchVel * VSizeSq(mVel);
	tTempRot.roll -= mRollVel * VSizeSq(mVel);
	tTempRot.yaw += mYawAdd;
	
	SetRelativeRotation(tTempRot);		
	
	tFinalMove = mVel * mVelMult;	
	
	tFinalMove.z*=Abs(tTempMove1.z);
	
	Move(tFinalMove);
	
	if (mVelMult > 1.0)
		mVelMult *= 0.8;
}

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeight=5.0000000
    StaticMesh=StaticMesh'TbeSm.obt085v2'
    bStatic=false
}