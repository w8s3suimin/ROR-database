import { defineConfig } from 'vite';
import { resolve } from 'path';
import { ViteImageOptimizer } from 'vite-plugin-image-optimizer';

export default defineConfig({
  plugins: [
    ViteImageOptimizer({
      png: { quality: 80 },
      jpeg: { quality: 80 },
      webp: { lossy: true, quality: 80 },
    }),
  ],
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
