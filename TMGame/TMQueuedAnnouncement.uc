/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMQueuedAnnouncement extends Info;

var TMQueuedAnnouncement nextAnnouncement;

var class<TMLocalMessage> AnnouncementClass;
var int MessageIndex;
var PlayerReplicationInfo PRI;
var Object OptionalObject;
