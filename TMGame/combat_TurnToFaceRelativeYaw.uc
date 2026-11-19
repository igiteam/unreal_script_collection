class combat_TurnToFaceRelativeYaw extends CoreTask within animscripts_combat;

// parameter
var float iFaceYaw;

// output
var bool oResult;

// local

state main
{
Begin:
	if (iFaceYaw < 0-turnThreshold)
	{
		if (a.pose == 'prone')
		{
			animscripts_cover_prone.proneTo('crouch');
			set_animarray_crouching();
			setupAim(0.2);
		}

		turn('left', 0-iFaceYaw);
		maps__gameskill.didSomethingOtherThanShooting();
		oResult = true;
		_return (true);
	}
	if (iFaceYaw > turnThreshold)
	{
		if (a.pose == 'prone')
		{
			animscripts_cover_prone.proneTo('crouch');
			set_animarray_crouching();
			setupAim(0.2);
		}

		turn('right', iFaceYaw);
		maps__gameskill.didSomethingOtherThanShooting();
		oResult = true;
		_return (true);
	}
	oResult = false;
	_return (true);
}
