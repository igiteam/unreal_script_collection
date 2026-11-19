//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDDroppedPickup extends TMDroppedPickup
      native(HDGame);

var() float             BastTranslationOffset;

event Destroyed()
{
    local HDPawn HDP;
    //1 notify Instigator clear best_pickup
    HDP = HDPawn(Instigator);
    if ( HDP != None )
    {
        HDP.ClearBestPickupObject();
    }
    if ( Inventory != None )
        Inventory.Instigator = None;
    Super.Destroyed();
}


function bool IsValidTouch(HDPawn P)
{
    return false;
}

function bool PickupItem(Pawn other, out HDWeapon weapon)
{
	return true;
}

simulated event SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
    local rotator TmpRot;

	if (PickupMesh != none)
	{
		DetachComponent(PickupMesh);
		PickupMesh = none;
	}

	super.SetPickupMesh(NewPickupMesh);

    if (PickupMesh != none)
    {
	    TmpRot.Roll = 90.0 / 360.0 * 65536.0;
	    PickupMesh.SetRotation(TmpRot);
	    PickupMesh.SetTranslation(Vect(0,0,1) *  BastTranslationOffset);
    }
}

simulated event SetPickupParticles(ParticleSystemComponent NewPickupParticles)
{
	if (PickupParticles != none)
	{
		DetachComponent(PickupParticles);
		PickupParticles = none;
	}

	super.SetPickupParticles(NewPickupParticles);
}

auto state Pickup
{
	// When touched by an actor.
	event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
	{
		local HDPawn P;
		P = HDPawn(Other);
		if (P != none)
			P.TouchDroppedPickup(self);
	}

	event Untouch(Actor Other)
	{
		local HDPawn P;
		P = HDPawn(Other);
		if (P != none)
			P.UntouchDroppedPickup(self);
	}

    function CheckTouching()
	{
	}

	function bool IsValidTouch(HDPawn Other)
	{
	    local HDWeapon OtherWeapon, ThisWeapon, ConstHoldWeapon;

        if ( bDeleteMe || Inventory.bDeleteMe )
            return false;

        if (!bPickupable)
	        return false;

        if ( Instigator != None && Instigator != Other )
            return false;

		// make sure its a live player
		if (Other == None || !Other.bCanPickupInventory || (Other.DrivenVehicle == None && Other.Controller == None))
			return false;

		// make sure thrower doesn't run over own weapon
		if ( (Physics == PHYS_Falling) && (Other == Instigator) && (Velocity.Z > 0) )
			return false;

		// make sure not touching through wall
		if ( !FastTrace(Other.Location, Location) )
			return false;


        OtherWeapon = HDWeapon(Other.Weapon);
        ThisWeapon = HDWeapon(Inventory);

        // grenade do not pickup weapon
        if ( OtherWeapon.HDWeaponType == EWEAPON_GRENADE ) return false;


        // const hold weapon cannot pickup
        ConstHoldWeapon = Other.GetConstHoldWeapon();
        if ( ConstHoldWeapon != None && ThisWeapon.HDWeaponType == EWEAPON_SPECIAL )
            return False;

        // in MP mode, only LONG - LONG and SHORT - SHORT
        if (HDBaseGame(WorldInfo.Game).bMatchingWeaponSwitch && ThisWeapon.HDWeaponType != EWEAPON_SPECIAL )
        {
            if ( OtherWeapon == None || ThisWeapon == None )
            {
                return false;
            }
            if ( OtherWeapon != None && ThisWeapon != None && OtherWeapon.HDWeaponType != ThisWeapon.HDWeaponType )
            {
                return true;//false; could promte pick up info
            }
        }

		// make sure game will let player pick me up
		if (WorldInfo.Game.PickupQuery(Other, Inventory.class, self))
			return true;

		return false;
	}

	function bool PickupItem(Pawn other, out HDWeapon weapon)
	{
		local HDWeapon temp;

		if (Inventory != none)
		{
			temp = weapon;
			if ( temp != none )
			    temp.Drop();

            weapon = HDWeapon(Inventory);
			weapon.AnnouncePickup(Other);
			weapon.GiveTo(Other);

			Inventory = temp;
		}

		if (Inventory == none)
			return false;
		LifeSpan = default.LifeSpan;
		return true;
	}

	event BeginState(Name PreviousStateName)
	{
		AddToNavigation();
	}

	event EndState(Name NextStateName)
	{
		RemoveFromNavigation();
	}
}

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    SetCollisionType(COLLIDE_TouchAllButWeapons);
    bCanStepUpOn=FALSE;
    bBounce = FALSE;
    Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	RotationRate = rot(0,0,0);
	SetCollision(TRUE, FALSE, FALSE);
	SetPhysics(PHYS_None);

}

simulated event Landed( vector HitNormal, actor FloorActor )
{
	HitWall(HitNormal, FloorActor, None);
}

event PreBeginPlay()
{
	Super.PreBeginPlay();
	bPickupable = TRUE;
}

function UnPossessed()
{
    Instigator = None;
    LifeSpan = default.LifeSpan;
}

function PossessedByPawn( HDPawn pawnOwner )
{
    Instigator = pawnOwner;
    LifeSpan = 0;
}


