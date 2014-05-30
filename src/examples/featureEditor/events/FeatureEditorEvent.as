package examples.featureEditor.events
{
	import com.iblsoft.flexiweather.ogc.editable.WFSFeatureEditable;
	import com.iblsoft.flexiweather.ogc.editable.featureEditor.data.FeatureEditorProduct;
	
	import flash.events.Event;

	public class FeatureEditorEvent extends Event
	{
		public static const FEATURE_EDITOR_PRODUCT_SELECTED: String = 'featureEditorProductSelected';
		public static const FEATURE_EDITOR_FREE_DRAWING_SELECTED: String = 'featureEditorFreeDrawingSelected';
		public static const FEATURE_EDITOR_PRODUCT_SELECTION_CANCELLED: String = 'featureEditorProductSelectionCancelled';
		
		public var product: FeatureEditorProduct;
		public var date: Date;
		public var timeOffset: int;
		public var forecastTime: int;
		
		public function FeatureEditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}