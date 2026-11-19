class FHHUD extends HUD;
var FHPlayerController playerController;

enum EMessageState
	{
	MSG_Inactive,        // not being used
	MSG_ReadyToActivate, // needs initialization
	MSG_Active           // displayable
	};

struct HudMessage
	{
	var EMessageState messageState;
	var float         duration;
	var float         startTime;
	var string        message;
	var Color         displayColor;
	var Vector        displayPosition;
	var Font          displayFont;

	structdefaultproperties
		{
		messageState = MSG_Inactive;
		}
	};

const            maxMessages = 20;
var   HudMessage messageList[maxMessages];
var   int        numMessages;

var bool paused;

var   bool       bShowInventory;
var   float      xInv;
var   float      yInv;
var   array <FHSeqVar_InventoryCategory> myInventory;
var FHPauseMenu		PauseMenuMovie;

exec function FHShowMenu()
{
	local FHSeqVar_InventoryCategory cat;
	local FHSeqVar_InventoryItem aNote;
	local string notesString;
	local array <bool> notesBool;
	local bool b;
	local int i;

	if( paused )
		return;

	for(i = 0; i < 8; i++) // oh the hacks!
		notesBool.AddItem(false);

	foreach myInventory(cat)
	{ // love the hacks! I hope you hurl when you read this!
		if(cat.categoryName == "Notes")
		{
			foreach cat.itemList(aNote)
			{
				if(aNote.itemName == "Research Note 1")
					notesBool[0] = true;
				if(aNote.itemName == "Research Note 2")
					notesBool[1] = true;
				if(aNote.itemName == "Research Note 3")
					notesBool[2] = true;
				if(aNote.itemName == "Electrician's Letter 1")
					notesBool[3] = true;
				if(aNote.itemName == "Electrician's Letter 2")
					notesBool[4] = true;
				if(aNote.itemName == "Electrician's Reply")
					notesBool[5] = true;
				if(aNote.itemName == "Red Cross Orders")
					notesBool[6] = true;
				if(aNote.itemName == "Prisoner's Scrawl")
					notesBool[7] = true;
			}
		}
	}

	foreach notesBool(b)
	{
		notesString $= b ? "1" : "0";
	}

	LogInternal("FHShowMenu");
	PauseMenuMovie = new class'FHPauseMenu';
	PauseMenuMovie.playerController = playerController;
	PauseMenuMovie.initialize_dave(self, notesString);
	PauseMenuMovie.Init();
    PauseMenuMovie.SetTimingMode(TM_Real);
	
	PauseMenuMovie.AddFocusIgnoreKey('Escape');
	//playerController.SetPause(true);
    PauseMenuMovie.Start();
	paused = true;
}

function HideMenu()
{
	paused = false;
}


function byte CalcAlpha (float startTime, float currentTime, float duration)
	{
	local float displayedPercent;

	displayedPercent = (currentTime - startTime) / duration;
	if (displayedPercent <= 0.75) return 255;
	if (displayedPercent > 1.0)   return 0;
	return (1 - displayedPercent) * 255 / 0.25;
	}

function DrawHelpMessage ()
	{
	local int    j;
	local bool   bIsFirstMessage;
	local float  y;
	local float  xSize;
	local float  ySize;
	local Color  c;
	local Vector pos;
	local float  currentTime;
	local byte   alpha;

	currentTime     = WorldInfo.TimeSeconds;
	bIsFirstMessage = true; // havent drawn any messages yet. used to get correct y pos
	y               = 0;    // let's make the compiler happy; it thinks it is being used before being initialized, but it isn't actually
	for (j = 0; j < maxMessages; ++j)
		{
		if (messageList[j].messageState == MSG_Inactive) continue; // not an active message
		if (messageList[j].messageState == MSG_ReadyToActivate)    // not initialized yet
			{
			messageList[j].messageState = MSG_Active;
			messageList[j].startTime    = currentTime;
			if (!bIsFirstMessage)
				{
				messageList[j].displayPosition.Y = y;
				}
			}

		c     = messageList[j].displayColor;
		pos   = messageList[j].displayPosition;
		y     = pos.Y;
		alpha = CalcAlpha (messageList[j].startTime, currentTime, messageList[j].duration);

		Canvas.SetDrawColor (c.R, c.G, c.B, alpha);
		Canvas.SetPos       (pos.X, pos.Y, pos.Z);
		Canvas.Font = messageList[j].displayFont;
		Canvas.DrawText (messageList[j].message);
		Canvas.TextSize (messageList[j].message, xSize, ySize);

		y += ySize;
		if ((currentTime - messageList[j].startTime) >= messageList[j].duration)
			{
			messageList[j].messageState = MSG_Inactive;
			--numMessages;
			}
		bIsFirstMessage = false;
		}
	}

