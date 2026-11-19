class TPGameMessage extends GameMessage;

//
// Messages common to GameInfo derivatives.
//
static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	switch (Switch)
	{
		case 1:
			if (RelatedPRI_1 == None)
                return Default.NewPlayerMessage;

			return "<Fonts:EngineFonts.MediumFont>"$RelatedPRI_1.GetPlayerAlias()$Default.EnteredMessage$"<Fonts:/>";
			break;
		case 4:
			if (RelatedPRI_1 == None)
				return "";

			return "<Fonts:EngineFonts.MediumFont>"$RelatedPRI_1.GetPlayerAlias()$Default.LeftMessage$"<Fonts:/>";
			break;
	}
	return "";
}

