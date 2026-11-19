class TGPawn_LocustBase extends TGPawn_Infantry
	dependson(TGPawn_Infantry)
	abstract
	native(TGPawn)
	config(TGPawn);

simulated function PostBeginPlay()
{
	// these need to go there due to this uncrealscipt compiler assertion:
	//Assertion failed: OverrideComponent==BaseTemplate [File:D:\depot_epicgames\code\UnrealEngine3\Development\Src\Editor\Src\UnEdObject.cpp] [Line: 663] OverrideComponent: 'DynamicLightEnvironmentComponent GearGame.Default__TGPawn_LocustBase:MyLightEnvironment' BaseTemplate: 'DynamicLightEnvironmentComponent GearGame.Default__TGPawn_Infantry:MyLightEnvironment' Stack: Address = 0x746f7065 (filename not found)
	LightEnvironment.SetTickGroup( TG_DuringAsyncWork );

	Super.PostBeginPlay();
}


simulated function ChainSawGore()
{
	BreakConstraint( vect(100,0,0), vect(0,10,0), 'b_MF_Spine_03' );
	BreakConstraint( vect(0,100,0), vect(0,0,10), 'b_MF_UpperArm_R' );
}

simulated function byte GetMPWeaponColorBasedOnClass()
{
	return 1;
}

function int GetMaxDownCount()
{
	// locust always return max down count.. cuz in MP we would use maxdown anyway, and we don't play as locust in SP
	return MaxDownCount;
}

simulated function RemoveAndSpawnAHelmet( Vector ApplyImpulse, class<DamageType> DamageType, bool bForced )
{
	Super.RemoveAndSpawnAHelmet(ApplyImpulse,DamageType,bForced);

	if( Role == ROLE_Authority )
	{
		ServerDoSpecialMove(SM_CoverHead);
	}
}

