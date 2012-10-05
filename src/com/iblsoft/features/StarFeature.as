package com.iblsoft.features
{
	import com.iblsoft.flexiweather.ogc.FeatureUpdateContext;
	import com.iblsoft.flexiweather.ogc.editable.features.IconLabeledEditableFeature;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	public class StarFeature extends IconLabeledEditableFeature
	{
		[Embed(source="/assets/pngs/star.png")]
		public var starClass: Class;
		
		private var star: Bitmap;
		
		public function StarFeature(s_namespace: String, s_typeName: String, s_featureId: String)
		{
			super(s_namespace, s_typeName, s_featureId);
			
			
			star = new starClass();
			
			bitmap = star;
		}
		
//		override public function update(changeFlag:FeatureUpdateContext):void
//		{
//			super.update(changeFlag);
//
//			var a_points: ArrayCollection = getPoints();
//			if(a_points.length > 0) { 
//				
//				var pt: Point = a_points.getItemAt(0) as Point;
//				
//				star.x = pt.x - star.width / 2;
//				star.y = pt.y - star.height / 2;
//			}
//		}
	}
}