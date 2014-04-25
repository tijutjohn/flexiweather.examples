package examples
{
	import com.iblsoft.flexiweather.FlexiWeatherConfiguration;
	import com.iblsoft.flexiweather.net.loaders.AbstractURLLoader;
	import com.iblsoft.flexiweather.ogc.InteractiveLayerWMS;
	import com.iblsoft.flexiweather.ogc.Version;
	import com.iblsoft.flexiweather.ogc.configuration.layers.WMSWithQTTLayerConfiguration;
	import com.iblsoft.flexiweather.ogc.configuration.services.WMSServiceConfiguration;
	import com.iblsoft.flexiweather.ogc.events.ServiceCapabilitiesEvent;
	import com.iblsoft.flexiweather.ogc.managers.OGCServiceConfigurationManager;
	import com.iblsoft.flexiweather.ogc.tiling.InteractiveLayerWMSWithQTT;
	import com.iblsoft.flexiweather.widgets.InteractiveLayerMap;
	import com.iblsoft.flexiweather.widgets.InteractiveWidget;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;

	/** Base class with helper methods for all examples. */
	public class FlexiWeatherTemplate extends Group
	{
		[Bindable]
		public var m_iw: InteractiveWidget;
		
		protected var s_serverURL: String
		protected var scm: OGCServiceConfigurationManager;
		[Bindable]
		protected var serviceRIA: WMSServiceConfiguration;
		[Bindable]
		protected var serviceAFWA: WMSServiceConfiguration;
		[Bindable]
		protected var serviceForecasts: WMSServiceConfiguration;
		[Bindable]
		protected var serviceObservations: WMSServiceConfiguration;
		[Bindable]
		protected var serviceGFS: WMSServiceConfiguration;

		public function FlexiWeatherTemplate()
		{
			super();

			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			s_serverURL = 'http://ogcie.iblsoft.com';
			AbstractURLLoader.baseURL = s_serverURL; 
		}

		protected function onCreationComplete(event: FlexEvent): void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

			scm = OGCServiceConfigurationManager.getInstance();
			
//			serviceAFWA = scm.getService(
//					"afwa",
//					s_serverURL + "/ow/afwa/afwaGC.xml", new Version(1, 3, 0),
//					WMSServiceConfiguration) as WMSServiceConfiguration;
			
			serviceRIA = scm.getService(
					"ria",
					s_serverURL + "/ria/wms", new Version(1, 3, 0),
					WMSServiceConfiguration) as WMSServiceConfiguration;
			
			serviceGFS = scm.getService(
					"gfs",
					s_serverURL + "/ncep/gfs", new Version(1, 3, 0),
					WMSServiceConfiguration) as WMSServiceConfiguration;
			serviceForecasts = scm.getService(
					"forecasts",
					s_serverURL + "/forecasts", new Version(1, 3, 0),
					WMSServiceConfiguration) as WMSServiceConfiguration;
			serviceObservations = scm.getService(
					"observations",
					s_serverURL + "/observations", new Version(1, 3, 0),
					WMSServiceConfiguration) as WMSServiceConfiguration;
			
			if (FlexiWeatherConfiguration.FLEXI_WEATHER_LOADS_GET_CAPABILITIES)
			{
				scm.addEventListener(ServiceCapabilitiesEvent.ALL_CAPABILITIES_UPDATED, onAllCapabilitiesUpdated);
				scm.addEventListener(ServiceCapabilitiesEvent.CAPABILITIES_UPDATED, onCapabilitiesUpdated);
				scm.addEventListener(ServiceCapabilitiesEvent.CAPABILITIES_LOADED, onCapabilitiesLoaded);
			}
			
			var map: InteractiveLayerMap;
			
			//add default map, if it is not there
			var layersCount: int = m_iw.numLayers;
//			map = m_iw.getLayerByType(InteractiveLayerMap) as InteractiveLayerMap;
			
			if (!map)
			{
				map = new InteractiveLayerMap();
				m_iw.addLayer(map);
			}
		}

		protected function onCapabilitiesNodeParsed(event: ServiceCapabilitiesEvent): void
		{
			trace("FlexiWeatherTemplate onCapabilitiesNodeParsed");
		}
		
		protected function onCapabilitiesLoaded(event: ServiceCapabilitiesEvent): void
		{
			trace("FlexiWeatherTemplate onCapabilitiesLoaded service: " + event.service.label);
		}
		protected function onAllCapabilitiesUpdated(event: ServiceCapabilitiesEvent): void
		{
			trace("FlexiWeatherTemplate onAllCapabilitiesUpdated");
		}
		protected function onCapabilitiesUpdated(event: ServiceCapabilitiesEvent): void
		{
			trace("FlexiWeatherTemplate onCapabilitiesUpdated service: " + event.service.label);
		}
		protected function getAllServicesCapabilities(): void
		{
			if (FlexiWeatherConfiguration.FLEXI_WEATHER_LOADS_GET_CAPABILITIES)
				scm.update(scm.getAllServicesNames());
		}

		protected function getWMSLayerConfiguration(type: String): WMSServiceConfiguration
		{
			var srv: WMSServiceConfiguration
			switch (type)
			{
				case 'ria':
				case 'wms':
				{
					return serviceRIA;
					break;
				}
				case 'afwa':
				{
					return serviceAFWA;
					break;
				}
				case 'forecasts':
				{
					return serviceForecasts;
					break;
				}
				case 'observations':
				{
					return serviceObservations;
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

		protected function addLayer(type: String, layerAlpha: Number = 1, iw: InteractiveWidget = null, tileSize: uint = 256, bUseTiling: Boolean = true ): InteractiveLayerWMS
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
					lc.avoidTiling = !bUseTiling;
					lWMS = new InteractiveLayerWMSWithQTT(iw, lc);
					lWMS.name = 'Background';
					lWMS.alpha = layerAlpha;
					iw.interactiveLayerMap.addLayer(lWMS);
					break;
				}
				case 'temperature':
				{
					srv = getWMSLayerConfiguration('gfs');
					lc = new WMSWithQTTLayerConfiguration(srv, ["temperature"], tileSize);
					lc.avoidTiling = !bUseTiling;
					lc.label = "Temperature";
					lc.dimensionRunName = 'RUN';
					lc.dimensionForecastName = 'FORECAST';
					lWMS = new InteractiveLayerWMSWithQTT(iw, lc);
					lWMS.name = 'Temperature';
					lWMS.alpha = layerAlpha;
					iw.interactiveLayerMap.addLayer(lWMS);
					break;
				}
				case 'taf':
				{
					srv = getWMSLayerConfiguration('forecasts');
					lc = new WMSWithQTTLayerConfiguration(srv, ["taf"], tileSize);
					lc.avoidTiling = !bUseTiling;
					lc.label = "TAF Airport Forecasts";
					lc.dimensionTimeName = 'TIME';
					lWMS = new InteractiveLayerWMSWithQTT(iw, lc);
					lWMS.name = 'TAF Airport Forecasts';
					lWMS.alpha = layerAlpha;
					iw.interactiveLayerMap.addLayer(lWMS);
					break;
				}
				case 'surface':
				{
					srv = getWMSLayerConfiguration('observation');
					lc = new WMSWithQTTLayerConfiguration(srv, ["surface"], tileSize);
					lc.avoidTiling = !bUseTiling;
					lc.label = "Surface";
					lc.dimensionTimeName = 'TIME';
					lWMS = new InteractiveLayerWMSWithQTT(iw, lc);
					lWMS.name = 'Surface';
					lWMS.alpha = layerAlpha;
					iw.interactiveLayerMap.addLayer(lWMS);
					break;
				}
				case 'foreground':
				{
					srv = getWMSLayerConfiguration('ria');
					lc = new WMSWithQTTLayerConfiguration(srv, ["foreground-lines"], tileSize);
					lc.label = "Overlays/Border lines";
					lc.avoidTiling = !bUseTiling;
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
