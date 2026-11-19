/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_PlayMovie extends SequenceAction
	dependson (TPGameViewportClient);

var() name MovieName;

var() TPGameViewportClient.ePlayMovie PlayMode;

