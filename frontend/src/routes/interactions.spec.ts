import { expect, it, vi, describe, afterEach } from 'vitest';
import { ToggleState } from './interactions';


describe('Test toggle states', () => {
	afterEach(() => {
		vi.restoreAllMocks();
	});

	it('Toggle item', () => {
		const element = document.createElement('div');
		element.id = 'details-1';

		const state = new ToggleState('details-1');
		state.toggle(1, element);

		expect(state.toggledItemId).toBe('details-1');
		expect(state.isToggled).toBeTruthy();
	});

	it('Untoggle item', () => {
		const element = document.createElement('div');
		element.id = 'details-1';

		const state = new ToggleState('details-1');
		state.toggle(1, element);

		const secondElement = document.createElement('div');
		secondElement.id = 'details-2';

		state.toggle(2, secondElement)

		expect(state.toggledItemId).toBe('details-2');
		expect(state.isToggled).toBeTruthy();
	})
});

