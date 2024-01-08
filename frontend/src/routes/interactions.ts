export class ToggleState {
	toggledItemId;
	isToggled = false;

	constructor(itemId: string) {
		this.toggledItemId = itemId;
	}

	public toggle(index: number) {
		if (this.isToggled) {
			if (`details-${index}` !== this.toggledItemId) {
				this.toggledItemId = `details-${index}`;
				this.isToggled = false;

				this.show()
			} else {
				this.hide()
			}
		} else {
			if (
				`details-${index}` !== this.toggledItemId ||
				(`details-${index}` === this.toggledItemId && !this.isToggled)
			) {
				this.toggledItemId = `details-${index}`;
				this.isToggled = false;

				this.show()
			}
		}
	};

	private hide() {
		const element = document.getElementById(this.toggledItemId)!;
		element.classList.add('hidden');
		this.isToggled = false;
	}

	private show() {
		const element = document.getElementById(this.toggledItemId)!;
		element.classList.remove('hidden');
		this.isToggled = true;
	}
}