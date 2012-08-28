package
{
	import com.iblsoft.flexiweather.ogc.InteractiveLayerWMS;
	import com.iblsoft.flexiweather.ogc.managers.OGCServiceConfigurationManager;
	import com.iblsoft.flexiweather.ogc.Version;
	import com.iblsoft.flexiweather.ogc.WMSLayerConfiguration;
	import com.iblsoft.flexiweather.ogc.WMSServiceConfiguration;
	import com.iblsoft.flexiweather.widgets.InteractiveWidget;
	
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	
	public class FlexiWeatherTemplate extends Application
	{
		public var m_iw: InteractiveWidget;
		
		protected var s_serverURL: String
		protected var scm: OGCServiceConfigurationManager;
		protected var serviceRIA: WMSServiceConfiguration;
		protected var serviceGFS: WMSServiceConfiguration;
		
		public function FlexiWeatherTemplate()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onCreationComplete(event: FlexEvent): void
		{
			
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			s_serverURL = 'http://wms.iblsoft.com';
			
			scm = OGCServiceConfigurationManager.getInstance();
			
			serviceRIA = scm.getService(
				"ria",
				s_serverURL + "/ria", new Version(1, 3, 0),
				WMSServiceConfiguration) as WMSServiceConfiguration;
			
			serviceGFS = scm.getService(
				"gfs",
				s_serverURL + "/gfs", new Version(1, 3, 0),
				WMSServiceConfiguration) as WMSServiceConfiguration;
		}
		
		protected function getWMSLayerConfiguration(type: String): WMSServiceConfiguration
		{
			var srv: WMSServiceConfiguration
			switch(type)
			{
				case 'ria':
					return serviceRIA;
					break;
				case 'gfs':
					return serviceGFS;
					break;
			}
			return null;
		}
		
		protected function addLayer(type: String, layerAlpha: Number = 1, iw: InteractiveWidget = null): InteractiveLayerWMS
		{
			
			if (!iw)
			{
				iw = m_iw;
			}
			
			trace("addLayer to iw: " + iw.name);
			var lWMS: InteractiveLayerWMS;
			var srv: WMSServiceConfiguration;
			var lc: WMSLayerConfiguration;
			
			switch(type)
			{
				case 'dem':
					srv = getWMSLayerConfiguration('ria');
					
					lc = new WMSLayerConfiguration(srv, ["background-dem"]);
					lc.label = "Background";
					
					lWMS = new InteractiveLayerWMS(iw, lc);
					iw.addLayer(lWMS);
					lWMS.name = 'Background';
					lWMS.alpha = layerAlpha;
					lWMS.refresh(true);
					break;
				
				case 'temperature':
					srv = getWMSLayerConfiguration('gfs');
					
					lc = new WMSLayerConfiguration(srv, ["Temperature"]);
					lc.label = "Temperature";
					lc.dimensionRunName = 'RUN';
					lc.dimensionForecastName = 'FORECAST';
					
					lWMS = new InteractiveLayerWMS(iw, lc);
					iw.addLayer(lWMS);
					lWMS.name = 'Temperature';
					lWMS.alpha = layerAlpha;
					lWMS.refresh(true);
					break;
				
				case 'foreground':
					
					srv = getWMSLayerConfiguration('ria');
					
					lc = new WMSLayerConfiguration(srv, ["foreground-lines"]);
					lc.label = "Overlays/Border lines";
					
					lWMS = new InteractiveLayerWMS(iw, lc);
					iw.addLayer(lWMS);
					lWMS.name = 'Borders';
					lWMS.alpha = layerAlpha;
					lWMS.refresh(true);
					
					break;
			}
			return lWMS;
		}
	}
}