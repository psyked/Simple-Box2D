package couk.psyked.box2d.utils.library
{
    import wumedia.vector.VectorShapes;

    public class ShapeParser extends VectorShapes
    {
        public function ShapeParser()
        {
            super();
        }

        static public function getPoints( id:String, scale:Number = 1.0, levelOfDetail:uint = 30 ):Array
        {
            if ( VectorShapes.library[ id ])
            {
                return ShapeRecord.getPoints( VectorShapes.library[ id ], scale, levelOfDetail );
            }
            else
            {
                trace( "ERROR: missing " + id + " vector" );
                return null;
            }
        }
    }
}