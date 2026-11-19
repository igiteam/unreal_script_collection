class ZombieSlidingDoor extends ZombieDoor
	hidecategories(ZombieRotatingDoor)
	placeable
	native;

var() rotator OpeningDirection;			// direction this door slides
var() float OpeningOffset;				// units to offset door in OpeningDirection

function SetUpDoor ( ) 
{
	KeyNum = 0;
		
	// copy editor vars to programmer versions
	openTime = TimeToOpen;
	resetTime = TimeBeforeClose;

	KeyPos[1] = OpeningOffset * vector ( Self.Rotation + OpeningDirection );
	KeyRot[1] =	rot ( 0, 0, 0 );

	doorVector.X = 1;
	doorVector.Y = 0;
	doorVector.Z = 0;

	if ( DrawScale3D.X < 0 || DrawScale < 0 )
		doorVector.X = -1;
	
	doorVector = Normal ( doorVector >> Self.Rotation );

	// door vector drops the z
	doorVector.Z = 0;
}

function StartOpening ( ) 
{	
	InterpolateTo ( 1, openTime );
}

// default properties

// Decompiled with UE Explorer.
defaultproperties
{
    OpeningOffset=80.0000000
    TriggerOffset=0.0000000
}