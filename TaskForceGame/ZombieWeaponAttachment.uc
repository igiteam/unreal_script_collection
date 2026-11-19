class ZombieWeaponAttachment extends WeaponAttachment 
	native;

//const WPNATTACHBONE = 'r_hand';
const WPNATTACHBONE = 'r_wrist';

var MuzzleFlashAttachment MuzzleFlash;
var class<MuzzleFlashAttachment> MuzzleClass;
var vector MuzzleOffset;
var vector MuzzleOffsetPoint;
var rotator MuzzleRotationOffset;

var vector HitLoc;						// Used to say where a trace hit occured
var vector EffectLocationOffset[2];		// Used for 1st person vs 3rd person Effects

var	class<Emitter>	BrassEffectClass; 
var vector			BrassThirdPersonOffset;		// Offset from the 'weapon_bon' on the mesh 
var Sound			ThirdPersonSound[3];
var bool			LastShot;

var int				Bounces;

var class<PlayerMuzzleLight> PlayerMuzzleLightClass;
var PlayerMuzzleLight		myPlayerMuzzleLight;

var bool			bNPCLaserSight;
var float			NextLaserDotUpdateTime;
var float			NextLaserDotTraceTime;
var vector			DotLocation;
var float			DotDistance;
var LaserDot		DotActor;
var Emitter			DotEffect;
var PlayerController BystanderPlayerController;

var float			TimeOfLastThirdPersonFireSound;

var float           FadeAlpha;
var bool			bFadingOut;		// when owner dies and drops... this is true because gun will be fading out.

var bool			bUseDynamicLight;

replication
{
	// Things the server should send to the client.
	unreliable if( bNetDirty && !bNetOwner && (Role==ROLE_Authority) )
		HitLoc,EffectLocationOffset,MuzzleFlash;
		
	unreliable if( bNetDirty && Role==ROLE_Authority )
		MuzzleRotationOffset,MuzzleOffset;

	//client calls these functions on server
//	reliable if (Role < ROLE_Authority)
//		PlayServerSound;
}

native function Material GetMaterial();

simulated function Adjust(int Person, vector Adjustment)
{
	EffectLocationOffset[Person] = EffectLocationOffset[Person]+Adjustment;

	if (Person==0)
		log("#### New 3rd Person Offset: "$EffectLocationOffset[Person]);
	else
		log("#### New 1st Person Offset: "$EffectLocationOffset[Person]); 
}

