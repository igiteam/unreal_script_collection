/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoEngine extends GameEngine
	native;

cpptext
{
	virtual UBOOL LoadMap(const FURL& URL, class UPendingLevel* Pending, FString& Error);
	virtual void Tick(FLOAT DeltaSeconds);
	virtual UBOOL Exec( const TCHAR* Cmd, FOutputDevice& Ar=*GLog );
};

defaultproperties
{
}
