class EffectSpawner extends Actor
	placeable;
	
var()	array <class<Emitter> >	Emitters;
var()	bool bStartOn;

var		transient array<Emitter>	MyEmitters;
var		transient bool				bOn;

function PreBeginPlay ( )
{
	local int Index;

	for ( Index = 0; Index < Emitters.Length; ++Index )
	{
		if ( Emitters[Index] != None )
		{
			//log ( "EffectSpawner - DLOing"@Emitters[Index].default.Class );
			DynamicLoadObject ( string ( Emitters[Index].default.Class ), class'Class' );
		}
	}

}

simulated function PostBeginPlay()
{
	if(bStartOn)
	{
		StartEmitters();
	}
}

function Destroyed()
{
	local int i;

	for(i = 0; i < Emitters.Length; i++)
	{
		MyEmitters[i].Destroy();
		MyEmitters[i] = None;
	}
}

//----------------------------------------------------------------------------//
// Trigger(                                                                   //
//                                                                            //
//----------------------------------------------------------------------------//
function Trigger( actor Other, pawn EventInstigator )
{
	if(!bOn)
	{
		StartEmitters();
	}
	else
	{
		StopEmitters();
	}
		
}

simulated function StartEmitters()
{
	local int i;
	local int emitterIndex;
	
	for(i = 0; i < Emitters.Length; i++)
	{
		MyEmitters[i] = Spawn(Emitters[i],self);
		if ( MyEmitters[i] != None ) {
		
			for ( emitterIndex = 0; emitterIndex < MyEmitters[i].Emitters.Length; emitterIndex++ ) {
			
				if ( MyEmitters[i].Emitters[emitterIndex] != None ) {
				
					if ( MyEmitters[i].Emitters[emitterIndex].Disabled ) {
					
						MyEmitters[i].Emitters[emitterIndex].Trigger( );
					}
				}
			}
		}
	}
	
	bOn = true;
}

simulated function StopEmitters()
{
	local int i;
	
	for(i = 0; i < Emitters.Length; i++)
	{
		MyEmitters[i].Destroy();
		MyEmitters[i] = None;
	}
	
	bOn = false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    bStartOn=true
    bHidden=true
    Texture=Texture'Engine.S_Emitter'
}