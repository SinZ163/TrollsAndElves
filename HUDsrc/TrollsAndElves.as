package  {
	
	import flash.display.MovieClip;
	
	import ValveLib.Globals;
    import ValveLib.ResizeManager;
	
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
		
		public function onLoaded() : void {
			trace('globals:');
			PrintTable(globals, 1);
			// constructor code
			// Note this doesn't run for some reason...
			//trace("###TrollsAndElves killing inventory UI");
			//PrintTable(globals.Loader_inventory.movieClip.inventory, 1);
			//globals.Loader_inventory.movieClip.removeChild(globals.Loader_inventory.movieClip.inventory);
			trace("###TrollsAndElves Init scoreboard diagnostics");
			PrintTable(globals.Loader_scoreboard, 1);
			trace("##TrollsAndElves Starting TrollsAndElves HUD");
			visible = true;
			
			//LumberOverlay
			lumberOverlay = new LumberOverlay();
			addChild(lumberOverlay);
			lumberOverlay.visible = true;
			lumberOverlay.setLumber("9876"); //TEMP just to test if it looks nice
			//Resizing is blitz
			Globals.instance.resizeManager.AddListener(this);
		}
		
		public function onResize(re:ResizeManager) : * {
			// Update the stage width
			trace("### Resizing");
			if (re.IsWidescreen()) {
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
					//lumberOverlay.onResize(2, globals.instance.Game.IsHUDFlipped());
					lumberOverlay.onScreenResize(2, false);
				}
				resWidth = res4by3Width;
				resHeight = res4by3Height;
				//1280 * 960
			}
			
			maxStageHeight = re.ScreenHeight / re.ScreenWidth * resWidth;
			maxStageWidth = re.ScreenWidth / re.ScreenHeight * resHeight;
            // Scale hud to screen
            this.scaleX = re.ScreenWidth/maxStageWidth;
            this.scaleY = re.ScreenHeight/maxStageHeight;
		}
		//Shamelessly copied from oldHudSrc Frota
		public function strRep(str, count) {
            var output = "";
            for(var i=0; i<count; i++) {
                output = output + str;
            }

            return output;
        }
		public function PrintTable(t, indent) {
            for(var key in t) {
                var v = t[key];

                if(typeof(v) == "object") {
                    trace(strRep("\t", indent)+key+":")
                    PrintTable(v, indent+1);

                    if(v.gameAPI) {
                        trace(strRep("\t", indent+1)+"gameAPI:")
                        PrintTable(v.gameAPI, indent+2);
                    }
                } else {
                    trace(strRep("\t", indent)+key.toString()+": "+v.toString());
                }
            }
        }	
	}	
}
