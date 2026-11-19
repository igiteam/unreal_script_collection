class animscripts_cover_right extends animscripts_corner;

// (Note that animations called left are used with right corner nodes, and vice versa.)

function main(optional bool newThread = false)
{
	current_corner_script = animscripts_cover_right;
	run (new(self) class'cover_right_main', newThread);
}

function set_anim_array_hiding(name iStance)
{
	switch (iStance)
	{
	case 'stand':
		set_animarray_standing_right();
		break;

	case 'crouch':
		set_animarray_crouching_right();
		break;

	default:
		assert (false);
	}
}

function set_animarray_standing_right() /* void */
{
	ResetAnimArray();

	SetAnimArray('hide_idle', 'cornerR_stand_hide_idle');
	SetAnimArray('hide_idle_twitch', 'cornerR_stand_hide_twitch_v1');
	SetAnimArray('hide_idle_twitch', 'cornerR_stand_hide_twitch_v2');
	SetAnimArray('hide_idle_twitch', 'cornerR_stand_hide_twitch_v3');
	SetAnimArray('hide_idle_twitch', 'cornerR_stand_hide_twitch_v4');
	SetAnimArray('hide_idle_twitch', 'cornerR_stand_hide_twitch_v5');
	SetAnimArray('hide_idle_twitch', 'cornerR_stand_hide_twitch_v6');
	SetAnimArray('hide_idle_twitch', 'cornerR_stand_hide_twitch_v7');

	SetAnimArray('hide_idle_flinch', 'cornerR_stand_flinch_v1');
	SetAnimArray('hide_idle_flinch', 'cornerR_stand_flinch_v2');
//	
//	//array['hide_to_C'] = %cornerR_stand_hide_2_C;
//	//array['B_to_C'] = %cornerR_stand_B_2_C;
//	//array['C_to_hide'] = %cornerR_stand_C_2_hide;
//	//array['C_to_B'] = %cornerR_stand_C_2_B;
	SetAnimArray('hide_to_A', 'cornerR_stand_hide_2_A_v1');
	SetAnimArray('hide_to_A', 'cornerR_stand_hide_2_A_v2');
	SetAnimArray('hide_to_B', 'cornerR_stand_hide_2_B_v1');
	SetAnimArray('hide_to_B', 'cornerR_stand_hide_2_B_v2');
	SetAnimArray('hide_to_B', 'cornerR_stand_hide_2_B_v3');
	SetAnimArray('A_to_hide', 'cornerR_stand_A_2_hide_v1');
	SetAnimArray('A_to_hide', 'cornerR_stand_A_2_hide_v2');
	//SetAnimArray('A_to_hide_reload', ']'); = array();
	SetAnimArray('A_to_B', 'cornerR_stand_A_2_B_v1');
	SetAnimArray('A_to_B', 'cornerR_stand_A_2_B_v2');
	SetAnimArray('B_to_hide', 'cornerR_stand_B_2_hide_v1');
	SetAnimArray('B_to_hide', 'cornerR_stand_B_2_hide_v2');
	SetAnimArray('B_to_hide', 'cornerR_stand_B_2_hide_v3');
	SetAnimArray('B_to_hide_reload', 'cornerR_stand_reload_B_2_hide');
	SetAnimArray('B_to_A', 'cornerR_stand_B_2_A_v1');
	SetAnimArray('B_to_A', 'cornerR_stand_B_2_A_v2');
	SetAnimArray('lean_to_hide', 'cornerR_stand_lean_2_hide');
	SetAnimArray('hide_to_lean', 'cornerR_stand_hide_2_lean');
	SetAnimArray('look', 'cornerR_stand_look');
	SetAnimArray('reload', 'cornerR_stand_reload_v1');// , %cornerR_stand_reload_v2); // v2 isn't finished, it seems
	SetAnimArray('grenade_exposed', 'cornerR_stand_grenade_exposed');
	SetAnimArray('grenade_safe', 'cornerR_stand_grenade_safe');
//	
	SetAnimArray('blind_fire', 'cornerR_stand_blindfire_v1');
	SetAnimArray('blind_fire', 'cornerR_stand_blindfire_v2');
//	
	SetAnimArray('rambo', 'cornerR_stand_rambo_dive_v1');
	SetAnimArray('rambo', 'cornerR_stand_rambo_dive_v2');
	SetAnimArray('rambo', 'cornerR_stand_rambo_jam');
	SetAnimArray('rambo', 'cornerR_stand_rambo_short');
	SetAnimArray('rambo', 'cornerR_stand_rambo_med');
	SetAnimArray('hide_to_look', 'cornerR_stand_hide_2_look');
	SetAnimArray('look_to_hide', 'cornerR_stand_look_2_hide');
	SetAnimArray('look_to_hide_fast', 'cornerR_stand_look_2_hide_fast');
	SetAnimArray('look_idle', 'cornerR_stand_look_idle');
	SetAnimArray('stance_change', 'cornerR_stand_2_crouch');
//
	SetAnimArray('lean_aim_down', 'cornerR_stand_lean_2');
	SetAnimArray('lean_aim_left', 'cornerR_stand_lean_4');
	SetAnimArray('lean_aim_straight', 'cornerR_stand_lean');
	SetAnimArray('lean_aim_right', 'cornerR_stand_lean_6');
	SetAnimArray('lean_aim_up', 'cornerR_stand_lean_8');
	SetAnimArray('lean_reload', 'cornerR_stand_lean_reload');
//	
	SetAnimArray('lean_idle', 'cornerR_stand_lean_idle');
//
	SetAnimArray('lean_single', 'cornerR_stand_lean_fire');
//	//array['lean_burst'] = %cornerR_stand_lean_autoburst;
	SetAnimArray('lean_fire', 'cornerR_stand_lean_auto');

	hideYawOffset = 90;
}

