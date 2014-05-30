package examples.ui
{
	import mx.core.UIComponent;
	
	public class CustomGroup extends UIComponent
	{
		override public function get visible(): Boolean
		{
			return super.visible;
		}
		
		override public function set visible(b_visible: Boolean): void
		{
			if (super.visible != b_visible)
			{
				super.visible = b_visible;
				
				trace("CustomGroup " + name + "/" + id + "  visible = " + b_visible + " / " + super.visible);
			}
		}
		
		public function CustomGroup()
		{
			super();
		}
	}
}