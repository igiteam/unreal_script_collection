/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoBonusXPValues extends Object
	abstract
	config(Game);


struct NanoBonusXPValueDatum
{
	var string Desc;
	var int XP;
};


var config NanoBonusXPValueDatum QuickKill;

var config NanoBonusXPValueDatum SlowKill;

var config NanoBonusXPValueDatum ArielKill;

var config NanoBonusXPValueDatum DropTheHammerKill;

var config NanoBonusXPValueDatum NaniteTornadoKill;


var config NanoBonusXPValueDatum SwordThrownJuggledQuickKill;

var config NanoBonusXPValueDatum SwordThrownJuggledKill;

var config NanoBonusXPValueDatum SwordThrownImpaledKill;


var config NanoBonusXPValueDatum ComboCountGreaterThan2Kill;

var config NanoBonusXPValueDatum ComboCountGreaterThan1Kill;

var config NanoBonusXPValueDatum ComboCountZeroKill;

var config NanoBonusXPValueDatum ChainLessThan8SecondsKill;




defaultproperties
{

}