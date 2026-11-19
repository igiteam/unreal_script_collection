class arrival_main extends CoreTask within animscripts_cover_arrival;

// parameter

// output

// local
var name newstance;
var name arrivalAnim;

state main
{
Begin:
	endon('killanimscript');

//	if (isdefined(self.doMiniArrival))
//	{
//		self.doMiniArrival = undefined;
//		node = self.miniArrivalNode;
//		self.miniArrivalNode = undefined;
//		self DoMiniArrival(node);
//		return;
//	}

	newstance = '';

	assert(isdefined(approachtype));

	arrivalAnim = anim.coverTrans[TransTypeID(approachtype)].data[approachnumber];
	assert(isdefined(arrivalAnim));

	switch (approachtype)
	{
	case 'exposed':
	case 'exposed_crouch':
		arrivalAnim = SetCustomAnim(exposed_modern, arrivalAnim);
		break;

	case 'crouch':
	case 'stand':
	case 'left_crouch':
	case 'right_crouch':
	case 'left':
	case 'right':
		arrivalAnim = SetCustomAnim(misc_modern, arrivalAnim);
		break;

	default:
		break;
	}

	switch (approachtype)
	{
	case 'left':
	case 'right':
	case 'stand':
	case 'stand_saw':
	case 'exposed':
		newstance = 'stand';
		break;

	case 'left_crouch':
	case 'right_crouch':
	case 'crouch_saw':
	case 'crouch':
	case 'exposed_crouch':
		newstance = 'crouch';
		break;

	case 'prone_saw':
		newstance = 'prone';
		break;

	default:
		//assertmsg('bad node approach type: ' + self.approachtype);
		_return();
	}

	setFlaggedAnimKnobAllRestart('coverArrival', arrivalAnim, 'body', 1, 0.3, 1);
	animscripts_shared.DoNoteTracks('coverArrival');

	if (isdefined(newstance))
		a.pose = newstance;
	a.movement = 'stop';

	a.arrivalType = approachType;

	// we rely on cover to start doing something else with animations very soon.
	// in the meantime, we don't want any of our parent nodes lying around with positive weights.
	clearanim('root', 0.3);
}
