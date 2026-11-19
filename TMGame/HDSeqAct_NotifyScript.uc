//-----------------------------------------------------------
//  ???Kismet???????(???????)
//-----------------------------------------------------------
class HDSeqAct_NotifyScript extends SequenceAction;

var() name   Type<autocomment=true>;
var() string Value;

event Activated()
{
 	local HDGame MyGame;

 	MyGame = HDGame(GetWorldInfo().Game);
 	if(MyGame != none)
 	{
   		MyGame.MessageFromKismet(Type, Value);
   		;
	}
	else
	{
		;
	}
}

