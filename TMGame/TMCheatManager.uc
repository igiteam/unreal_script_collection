/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// CheatManager
// Object within playercontroller that manages "cheat" commands
// only spawned in single player mode
//=============================================================================

class TMCheatManager extends CheatManager within PlayerController
	native;

var class<LocalMessage> LMC;
var SpeechRecognition RecogObject;

exec function Glow(float F)
{
	local TMVehicle V;

	ForEach DynamicActors(class'TMVehicle' , V)
	{
		V.LightEnvironment.AmbientGlow = MakeLinearColor(F,F,F,1.0);
	}
}

exec function LM( string MessageClassName )
{
	LMC = class<LocalMessage>(DynamicLoadObject(MessageClassName, class'Class'));
}

exec function LMS( int switch )
{
	ReceiveLocalizedMessage(LMC, switch, PlayerReplicationInfo, PlayerReplicationInfo);
}

/** Summon a vehicle */
exec function SummonV( string ClassName )
{
	local class<actor> NewClass;
	local vector SpawnLoc;

	;
	NewClass = class<actor>( DynamicLoadObject( "TMGameContent.TMVehicle_"$ClassName, class'Class' ) );
	if ( NewClass == None )
	{
		NewClass = class<actor>( DynamicLoadObject( "TMGameContent.TMVehicle_"$ClassName$"_Content", class'Class' ) );
	}
	if( NewClass!=None )
	{
		if ( Pawn != None )
			SpawnLoc = Pawn.Location;
		else
			SpawnLoc = Location;
		Spawn( NewClass,,,SpawnLoc + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
	}
}

/* AllWeapons
	Give player all available weapons
*/
exec function AllWeapons()
{
	if( (WorldInfo.NetMode!=NM_Standalone) || (Pawn == None) )
		return;

	GiveWeapon("TMGame.HDWeap_88Sniper");
	//GiveWeapon("TMGame.TMWeap_RocketLauncher");
	//GiveWeapon("TMGame.TMWeap_ShockRifle");
	//GiveWeapon("TMGameContent.TMWeap_Physicsgun");
}

exec function DoubleUp()
{

}

//exec function PhysicsGun()
//{
//	if (Pawn != None)
//	{
//		GiveWeapon("TMGameContent.TMWeap_PhysicsGun");
//	}
//}

/* AllAmmo
	Sets maximum ammo on all weapons
*/
exec function AllAmmo()
{
	if ( (Pawn != None) && (TMInventoryManager(Pawn.InvManager) != None) )
	{
		TMInventoryManager(Pawn.InvManager).AllAmmo(true);
		TMInventoryManager(Pawn.InvManager).bInfiniteAmmo = true;
	}
}

exec function Invisible(bool B)
{
	if ( TMPawn(Pawn) != None )
	{
		TMPawn(Pawn).SetInvisible(B);
	}
}

exec function FreeCamera()
{
	TMPlayerController(Outer).bFreeCamera = !TMPlayerController(Outer).bFreeCamera;
	TMPlayerController(Outer).SetBehindView(TMPlayerController(Outer).bFreeCamera);
}

exec function ViewBot()
{
	local Controller first;
	local bool bFound;
	local AIController C;

	foreach WorldInfo.AllControllers(class'AIController', C)
	{
		if (C.Pawn != None && C.PlayerReplicationInfo != None)
		{
			if (bFound || first == None)
			{
				first = C;
				if (bFound)
				{
					break;
				}
			}
			if (C.PlayerReplicationInfo == RealViewTarget)
			{
				bFound = true;
			}
		}
	}

	if ( first != None )
	{
		SetViewTarget(first);
		TMPlayerController(Outer).SetBehindView(true);
		TMPlayerController(Outer).bFreeCamera = true;
		FixFOV();
	}
	else
		ViewSelf(true);
}

exec function KillBadGuys()
{
	local playercontroller PC;
	local TMPawn p;

	PC = TMPlayerController(Outer);

	if (PC!=none)
	{
		ForEach DynamicActors(class'TMPawn', P)
		{
			if ( !WorldInfo.GRI.OnSameTeam(P,PC) && (PC.Pawn != none && PC.Pawn != P) )
			{
				P.TakeDamage(20000,PC, P.Location, Vect(0,0,0),class'TMDmgType_Rocket');
			}
		}
	}
}

exec function RBGrav(float NewGravityScaling)
{
	WorldInfo.RBPhysicsGravityScaling = NewGravityScaling;
}

/** allows suiciding with a specific damagetype and health value for testing death effects */
exec function SuicideBy(string Type, optional int DeathHealth)
{
	local class<DamageType> DamageType;

	if (Pawn != None)
	{
		if (InStr(Type, ".") == -1)
		{
			Type = "TMGame." $ Type;
		}
		DamageType = class<DamageType>(DynamicLoadObject(Type, class'Class'));
		if (DamageType != None)
		{
			Pawn.Health = DeathHealth;
			if (Pawn.IsA('TMPawn'))
			{
				TMPawn(Pawn).AccumulateDamage = -DeathHealth;
				TMPawn(Pawn).AccumulationTime = WorldInfo.TimeSeconds;
			}
			Pawn.Died(Outer, DamageType, Pawn.Location);
		}
	}
}

exec function EditWeapon(string WhichWeapon)
{
	local TMWeapon Weapon;
	local array<string> weaps;
	local string s;
	local int i;
	if (WhichWeapon != "")
	{
		ConsoleCommand("Editactor class="$WhichWeapon);
	}
	else
	{
		foreach AllActors(class'TMWeapon',Weapon)
		{
			s = ""$Weapon.Class;
			if ( Weaps.Find(s) < 0 )
			{
				Weaps.Length = Weaps.Length + 1;
				Weaps[Weaps.Length-1] = s;
			}
		}

		for (i=0;i<Weaps.Length;i++)
		{
			;
		}
	}
}

/** kills all the bots that are not the current viewtarget */
exec function KillOtherBots()
{
	local TMBot B;

	TMGame(WorldInfo.Game).DesiredPlayerCount = WorldInfo.Game.NumPlayers + 1;
	foreach WorldInfo.AllControllers(class'TMBot', B)
	{
		if ((B.Pawn == None || B.Pawn != ViewTarget) && (B.PlayerReplicationInfo == None || B.PlayerReplicationInfo != RealViewTarget))
		{
			if (B.Pawn != None)
			{
				B.Pawn.Suicide();
			}
			B.Destroy();
		}
	}
}



//// START:  Decal testing code
exec function SpawnABloodDecal2()
{
	LeaveADecal2( Pawn.Location, vect(0,0,0) );
}

simulated function LeaveADecal2( vector HitLoc, vector HitNorm )
{
	local TMGib Gib;

	Gib = Spawn( class'TMGib_HumanTorso',,, Pawn.location + vect(0,0,150),,, TRUE );
	Gib.GibMeshComp.WakeRigidBody();
}


exec function SpawnABloodDecal()
{
	LeaveADecal( Pawn.Location, vect(0,0,0) );
}

simulated function LeaveADecal( vector HitLoc, vector HitNorm )
{
	local MaterialInstance MIC_Decal;
	local Actor TraceActor;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local TraceHitInfo HitInfo;

	// these should be randomized
	TraceStart = HitLoc + ( Vect(0,0,15));
	TraceDest =  HitLoc - ( Vect(0,0,100));

	TraceActor = Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, TRACEFLAG_PhysicsVolumes );

	if( TraceActor != None )
	{
		MIC_Decal = new(Outer) class'MaterialInstanceTimeVarying';
		//MIC_Decal.SetParent( MaterialInstanceTimeVarying'CH_Gibs.Decals.BloodSplatter' );

		WorldInfo.MyDecalManager.SpawnDecal(MIC_Decal, out_HitLocation, rotator(-out_HitNormal), 200, 200, 10, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);

		MaterialInstanceTimeVarying(MIC_Decal).SetScalarStartTime( 'DissolveAmount',  3.0f );
		MaterialInstanceTimeVarying(MIC_Decal).SetScalarStartTime( 'BloodAlpha',  3.0f );
		MIC_Decal.SetScalarParameterValue( 'DissolveAmount',  3.0f );
		MIC_Decal.SetScalarParameterValue( 'BloodAlpha',  3.0f );
	}
}

