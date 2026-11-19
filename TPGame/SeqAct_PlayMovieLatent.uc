//***********************************************************************
// Class:		 SeqAct_PlayMovieLatent
// Description:  Plays a movie but wait to fire the out event until the movie is done or interrupted
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  
//***********************************************************************
class SeqAct_PlayMovieLatent extends SeqAct_Latent
	dependson (TPGameViewportClient);

var() name MovieName;

var() TPGameViewportClient.ePlayMovie PlayMode;

