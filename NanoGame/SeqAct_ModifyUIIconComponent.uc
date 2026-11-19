/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyUIIconComponent extends SequenceAction;


/** Which IconType to update **/
var() EIconType IconType;

/** The data to replace on the component **/
var() IconDatum NewIconDatum;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


event Activated()
{
	local int Idx;
	local NanoInterface_Objective UIObj;
	local UIIconComponent CompToMod;

	for( Idx = 0; Idx < Targets.Length; Idx++ )
	{
		UIObj = NanoInterface_Objective(Targets[Idx]);
		if( UIObj != None )
		{
			CompToMod = UIObj.GetUIIconComponent();

			if( CompToMod != None )
			{
				CompToMod.SetIconDatum( IconType, NewIconDatum );
			}
		}
	}
}



defaultproperties
{
	ObjName="Modify UI Icon Component"
	ObjCategory="Nano"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',PropertyName=Targets)

	bCallHandler=FALSE


}