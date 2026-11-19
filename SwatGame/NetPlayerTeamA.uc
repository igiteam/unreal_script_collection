///////////////////////////////////////////////////////////////////////////////

class NetPlayerTeamA extends NetPlayer;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// COOP: Note this will make ALL swat officers ALWAYS relevant until 
    // there is a mechanism on clients to determine if the game mode is COOP 	
	if ( Level.IsPlayingCOOP )
		bAlwaysRelevant = true;
}


simulated function int GetTeamNumber()
{
    return 0;
}









// Decompiled with UE Explorer.
defaultproperties
{
    TeamNumber=0
    Skins[0]=Shader'mp_OfficerTex.mpSWAT_bdu_camoShader'
    Skins[1]=Shader'mp_OfficerTex.mpSWATelementLeadShader'
    Skins[2]=Shader'mp_OfficerTex.NameTagBlueShader'
    Skins[3]=Shader'mp_OfficerTex.mpSWAT_vest_DefaultShader'
}