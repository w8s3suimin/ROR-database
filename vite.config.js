import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        cardUpgrade: resolve(__dirname, 'card-upgrade.html'),
        promotionBudget: resolve(__dirname, 'promotion-budget.html'),
        enchantConversion: resolve(__dirname, 'enchant-conversion.html'),
        petCombo: resolve(__dirname, 'pet-combo.html')
      }
    }
  }
});
