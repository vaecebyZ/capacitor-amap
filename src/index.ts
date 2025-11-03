import { registerPlugin } from '@capacitor/core';

import type { AmapPlugin } from './definitions';

const CapacitorAMap = registerPlugin<AmapPlugin>('CapacitorAMap', {
  web: () => import('./web').then(m => new m.CapacitorAMapWeb()),
});

export * from './definitions';
export { CapacitorAMap };
