//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_Pistol extends HDConventionalWeapon
    abstract;

// Recoil function
simulated function CalculateRecoil();
simulated function RecoverRecoil( float DeltaTime );

simulated function bool IsPrimaryWeapon(){return False;}

simulated state Active
{
	simulated event OnAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
	{
		local int IdleIndex;
		local HDPawn	HDP;
		local name	animName;

		HDP = HDPawn(Instigator);
		if ( HDP == none )
			return;

		if ( WorldInfo.NetMode != NM_DedicatedServer && WeaponIdleAnims.Length > 0 )
		{
			IdleIndex = (ClipBulletCount[CurrentFireModeType] != 0) ? 0 : 1;
			if ( WeaponIdleAnims.Length > IdleIndex )
			{
                animName = ( (HDP.bSprintTag == true)&&(WeaponSprintLoops.Length>IdleIndex) )? WeaponSprintLoops[IdleIndex] : WeaponIdleAnims[IdleIndex];
                PlayWeaponAnimation(animName, 0.0, true);
            }
            IdleIndex = CurrentFireModeType;
			if(ArmIdleAnims.Length > IdleIndex && ArmsAnimSet != none)
			{
				animName = ((HDP.bSprintTag == true)&&(ArmSprintLoops.Length>IdleIndex))? ArmSprintLoops[IdleIndex] : ArmIdleAnims[IdleIndex];
                PlayArmAnimation(animName, 0.0,, true);
			}
		}

		// local reload internal
        if ( HDP.IsLocallyControlled() )
            ReloadWeapon();
	}
}
