import fs from 'fs';
import https from 'https';
import path from 'path';

// ==========================================
// 💡 設定區 (請在這裡貼上你的 CSV 網址)
// ==========================================
// 範例網址格式：https://docs.google.com/spreadsheets/d/e/.../pub?output=csv
const SHEETS_TO_FETCH = [
  {
    name: "cardUpgrade", // 卡片升星查詢的資料
    csvUrl: "這裡替換成_卡片升星查詢_的_CSV_發布網址"
  },
  // {
  //   name: "promotionBudget",
  //   csvUrl: "這裡替換成_升格預算計算_的_CSV_發布網址"
  // }
];

// ==========================================
// 腳本執行區 (自動下載並轉換)
// ==========================================
const dataDir = path.join(process.cwd(), 'src', 'data');
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir, { recursive: true });
}

function fetchCSV(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    }).on('error', reject);
  });
}

function csvToJson(csvText) {
  const lines = csvText.split('\n').filter(line => line.trim() !== '');
  if (lines.length === 0) return [];
  
  const headers = lines[0].split(',').map(h => h.trim());
  const result = [];
  
  for (let i = 1; i < lines.length; i++) {
    // 簡單的 CSV 解析 (未處理包含逗號的字串，若資料有逗號後續可優化)
    const currentLine = lines[i].split(',');
    const obj = {};
    headers.forEach((header, index) => {
      obj[header] = currentLine[index] ? currentLine[index].trim() : '';
    });
    result.push(obj);
  }
  return result;
}

async function updateData() {
  console.log('🔄 開始從 Google Sheets 同步資料...');
  
  for (const sheet of SHEETS_TO_FETCH) {
    if (sheet.csvUrl.includes('這裡替換成')) {
      console.log(`⚠️ 略過 ${sheet.name}：請先填入真實的 CSV 網址`);
      continue;
    }
    
    try {
      console.log(`下載 ${sheet.name} 的資料中...`);
      const csvData = await fetchCSV(sheet.csvUrl);
      const jsonData = csvToJson(csvData);
      
      const outputPath = path.join(dataDir, `${sheet.name}.json`);
      fs.writeFileSync(outputPath, JSON.stringify(jsonData, null, 2), 'utf-8');
      console.log(`✅ 成功更新 ${sheet.name}.json`);
    } catch (err) {
      console.error(`❌ 更新 ${sheet.name} 失敗:`, err);
    }
  }
  console.log('🎉 所有資料同步完成！');
}

updateData();
