class TGPawn_EnemyBase extends TGPawn_LocustBase;

//var protected const GearSoundGroup	SoundGroupB;
var() Controller FiredAroundInstigator;

simulated function PostBeginPlay()
{
	// these need to go there due to this uncrealscipt compiler assertion:
	//Assertion failed: OverrideComponent==BaseTemplate [File:D:\depot_epicgames\code\UnrealEngine3\Development\Src\Editor\Src\UnEdObject.cpp] [Line: 663] OverrideComponent: 'DynamicLightEnvironmentComponent GearGame.Default__TGPawn_LocustBase:MyLightEnvironment' BaseTemplate: 'DynamicLightEnvironmentComponent GearGame.Default__TGPawn_Infantry:MyLightEnvironment' Stack: Address = 0x746f7065 (filename not found)
	LightEnvironment.SetTickGroup( TG_DuringAsyncWork );

	Super.PostBeginPlay();
}

simulated function InitHod()
{
	//hod.animTree = '';
	hod.team = 'axis';
	hod.type = 'human';
	hod.accuracy = 0.1;
	hod.health = 150;
	hod.weapon = 'mp5';
	//hod.secondaryweapon = 'beretta';
	//hod.sidearm = 'beretta';
	hod.grenadeWeapon = 'fraggrenade';
	//hod.grenadeAmmo = 0;

	setEngagementMinDist( 128.000000, 0.000000 );
	setEngagementMaxDist( 512.000000, 1024.000000 );
}

/** Grunts just explode when shot by ride reaver or brumak - like crowd members - save ragdoll perf */
simulated function bool ShouldUseSimpleEffectDeath(class<TGDamageType> TGDamageType)
{
	//if( ClassIsChildOf(TGDamageType, class'TMGame.GDT_RideReaverCannon') ||
	//	ClassIsChildOf(TGDamageType, class'TMGame.GDT_ReaverMinigun') ||
	//	ClassIsChildOf(TGDamageType, class'TMGame.GDT_BrumakBulletPlayer') ||
	//	ClassIsChildOf(TGDamageType, class'TMGame.GDT_BrumakCannonPlayer') ||
	//	ClassIsChildOf(TGDamageType, class'TMGame.GDT_ReaverCannonCheap') )
	//{
	//	return TRUE;
	//}
	//else
	//{
		return FALSE;
	//}
}

simulated function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

    if(Role == ROLE_Authority && bFiredAround && Health > 0)
    {
        hod.NotifySuppressed();
        TriggerEventClass(class'HDSeqEvent_MissTarget', FiredAroundInstigator);

        //clear flag
        bFiredAround = false;
        FiredAroundInstigator = none;
    }
}

function OnFiredAround(Controller iInstigator)
{
   if(!bFiredAround && Health > 0)
   {
       bFiredAround = true;
       FiredAroundInstigator = iInstigator;
   }
}

