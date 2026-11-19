/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMLinkedReplicationInfo extends ReplicationInfo
	abstract
	native
	nativereplication;

var TMLinkedReplicationInfo NextReplicationInfo;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
	// Variables the server should send to the client.
	if ( bNetInitial && (Role==ROLE_Authority) )
		NextReplicationInfo;
}

