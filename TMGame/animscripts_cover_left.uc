class animscripts_cover_left extends animscripts_corner;

// (Note that animations called right are used with left corner nodes, and vice versa.)

function main(optional bool newThread = false)
{
	current_corner_script = animscripts_cover_left;
	run (new(self) class'cover_left_main', newThread);
}

function set_anim_array_hiding(name iStance)
{
	switch (iStance)
	{
	case 'stand':
		set_animarray_standing_left();
		break;

	case 'crouch':
		set_animarray_crouching_left();
		break;

	default:
		assert (false);
	}
}

function set_animarray_standing_left() /* void */ 
{
	ResetAnimArray();

	SetAnimArray('hide_idle', 'cornerL_stand_hide_idle');
	SetAnimArray('hide_idle_twitch', 'cornerL_stand_hide_twitch_v1');
	SetAnimArray('hide_idle_twitch', 'cornerL_stand_hide_twitch_v2');
	SetAnimArray('hide_idle_twitch', 'cornerL_stand_hide_twitch_v3');
	SetAnimArray('hide_idle_twitch', 'cornerL_stand_hide_twitch_v4');
	SetAnimArray('hide_idle_twitch', 'cornerL_stand_hide_twitch_v5');
	SetAnimArray('hide_idle_twitch', 'cornerL_stand_hide_twitch_v6');
	SetAnimArray('hide_idle_twitch', 'cornerL_stand_hide_twitch_v7');

	SetAnimArray('hide_idle_flinch', 'cornerL_stand_flinch');
//
//	//array["hide_to_C"] = %cornerL_stand_hide_2_C;
//	//array["B_to_C"] = %cornerL_stand_B_2_C;
//	//array["C_to_hide"] = %cornerL_stand_C_2_hide;
//	//array["C_to_B"] = %cornerL_stand_C_2_B;
	SetAnimArray('hide_to_A', 'cornerL_stand_hide_2_A_v1');
	SetAnimArray('hide_to_A', 'cornerL_stand_hide_2_A_v2');
	SetAnimArray('hide_to_A', 'cornerL_stand_hide_2_A_v3');
	SetAnimArray('hide_to_B', 'cornerL_stand_hide_2_B_v1');
	SetAnimArray('hide_to_B', 'cornerL_stand_hide_2_B_v2');
	SetAnimArray('A_to_hide', 'cornerL_stand_A_2_hide_v1');
	SetAnimArray('A_to_hide', 'cornerL_stand_A_2_hide_v2');
	//SetAnimArray('A_to_hide_reload', "]'); = array();
	SetAnimArray('A_to_B', 'cornerL_stand_A_2_B_v1');
	SetAnimArray('A_to_B', 'cornerL_stand_A_2_B_v2');
	SetAnimArray('B_to_hide', 'cornerL_stand_B_2_hide_v1');
	SetAnimArray('B_to_hide', 'cornerL_stand_B_2_hide_v2');
	SetAnimArray('B_to_hide_reload', 'cornerL_stand_reload_B_2_hide');
	SetAnimArray('B_to_A', 'cornerL_stand_B_2_A_v1');
	SetAnimArray('B_to_A', 'cornerL_stand_B_2_A_v2');
	SetAnimArray('lean_to_hide', 'cornerL_stand_lean_2_hide');
	SetAnimArray('hide_to_lean', 'cornerL_stand_hide_2_lean');
	SetAnimArray('look', 'cornerL_stand_look');
	SetAnimArray('reload', 'cornerL_stand_reload_v1');//, %cornerL_stand_reload_v2 );
	SetAnimArray('grenade_exposed', 'cornerL_stand_grenade_exposed');
	SetAnimArray('grenade_safe', 'cornerL_stand_grenade_safe');
	
	SetAnimArray('blind_fire', 'cornerL_stand_blindfire_v1');
	SetAnimArray('blind_fire', 'cornerL_stand_blindfire_v2');
	
	SetAnimArray('rambo', 'cornerL_stand_rambo_set');
	SetAnimArray('rambo', 'cornerL_stand_rambo_jam');
	
	SetAnimArray('hide_to_look', 'cornerL_stand_hide_2_look');
	SetAnimArray('look_to_hide', 'cornerL_stand_look_2_hide');
	SetAnimArray('look_to_hide_fast', 'cornerL_stand_look_2_hide_fast');
	SetAnimArray('look_idle', 'cornerL_stand_look_idle');
	SetAnimArray('stance_change', 'cornerL_stand_2_crouch');
//	
	SetAnimArray('lean_aim_down', 'cornerL_stand_lean_2');
	SetAnimArray('lean_aim_left', 'cornerL_stand_lean_4');
	SetAnimArray('lean_aim_straight', 'cornerL_stand_lean');
	SetAnimArray('lean_aim_right', 'cornerL_stand_lean_6');
	SetAnimArray('lean_aim_up', 'cornerL_stand_lean_8');
	SetAnimArray('lean_reload', 'cornerL_stand_lean_reload');
//	
	SetAnimArray('lean_idle', 'cornerL_stand_lean_idle');
//
	SetAnimArray('lean_single', 'cornerL_stand_lean_fire');
//	//array["lean_burst"] = %cornerL_stand_lean_autoburst;
	SetAnimArray('lean_fire', 'cornerL_stand_lean_auto');
	
	hideYawOffset = -90;
}


function set_animarray_crouching_left()
{
//	array = [];

	ResetAnimArray();
	SetAnimArray('hide_idle', 'cornerL_crouch_hide_idle');
	//SetAnimArray('hide_idle_twitch', "]'); = array();
	//SetAnimArray('hide_idle_flinch', "]'); = array();
//
//	//array["hide_to_C"] = %cornerL_crouch_hide_2_C;
//	//array["B_to_C"] = %cornerL_crouch_B_2_C;
//	//array["C_to_hide"] = %cornerL_crouch_C_2_hide;
//	//array["C_to_B"] = %cornerL_crouch_C_2_B;
	SetAnimArray('hide_to_A', 'cornerL_crouch_hide_2_A');
	SetAnimArray('hide_to_B', 'cornerL_crouch_hide_2_B');
	SetAnimArray('A_to_hide', 'cornerL_crouch_A_2_hide');
	//SetAnimArray('A_to_hide_reload', "]'); = array();
	SetAnimArray('A_to_B', 'cornerL_crouch_A_2_B');
	SetAnimArray('B_to_hide', 'cornerL_crouch_B_2_hide');
	//SetAnimArray('B_to_hide_reload', "]'); = array();
	SetAnimArray('B_to_A', 'cornerL_crouch_B_2_A');
	SetAnimArray('look', 'cornerL_crouch_look_fast');
	SetAnimArray('reload', 'cornerL_crouch_reload_v1');
	SetAnimArray('reload', 'cornerL_crouch_reload_v2');
	SetAnimArray('grenade_safe', 'cornerL_crouch_grenade_safe');
	SetAnimArray('grenade_exposed', 'cornerL_crouch_grenade_exposed');
	
	//SetAnimArray('blind_fire', "]'); = array();

	//SetAnimArray('rambo', "]'); = array();
//	
//	//array["hide_to_look"] = %cornerL_crouch_hide_idle; // TODO
//	//array["look_to_hide"] = %cornerL_crouch_hide_idle; // TODO
//	//array["look_to_hide_fast"] = %cornerL_crouch_hide_idle; // TODO
//	//array["look_idle"] = %cornerL_crouch_hide_idle; // TODO
	SetAnimArray('stance_change', 'cornerL_crouch_2_stand');
	
	hideYawOffset = -90;
}