event PostBeginPlay()
{

	local name BoneName;
	local Pawn P;
	
//	log("Begin PBP SFRM WeaponAttachment");

	Super.PostBeginPlay();

//	log("Middle PBP SFRM WeaponAttachment");
//	log(MuzzleClass);

	P = Pawn(Owner);
	
	if (P!=None && MuzzleClass!=None)
	{
//		MuzzleFlash = spawn(MuzzleClass,Owner);
		MuzzleFlash = spawn(MuzzleClass,Self);
//		log("MuzzleFlash in SFRM WeaponAttachment");
//		log(MuzzleFlash);
		BoneName = P.GetWeaponBoneFor(P.Weapon);
		if (BoneName == '')
		{
			MuzzleFlash.SetLocation(P.Location);
			MuzzleFlash.SetBase(P);
		}
		else
			P.AttachToBone(MuzzleFlash,BoneName);
		
		MuzzleFlash.SetRelativeRotation(MuzzleRotationOffset);
		MuzzleFlash.SetRelativeLocation(MuzzleOffset);
	}

	if( bNPCLaserSight )
		BystanderPlayerController = FindPlayerController();

	// No dynamic light in multiplayer
	if( (Level.NetMode != NM_Standalone) || (Level.Game == none) || 
	 (ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMMultiPlayer') ) )
		bUseDynamicLight = false;
	else
		bUseDynamicLight = true;
}

function PlayerController FindPlayerController()
{
	local Controller BystanderController;
	local PlayerController FoundBystanderPlayerC;

	BystanderPlayerController = None;
	
	BystanderController = Level.ControllerList;  // Get head of controller list

	// Go through each controller in the level's controller list
	do
	{
	//	Log("  Searching...   BystanderController:"$BystanderController.class );
		if( PlayerController(BystanderController) != None )
		{
			FoundBystanderPlayerC = PlayerController(BystanderController);
		}
		
		BystanderController = BystanderController.nextController;  // Go to next node in controller list
	} until ( BystanderController == None || FoundBystanderPlayerC != None );

	return FoundBystanderPlayerC;
}

native function HackFixOuter();

event Destroyed()
{
	if (MuzzleFlash!=None)
	{
		MuzzleFlash.Destroy();
	}
	if( Skins.Length > 0 && ColorModifier(Skins[0]) != none )
	{
		HackFixOuter();
	}

	Super.Destroyed();
}

//Since this function is not used for any effect start the EffectLocationOffset is not
//a valid value, Muzzle offset has been used for 3rd person effects here because this is the value
//currently used for drawing the muzzle flash effect
simulated function GetEffectStart(out vector Start, out rotator Rot)
{
	local PlayerController PC;
	local Pawn P;
	local vector x,y,z; //,S,E;
	local coords C;
	//local barrel b; //unused 

	P  = Pawn(Owner);
	PC = PlayerController(P.Controller); 

	if (P.IsLocallyControlled() && PC!=None && (!PC.bBehindView) )
		Start = Instigator.Weapon.Location + EffectLocationOffset[1];
	else
	{
		C = Instigator.GetBoneCoords(WPNATTACHBONE);
		GetAxes(Instigator.GetViewRotation(),X,Y,Z);
		Start = C.Origin + (X*MuzzleOffsetPoint.X) + (Y*MuzzleOffsetPoint.Y) + (Z*MuzzleOffsetPoint.Z);
	}
	Rot = Instigator.GetViewRotation();
}	


simulated event ThirdPersonEffects()
{
	//local rotator EffectRotation; 
	local vector x,y,z, Start; 
	local coords C; 
	local PlayerController PC;
	local Pawn P;
	local name BoneName;

	Super.ThirdPersonEffects();
	
//	log("ThirdPersonEffects"@Owner@Instigator@Region.Zone@FlashCount);

	if (Instigator == None ) return;
	P  = Instigator;
//	if (p == none) return;
	
	if ( (Level.NetMode != NM_Standalone) && (FlashCount == 0))
	{
		return;
	}

	PC = PlayerController(P.Controller); 

	// Play third-person firing sound
	if (Region.Zone!=None)
	{
		// If this is a bot, or this is not locally controlled
		if( (PC == None || !P.IsLocallyControlled()) && Level.NetMode != NM_DedicatedServer )
			PlayThirdPersonFireSound(ThirdPersonSound[Region.Zone.SoundZone], SLOT_Misc, 1.0,, 450.0 );
	}

	// Only go past this point if owner is not a player in single-player
	if (PC!=None && (!PC.bBehindView) && Level.Game!=None&&ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMSinglePlayer') )
		return; 

	// Show muzzle flame at the end of the weapon's barrel
	if (MuzzleFlash!=None)
	{
		if( MuzzleFlash.Base == None )
		{
			if (BoneName == '')
			{
				MuzzleFlash.SetLocation(P.Location);
				MuzzleFlash.SetBase(P);
			}
			else
				P.AttachToBone(MuzzleFlash,BoneName);
		}

		P.BoneRefresh ( );	// trying to make ghost muzzle flashes go away

	//	Log("ZWA.TPE  MRO:"$ MuzzleRotationOffset $"  MO:"$ MuzzleOffset );
		MuzzleFlash.SetRelativeRotation(MuzzleRotationOffset);
		MuzzleFlash.SetRelativeLocation(MuzzleOffset);

		MuzzleFlash.Flash();
	}

//	Log("  P.IsLocallyControlled():"$ P.IsLocallyControlled() $"  PC!=None:"$ PC!=None $"  (!PC.bBehindView):"$ (!PC.bBehindView) );
	// Only go past this point if owner is not a locally-controlled player
	if (Role<ROLE_Authority && P.IsLocallyControlled() && PC!=None && (!PC.bBehindView) )
		return; 

	if ( PC != None && SFRMPlayerController ( PC ).IsMP ( ) )
	{
		return;
	}

	// Eject spent shell casings
	if ( BrassEffectClass != None && instigator!=None )
	{
		C = Instigator.GetBoneCoords(WPNATTACHBONE);
		GetAxes(Instigator.GetViewRotation(),X,Y,Z);
		Start = C.Origin + (X*BrassThirdPersonOffset.X) + (Y*BrassThirdPersonOffset.Y) + (Z*BrassThirdPersonOffset.Z); 

		// EffectRotation = Instigator.GetViewRotation(); 
		// EffectRotation.Pitch = (EffectRotation.Pitch + 32768)%65536;

		Spawn(BrassEffectClass,,,Start);
	}
}

simulated function FlashPlayerMuzzleLight(Pawn P)
{
	if( bUseDynamicLight )
	{
		// If weapon is currently controlled by a player, create a player muzzle light if neccessary
		if( myPlayerMuzzleLight == None && ZombiePlayerPawn(P) != None )
		{
			if (PlayerMuzzleLightClass!=None && MuzzleFlash!=None)
				myPlayerMuzzleLight = Spawn(PlayerMuzzleLightClass,,,MuzzleFlash.Location );
		}
		else if( myPlayerMuzzleLight != None && ZombiePlayerPawn(P) == None )
		{
			myPlayerMuzzleLight.Destroy();
		}

		// Flash the player muzzle light (should take care of 1st and 3rd person for player)
		if ( myPlayerMuzzleLight!=None && P.Weapon!=None && ZombieWeapon(P.Weapon)!=None)
		{
			myPlayerMuzzleLight.SetLocation( P.Weapon.Location + (myPlayerMuzzleLight.RelativeLocation >> P.GetViewRotation()) );
			if( ZombieWeapon(P.Weapon).bIsSilenced )
				myPlayerMuzzleLight.PlayerSubduedFlash(P.Weapon);
			else
				myPlayerMuzzleLight.PlayerFlash(P.Weapon);
		}
	}
}

function DetachFrom ( Pawn OwnerPawn )
{
	local rotator temp;
	if ( OwnerPawn != None )
	{
		OwnerPawn.DetachFromBone ( Self );
		SetPhysics ( PHYS_Projectile );
		bCollideWorld = true;
		
		bBlockZeroExtentTraces = true;
		bBlockNonZeroExtentTraces = true;
		bProjTarget = true;
		bUseCylinderCollision = false;
		SetCollisionSize ( 5, 5 );
		Velocity = Normal ( Vector ( Rotation ) ) * RandRange(50,25);
		Velocity.Z = RandRange ( 0, 30 );
		Acceleration = vect ( 0, 0, 0 );
		Acceleration.Z = -1500.0;
		temp = Rotation;
		temp.roll = 16384;
		SetRotation ( temp );
		bBounce = True;
		bFixedRotationDir = true;
		bRotateToDesired = true;
		//RandSpin ( 30000 );
	}
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	local float Speed;
	local Material prev;
	local ColorModifier cm;

	if ( HitWall == Instigator)	return; 

	Speed = VSize ( Velocity );
	
	if ( /*Speed > 5 &&*/ Bounces < 2 ) 
	{
		Velocity = 0.1*( ( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		//RandSpin ( 30000 );
		Bounces++;
	}
	else if( cm == none )
	{
		Velocity = vect ( 0.0, 0.0, 0.0 );
		Acceleration = vect ( 0.0, 0.0, 0.0 );

        Skins[0] = GetMaterial();

		prev = Skins[0];
		cm = new class'ColorModifier';
		cm.AlphaBlend = true;
		cm.Material = prev;
		Skins[0] = cm;

		bFadingOut = true;
	}
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal, None);
}

simulated final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}

simulated function Tick(float TimeDelta)
{
	Super.Tick( TimeDelta );
	if( bNPCLaserSight && Level.TimeSeconds >= NextLaserDotUpdateTime )
		LaserSightDot();

	if ( bFadingOut )
	{
		FadeAlpha -= 255*TimeDelta/2;
		ColorModifier( Skins[0] ).Color.A = FadeAlpha;

		if( FadeAlpha <= 0 )
		{
			Destroy();
		}
	}
}

function LaserSightDot()
{
	local vector THitLocation, THitNormal, LaserStart, EndTrace, X,Y,Z;
	local actor Other;
	local Pawn PawnOwner;
	local rotator ModRotation, DotRotation;

	PawnOwner = Pawn(Owner);

	if(  Owner == None 
	  || (PawnOwner != None && PawnOwner.Health <= 0) 
	  || ZombiePlayerPawn(PawnOwner) != None   )
	{
		// Destroy the dot if the owner is dead, or owner is a player
		if( DotActor != None )
		{
			DotActor.bHidden = true;
			DotActor.Destroy();
		}

		return;
	}

	// If weapon is holstered, hide dot
	if( DotActor != None )
	{
		DotActor.bHidden = false;
	}

	// Spawn laser dot, if we don't have one already
	if( DotActor == None && PawnOwner != None && PawnOwner.Health > 0 )
	{
		DotActor = Spawn(class'ZombieGame.LaserDot',,,DotLocation,Rotation);
	}

	ModRotation = Rotation;

	// Add jitter.
	//   sin = opposite / hypoteneuse = vertical jitter / DotDistance
	//     For small angles (< 10 deg), sine is about the same as the angle (in radians).  
	//     Even if our angle is outside that range it's ok: it doesn't have to be exact,
    //     we just want less angle change at larger distances.
	//   angle = opposite / hypoteneuse = vertical jitter / DotDistance  (sine in radians, angle < 10 deg)
	//     Unreal angle units to Radians: 10430.22
	//     vertical jitter = max amplitude * FRand()
	//   angle = 10430.22 * vertical jitter / DotDistance            (in Unreal angle units)
	//   angle = 10430.22 * max amplitude * FRand() / DotDistance    (in Unreal angle units)
	//     If max amplitude is constant, then 10430.22 * max amplitude  can be expressed as a constant.
	ModRotation.Pitch += 34419.73*FRand() / DotDistance;

	GetAxes(ModRotation,X,Y,Z);

//	LaserStart = Location +	(	(X*EffectLocationOffset[0].X) +
//								(Y*EffectLocationOffset[0].Y) +
//								(Z*EffectLocationOffset[0].Z) );
	LaserStart = Location;

	// Find new sprite location
	if( Level.TimeSeconds >= NextLaserDotTraceTime )
	{
		// Do trace (do this less frequently than estimate)
		EndTrace = LaserStart + X*5000.0;
		Other = Trace( THitLocation, THitNormal, EndTrace,,,, );
		DotLocation = THitLocation - X;

		DotDistance = VSize( THitLocation - LaserStart ) - 1.0;

		// Set eariest allowed time for next trace.  (Make it happen more often if dot is close to player)
		if( BystanderPlayerController != None && BystanderPlayerController.Pawn != None 
		 && (Normal(DotLocation-Location) dot Normal(BystanderPlayerController.Pawn.Location-Location)) < 0.819 )  // If dot and player are > 35 deg apart as seen from me
		{
			NextLaserDotTraceTime = Level.TimeSeconds + 0.100;  // Then don't trace as often
		}
		else
		{
			NextLaserDotTraceTime = Level.TimeSeconds + 0.033; // Otherwise, trace very often
		}
	}
	else
	{
		// Estimate, assuming same distance (interpolate between traces)
		DotLocation = LaserStart + X*DotDistance;
	}

	// Move dot to new location
	DotActor.SetLocation( DotLocation );
	DotRotation = rotator(THitNormal);
	DotRotation.Yaw += 8192;
	DotActor.SetRotation( DotRotation );


	NextLaserDotUpdateTime = Level.TimeSeconds + 0.033;
//	NextLaserDotUpdateTime = Level.TimeSeconds;
}

simulated function PlayThirdPersonFireSound
(
	sound				Sound,
	optional ESoundSlot Slot,
	optional float		Volume,
	optional bool		bNoOverride,
	optional float		Radius,
	optional float		Pitch,
	optional bool		Attenuate
)
{
	if( Level.GRI.bGameEnded )
	{
	//	Log("PlayThirdPersonFireSound  after game end  Level.GRI.bGameEnded:"$ Level.GRI.bGameEnded );
		return;
	}

	if( Level.TimeSeconds < TimeOfLastThirdPersonFireSound + 0.05 )
		return;

	// PlaySound will not propagate a sound across the network if it is called
	// from a simulated function.

	if( Instigator != none )
		Instigator.PlaySound(Sound,Slot,Volume,bNoOverride,Radius,Pitch,Attenuate );
	else
		PlaySound(Sound,Slot,Volume,bNoOverride,Radius,Pitch,Attenuate );

	TimeOfLastThirdPersonFireSound = Level.TimeSeconds;

//	Log("  o(((((( PlayThirdPersonFireSound ");
}


// Decompiled with UE Explorer.
defaultproperties
{
    ThirdPersonSound[0]=Sound'CBW_DYN_weapons.M4.M4_FireIndoor_3rd1'
    ThirdPersonSound[1]=Sound'CBW_DYN_weapons.M4.M4_FireOutdoor_3rd1'
    PlayerMuzzleLightClass=Class'PlayerMuzzleLight'
    FadeAlpha=255.0000000
}