package examples.dragging
{
	import mx.controls.Tree;
	import mx.core.mx_internal;

	use namespace mx_internal;

	public class DocStorageTree extends Tree
	{
		override public function set editedItemPosition(value:Object):void
		{
			super.editedItemPosition = value;
		}
		public function DocStorageTree()
		{
			super();
		}

		override public function createItemEditor(colIndex:int, rowIndex:int):void
		{
			super.createItemEditor(colIndex, rowIndex);

		}

		override public function setFocus(): void
		{
		}

		override public function itemToLabel(data:Object):String
		{
			var label:String = super.itemToLabel(data);
			return label;
		}
		/**
		 *  @private
		 */
		override public function itemToIcon(item:Object):Class
		{
			return null;
		}

		public function updateDataPath(item: Object): void
		{
			var parentItem: Object = getParentItem(item);
			if (parentItem)
			{

			}
		}

		override mx_internal function removeChildItem(parent:Object, child:Object, index:Number):Boolean
		{
			return super.removeChildItem(parent, child, index);
		}

		override mx_internal function addChildItem(parent:Object, child:Object, index:Number):Boolean
		{
			return super.addChildItem(parent, child, index);
		}

	}
}