function DrawHUD()
	{
	if (numMessages > 0)
		{
		DrawHelpMessage ();
		}
	if (bShowInventory)
		{
		ShowInventory ();
		}
	}

// returns index of an available message slot in messageList
// returns -1 if no slots available
function int FindEmptyMessageSlot()
	{
	local int  j;
	for (j = 0; j < maxMessages; ++j)
		{
		if (messageList[j].messageState == MSG_Inactive) return j;
		}
	return -1;
	}

// returns the index of the active message that matches the given string
// returns -1 if no such message exists
function int FindMessageSlot (string msg)
	{
	local int  j;
	for (j = 0; j < maxMessages; ++j)
		{
		if (messageList[j].messageState == MSG_Inactive) continue;
		if (messageList[j].message      == msg)          return j;  // active message found!
		}
	return -1;
	}

function RemoveGameMessage (string message)
	{
	local int index;
	index = FindMessageSlot (message);
	if (index < 0) return; // not found
	messageList[index].messageState = MSG_Inactive;
	}

function DrawGameMessage (String message, float time, color c, vector pos, font msgFont)
	{
	local int messageIndex;

	// If this message is already active, just refresh its start time.
	messageIndex = FindMessageSlot (message);
	if (messageIndex >= 0)
		{
		messageList[messageIndex].startTime = WorldInfo.TimeSeconds;
		LogInternal("Refreshed a message!");
		return;
		}

	messageIndex = FindEmptyMessageSlot();
	if (messageIndex < 0)
		{
		LogInternal("No message slots available ----- ERROR -----");
		return;
		}
	messageList[messageIndex].messageState    = MSG_ReadyToActivate;
	messageList[messageIndex].duration        = time;
	messageList[messageIndex].message         = message;
	messageList[messageIndex].displayColor    = c;
	messageList[messageIndex].displayPosition = pos;
	messageList[messageIndex].displayFont     = msgFont;
	++numMessages;
	}

function DrawInventory(array <FHSeqVar_InventoryCategory> inv, float x, float y)
	{
	xInv           = x;
	yInv           = y;
	myInventory    = inv;
	bShowInventory = true;
	}

function ShowInventory ()
	{
	local float  x;
	local float  y;
	local float  xSize;
	local float  ySize;
	local bool   bIsCollectible;
	local string text;
	local string aWord;
	local int    numFound;
	local int    numNeeded;
	local FHSeqVar_InventoryCategory cat;
	local FHSeqVar_InventoryItem     items;

	y = yInv;

	foreach myInventory(cat)
		{
		x = xInv;
		Canvas.Font = cat.categoryFont;
		Canvas.SetPos (x, y, 0);
		Canvas.SetDrawColor (cat.categoryColor.R, cat.categoryColor.G, cat.categoryColor.B, cat.categoryColor.A);
		Canvas.TextSize (cat.categoryName, xSize, ysize);

		text     = cat.categoryName;
		numFound = cat.itemList.Length;
		bIsCollectible = (cat.categoryQuantity > 0);
		if (bIsCollectible)
			{
			numNeeded = cat.categoryQuantity;
			text      = text $" - " $numFound $" of " $numNeeded $" found";
			}
		else
			{
			if (numFound == 1) aWord = " item";
			else aWord = " items";
			text      = text $" - " $numFound $aWord;
			}

		Canvas.DrawText (text);
		y += ySize;
		x += 20;
		foreach cat.itemList(items)
			{
			Canvas.SetPos (x, y, 0);
			Canvas.TextSize (cat.categoryName, xSize, ysize);
			Canvas.DrawText (items.itemName);
			y += ySize;
			}
		}

	bShowInventory = false;
	}

