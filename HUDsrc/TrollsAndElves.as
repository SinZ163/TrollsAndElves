package  {
	// Flash Libraries
	import flash.display.MovieClip;

    // Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
    import scaleform.clik.events.ButtonEvent;

    // Timer
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    // For chrome browser
    import flash.utils.getDefinitionByName;
	
	public class TrollsAndElves extends MovieClip {
		//Game API stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		// These vars determain how much of the stage we can use
        // They are updated as the stage size changes
        public var res16by9Width:Number = 1920;
        public var res16by9Height:Number = 1080;
		
		public var res16by10Width:Number = 1680;
		public var res16by10Height:Number = 1050;
		
		public var res4by3Width:Number = 1280;
		public var res4by3Height:Number = 960;
		
		public var curRes:int = 3; //Invalid so that everything resizes
		
		public var resWidth:Number = res16by9Width;
		public var resHeight:Number = res16by10Width;
		
		//Default to 16by9 as that is the master resolution
		public var maxStageWidth:Number = res16by9Width;
		public var maxStageHeight:Number = res16by9Height;
		
		//Load in our other scripts here
		public var lumberOverlay:LumberOverlay;
		
		public function TrollsAndElves() {
			// constructor code
			// Note this DOES run for some reason.
			trace("##TrollsAndElves Hello World from the Constructor.");
		}
		
		public function lumberEvent(args:Object) : void {
			if (globals.Players.GetLocalPlayer() == args.pid)
			{
				lumberOverlay.setLumber(args.lumber);
			}
		}

		public function onLoaded() : void {
			//trace('globals:');
			//PrintTable(globals, 1);
			trace("##TrollsAndElves Fixing healthbar");
			globals.GameInterface.SetConvar("dota_health_per_vertical_marker", "25000");
			
			// constructor code
			//trace("###TrollsAndElves killing inventory UI");
			//PrintTable(globals.Loader_inventory.movieClip.inventory, 1);
			//globals.Loader_inventory.movieClip.removeChild(globals.Loader_inventory.movieClip.inventory);
			trace("##TrollsAndElves Starting TrollsAndElves HUD");
			visible = true;
			
			lumberOverlay = new LumberOverlay();
			addChild(lumberOverlay);
			lumberOverlay.visible = true;
			lumberOverlay.setLumber("1000"); //TEMP just to test if it looks nice
			gameAPI.SubscribeToGameEvent("trollsandelves_lumber", this.lumberEvent);
			//Resizing is blitz
			Globals.instance.resizeManager.AddListener(this);
			
			//globals.Loader_inventory.movieClip.inventory.quickbuy = null;
		}
		
		public function onResize(re:ResizeManager) : * {
			// Update the stage width
			trace("### Resizing");
			if (re.IsWidescreen()) {
				trace("### Widescreen detected!");
				//16:x
				if (re.Is16by9()) {
					if (curRes != 0) {
						curRes = 0;
						//lumberOverlay.onScreenResize(0, globals.instance.Game.IsHUDFlipped());
						try {
							trace("###TrollsAndElves HUD Flipped to "+globals.instance.Game.IsHUDFlipped());
						} catch (Exception) {
							trace("###ERRROR Ok, this didn't work..."); //This actually is used, not quite sure why yet.
						}
						lumberOverlay.onScreenResize(0, false);
					}
					trace("###TrollsAndElves Resizing for 16:9 resolution");
					resWidth = res16by9Width;
					resHeight = res16by9Height;
					//1920 * 1080
				} else {
					if (curRes != 1) {
						curRes = 1;
						//lumberOverlay.onResize(1, globals.instance.Game.IsHUDFlipped());
						lumberOverlay.onScreenResize(1, false);
					}
					trace("###TrollsAndElves Resizing for 16:10 resolution");
					resWidth = res16by10Width;
					resHeight = res16by10Height;
					//1680 * 1050
				}
			} else {
				trace("###TrollsAndElves Resizing for 4:3 resolution");
				if (curRes != 2) {
					curRes = 2;
					//lumberOverlay.onScreenResize(2, globals.instance.Game.IsHUDFlipped());
					lumberOverlay.onScreenResize(2, false);
				}
				resWidth = res4by3Width;
				resHeight = res4by3Height;
				//1280 * 960
			}
			
			maxStageHeight = re.ScreenHeight / re.ScreenWidth * resWidth;
			maxStageWidth = re.ScreenWidth / re.ScreenHeight * resHeight;
            //Scale hud to screen
            this.scaleX = re.ScreenWidth/maxStageWidth;
            this.scaleY = re.ScreenHeight/maxStageHeight;
		}
		
		
		// Function to repeat a string many times
        public function strRep(str, count) {
            var output = "";
            for(var i=0; i<count; i++) {
                output = output + str;
            }

            return output;
        }

        public function isPrintable(t) {
        	if(t == null || t is Number || t is String || t is Boolean || t is Function || t is Array) {
        		return true;
        	}
        	// Check for vectors
        	if(flash.utils.getQualifiedClassName(t).indexOf('__AS3__.vec::Vector') == 0) return true;

        	return false;
        }

        public function PrintTable(t, indent=0, done=null) {
        	var i:int, key, key1, v:*;

        	// Validate input
        	if(isPrintable(t)) {
        		trace("PrintTable called with incorrect arguments!");
        		return;
        	}

        	if(indent == 0) {
        		trace(t.name+" "+t+": {")
        	}

        	// Stop loops
        	done ||= new flash.utils.Dictionary(true);
        	if(done[t]) {
        		trace(strRep("\t", indent)+"<loop object> "+t);
        		return;
        	}
        	done[t] = true;

        	// Grab this class
        	var thisClass = flash.utils.getQualifiedClassName(t);

        	// Print methods
			for each(key1 in flash.utils.describeType(t)..method) {
				// Check if this is part of our class
				if(key1.@declaredBy == thisClass) {
					// Yes, log it
					trace(strRep("\t", indent+1)+key1.@name+"()");
				}
			}

			// Check for text
			if("text" in t) {
				trace(strRep("\t", indent+1)+"text: "+t.text);
			}

			// Print variables
			for each(key1 in flash.utils.describeType(t)..variable) {
				key = key1.@name;
				v = t[key];

				// Check if we can print it in one line
				if(isPrintable(v)) {
					trace(strRep("\t", indent+1)+key+": "+v);
				} else {
					// Open bracket
					trace(strRep("\t", indent+1)+key+": {");

					// Recurse!
					PrintTable(v, indent+1, done)

					// Close bracket
					trace(strRep("\t", indent+1)+"}");
				}
			}

			// Find other keys
			for(key in t) {
				v = t[key];

				// Check if we can print it in one line
				if(isPrintable(v)) {
					trace(strRep("\t", indent+1)+key+": "+v);
				} else {
					// Open bracket
					trace(strRep("\t", indent+1)+key+": {");

					// Recurse!
					PrintTable(v, indent+1, done)

					// Close bracket
					trace(strRep("\t", indent+1)+"}");
				}
        	}

        	// Get children
        	if(t is MovieClip) {
        		// Loop over children
	        	for(i = 0; i < t.numChildren; i++) {
	        		// Open bracket
					trace(strRep("\t", indent+1)+t.name+" "+t+": {");

					// Recurse!
	        		PrintTable(t.getChildAt(i), indent+1, done);

	        		// Close bracket
					trace(strRep("\t", indent+1)+"}");
	        	}
        	}

        	// Close bracket
        	if(indent == 0) {
        		trace("}");
        	}
        }
	}	
}
