package
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;

    import couk.psyked.box2d.Box2DWorld;
    import couk.psyked.box2d.utils.Box2DPointUtils;
    import couk.psyked.box2d.utils.Box2DUtils;
    import couk.psyked.box2d.utils.Box2DWorldOptions;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;

    [SWF( width="500",height="280",frameRate="30",backgroundColor="0x000000",pageTitle="Box2D Experiments" )]
    public class CurvedShapeExample extends Sprite
    {
        public function CurvedShapeExample()
        {
            addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
        }

        private var world:Box2DWorld;
        private var worldOptions:Box2DWorldOptions;

        private function onAddedToStage( e:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
            addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
            //
            worldOptions = new Box2DWorldOptions( 500, 280, 30, 9.8 );
            worldOptions.setWorldEdges( false, true );
            world = Box2DUtils.createBoxedWorld( worldOptions );
            world.debugDraw = true;
            world.mouseInteractExclusions = new Array();
            world.mouseInteraction = true;
            world.framerateIndependantAnimation = true;
            addChild( world );

            world.createPolyFromLibraryShape( 30, 50, "stars", "/stars_assets.swf" );
            world.addEventListener( Event.COMPLETE, onLoadComplete );

        /* var kbm:KeyboardManager = new KeyboardManager( this );
         kbm.registerKeyDownAction( "c", connectToCeiling ); */
        }

        private function attachToCeiling( body:b2Body ):void
        {
            if ( !body.IsStatic())
            {
                var bodyPos:b2Vec2 = body.GetPosition();
                var bodyCenter:b2Vec2 = body.GetWorldCenter();
                world.createDisanceJoint( body, Box2DPointUtils.getTopBodyAtPoint( new Point( bodyCenter.x * worldOptions.scale, 0 ), true ), world.b2Vec2ToPoint( bodyCenter ), new Point( bodyCenter.x * worldOptions.scale, 0 ));
            }
        }

        private function onLoadComplete( e:Event ):void
        {
            world.removeEventListener( Event.COMPLETE, onLoadComplete );
            world.forEachBody( attachToCeiling );
        }

        /* private function connectToCeiling():void
           {
           var bodyAtMouse:b2Body = Box2DMouseUtils.getTopBodyAtMouse();
           if ( bodyAtMouse )
           {
           world.createDisanceJoint( bodyAtMouse, Box2DPointUtils.getTopBodyAtPoint( new Point( mouseX, 0 ), true ), new Point( mouseX, mouseY ), new Point( mouseX, 0 ));
           }
         } */

        private function onRemovedFromStage( e:Event ):void
        {
            addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
            removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
        }
    }
}
