﻿package  {
	// Flash Libraries
	import flash.display.MovieClip;

    // Valve Libaries
    import ValveLib.Globals;
    import ValveLib.ResizeManager;
    import scaleform.clik.events.ButtonEvent;
    import scaleform.clik.events.*;
    import flash.events.MouseEvent;
	import flash.events.Event;
    import flash.geom.ColorTransform;

    // Timer
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.display.Shape;
    import flash.geom.Point;

    // For chrome browser
    import flash.utils.getDefinitionByName;
	
	import buildings.*;
	
	public class TrollsAndElves extends MovieClip {
		//Game API stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		public static var Translate;
		
		// These vars determain how much of the stage we can use
        // They are updated as the stage size changes

        private static var X_SECTIONS = 1;      // How many sections in the x direction
        private static var Y_SECTIONS = 1;      // How many sections in the y direction

        private static var X_PER_SECTION = 1;   // How many skill lists in each x section
        private static var Y_PER_SECTION = 1;   // How many skill lists in each y section

        // How big a SelectSkillList is
        private static var SL_WIDTH = 43;
        private static var SL_HEIGHT = 43;

        private var ITEM_WIDTH = 100;
		private var ITEM_HEIGHT = 80;
		
		private var SPELL_WIDTH = 128;
		private var SPELL_HEIGHT = 128;
		
        private var ITEM_PADDING = 4;
        private var ROW_SIZE = 1100;
        private var COLUMN_SIZE = 300; 

        // How much padding to put between each list
        private static var S_PADDING = 2;

		private var debugButtonY:Number = 100;

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

		public var scalingFactor;

		public var realScreenWidth;

		public var realScreenHeight;

		public var myStageHeight = 720;

		public var itemButton:MovieClip = new MovieClip();
		public var buildingButton:MovieClip = new MovieClip();

		public var itemPanel:MovieClip = new MovieClip();
		public var buildingPanel:MovieClip = new MovieClip();

		private var itemsCustomKV;
		private var resourceCustomKV;
		
		public var TownHallOverlay:TownHall;
		public var AncientTreeOverlay:AncientTree;

		//Load in our other scripts here
		public var lumberOverlay:LumberOverlay;
		
		public function TrollsAndElves() {
			// constructor code
			// Note this DOES run for some reason.
			trace("##TrollsAndElves Hello World from the Constructor. 2222");
		}
		
		public function lumberEvent(args:Object) : void {
			if (globals.Players.GetLocalPlayer() == args.pid)
			{
				lumberOverlay.setLumber(args.lumber);
			}
		}
		
		//build a panel filled with KV-generated icons with tooltips and shit
		private function buildResourcePanel(panelName:String, resource:String, onResourceClick:Function) {
            var i:Number, j:Number, k:Number, l:Number, sl:MovieClip;

			trace("Entering..");
			
            // How much space we have to use
            var workingWidth:Number = myStageHeight*4/3;

            // Build a container
            this[panelName] = new MovieClip();
			var container = this[panelName];
            addChild(container);
            container.visible = false;
			trace("Assigned panel");

			//maybe should be able to specify these per-case
			var entryWidth:Number;
			var entryHeight:Number;
			if (panelName == "itemPanel") {
				entryWidth = ITEM_WIDTH + ITEM_PADDING;
				entryHeight = ITEM_HEIGHT + ITEM_PADDING;
			} else {
				entryWidth = SPELL_WIDTH + ITEM_PADDING;
				entryHeight = SPELL_HEIGHT + ITEM_PADDING;
			}
            var totalWidth:Number = ROW_SIZE;
            var totalHeight:Number = COLUMN_SIZE;
            var useableHeight:Number = 320;
            var entriesAcross = totalWidth / entryWidth;
            var entriesDown = totalHeight / entryHeight;

			//generically approved
            var cls = getDefinitionByName("DB4_outerpanel");
			var panel = new cls();
			panel.visible = true;
			panel.x = -15;
			panel.y = -15;
			panel.height = totalHeight + 100;
			panel.width = totalWidth + 100;
			container.addChild(panel);
			trace("Assigned outerpanel");
			

			//generically approved
			var closecls = getDefinitionByName("button_big");
			var closebutton = new closecls();
			closebutton.label = "Close";
			closebutton.visible = true;
			closebutton.x = 50;
			closebutton.y = totalHeight + 50;
			closebutton.addEventListener(MouseEvent.CLICK, onPanelClose);
			container.addChild(closebutton);
			trace("Assigned close");
			
			var kv = resourceCustomKV[resource]
			trace(kv);
			
            var itemnum = 0;
            for(var down = 0; down < entriesDown; down++){
            	for(var across = 0; across < entriesAcross; across++){
            		
            		var resourcedata = kv[itemnum];
					trace(resourcedata);
            		if(resourcedata){
            			var offset = entryWidth * across;
	            		var item = new MovieClip();
	            		item.x = offset;
	            		item.y = down * entryHeight;
	            		var img = new ResourceIcon(resourcedata, onResourceClick);
						trace("Instanced icon");

	            		img.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver, false, 0, true);
	        			img.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut, false, 0, true);
						img.itemName = resourcedata;
						img.resourceName = resourcedata;
	      			    Globals.instance.LoadAbilityImage(resourcedata, img);
						trace("loaded image");
	       	
	            		item.itemName = resourcedata;
	            		item.addChild(img);
						
						trace("Well?");
	            		
	            		container.addChild(item);
	            		itemnum++;
            		}
            	}
            }
        }

		public function onItemClick(item:String){
			trace("AS " + item);
			gameAPI.SendServerCommand("tae_buy_item " + item);
		}
		
		public function onBuildingClick(building:String){
			trace("Building " + building);
			gameAPI.SendServerCommand("tae_wants_to_build " + building);
		}
		
        public function onPanelClose(obj:Object){
			var closecls = getDefinitionByName("button_big");
			var closebutton = new closecls();
			PrintTable(closebutton);
        	obj.target.parent.visible = false;
        }

        public function onMouseClickItem(keys:MouseEvent){
        	trace("click");
       		var s:Object = keys.target;

       		trace("Bought " + s.itemName);

        }

       	public function onMouseRollOver(keys:MouseEvent){
       		
       		var s:Object = keys.target;
       		trace("roll over! " + s.itemName);
            // Workout where to put it
            var lp:Point = s.localToGlobal(new Point(0, 0));

            // Decide how to show the info
            if(lp.x < realScreenWidth/2) {
                // Workout how much to move it
                var offset:Number = 16*scalingFactor;

                // Face to the right
                globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(lp.x+offset, lp.y, s.getResourceName());
            } else {
                // Face to the left
                globals.Loader_heroselection.gameAPI.OnSkillRollOver(lp.x, lp.y, s.getResourceName());
            }
       	}

       	public function onMouseRollOut(keys:Object){
       		 globals.Loader_heroselection.gameAPI.OnSkillRollOut();
       	}
		public function delayedUnit(e:TimerEvent) {
			//trace("Name: "+globals.Loader_actionpanel.movieClip.middle.unitName.text);
			var unitSelected:String = "";
			switch(globals.Loader_actionpanel.movieClip.middle.unitName.text) {
				case Translate("#npc_trollsandelves_hall_1"):
				case Translate("#npc_trollsandelves_hall_2"):
				case Translate("#npc_trollsandelves_hall_3"):
					//trace("We have ourselves a hall");
					unitSelected = "hall";
				break;
				case Translate("#npc_trollsandelves_tree"):
					//trace("We have ourselves a tree");
					unitSelected = "tree";
				break;
				default:
					//trace("Boring entity selected: "+globals.Loader_actionpanel.movieClip.middle.unitName.text);
				break;
			}
			TownHallOverlay.visible = (unitSelected == "hall");
			AncientTreeOverlay.visible = (unitSelected == "tree");
		}
		
		
		public function onLoaded() : void {
			trace('##globals:');
			//PrintTable(globals);
			trace('##endglobals');
			
			trace("##TrollsAndElves Fixing healthbar");
			globals.GameInterface.SetConvar("dota_health_per_vertical_marker", "25000");
			
			// constructor code
			//trace("###TrollsAndElves killing inventory UI");
			//PrintTable(globals.Loader_inventory.movieClip.inventory, 1);
			//globals.Loader_inventory.movieClip.removeChild(globals.Loader_inventory.movieClip.inventory);
			trace("##TrollsAndElves Starting TrollsAndElves HUD");
			visible = true;
			
			Translate = Globals.instance.GameInterface.Translate;
			
			globals.scaleX = 0.5;
			globals.scaleY = 0.5;
			
			trace("Loading kv..");
			resourceCustomKV = Globals.instance.GameInterface.LoadKVFile('scripts/kv/tae_resources.txt').abs;
			
            buildResourcePanel("itemPanel", "troll_shop", onItemClick);
			buildResourcePanel("buildingPanel", "elf_buildings", onBuildingClick);

			lumberOverlay = new LumberOverlay();
			addChild(lumberOverlay);
			lumberOverlay.visible = true;
			lumberOverlay.setLumber("1000"); //TEMP just to test if it looks nice
			gameAPI.SubscribeToGameEvent("trollsandelves_lumber", this.lumberEvent);
			
			TownHallOverlay = new TownHall();
			addChild(TownHallOverlay);
			TownHallOverlay.visible = false;

			AncientTreeOverlay = new AncientTree(gameAPI);
			addChild(AncientTreeOverlay);
			AncientTreeOverlay.visible = false;
			
			gameAPI.SubscribeToGameEvent("tae_new_troll", this.newTroll);
			gameAPI.SubscribeToGameEvent("tae_new_elf", this.newElf);
			gameAPI.SubscribeToGameEvent("tae_build_menu", this.buildMenuToggle);

			var delayTimer:Timer = new Timer(10);
            delayTimer.addEventListener(TimerEvent.TIMER, delayedUnit);
            delayTimer.start();
			
			//Resizing is blitz
			Globals.instance.resizeManager.AddListener(this);
			
			createDebugButton("LIST", debugButton1Func);
			createDebugButton("CREATE", debugButton2Func);
			createDebugButton("LOAD", debugButton3Func);
		}
		public function createDebugButton(name:String, func:Function) {
			var btncls = getDefinitionByName("button_big");
			var debugButton = new btncls();
			debugButton.label = name;
			debugButton.x = 100;
			debugButton.y = debugButtonY;
			debugButton.visible = true;
			debugButton.addEventListener(ButtonEvent.CLICK, func);
			addChild(debugButton);
			
			debugButtonY = debugButtonY + 100;
		}
		
		public function debugButton1Func(args:Object) {
			globals.Loader_StatsCollectionRPG.movieClip.GetList("e0722e12ab344c4a85c5b28f7237673e", debugTest1);
		}
		public function debugButton2Func(args:Object) {
			globals.Loader_StatsCollectionRPG.movieClip.CreateSave("e0722e12ab344c4a85c5b28f7237673e", debugTest2);
		}
		public function debugButton3Func(args:Object) {
			globals.Loader_StatsCollectionRPG.movieClip.GetSave("e0722e12ab344c4a85c5b28f7237673e", 1, debugTest3);
		}
		public function debugTest1(jsonArray:Array) {
			trace("##CALLBACK");
			for each (var entry:Object in jsonArray) {
				trace(entry.saveID);
				trace("##METADATA");
				for (var metaData in entry.metaData) {
					trace("entry.metaData." + metaData + " = " + entry.metaData[metaData]);
					//
				}
				trace("##END_METADATA");
				trace(entry.dateRecorded.toString());
			}
			trace("##END_CALLBACK");
		}
		public function debugTest2(saveID:int) {
			trace("##CALLBACK2");
			trace(saveID.toString());
			var jsonData:Object = {
				"hi" : "bob"
			};
			var metaData:Object = {
				"hello" : "world"
			}
			globals.Loader_StatsCollectionRPG.movieClip.SaveData("e0722e12ab344c4a85c5b28f7237673e", saveID, jsonData, metaData, saveCallback);
			trace("##END_CALLBACK2");
		}
		public function debugTest3(jsonData:Object) {
			trace("##CALLBACK3");
			for (var info in jsonData) {
				trace("jsonData." + info + " = " + jsonData[info]);
			}
			trace("##END_CALLBACK3");
		}
		public function saveCallback(success:Boolean) {
			trace("##CALLBACK_SAVE");
			trace(success.toString());
			trace("##END_CALLBACK_SAVE");
		}
		
		
		public function buildMenuToggle(keys:Object){
			if (globals.Players.GetLocalPlayer() == keys.pid)
			{
				buildingPanel.visible = !buildingPanel.visible;
			}
		}
		
		public function newTroll(keys:Object){
			trace("###NEW TROLL###");
			if (globals.Players.GetLocalPlayer() == keys.pid)
			{
				trace("GOT IT WHERE WE WANT IT");
				buildingButton.visible = false;
				drawItemsButton();
			}
		}

		public function newElf(keys:Object){
			trace("###NEW ELF###");
			if (globals.Players.GetLocalPlayer() == keys.pid)
			{
				trace("GOT IT WHERE WE WANT IT");
				itemButton.visible = false;
				

				drawBuildingsButton();
			}
		}

		public function drawItemsButton(){
			var cls = getDefinitionByName("button_big");
			var btn = new cls();
			btn.x = 400;
			btn.y = 400;
			btn.visible = true;
			btn.addEventListener(ButtonEvent.CLICK, itemsClicked);
			itemButton.addChild(btn);
			itemButton.visible = true;
			addChild(itemButton);
		}

		public function drawBuildingsButton(){
			var cls = getDefinitionByName("button_big");
			var btn = new cls();
			btn.x = 400;
			btn.y = 400;
			btn.visible = true;
			btn.addEventListener(ButtonEvent.CLICK, buildingsClicked);
			buildingButton.addChild(btn);
			buildingButton.visible = true;
			addChild(buildingButton);
		}

		public function itemsClicked(obj:Object){
			itemPanel.visible = true;
		}

		public function buildingsClicked(obj:Object){
			buildingPanel.visible = true;
		}

		public function fireAbility(idx:int){
			//get movieclip and fake mouseevent
			var clip = globals.Loader_actionpanel.movieClip.middle.abilities["Ability" + idx];
			globals.Loader_actionpanel.movieclip.onAbilityClicked({"currentTarget":clip,"buttonIdx":idx});
		}

		public function onResize(re:ResizeManager) : * {
			// Update the stage width

			x = 0;
			y = 0;

			visible = true;

			scalingFactor = re.ScreenHeight/myStageHeight;

			this.scaleX = scalingFactor;
			this.scaleY = scalingFactor;

			realScreenWidth = re.ScreenWidth;
			realScreenHeight = re.ScreenHeight;

			var workingWidth:Number = myStageHeight*4/3;

			itemPanel.x = (realScreenWidth/scalingFactor-workingWidth)/2;
			itemPanel.y = 128;

			buildingPanel.x = (realScreenWidth/scalingFactor-workingWidth)/2;
			buildingPanel.y = 128;

			trace("### Resizing");
			if (re.IsWidescreen()) {
				trace("### Widescreen detected!");
				//16:x
				if (re.Is16by9()) {
					if (curRes != 0) {
						curRes = 0;
						//lumberOverlay.onScreenResize(0, globals.instance.Game.IsHUDFlipped());
						try {
							trace("###TrollsAndElves HUD Flipped to "+globals.instance.Game.IsHUDFlipped().toString());
						} catch (Exception) {
							trace("###ERRROR Ok, this didn't work..."); //This actually is used, not quite sure why yet.
						}
						lumberOverlay.onScreenResize(0, false);
						TownHallOverlay.onScreenResize(0, false);
						AncientTreeOverlay.onScreenResize(0, false);
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
						TownHallOverlay.onScreenResize(1, false);
						AncientTreeOverlay.onScreenResize(1, false);
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
					TownHallOverlay.onScreenResize(2, false);
					AncientTreeOverlay.onScreenResize(2, false);
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
		
		
		public function hookAndReplace(btn:MovieClip, type:String, eventType:String="", func:Function=null) : MovieClip {
			trace("##HOOK a");
			var parent = btn.parent;
			trace(parent);
			
			trace("##HOOK b");
			var oldx = btn.x;
			trace("##HOOK c");
			var oldy = btn.y;
			trace("##HOOK d");
			var oldwidth = btn.width;
			trace("##HOOK e");
			var oldheight = btn.height;
			trace("##HOOK f");
			
			var newObjectClass = getDefinitionByName(type);
			trace("##HOOK g");
			var newObject = new newObjectClass();
			trace("##HOOK h");
			newObject.x = oldx;
			trace("##HOOK i");
			newObject.y = oldy;
			trace("##HOOK j");
			newObject.width = oldwidth;
			trace("##HOOK k");
			newObject.height = oldheight;
			trace("##HOOK m");
			
			parent.removeChild(btn);
			trace("##HOOK n");
			parent.addChild(newObject);
			
			if (eventType != "") {
				newObject.addEventListener(eventType, func);
			}
			return newObject;
		}
		// Shamelessly stolen from Frota
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
        		trace(t);
        		return;
        	}

        	if(indent == 0) {
        		trace("{");
        	}

        	// Stop loops
        	done ||= new flash.utils.Dictionary(true);
        	if(done[t]) {
        		trace(strRep("\t", indent+1)+"\"object\" : \"<loop object>"+t+"\"");
        		return;
        	}
        	done[t] = true;

        	// Grab this class
        	var thisClass = flash.utils.getQualifiedClassName(t);

        	// Print methods
			trace(strRep("\t", indent+1) + "\"methods\" : [");
			for each(key1 in flash.utils.describeType(t)..method) {
				// Check if this is part of our class
				if(key1.@declaredBy == thisClass) {
					// Yes, log it
					trace(strRep("\t", indent+2)+"\""+key1.@name+"()\",");
				}
			}
			trace(strRep("\t", indent+2)+"\"###IGNOREME###\""); //This is to validate the json
			trace(strRep("\t", indent+1) + "],");

			// Check for text
			if("text" in t) {
				trace(strRep("\t", indent+1)+"\"text\" : \""+escape(t.text)+"\",");
			}

			// Print variables
			//trace(strRep("\t", indent+1)+"##DEBUG: We are doing variables now");
			for each(key1 in flash.utils.describeType(t)..variable) {
				key = key1.@name;
				v = t[key];

				// Check if we can print it in one line
				if(isPrintable(v)) {
					trace(strRep("\t", indent+1)+"\""+key+"\" : \""+v+"\",");
				} else {
					// Open bracket
					trace(strRep("\t", indent+1)+"\""+key+"\" : {");

					// Recurse!
					PrintTable(v, indent+1, done)

					// Close bracket
					trace(strRep("\t", indent+1)+"},");
				}
			}

			// Find other keys
			//trace(strRep("\t", indent+1)+"##DEBUG: We are doing keys now");
			for(key in t) {
				v = t[key];

				// Check if we can print it in one line
				if(isPrintable(v)) {
					trace(strRep("\t", indent+1)+"\""+key+"\" : \""+v+"\",");
				} else {
					// Open bracket
					trace(strRep("\t", indent+1)+"\""+key+"\" : {");

					// Recurse!
					PrintTable(v, indent+1, done)

					// Close bracket
					trace(strRep("\t", indent+1)+"},");
				}
        	}

        	// Get children
			//trace(strRep("\t", indent+1)+"##DEBUG: We are doing children now");
			trace(strRep("\t", indent+1)+"\"children\" : [");
        	if(t is MovieClip) {
        		// Loop over children
	        	for(i = 0; i < t.numChildren; i++) {
	        		// Open bracket
					trace(strRep("\t", indent+2)+"{");
					//add type
					trace(strRep("\t", indent+3)+"\"name\" : \""+t.name+"\",");
					trace(strRep("\t", indent+3)+"\"type\" : \""+t+"\",");
					// Recurse!
	        		PrintTable(t.getChildAt(i), indent+2, done);

	        		// Close bracket
					trace(strRep("\t", indent+2)+"},");
	        	}
				trace(strRep("\t", indent+2)+"\"###IGNOREME###\""); //This is to validate the json
        	}
			trace(strRep("\t", indent+1)+"]");
        	// Close bracket
        	if(indent == 0) {
        		trace("}");
        	}
        }
	}	
}
