package couk.psyked.utils
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class KeyboardManager
	{

		internal var actionsArray:Array;

		internal var displayobject:DisplayObject;

		public function KeyboardManager( _displayobject:DisplayObject )
		{
			displayobject = _displayobject;

			if ( displayobject.stage )
			{
				onAddedToStage();
			}
			else
			{
				displayobject.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			}
			actionsArray = new Array();
		}

		public function registerKeyDownAction( key:String, action:Function, ctrl:Boolean = false, alt:Boolean = false, shift:Boolean = false ):void
		{
			actionsArray.push([ key, action, ctrl, alt, shift ]);
		}

		public function unregisterKeyAction( key:String ):void
		{
			for ( var i:int = 0; i < actionsArray.length; i++ )
			{
				if ( actionsArray[ i ] == key )
				{
					actionsArray.splice( i, 1 );
				}
			}
		}

		internal function keyDownHandler( e:KeyboardEvent ):void
		{
			for each ( var a:Array in actionsArray )
			{
				if ( String( a[ 0 ]).charCodeAt( 0 ) == e.charCode || e.keyCode == parseInt( a[ 0 ]))
				{
					if (( a[ 2 ] == true && e.ctrlKey || !a[ 2 ]) && ( a[ 3 ] == true && e.altKey || !a[ 3 ]) && ( a[ 4 ] == true && e.shiftKey || !a[ 4 ]))
					{
						( a[ 1 ] as Function ).call();
					}
				}
			}
		}

		internal function keyUpHandler( e:KeyboardEvent ):void
		{
			//keyUpText.text = "Key code: " + e.keyCode;
		}

		private function onAddedToStage( e:Event = null ):void
		{
			if ( e )
			{
				displayobject.removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			}
			displayobject.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			displayobject.stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
		}

		private function onRemovedFromStage( e:Event = null ):void
		{
			displayobject.stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			displayobject.stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
		}
	}
}