/** Cheat that unocks all possible characters. */
exec native function UnlockAllChars();


exec function TiltIt( bool bActive )
{
	SetControllerTiltActive( bActive );
}


exec function ShowStickBindings()
{
	local int BindIndex;
	;

	for( BindIndex = 0; BindIndex < PlayerInput.Bindings.Length; ++BindIndex )
	{
		if( ( PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_LeftX' )
			||  ( PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_LeftY' )
			||  ( PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightX' )
			||  ( PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightY' )
			||  ( PlayerInput.Bindings[BindIndex].Name == 'GBA_Look_Gamepad' )

			)
		{
			;
			//PlayerInput.Bindings[BindIndex].Command = TheCommand;
		}
		//`log( " " $ PlayerInput.Bindings[BindIndex].Command );
	}
}

exec function SetStickBind( float val )
{
	local int BindIndex;
	local string cmd;

	;

	for( BindIndex = 0; BindIndex < PlayerInput.Bindings.Length; ++BindIndex )
	{
		if(
			( PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightY' )
			||  ( PlayerInput.Bindings[BindIndex].Name == 'GBA_Look_Gamepad' )
			)
		{
			cmd = "Axis aLookup Speed=" $ val $ " DeadZone=0.3";
			PlayerInput.Bindings[BindIndex].Command = cmd;
			;
		}
	}
}


