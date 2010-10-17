package
{
	import com.iblsoft.flexiweather.ogc.InteractiveLayerWFS;
	import com.iblsoft.flexiweather.ogc.editable.WFSFeatureEditableCurve;
	import com.iblsoft.flexiweather.utils.AnticollisionLayout;
	
	import flash.display.GradientType;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.ToolTip;

	public class Example3Feature extends WFSFeatureEditableCurve
	{
		private var m_label: ToolTip;
		private var ms_type: String;
		
		public function Example3Feature(s_type: String)
		{
			super('http://www.iblsoft.com/wfs/test', 'Example3FeatureWithLabel', null);
			ms_type = s_type;
		}

		public override function update(): void
		{
			super.update();
			
			graphics.clear();

			var ptAvg: Point = new Point(0, 0);
			var ptFirst: Point;

			graphics.lineStyle(3, 0xff8040, 1);
			if(/^filled-.*/.test(ms_type))
				graphics.beginFill(0x0080c0, 0.5); 
			var ptPrev: Point = null;
			for each(var pt: Point in getPoints()) {
				ptAvg.x += pt.x;
				ptAvg.y += pt.y;
				if(ptPrev == null) {
					graphics.moveTo(pt.x, pt.y);
					ptFirst = pt;
				}
				else
					graphics.lineTo(pt.x, pt.y);
				ptPrev = pt;
			}
			ptAvg.x /= getPoints().length;
			ptAvg.y /= getPoints().length;
			if(/.*polygon$/.test(ms_type) && ptFirst != null)
				graphics.lineTo(ptFirst.x, ptFirst.y);
			if(/^filled-.*/.test(ms_type))
				graphics.endFill();
			
			if(m_label == null) {
				m_label = new ToolTip();
				master.addChild(m_label);
			}
			m_label.text = "Hello World!\nThis is a label";
			m_label.validateNow();
			m_label.width = m_label.measuredWidth;
			m_label.height = m_label.measuredHeight;
			m_label.x = ptAvg.x - m_label.width / 2.0;
			m_label.y = ptAvg.y - m_label.height / 2.0;

			master.container.m_labelLayout.removeObject(this);
			master.container.m_labelLayout.removeObject(m_label);
			master.container.m_labelLayout.addObject(this, AnticollisionLayout.DISPLACE_NOT_ALLOWED);
			master.container.m_labelLayout.addObject(m_label, AnticollisionLayout.DISPLACE_AUTOMATIC);
		}

		public override function cleanup(): void
		{
			super.cleanup();
			if(m_label != null)
				master.removeChild(m_label);
		}
	}
}