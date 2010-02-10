package couk.psyked.box2d.utils
{
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;
    
    import couk.psyked.box2d.Box2DWorld;
    
    import flash.display.Sprite;


    public class Box2DUtils
    {
        public function Box2DUtils()
        {
            //
        }

        public static function createBoxedWorld( options:Box2DWorldOptions ):Box2DWorld
        {
            var world:b2World = new b2World( options.aabb, options.gravity, true );

            // Create border of boxes
            var wallSd:b2PolygonDef = new b2PolygonDef();
            var wallBd:b2BodyDef = new b2BodyDef();
            var wallB:b2Body;

            if ( options.edgeLeft )
            {
                wallBd.position.Set( -100 / options.scale, options.height / options.scale / 2 );
                wallSd.SetAsBox( 100 / options.scale, ( options.height + 40 ) / options.scale / 2 );
                wallB = world.CreateBody( wallBd );
                wallB.CreateShape( wallSd );
                wallB.SetMassFromShapes();
            }
            if ( options.edgeRight )
            {
                wallBd.position.Set(( options.width + 99 ) / options.scale, options.height / options.scale / 2 );
                wallB = world.CreateBody( wallBd );
                wallB.CreateShape( wallSd );
                wallB.SetMassFromShapes();
            }
            if ( options.edgeTop )
            {
                wallBd.position.Set( options.width / options.scale / 2, -100 / options.scale );
                wallSd.SetAsBox(( options.width + 40 ) / options.scale / 2, 100 / options.scale );
                wallB = world.CreateBody( wallBd );
                wallB.CreateShape( wallSd );
                wallB.SetMassFromShapes();
            }
            if ( options.edgeBottom )
            {
                wallBd.position.Set( options.width / options.scale / 2, ( options.height + 99 ) / options.scale );
                wallB = world.CreateBody( wallBd );
                wallB.CreateShape( wallSd );
                wallB.SetMassFromShapes();
            }

            return new Box2DWorld( world , options);
        }

        public static function addDebugDraw( world:b2World ):Sprite
        {
            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            var dbgSprite:Sprite = new Sprite();
            dbgDraw.SetSprite( dbgSprite );
            dbgDraw.SetDrawScale( 30 );
            dbgDraw.SetFillAlpha( 0.3 );
            dbgDraw.SetLineThickness( 1 );
            dbgDraw.SetFlags( b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit );
            world.SetDebugDraw( dbgDraw );
            return dbgSprite;
        }

    }
}