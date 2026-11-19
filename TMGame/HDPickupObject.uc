class HDPickupObject extends HDDroppedPickup
	placeable;

var() class<HDWeapon>   WeaponClass;
var() bool              bInfinit;
var() int               Ammo1;
var() int               Ammo2;
var() bool              bClearBullets;
var() float             RespawnTime;


event PostBeginPlay()
{
	local HDWeapon tmw;

	if (WeaponClass == none)
	{
		Destroy();
		return;
	}

	tmw = Spawn(WeaponClass);
	if(tmw.DroppedPickupClass == None || tmw.DroppedPickupMesh == None)
	{
		tmw.Destroy();
		Destroy();
		return;
	}

	SetPhysics(PHYS_Falling);
	SetPickupMesh(tmw.DroppedPickupMesh);
	SetPickupParticles(tmw.DroppedPickupParticles);
	Inventory = tmw;
	InventoryClass = WeaponClass;
}

simulated function SpawnInventory()
{
    SyncSetPickupableFlag(True);
}

auto state Pickup
{
	function bool PickupItem(Pawn other, out HDWeapon weapon)
	{
		local HDWeapon temp;

		if (Inventory != none && !Inventory.bDeleteMe )
		{
			temp = weapon;
			if ( temp != none )
			    temp.Drop();

            weapon = HDWeapon(Inventory);
			weapon.AnnouncePickup(Other);
			weapon.GiveTo(Other);

			if(Ammo1 >= 0)
			{
			   if(bClearBullets)
			       weapon.AddBulletCount(-10000, 0);

               weapon.AddAmmoCount(-10000, 0);
               weapon.AddAmmoCount(Ammo1, 0);
			}
			if(Ammo2 >= 0)
			{
			   //clear
			   if(bClearBullets)
		           weapon.AddBulletCount(-10000, 1);

               weapon.AddAmmoCount(-10000, 1);
               weapon.AddAmmoCount(Ammo2, 1);
			}

            if ( !bInfinit )
            {
                Inventory = temp;
			}
			else
			{
                if ( RespawnTime > 0 )
                {
                    SyncSetPickupableFlag(False);
                    SetTimer( RespawnTime + 0.01, false, 'SpawnInventory' );
                }
                else
                {
                    SpawnInventory();
                }

			}
		}

		if (Inventory == none)
			return false;

		LifeSpan = default.LifeSpan;
		return true;
	}

    // pick by pawn
    function PickedUpBy(Pawn P)
    {
        if ( !bInfinit )
        {
            Global.PickedUpby(P);
            return;
        }
        //Inventory = None;
        Inventory.Instigator = None;
        Inventory.Destroy();
        if ( RespawnTime > 0 )
        {
            SyncSetPickupableFlag(False);
            SetTimer( RespawnTime + 0.01, false, 'SpawnInventory' );
        }
        else
        {
            SpawnInventory();
        }
    }
}

reliable sync function SyncSetPickupableFlag( bool bFlag )
{
    bPickupable = bFlag;
    if ( !bFlag )
        PickupMesh.SetScale(0);
    else
    {
        Inventory = Spawn(WeaponClass);
        PickupMesh.SetScale(PickupMesh.default.Scale);
    }
}

