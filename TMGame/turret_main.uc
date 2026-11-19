class turret_main extends CoreTask within HodAI;

// local
var name lDesiredPose;
var float lYaw;
var float lBase;
var float lDelta;
var float lAnim;
var array<string> lLeftAnims;
var array<string> lRightAnims;
var Turret lTurret;
var float lPitch;


state main
{
	function float myFrac(float t)
	{
		return abs(t - int(t));
	}

Begin:
	endon ('killanimscript');

	trackScriptState('Turret Main', "code");
	animscripts_utility.initialize('turret');

	lLeftAnims.AddItem("center");
	lLeftAnims.AddItem("left15");
	lLeftAnims.AddItem("left30");
	lLeftAnims.AddItem("left45");
	lLeftAnims.AddItem("left30");

	lRightAnims.AddItem("center");
	lRightAnims.AddItem("right15");
	lRightAnims.AddItem("right30");
	lRightAnims.AddItem("right45");
	lRightAnims.AddItem("right30");

    lTurret = Turret(Pawn.DrivenVehicle);

	//if (Pawn.DrivenVehicle != none)
	//	OrientMode('face angle', RotatorToAngles(Pawn.DrivenVehicle.Rotation).yaw);
	SetAnimKnobAll(SetCustomAnim(turret, 'turret_aim_center'), 'root', 1, 0);
	wait (0.2);
	lYaw = angles.yaw;
	lBase = 0;
	while (lTurret != none)
	{
		wait(0.05);
		lDelta = AngleClamp180(angles.yaw - lYaw);
		if (abs(lDelta) > 1.f)
		{
			if (lDelta > 0)
				lDelta = 1.f;
			else
				lDelta = -1.f;
		}

		lDelta = lDelta / 15;
		lYaw = angles.yaw;
		lBase = lBase + lDelta;

		ClearAnim('turret', 0.05);
		SetAnim('turret', 1, 0);

		lPitch = FClamp(AngleClamp180(RotatorToAngles(lTurret.AimDir).Pitch) / 45.0, -1, 1);
		if (lBase >= 0)
		{
			if (lBase > 2)
				lBase = myFrac((lBase - 2) / 2) * 2 + 2;

			SetAnimLimited(SetCustomAnim(turret, name("turret_aim_" $ lRightAnims[int(lBase)])), (1.0 - myFrac(lBase)) * (1.0 - Abs(lPitch)), 0.05);
			SetAnimLimited(SetCustomAnim(turret, name("turret_aim_" $ lRightAnims[int(lBase) + 1])), myFrac(lBase) * (1.0 - Abs(lPitch)), 0.05);

			if (lPitch >= 0)
			{
				SetAnimLimited(SetCustomAnim(turret, name("turret_up_" $ lRightAnims[int(lBase)])), (1.0 - myFrac(lBase)) * Abs(lPitch), 0.05);
				SetAnimLimited(SetCustomAnim(turret, name("turret_up_" $ lRightAnims[int(lBase) + 1])), myFrac(lBase) * Abs(lPitch), 0.05);
			}
			else
			{
				SetAnimLimited(SetCustomAnim(turret, name("turret_down_" $ lRightAnims[int(lBase)])), (1.0 - myFrac(lBase)) * Abs(lPitch), 0.05);
				SetAnimLimited(SetCustomAnim(turret, name("turret_down_" $ lRightAnims[int(lBase) + 1])), myFrac(lBase) * Abs(lPitch), 0.05);
			}

		}
		else
		{
			lBase = -lBase;
			if (lBase > 2)
				lBase = myFrac((lBase - 2) / 2) * 2 + 2;

			SetAnimLimited(SetCustomAnim(turret, name("turret_aim_" $ lLeftAnims[int(lBase)])), (1.0 - myFrac(lBase)) * (1.0 - Abs(lPitch)), 0.05);
			SetAnimLimited(SetCustomAnim(turret, name("turret_aim_" $ lLeftAnims[int(lBase) + 1])), myFrac(lBase) * (1.0 - Abs(lPitch)), 0.05);

			if (lPitch >= 0)
			{
				SetAnimLimited(SetCustomAnim(turret, name("turret_up_" $ lLeftAnims[int(lBase)])), (1.0 - myFrac(lBase)) * Abs(lPitch), 0.05);
				SetAnimLimited(SetCustomAnim(turret, name("turret_up_" $ lLeftAnims[int(lBase) + 1])), myFrac(lBase) * Abs(lPitch), 0.05);
			}
			else
			{
				SetAnimLimited(SetCustomAnim(turret, name("turret_down_" $ lLeftAnims[int(lBase)])), (1.0 - myFrac(lBase)) * Abs(lPitch), 0.05);
				SetAnimLimited(SetCustomAnim(turret, name("turret_down_" $ lLeftAnims[int(lBase) + 1])), myFrac(lBase) * Abs(lPitch), 0.05);
			}
			lBase = -lBase;
		}
	}
}
