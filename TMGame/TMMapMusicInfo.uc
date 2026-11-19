/** 
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMMapMusicInfo extends Object
	native
	dependson(TMTypes)
	hidecategories(Object)
	editinlinenew;


/** 
 * This is the music for the map.  Content folk will pick from the various sets of music that exist
 * and then specify the music the map should have.
 **/
var() MusicForAMap MapMusic;

/** These are the stingers for the map **/
var() StingersForAMap MapStingers;




