//--------------------------------------------------------------------------
// Sounder class - plays a sound.. once or looped.... triggered by events
//--------------------------------------------------------------------------

class Sounder extends Keypoint
	placeable;
	
var(Sounder) sound SoundFile;
var(Sounder) bool bStartOn;
var(Sounder) bool bUsable;

var(Sounder) enum ESounderType 
{
	ST_PLAYONCE,
	ST_LOOP

} SounderType;

var(Sounder) float MakeNoiseVolume;

var bool bLooping;

function PostBeginPlay ( ) 
{
	Super.PostBeginPlay ( );
	
	// set up for ambient settings
	TransientSoundVolume = SoundVolume / 255.0;
	TransientSoundRadius = SoundRadius;

	MakeNoiseVolume = FClamp ( MakeNoiseVolume, 0.0, 1.0 );
	
	if ( SounderType == ST_PLAYONCE ) 
	{
        if ( bStartOn ) 
		{		
			PlaySound ( SoundFile,				// sound
						SLOT_Misc,				// slot
						SoundVolume / 255.0,	// volume	0 - 1
						true,					// bNoOverride
						SoundRadius,			// radius
						SoundPitch / 64.0,		// pitch	not sure why / 64.0
						true );					// attenuate

//			MakeNoise ( MakeNoiseVolume );
		}					
	} 
	else if ( SounderType == ST_LOOP ) 
	{
		if ( bStartOn ) 
		{		
			AmbientSound = SoundFile;
			bLooping = true;
		}	
	}
}

function UsedBy ( Pawn User ) 
{
	if ( bUsable ) 
	{  
		Self.Trigger ( User, User );	
	}  
}

function Trigger ( Actor Other, Pawn EventInstigator ) 
{
	local ZombiePlayerPawn MyPlayerPawn;

	if ( SounderType == ST_PLAYONCE ) 
	{		
		PlaySound ( SoundFile,				// sound
					SLOT_Misc,				// slot
					SoundVolume / 255.0,	// volume	0 - 1
					true,					// bNoOverride
					SoundRadius,			// radius
					SoundPitch / 64.0,		// pitch
					true );					// attenuate
        		
		if ( Instigator == None )
		{
			// need to set an instigator
			foreach DynamicActors ( class'ZombiePlayerPawn', MyPlayerPawn )
				break;
			
			Instigator = MyPlayerPawn;
		}

		//log ( Instigator );

		//MakeNoise ( MakeNoiseVolume );
	}
	if ( SounderType == ST_LOOP ) 
	{	
		if ( !bLooping ) 
		{		
			// turn on
			bLooping = true;
			
			AmbientSound = SoundFile;		
		} 
		else 
		{		
			// turn off
			bLooping = false;		
			
			AmbientSound = None;
		}	
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    MakeNoiseVolume=1.0000000
    bStatic=false
    Texture=Texture'Engine.S_WhiteCircle'
    SoundRadius=256.0000000
    SoundVolume=255
    CollisionRadius=80.0000000
    CollisionHeight=80.0000000
    bCollideActors=true
}