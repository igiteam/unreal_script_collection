//=============================================================================
// SASTorchBeamCorona.uc
//
//=============================================================================

class SASTorchBeamCorona extends DirectionalCorona;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var Actor		mAttachActor;
var Name		mAttachBone;
var vector		mRelativeLocation;

var int			miCoronaType;		// 0 - normal corona	1 - brighter corona
var float		mfCoronaAlpha;

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

function SetAttachBone(Actor actor, Name bone, vector relativeLocation)
{
	mAttachActor = actor;
	mAttachBone = bone;
	mRelativeLocation = relativeLocation;
}

//-----------------------------------------------------------------------------

function UnsetAttachBone()
{
	mAttachActor = None;
	mAttachBone = '';
}

//-----------------------------------------------------------------------------

event Tick(float DeltaTime)
{
	local coords			TempCoord;
	local vector			Temp;
	local rotator			TempRot;
	local float				fAlpha;
	local PlayerController	PC;
	local float				fDeltaAngle;
	local float				fPercentage;
	local float				fFadeInPoint;
	local int				iBrightness;
	local vector			flashLoc;
	local vector			cameraDir;
	local vector			flashDir;
	local float				fMag;
	
	if (mAttachActor != None)
	{
		TempCoord = mAttachActor.GetBoneCoords(mAttachBone);

		Temp = TempCoord.Origin;
		Temp += TempCoord.XAxis * mRelativeLocation.X;
		Temp += TempCoord.YAxis * mRelativeLocation.Y;
		Temp += TempCoord.ZAxis * mRelativeLocation.Z;

		SetLocation(Temp);

		TempRot = OrthoRotation(TempCoord.ZAxis, TempCoord.YAxis, TempCoord.XAxis);
		SetRotation(TempRot);
		
		// calculate intensity of corona here and set it to the actor's intensity var
		// check which corona it is, the brighter or the normal one
		// and update the right variable in the actor class!
		PC = Level.GetLocalPlayerController();


			flashLoc = mAttachActor.GetBoneLocation(mAttachBone);
			cameraDir = Vector(PC.Pawn.Rotation);
			flashDir = Vector( mAttachActor.GetBoneRotation(mAttachBone) );

			fMag = sqrt((flashDir.x*flashDir.x)+(flashDir.y*flashDir.y)+(flashDir.z*flashDir.z));
			flashDir.x/=fMag;flashDir.y/=fMag;flashDir.z/=fMag;

			fMag = sqrt((cameraDir.x*cameraDir.x)+(cameraDir.y*cameraDir.y)+(cameraDir.z*cameraDir.z));
			cameraDir.x/=fMag;cameraDir.y/=fMag;cameraDir.z/=fMag;
			
			fDeltaAngle = (cameraDir Dot (flashDir));

			fFadeInPoint = -0.95;
			if( miCoronaType == 0 )
			{
				// adjust the normal flare intensity
				if ( fDeltaAngle <= fFadeInPoint && fDeltaAngle >= -1.0 )
				{
					// start reducing the flare intensity based on how close to 1.0 the angle diff is
					fPercentage = (fFadeInPoint-fDeltaAngle) / (fFadeInPoint+1.0f);
					fAlpha = 1.0 - fPercentage;
				}
				else
				{
					if( fDeltaAngle >= -0.3f )
						fAlpha = 0.0f;
					else
					{
						// supposed to fade to 1.0f;
						fPercentage = ((-0.3f) - fDeltaAngle)/((-0.3f)-fFadeInPoint);
						fAlpha = fPercentage;
					}

				}

			}
			else if( miCoronaType == 1 )
			{
				// adjust the brighter flare intensity
				if ( fDeltaAngle <= fFadeInPoint && fDeltaAngle >= -1.0 )
				{
					// start increasing the flare intensity based on how close to 1.0 the angle diff is
					fPercentage = (fFadeInPoint-fDeltaAngle) / (fFadeInPoint+1.0f);
					fAlpha = fPercentage;
				}
				else
				{
					fAlpha = 0.0;
				}

			}
			
			if( fAlpha < 0.0 )fAlpha = 0.0;
			if( fAlpha > 1.0 )fAlpha = 1.0;
			iBrightness = fAlpha * 255;
			
			bSetCoronaAlpha = true;


			if( miCoronaType == 0 )
				LightAlpha = iBrightness;
			else
				LightAlpha = iBrightness;


	}

	Super.Tick(DeltaTime);
}

//-----------------------------------------------------------------------------

function SetSkin(Texture coronaTexture, int CoronaType)
{
	if (Skins.Length < 1)
	{
		Skins.Length = Skins.Length+1;
	}
	Skins[0] = coronaTexture;
	miCoronaType = CoronaType;
}

//-----------------------------------------------------------------------------


// Decompiled with UE Explorer.
defaultproperties
{
    mfCoronaAlpha=1.0000000
    DrawScale=0.3000000
    ScaleGlow=100.0000000
    RemoteRole=0
    bStatic=false
    bNoDelete=false
    bAlwaysRelevant=true
    bHardAttach=true
    bGameRelevant=true
    bMovable=true
}