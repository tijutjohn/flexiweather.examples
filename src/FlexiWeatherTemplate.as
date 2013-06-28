package
{
	import com.iblsoft.flexiweather.ogc.InteractiveLayerWMS;
	import com.iblsoft.flexiweather.ogc.Version;
	import com.iblsoft.flexiweather.ogc.configuration.layers.WMSWithQTTLayerConfiguration;
	import com.iblsoft.flexiweather.ogc.configuration.services.WMSServiceConfiguration;
	import com.iblsoft.flexiweather.ogc.managers.OGCServiceConfigurationManager;
	import com.iblsoft.flexiweather.ogc.tiling.InteractiveLayerWMSWithQTT;
	import com.iblsoft.flexiweather.widgets.InteractiveLayerMap;
	import com.iblsoft.flexiweather.widgets.InteractiveWidget;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.Application;

	/** Base class with helper methods for all examples. */
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
			s_serverURL = 'http://ogcie.iblsoft.com';
			scm = OGCServiceConfigurationManager.getInstance();
			serviceRIA = scm.getService(
					"ria",
					s_serverURL + "/ria", new Version(1, 3, 0),
					WMSServiceConfiguration) as WMSServiceConfiguration;
			serviceGFS = scm.getService(
					"gfs",
					s_serverURL + "/ncep/gfs", new Version(1, 3, 0),
					WMSServiceConfiguration) as WMSServiceConfiguration;
			
			scm.addEventListener(WMSServiceConfiguration.CAPABILITIES_UPDATED, onCapabilitiesUpdated);
			
			var map: InteractiveLayerMap = new InteractiveLayerMap();
			m_iw.addLayer(map);
		}

		protected function onCapabilitiesUpdated(event: Event): void
		{
			trace("FlexiWeatherTemplate onCapabilitiesUpdated");
		}
		protected function getAllServicesCapabilities(): void
		{
			scm.update(scm.getAllServicesNames());
		}

		protected function getWMSLayerConfiguration(type: String): WMSServiceConfiguration
		{
			var srv: WMSServiceConfiguration
			switch (type)
			{
				case 'ria':
				{
					return serviceRIA;
					break;
				}
				case 'gfs':
				{
					return serviceGFS;
					break;
				}
			}
			return null;
		}

		protected function addLayer(type: String, layerAlpha: Number = 1, iw: InteractiveWidget = null, tileSize: uint = 256): InteractiveLayerWMS
		{
			if (!iw)
				iw = m_iw;
			var lWMS: InteractiveLayerWMSWithQTT;
			var srv: WMSServiceConfiguration;
			var lc: WMSWithQTTLayerConfiguration;
			switch (type)
			{
				case 'dem':
				{
					srv = getWMSLayerConfiguration('ria');
					lc = new WMSWithQTTLayerConfiguration(srv, ["background-dem"], tileSize);
					lc.label = "Background";
					lWMS = new InteractiveLayerWMSWithQTT(iw, lc);
					lWMS.name = 'Background';
					lWMS.alpha = layerAlpha;
					iw.interactiveLayerMap.addLayer(lWMS);
					break;
				}
				case 'temperature':
				{
					srv = getWMSLayerConfiguration('gfs');
					lc = new WMSWithQTTLayerConfiguration(srv, ["Temperature"], tileSize);
					lc.label = "Temperature";
					lc.dimensionRunName = 'RUN';
					lc.dimensionForecastName = 'FORECAST';
					lWMS = new InteractiveLayerWMSWithQTT(iw, lc);
					lWMS.name = 'Temperature';
					lWMS.alpha = layerAlpha;
					iw.interactiveLayerMap.addLayer(lWMS);
					break;
				}
				case 'foreground':
				{
					srv = getWMSLayerConfiguration('ria');
					lc = new WMSWithQTTLayerConfiguration(srv, ["foreground-lines"], tileSize);
					lc.label = "Overlays/Border lines";
					lWMS = new InteractiveLayerWMSWithQTT(iw, lc);
					lWMS.name = 'Borders';
					lWMS.alpha = layerAlpha;
					iw.interactiveLayerMap.addLayer(lWMS);
					break;
				}
			}
			return lWMS;
		}
	}
}
