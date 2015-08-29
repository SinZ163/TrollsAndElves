package buildings {
	
	import flash.display.MovieClip;
	import scaleform.clik.events.ButtonEvent;
	import flash.events.MouseEvent;
	
	import ValveLib.Globals;
	
    import flash.utils.getDefinitionByName;
	
	public class AncientTree extends MovieClip {
		private var gameAPI:Object;
		
		private var  left16by9X = 700;
		private var right16by9X = 700;
		
		private var  left16by10X = 700;
		private var right16by10X = 700;
		
		private var  left4by3X = 700;
		private var right4by3X = 700;
		
		private var  res16by9Y = 800;
		private var res16by10Y = 800;
		private var   res4by3Y = 800;
		
		public var bg;
		public var item1;
		public var item2;
		public var item3;
		public var item4;
		public var item5;
		public var item6;
		public var item7;
		public var item8;
		
		public var text1;
		public var text2;
		public var text3;
		public var text4;
		public var text5;
		public var text6;
		public var text7;
		public var text8;
		
		public function AncientTree(gameAPI:Object) {
			this.gameAPI = gameAPI;
			this.x = 10;
			this.y = 10;
			
			hookAndReplace(bg, "DB4_floading_panel");
			hookAndReplace(item1, "newlayout_inset", MouseEvent.CLICK, onAbility1Used);
			hookAndReplace(item2, "newlayout_inset", MouseEvent.CLICK, onAbility2Used);
			hookAndReplace(item3, "newlayout_inset", MouseEvent.CLICK, onAbility3Used);
			hookAndReplace(item4, "newlayout_inset", MouseEvent.CLICK, onAbility4Used);
			hookAndReplace(item5, "newlayout_inset", MouseEvent.CLICK, onAbility5Used);
			hookAndReplace(item6, "newlayout_inset", MouseEvent.CLICK, onAbility6Used);
			hookAndReplace(item7, "newlayout_inset", MouseEvent.CLICK, onAbility7Used);
			hookAndReplace(item8, "newlayout_inset", MouseEvent.CLICK, onAbility8Used);
			
			addChild(text1);
			addChild(text2);
			addChild(text3);
			addChild(text4);
			addChild(text5);
			addChild(text6);
			addChild(text7);
			addChild(text8);
		}
		public function onAbilityUsed(ability:int) {
			var i:int = ability + 6;
			trace("EXECUTING ABILITY");
			trace(i.toString());
			//gameAPI.SendServerCommand("tae_use_spell Ancient_Tree npc_trollsandelves_collector_" + ability.toString());
			//gameAPI.SendServerCommand("dota_ability_execute "+i.toString());
			Globals.instance.Loader_action_panel.movieClip.gameAPI.OnAbilityClicked(i);
		}
		public function onAbility1Used(obj:Object) {
			onAbilityUsed(1);
		}
		
		public function onAbility2Used(obj:Object) {
			onAbilityUsed(2);
		}

		public function onAbility3Used(obj:Object) {
			onAbilityUsed(3);
		}

		public function onAbility4Used(obj:Object) {
			onAbilityUsed(4);
		}

		public function onAbility5Used(obj:Object) {
			onAbilityUsed(5);
		}

		public function onAbility6Used(obj:Object) {
			onAbilityUsed(6);
		}

		public function onAbility7Used(obj:Object) {
			onAbilityUsed(7);
		}

		public function onAbility8Used(obj:Object) {
			onAbilityUsed(8);
		}

		public function onScreenResize(scale:int, left:Boolean) : void {
			trace("##LumberOverlay getting ready to resize");
			switch(scale) {
				case 0:
					//16by9
					trace("##LumberOverlay setting position for 16by9 resolutions");
					if (left) {
						this.x = left16by9X; //I have no actual idea where this should be.
					} else {
						this.x = right16by9X;
					}
					this.y = res16by9Y;
					break;
				case 1:
					//16by10
					trace("##LumberOverlay setting position for 16by10 resolutions");
					if (left) {
						this.x = left16by10X; //I have no actual idea where this should be.
					} else {
						this.x = right16by10X;
					}
					this.y = res16by10Y;
					break;
				case 2:
					//4by3
					trace("##LumberOverlay setting position for 4by3 resolutions");
					if (left) {
						this.x = left4by3X; //I have no actual idea where this should be.
					} else {
						this.x = right4by3X;
					}
					this.y = res4by3Y;
					break;
			}
		}
		
		public function hookAndReplace(btn:MovieClip, type:String, eventType:String="", func:Function=null) : MovieClip {
			var parent = btn.parent;
			var oldx = btn.x;
			var oldy = btn.y;
			var oldwidth = btn.width;
			var oldheight = btn.height;
			
			var newObjectClass = getDefinitionByName(type);
			var newObject = new newObjectClass();
			newObject.x = oldx;
			newObject.y = oldy;
			newObject.width = oldwidth;
			newObject.height = oldheight;
			
			parent.removeChild(btn);
			parent.addChild(newObject);
			
			if (eventType != "") {
				newObject.addEventListener(eventType, func);
			}
			return newObject;
		}
	}
	
}
