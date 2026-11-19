class TPDroppedPickupWeapon extends TPDroppedPickup;

// These are temp var's that hold values set in the editor that will be trasposed ot the actually weapon at
// runtime
var (AI_AudioEvents)	float	m_FiringLoudness;
var (AI_AudioEvents)	float	m_ProjectileImpactLoudness;
var (AI_AudioEvents)	float	m_ProjectileExplodingLoudness;
var (AI_AudioEvents)	float	m_ReloadingLoudness;
var (AI_AudioEvents)	float	m_DroppingLoudness;
var (AI_AudioEvents)	float	m_PickingUpLoudness;

var localized string WeaponTakeString;

simulated function PostBeginPlay()
{
    local TPWeapon TheWeapon;

	super.PostBeginPlay();

	TheWeapon = TPWeapon(Inventory);

	SetWeaponAudioValues(TheWeapon);
}

simulated function name GetPickupName ( )
{
    local string PickupName;

    //PickupName = "Take";
    PickupName = WeaponTakeString;

    PickupName @= class<TPWeapon>(TPSPInventoryClass).default.WeapName;

    return name(PickupName);
}

// Should be overriden by subclasses
//function bool TakeAmmo (Pawn P);
function bool TakeAmmo (Pawn P)
{
    local Inventory MyInv;
    local bool AmmoLeft;
	local TPWeapon tpWeap;

    AmmoLeft= true;
    MyInv = P.InvManager.FindInventoryType(TPSPInventoryClass, true);

    if (MyInv != None)
    {
		tpWeap = TPWeapon(MyInv);

		if ( tpWeap != None && !tpWeap.AmmoCountFull() && !tpWeap.bInfiniteAmmo ) // something wrong here.
        {
            AmmoLeft = tpWeap.TakeAmmo( TPWeapon(Inventory) );
            Inventory.PickupSound = PickupSound;
            Inventory.AnnouncePickup(P);
        }

        if (!AmmoLeft)
		{
			Inventory = None;
			PickedUpBy(P);
        }
    }

    return true;
}

function GiveTo( Pawn P )
{
    local bool Given;
	local TPPlayerController myTPC;
	local MultiplayerPawn mPP;

	if( Inventory != None )
	{
        Given = P.InvManager.AddInventory(Inventory );

		// When giving inventory in multiplayer, the owner ( MPP ) must locally add the animsets in order to play them.
		mPP = MultiplayerPawn( P );
		if ( mPP != None )
			mPP.ClientAddAnimSets( TPWeapon(Inventory) );

        if (Given)
        {
			TriggerEventClass(class'SeqEvent_PlayerPickUpType',self,0);
            Inventory.PickupSound = PickupSound;
            Inventory.AnnouncePickup(P);

			myTPC = TPPlayerController(P.Controller);
			if (myTPC != None)
				myTPC.FadeInHUD();

	        //if (RespawnTime <= 0)
			//{
				Inventory = None;
				PickedUpBy(P);
			//}
			//else
			//{
			//	SetCollision(false, false);
			//	SetHidden(true);
			//	SetTimer(RespawnTime, false, 'RespawnWeapon');
			//}
        }
        else
        {
            TakeAmmo (P);
        }
	}
}

function SetWeaponAudioValues( TPWeapon TheWep )
{
	if( TheWep != None )
	{
		TheWep.m_FiringLoudness					= m_FiringLoudness;
		TheWep.m_ProjectileImpactLoudness		= m_ProjectileImpactLoudness;
		TheWep.m_ProjectileExplodingLoudness	= m_ProjectileExplodingLoudness;
		TheWep.m_ReloadingLoudness				= m_ReloadingLoudness;
		TheWep.m_DroppingLoudness				= m_DroppingLoudness;
		TheWep.m_PickingUpLoudness				= m_PickingUpLoudness;
	}
}

