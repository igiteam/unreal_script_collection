class corner_TryThrowingGrenade extends BoolTask within animscripts_corner;

// parameter
var HodEntity iThrowAt;
var bool iSafe;

// local
var name lTheAnim;
var bool lThrewGrenade;

state main
{
Begin:
//	if (!mayMoveToPoint(getPredictedPathMidpoint()))
//		_return (false);
//	
//	lTheAnim = '';
//	if (iSafe)
//	{
//		if (!animscripts_utility.animArrayAnyExist('grenade_safe'))
//			_return (false);
//		lTheAnim = animscripts_utility.animArray('grenade_safe');
//	}
//	else
//	{
//		if (!animscripts_utility.animArrayAnyExist('grenade_exposed'))
//			_return (false);
//		lTheAnim = animscripts_utility.animArray('grenade_exposed');
//	}
//	
//	animMode ('zonly_physics'); // Unlatch the feet
//	keepClaimedNodeInGoal = true;
//	
////	armOffset = (32,20,64); // needs fixing!
//	lThrewGrenade = TryGrenade(iThrowAt, lTheAnim);
//	
//	keepClaimedNodeInGoal = false;
//	_return (lThrewGrenade);
}
