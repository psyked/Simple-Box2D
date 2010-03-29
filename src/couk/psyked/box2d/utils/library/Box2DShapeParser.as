package couk.psyked.box2d.utils.library
{
    import wumedia.vector.VectorShapes;

    public class Box2DShapeParser extends VectorShapes
    {
        public function Box2DShapeParser()
        {
            super();
        }

        static public function getPoints( id:String, scale:Number = 1.0, levelOfDetail:uint = 30 ):Array
        {
            if ( VectorShapes.library[ id ])
            {
                return Box2DShapeRecord.getPoints( VectorShapes.library[ id ], scale, levelOfDetail );
            }
            else
            {
                trace( "ERROR: missing " + id + " vector" );
                return null;
            }
        }
    }
}