function set_animarray_crouching_right()
{
	ResetAnimArray();

	SetAnimArray('hide_idle', 'cornerR_crouch_hide_idle');
	SetAnimArray('hide_idle_twitch', 'cornerR_crouch_hide_twitch_v1');
	SetAnimArray('hide_idle_twitch', 'cornerR_crouch_hide_twitch_v2');
	SetAnimArray('hide_idle_twitch', 'cornerR_crouch_hide_twitch_v3');

	//SetAnimArray('hide_idle_flinch', ']'); = array();

//	//array['hide_to_C'] = %cornerR_crouch_hide_2_C;
//	//array['B_to_C'] = %cornerR_crouch_B_2_C;
//	//array['C_to_hide'] = %cornerR_crouch_C_2_hide;
//	//array['C_to_B'] = %cornerR_crouch_C_2_B;
	SetAnimArray('hide_to_A', 'cornerR_crouch_hide_2_A');
	SetAnimArray('hide_to_B', 'cornerR_crouch_hide_2_B');
	SetAnimArray('A_to_hide', 'cornerR_crouch_A_2_hide');
	//SetAnimArray('A_to_hide_reload', ']'); = array();
	SetAnimArray('A_to_B', 'cornerR_crouch_A_2_B');
	SetAnimArray('B_to_hide', 'cornerR_crouch_B_2_hide');
	//SetAnimArray('B_to_hide_reload', 'cornerR_crouch_reload_B_2_hide');
	SetAnimArray('B_to_A', 'cornerR_crouch_B_2_A');
	SetAnimArray('reload', 'cornerR_crouch_reload_v1');
	SetAnimArray('reload', 'cornerR_crouch_reload_v2');
	SetAnimArray('grenade_exposed', 'cornerR_crouch_grenade');
	SetAnimArray('grenade_safe', 'cornerR_crouch_grenade'); // TODO: need a unique animation for this; use the exposed throw because not having it limits the options of the AI too much
	
	//SetAnimArray('blind_fire', ']'); = array();

	//SetAnimArray('rambo', ']'); = array();
	
	SetAnimArray('hide_to_look', 'cornerR_crouch_hide_2_look');
	SetAnimArray('look_to_hide', 'cornerR_crouch_look_2_hide');
	SetAnimArray('look_to_hide_fast', 'cornerR_crouch_look_2_hide_fast'); // there's a v2 we could use for this also if we want
	SetAnimArray('look_idle', 'cornerR_crouch_look_idle');
	SetAnimArray('stance_change', 'cornerR_crouch_2_stand');

	
	hideYawOffset = 90;
}
