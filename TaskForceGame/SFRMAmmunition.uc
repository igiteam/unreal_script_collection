class SFRMAmmunition extends Ammunition
	native;


struct MovingSoundDefinition
{
	var()	sound AmbientSound; 
	var()	float Radious; 
	var()	float Volume; 
	var()	float Pitch;
	
};

var(BulletSounds)	array<MovingSoundDefinition>	FlyBySounds;
var(BulletSounds)	Sound							RandomBulletImpactSounds[EMATERIALTYPE_SIZE];

//var					BulletImpactEffects				BulletImpactEffectsSpawner; 
//var					class<BulletImpactEffects>		BulletImpactEffectClass;

var					bool							bHideAmmoCount;			

replication
{
	unreliable if( Role==ROLE_Authority )
		ClientNewBulletHole;
}

/*
simulated function bool HasAmmo()
{
	local SFRMCheatInteraction intr;
	local SFRMPlayerController pc;

	if (Instigator != none)
	{
//SysLinkSPAM		Log("SFRMAmmunition.HasAmmo:   entered function");
//SysLinkSPAM		Log(" SFRMAmmunition.HasAmmo:  Instigator="$Instigator$"  Instigator.Controller="$Instigator.Controller);
		pc = SFRMPlayerController(Instigator.Controller);
//SysLinkSPAM		Log(" SFRMAmmunition.HasAmmo:  SFRMPlayerController pc: "$pc );
		
		if(pc != None)
		{
			intr = pc.CheatInteraction;
			if(intr != None)
			{
				if(intr.bInfiniteAmmo)
				{
					return true;	
				}
			}
		}
	}

	//Log(" SFRMAmmunition.HasAmmo:   about to call Super.HasAmmo() " );
	return Super.HasAmmo();
}
*/

function SpawnSoundProjectile(vector Start, rotator Dir, MovingSoundDefinition Def)
{
	local SoundProjectile M; 
	
	M = Spawn(class'SoundProjectile',,, Start,Dir);	
	
	M.MoveAmbientSound=Def.AmbientSound;
	M.SoundRadius=Def.Radious;
	M.SoundVolume=Def.Volume / 255; // come in as a byte but has to be avalue between 0 and 1
	M.SoundPitch=Def.Pitch / 64;
	
	M.LifeSpan = 20.0f; 
	M.Speed = 100.0f;
}

function bool IsInMP(Pawn test)
{
	return ((test.Controller.Level.NetMode != NM_Standalone) || 
			(test.Controller.Level.Game == none) || 
			ClassIsChildOf(test.Controller.Level.Game.class, class'ZombieGame.SFRMMultiPlayer')
			);
}

// Tells client to make a bullet hole at the given location and orientation
// -HitNormal is multiplied by 1000 because vector components get turned into ints when
//  being sent accross the network.
simulated function ClientNewBulletHole( float HitLocX, float HitLocY, float HitLocZ, vector HitNormalX1000 )
{
	local vector HitLocation;

	HitLocation.X = HitLocX;
	HitLocation.Y = HitLocY;
	HitLocation.Z = HitLocZ;

//	Log("SFRMAmmunition.ClientNewBulletHole   HitLocation:"$ HitLocation $"  HitNormalX100:"$ HitNormalX1000 $" HitNormalX1000 x 0.001:"$ HitNormalX100*0.001);
//	Log("SFRMAmmunition.ClientNewBulletHole   bNetOwner:"$ bNetOwner $"  Role==ROLE_Authority :"$ Role==ROLE_Authority );
	Level.NewBulletHole( HitLocation , HitNormalX1000*0.001 );
}

function FinishTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z, optional Material MaterialHit)
{
	local byte byteType;
	local Actor ImpactActor; 
	local ZombiePlayerPawn P;
	local ZombieWeapon SFRMW; 
	local float FalloffModifier, Dist;
	local float ImpactScaleFactor;
	local float FOV;

	SFRMW = ZombieWeapon(W);
	
//	log(self$"::FinshTraceHit");
//	Log("MaterialHit:"$ MaterialHit $"  is sky?"$ MaterialHit.MaterialType == EMATERIALTYPE_SKY );

	// Calculate modifier to reduce damage at long range
	Dist = VSize( W.Location - HitLocation );
	FalloffModifier = 1.0;
	if( W.TraceDist > 0 )
	{
		if( Dist > W.TraceDist * 0.50 )
			FalloffModifier = 1.0-0.75*(Dist-W.TraceDist*0.50)/(W.TraceDist*0.50);  // Falls off to 0.25 at max range
	}
//	Log("* Dist:"$Dist $" ("$Dist/24.0 $" ft, "$Dist/W.TraceDist$")   FalloffModifier:"$FalloffModifier $"  Aim yaw:"$Instigator.Rotation.Yaw );

	// Apply weapon specific damage modifier
//	Log("  Other:"$Other.class );
//	Log("  W.DamageAmount:"$DamageAmount $"   FalloffModifier:"$FalloffModifier );
//	Log("  W.Instigator:"$W.Instigator $"  HitLocation:"$HitLocation $"  MomentumTransfer*X:"$MomentumTransfer*X $"  MyDamageType:"$MyDamageType );
	Other.TakeDamage(W.DamageAmount * FalloffModifier, W.Instigator, HitLocation, MomentumTransfer*X, MyDamageType);

	// Bullet hole
	if( Level.Game.bShowBulletHoles  
	 &&	Other.bShowBulletHoles 
	 && MaterialHit != None   // MAT 2/17/05
	 && MaterialHit.MaterialType != EMATERIALTYPE_WATER 
	 && MaterialHit.MaterialType != EMATERIALTYPE_SKY )
	{
//		Log("Bullet hole!!!   Other:"$ Other $"  bShowBulletHoles:"$ Other.bShowBulletHoles $"  matl:"$ MaterialHit.MaterialType );
//		ZombiePlayerPawn(instigator).BulletHoleMgr.NewBulletHole( HitLocation, HitNormal );
		if( Level.NetMode == NM_Standalone )
			Level.NewBulletHole( HitLocation, HitNormal );
		else
			ClientNewBulletHole( HitLocation.X, HitLocation.Y, HitLocation.Z, (HitNormal*1000) );  // PC: bullet holes in multiplayer too
	}
//	else
//		Log("No bullet hole.  Other:"$ Other $"  bShowBulletHoles:"$ Other.bShowBulletHoles $"  matl:"$ MaterialHit.MaterialType );

	// Impact effect (e.g. dust kicked up)
	if (SFRMW != None && SFRMW.bOverwriteBulletImpact)
		SFRMW.SpawnImpactEffect(Other, Self, HitLocation, HitNormal, byteType);
		
	if(ZombiePlayerPawn(W.Instigator) == None)
	{
		//Don't do this if it can't be seen by a player.
		ForEach RadiusActors(class'ZombiePlayerPawn', P, 600,HitLocation)
		{
			break;		
		}

		if(P == None)
		{
			return;
		}
	}
	
	if( MaterialHit != None && MaterialHit.MaterialType != EMATERIALTYPE_SKY )
	{
		byteType = MaterialHit.MaterialType; 
		
		// Scale up impact effect if further away from player
		if( ZombiePlayerPawn(Instigator) != None && PlayerController(Instigator.Controller) != None )
		{
			FOV = PlayerController(Instigator.Controller).FOVAngle;
			ImpactScaleFactor = FClamp( Dist*0.0016*(FOV/80.0), 1.0, 5.5 );
		}
		else
			ImpactScaleFactor = 1.0;

		if( ClassIsChildOf(MyDamageType, Class'ZombieGame.DamageTypeMelee') ) 
		{
			log( "Knife noise" );
			W.Instigator.MakeNoise(0.8);
		}

		if( MaterialHit.MaterialType != MATERIAL_Flesh )
		{
			ImpactActor = class'BulletImpactEffects'.Static.SpawnImpactEffect(Other, W.Instigator, HitLocation, HitNormal, byteType, ImpactScaleFactor ); 
		}
		else
		{
			if( Other != None )
			{
		//		Other.PlaySound(RandomBulletImpactSounds[byteType],, 1,,15, ,true);
		//		Other.MakeNoise(1.0);
			}
		}
		if ( (Other != None && Other.bWorldGeometry || (Mover(Other) != None)) && ImpactActor != None && MyDamageType.default.bCausesImpactSound)
		{
			ImpactActor.PlaySound(RandomBulletImpactSounds[byteType],, 1,,30, ,true);
			if(W.Instigator != None )
				ImpactActor.Instigator = W.Instigator;

			//ImpactActor.MakeNoise(1.0);
		}
	}
}

function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z, optional Material MaterialHit)
{
	Super.ProcessTracehit(W,Other,HitLocation, HitNormal, X, Y, Z, MaterialHit);
	
	if ( Other == None)
		return;

	if ( Other != W.Instigator ) 
	{
	//	log(self$"::ProcessTraceHit");
		FinishTraceHit(W, Other, HitLocation, HitNormal, X, Y, Z,MaterialHit);
	}
}

function Projectile SpawnProjectileEx(vector Start, rotator Dir, float SpeedMod, float TimeDelta)
{
	SpawnProjectile(Start, Dir); 
	return None; 
}

function ProcessMissedSound(Weapon W, rotator Rot) 
{
	if ( FlyBySounds.Length > 0 )
	{ 
		SpawnSoundProjectile(W.Location, Rot, FlyBySounds[rand(FlyBySounds.Length)]); 
	}
}
function Sound GetRandomBulletImpactSound(byte byteType)
{
	return RandomBulletImpactSounds[byteType];
}


// Decompiled with UE Explorer.
defaultproperties
{
    RandomBulletImpactSounds[0]=Sound'CBW_DYN_Foley.Bullet_Impacts.bullet_impact_sand1'
    RandomBulletImpactSounds[1]=Sound'CBW_DYN_Foley.Bullet_Impacts.bullet_impact_gravel1'
    RandomBulletImpactSounds[2]=Sound'CBW_DYN_Foley.Bullet_Impacts.bullet_impact_sand1'
    RandomBulletImpactSounds[3]=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_metal1'
    RandomBulletImpactSounds[4]=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_stone1'
    RandomBulletImpactSounds[5]=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_water1'
    RandomBulletImpactSounds[6]=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_wood1'
    RandomBulletImpactSounds[7]=Sound'CBW_DYN_Foley.Bullet_Impacts.bullet_impact_gravel1'
    RandomBulletImpactSounds[8]=Sound'CBW_DYN_Foley.Bullet_Impacts.bullet_impact_sand1'
    RandomBulletImpactSounds[9]=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_water1'
    RandomBulletImpactSounds[10]=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_mud1'
    RandomBulletImpactSounds[11]=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_flesh1'
    MyDamageType=Class'SFRMDamageType'
}