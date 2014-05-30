package layer
{
	import com.iblsoft.flexiweather.ogc.configuration.layers.WMSWithQTTLayerConfiguration;
	import com.iblsoft.flexiweather.ogc.tiling.InteractiveLayerWMSWithQTT;
	import com.iblsoft.flexiweather.widgets.InteractiveWidget;
	
	public class IblBaseLayer extends InteractiveLayerWMSWithQTT
	{
		public function IblBaseLayer(container:InteractiveWidget, cfg:WMSWithQTTLayerConfiguration)
		{
			super(container, cfg);
		}
	}
}