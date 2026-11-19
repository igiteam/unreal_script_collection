class GTVipPawn extends ZombiePlayerPawn
native;

const VIPHealth = 150;
var float VIPDamageMult;
event VIPRoundStarting()
{
	if( bDeleteMe )
	{
		log( "NOT cleaning up VIP pawn due to bDeleteMe" );
		return;
	}

	if(Controller!=None)
	{
		Controller.UnPossess();
	}
	/*if( Controller!=None )
		Controller.PawnDied( self );*/
	Destroy();
		
}
function Unpossessed()
{
	//log("GTVipPawn: Unpossessed PRE: " $ Controller@GTVipPlayerController(Controller) @ GTVipPlayerController(Controller).IsVip());
	Health=0;
	Super.Unpossessed();
	//log("GTVipPawn: Unpossessed POST: " $ Controller@GTVipPlayerController(Controller));
}
function PossessedBy(Controller C)
{
	Super.PossessedBy(C);
	//log("GTVipPawn: PossessedBy: " $ Controller@GTVipPlayerController(Controller) @ GTVipPlayerController(Controller).IsVip());
	if (IsVIP())
	{
		Health = VIPHealth;
/*kkm--MERGEALERT
		CurrentWeaponAnims = WA_Pistol;			
		SetMovementAnims ( );
		SetWeaponAnims ( );
*/
	}	
}

function bool IsVip()
{
	//log("GTVipPawn: IsVip: " $ GTVipPlayerController(Controller) @ GTVipPlayerController(Controller).IsVip());

	if (GTVipPlayerController(Controller) == none)
	{
	
		//log("IsVip: not a GTVipPlayerController: " $ Controller);
		return false;
	}

	return GTVipPlayerController(Controller).IsVip();
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType, optional Controller KillerController)
{
	Super.TakeDamage(Damage*VIPDamageMult,instigatedBy,hitLocation,momentum,damagetype,KillerController);
}
event Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	// check validity
	if ( Level.Game != None && IsVIP() )
	{
		if ( Killer != None && Killer.PlayerReplicationInfo != None )
		{
			// suicide
			if ( Killer.Pawn == Self )
			{
				Level.Game.EndGame ( Self.PlayerReplicationInfo, class'GTVIP'.default.VIPCommittedSuicideText );
			}
			else
			{
				Level.Game.EndGame ( Killer.PlayerReplicationInfo, class'GTVIP'.default.KilledVIPText );
			}
		}
		else
		{
			// should never happen
			Level.Game.EndGame ( None, class'GTVIP'.default.VIPDiedText );
		}
	}

	super.Died(Killer, damageType, HitLocation);
}


// Decompiled with UE Explorer.
defaultproperties
{
    VIPDamageMult=1.3000000
}