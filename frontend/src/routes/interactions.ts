export class ToggleState {
	toggledItemId;
	isToggled = false;

	constructor(itemId: string) {
		this.toggledItemId = itemId;
	}

	public toggle(index: number, element: HTMLElement) {
		if (this.isToggled) {
			if (`details-${index}` !== this.toggledItemId) {
				this.toggledItemId = `details-${index}`;
				this.isToggled = false;

				this.show(element);
			} else {
				this.hide(element);
			}
		} else {
			if (
				`details-${index}` !== this.toggledItemId ||
				(`details-${index}` === this.toggledItemId && !this.isToggled)
			) {
				this.toggledItemId = `details-${index}`;
				this.isToggled = false;

				this.show(element);
			}
		}
	};

	private hide(element: HTMLElement) {
		element.classList.add('hidden');
		this.isToggled = false;
	}

	private show(element: HTMLElement) {
		element.classList.remove('hidden');
		this.isToggled = true;
	}
}