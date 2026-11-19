// Hacked Health Pickup, used like this until Vertical Slice is over
class TPDroppedIntelPickup extends TPDroppedPickup
	hidecategories(TPDroppedPickup)
	deprecated;

enum EIntelNums
{
	Intel_NYSS_Diary, //0
	Intel_NYBR_Telegram, //1
	Intel_NYBR_Letter, //2
	Intel_NYES_Note, //3
	Intel_NYES_Schedule, //4
	Intel_NYES_Orders, //5
	Intel_DCRD_Factory, //6
	Intel_DCRD_Log, //7
	Intel_DCWH_Report, //8
	Intel_DCWH_Resistance, //9
	Intel_DCWH_Episilon, //10
	Intel_DCWH_Letter, //11
	Intel_UKTL_Diary, //12
	Intel_UKTL_Notebook, //13
	Intel_UKTL_Report, //14
	Intel_UKBR_Diary, //15
	Intel_UKBR_Orders, //16
	Intel_UKZP_Cargo, //17
	Intel_UKZP_Journal //18
};

var() EIntelNums IntelNumber;
var string IntelPickupTitle;
var bool bCheckedValidity;

var() StaticMesh IntelReplacementMesh;

simulated function PostBeginPlay()
{
	IntelPickupTitle = TPGameInfo(WorldInfo.Game).IntelPickupTitle[IntelNumber];

	if (IntelReplacementMesh != None)
		StaticMeshComponent(ActorComp).SetStaticMesh(IntelReplacementMesh);
	//`log("Setting intel pickup title for"@self@"to"@IntelPickupTitle);

	SetPhysics(PHYS_None);
}
simulated function Destroyed()
{
	super.Destroyed();
}

simulated function name GetPickupName ( )
{
    local string PickupName;

	PickupName = "Take Intel";

    return name(PickupName);
}

simulated function Tick(float DeltaTime)
{
	local PlayerController PC;
	local TPPlayerController TPC;

	// Making the relatively safe assumption here that intel pickups are only placed in single player levels...
	if (!bCheckedValidity)
	{
		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			TPC = TPPlayerController(PC);
			if (TPC != None && TPC.ProfileSettings.ProfileSettings.Length != 0)
			{
				if (TPC.PlayerHasIntel(IntelNumber))
				{
					;
					Destroy();
				}
				else
					bCheckedValidity = true;
			}
		}
	}

	super.Tick(DeltaTime);
}

auto state Pickup
{
	event Touch( Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal )
	{
		// Do nothing for intel
	} 

	event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		// Do nothing for intel
	}
}
