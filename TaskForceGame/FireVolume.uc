class FireVolume extends PhysicsVolume
	hidecategories(Volume)
	hidecategories(Lighting)
	hidecategories(LightColor)
	hidecategories(Karma)
	hidecategories(Brush)
	hidecategories(Force)
	hidecategories(Sound)
	hidecategories(VolumeDamage);
	
var ( ) bool				bFireDefault;
var ( )	float				FireDamageRate;
var ( ) float				FireDamageAmount;
var ( ) class<DamageType>	FireDamageType;
var ( ) sound				FireDamageSound;

var	int						NumBurningActors;

function PostBeginPlay ( )
{
	Super.PostBeginPlay ( );
	
	// check if we just want defaults
	if ( bFireDefault )
	{
		// restore defaults
		FireDamageRate = Default.FireDamageRate;
		FireDamageAmount = Default.FireDamageAmount;
		FireDamageType = Default.FireDamageType;
		FireDamageSound = Default.FireDamageSound;
	}
	
	// quick clamps
	if ( FireDamageAmount < 0 )
	{
		FireDamageAmount = 0;
	}
	
	// if zero
	if ( FireDamageRate <= 0 )
	{
		// pretty fast
		FireDamageRate = 0.05;
	}
		
	// make sure we have a pain timer
	if ( PainTimer != None )
	{
		// reset the timer to do what we need
		PainTimer.SetTimer ( FireDamageRate, true );
	}
}

function CausePainTo ( Actor Other )
{
	local Pawn P;

	P = Pawn ( Other );
	
	Other.TakeDamage ( FireDamageAmount, None, Other.Location, vect ( 0, 0, 0 ), FireDamageType );
	if ( P != None && P.Controller != None )
	{
		P.Controller.PawnIsInPain ( Self );
	}
}


event Touch ( Actor Other )
{
	//Super.Touch ( Other );

	if ( Other != None )
	{
		NumBurningActors++;
	
		if ( PainTimer != None && PainTimer.AmbientSound != FireDamageSound )
		{
			PainTimer.AmbientSound = FireDamageSound;
		}
	}
}

event UnTouch ( Actor Other ) 
{
	//Super.UnTouch ( Other );

	if ( Other != None )
	{
		NumBurningActors--;
		
		if ( PainTimer != None && NumBurningActors <= 0 )
		{
			PainTimer.AmbientSound = None;
		}
	}
}
event PawnEnteredVolume ( Pawn Other ) {}
event PawnLeavingVolume ( Pawn Other ) {}


// Decompiled with UE Explorer.
defaultproperties
{
    bFireDefault=true
    FireDamageRate=0.5000000
    FireDamageAmount=10.0000000
    FireDamageType=Class'DamageTypeBurned'
    FireDamageSound=Sound'CBW_DYN_interface.HUD.Flesh_Burn_loop'
    bPainCausing=true
    bStatic=false
}