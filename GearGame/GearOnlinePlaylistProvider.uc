/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Per object config provider that exposes dynamic playlists to the UI system
 * Put here to move localization into Gears and out of engine
 */
class GearOnlinePlaylistProvider extends OnlinePlaylistProvider
	PerObjectConfig
	Config(Playlist);

/** Unique identifier for the ranked version of this Playlist */
var	config int RankedPlaylistId;

/** Description text used to describe this playlist */
var localized string PlaylistDescription;